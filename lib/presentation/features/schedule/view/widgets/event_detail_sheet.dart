import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/logic/event_formatter.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';

/// Muestra el detalle de un evento en un bottom sheet con estética Vision 2026.
void showDetailSheet(BuildContext context, Event event) {
  AppBottomSheet.show(
    context: context,
    title: '',
    child: EventDetailContent(event: event),
  );
}

/// Contenido principal del detalle del evento.
class EventDetailContent extends ConsumerWidget {
  final Event event;
  const EventDetailContent({super.key, required this.event});

  String? _duration() {
    if (event.startDate == null || event.endDate == null) return null;
    final duration = const EventFormatter().formatDuration(
      event.startDate,
      event.endDate,
    );
    return duration == '0m' ? null : duration;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final status = EventStatusResolver.resolve(event);
    final duration = _duration();
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.valueOrNull?.contains(event.id) ?? false,
      ),
    );

    // Orquesta el orden de los elementos que se muestran en el detalle.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTypeHeader(context, status),
        const SizedBox(height: AppSpacing.m),
        _buildTitle(context, locale),
        const SizedBox(height: AppSpacing.l),
        _buildAttributesGrid(context, duration),
        const SizedBox(height: AppSpacing.l),
        if (event.aboutPresentationUrl != null ||
            event.videoPresentationUrl != null) ...[
          _buildResources(context),
          const SizedBox(height: AppSpacing.l),
        ],
        _buildFavoriteButton(context, ref, isFavorite),
      ],
    );
  }

  /// Header que muestra el tipo de evento y su estado.
  Widget _buildTypeHeader(BuildContext context, EventStatus status) {
    final style = resolveTypeStyle(context, event.type);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: style.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: 12, color: style.color),
              const SizedBox(width: 6),
              Text(
                event.type.label.toUpperCase(),
                style: TextStyle(
                  color: style.color,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (status != EventStatus.ended) ...[
          const SizedBox(width: AppSpacing.s),
          EventStatusChip(status: status),
        ],
      ],
    );
  }

  /// Titulo del evento.
  Widget _buildTitle(BuildContext context, String locale) {
    return Text(
      event.title.resolve(locale),
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -1.0,
      ),
    );
  }

  /// Grid que muestra la fecha y hora, sala, duración e idioma del evento.
  Widget _buildAttributesGrid(BuildContext context, String? duration) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AttributeCell(
                  icon: Icons.access_time_filled_rounded,
                  label: 'Time',
                  value: event.filterTime ?? '--:--',
                ),
              ),
              Expanded(
                child: _AttributeCell(
                  icon: Icons.meeting_room_rounded,
                  label: 'Room',
                  value: event.roomId ?? 'TBA',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _AttributeCell(
                  icon: Icons.timelapse_rounded,
                  label: 'Duration',
                  value: duration ?? '--',
                ),
              ),
              Expanded(
                child: _AttributeCell(
                  icon: Icons.translate_rounded,
                  label: 'Language',
                  value: event.lang?.toUpperCase() ?? '--',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sección de recursos del evento.
  Widget _buildResources(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resources'.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        if (event.aboutPresentationUrl != null)
          _ActionLink(
            icon: Icons.description_outlined,
            label: 'About this presentation',
            onTap: () => launchUrl(
              Uri.parse(event.aboutPresentationUrl!),
              mode: LaunchMode.externalApplication,
            ),
          ),
        if (event.videoPresentationUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => launchUrl(
                  Uri.parse(event.videoPresentationUrl!),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: const Text('Watch recording'),
              ),
            ),
          ),
      ],
    );
  }

  /// Boton para guardar o no un evento.
  Widget _buildFavoriteButton(
    BuildContext context,
    WidgetRef ref,
    bool isFavorite,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        ),
        onPressed: () =>
            ref.read(toggleFavoriteUseCaseProvider).execute(event.id),
        icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_add_rounded),
        label: Text(
          isFavorite ? 'Saved to my schedule' : 'Add to my schedule',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Celda de atributo para el Grid.
class _AttributeCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AttributeCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Enlace de acción estilizado.
class _ActionLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
