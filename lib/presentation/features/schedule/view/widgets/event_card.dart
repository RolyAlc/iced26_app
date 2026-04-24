import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/schedule/view/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';

/// Tarjeta de un evento.
class EventCard extends ConsumerWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final style = resolveTypeStyle(context, event.type);
    final status = EventStatusResolver.resolve(event);
    // select() evita que la card se reconstruya cuando cambia el favorito de otro evento
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.valueOrNull?.contains(event.id) ?? false,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => showDetailSheet(context, event),
        borderRadius: AppRadius.m,
        bordered: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              TypeIcon(style: style),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title.resolve(locale),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (status != EventStatus.ended) ...[
                          const SizedBox(width: AppSpacing.xs),
                          EventStatusChip(status: status),
                        ],
                      ],
                    ),
                    if (event.filterTime != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        event.filterTime!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              if (isFavorite)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Icon(
                    Icons.bookmark,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icono que representa el tipo de evento.
class TypeIcon extends StatelessWidget {
  final EventTypeStyle style;
  final int? badge;

  const TypeIcon({super.key, required this.style, this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final container = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Icon(style.icon, color: style.color, size: 20),
    );

    if (badge == null) return container;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        container,
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(AppRadius.s),
            ),
            child: Text(
              '$badge',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.surface,
                fontSize: AppTextSize.chip,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
