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
import 'package:iced26/presentation/features/schedule/view/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';

/// Muestra el detalle de un evento en un bottom sheet.
void showDetailSheet(BuildContext context, Event event) {
  final locale = Localizations.localeOf(context).languageCode;
  AppBottomSheet.show(
    context: context,
    title: event.title.resolve(locale),
    child: EventDetailContent(event: event),
  );
}

/// Contenido del detalle de un evento.
class EventDetailContent extends ConsumerWidget {
  final Event event;

  const EventDetailContent({super.key, required this.event});

  String? _duration() {
    if (event.startDate == null || event.endDate == null) return null;
    final d = const EventFormatter().formatDuration(
      event.startDate,
      event.endDate,
    );
    return d == '0m' ? null : d;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = resolveTypeStyle(context, event.type);
    final status = EventStatusResolver.resolve(event);
    final duration = _duration();
    // select() evita rebuild cuando cambia el favorito de otro evento
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.valueOrNull?.contains(event.id) ?? false,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Chip(
              avatar: Icon(style.icon, size: 14, color: style.color),
              label: Text(event.type),
              backgroundColor: style.color.withValues(alpha: 0.12),
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: style.color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (status != EventStatus.ended) ...[
              const SizedBox(width: AppSpacing.s),
              EventStatusChip(status: status),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        if (event.filterTime != null)
          DetailRow(icon: Icons.access_time, text: event.filterTime!),
        if (duration != null) DetailRow(icon: Icons.timelapse, text: duration),
        if (event.roomId != null)
          DetailRow(icon: Icons.meeting_room_outlined, text: event.roomId!),
        if (event.lang != null)
          DetailRow(icon: Icons.language, text: event.lang!.toUpperCase()),
        if (event.aboutPresentationUrl != null || event.videoPresentationUrl != null) ...[
          const SizedBox(height: AppSpacing.s),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
        ],
        if (event.aboutPresentationUrl != null)
          DetailLinkRow(
            icon: Icons.article_outlined,
            label: 'About this presentation',
            url: event.aboutPresentationUrl!,
          ),
        if (event.videoPresentationUrl != null) ...[
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: () => launchUrl(
                Uri.parse(event.videoPresentationUrl!),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: const Text('Watch recording'),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.l),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: () =>
                ref.read(toggleFavoriteUseCaseProvider).execute(event.id),
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
            ),
            label: Text(isFavorite ? 'Saved' : 'Add to favorites'),
          ),
        ),
      ],
    );
  }
}

/// Fila de detalle de un evento.
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de enlace externo en el detalle de un evento.
class DetailLinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const DetailLinkRow({
    super.key,
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      ),
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.open_in_new_rounded,
              size: 14,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
