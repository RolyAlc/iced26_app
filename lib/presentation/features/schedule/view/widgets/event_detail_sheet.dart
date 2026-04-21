import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';

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

  String? _formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return null;
    final minutes = end.difference(start).inMinutes;
    if (minutes <= 0) return null;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '$m min';
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = resolveTypeStyle(context, event.type);
    final duration = _formatDuration(event.startDate, event.endDate);
    final favoriteIds = ref.watch(favoriteIdsProvider).valueOrNull ?? {};
    final isFavorite = favoriteIds.contains(event.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: AppSpacing.m),
        if (event.filterTime != null)
          DetailRow(icon: Icons.access_time, text: event.filterTime!),
        if (duration != null) DetailRow(icon: Icons.timelapse, text: duration),
        if (event.roomId != null)
          DetailRow(icon: Icons.meeting_room_outlined, text: event.roomId!),
        if (event.lang != null)
          DetailRow(icon: Icons.language, text: event.lang!.toUpperCase()),
        const SizedBox(height: AppSpacing.l),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: () =>
                ref.read(toggleFavoriteUseCaseProvider).execute(event.id),
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
            ),
            label: Text(isFavorite ? 'Saved' : 'Add to Favorites'),
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
