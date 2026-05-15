import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';
import 'package:iced26/presentation/shared/widgets/slot_time_label.dart';

/// Tarjeta para mostrar una presentación guardada dentro de la pantalla 'My Schedule'.
class SavedPresentationCard extends ConsumerWidget {
  const SavedPresentationCard({super.key, required this.presentation});
  final Presentation presentation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final title =
        presentation.title?.resolve(locale) ?? presentation.externalRef ?? '—';
    final timeRange = DateHelper.formatTimeRange(
      presentation.startDate,
      presentation.endDate,
    );
    final isFavorite =
        ref
            .watch(presentationFavoriteIdsProvider)
            .value
            ?.contains(presentation.id) ??
        false;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => showPresentationDetail(context, presentation),
        bordered: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (timeRange.isNotEmpty) ...[
                SlotTimeLabel(time: timeRange),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (presentation.track != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Track ${presentation.track!}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkOutline,
                  color: isFavorite ? colors.primary : colors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(togglePresentationFavoriteUseCaseProvider)
                      .execute(presentation.id);
                },
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Icon(AppIcons.chevronRight, color: colors.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
