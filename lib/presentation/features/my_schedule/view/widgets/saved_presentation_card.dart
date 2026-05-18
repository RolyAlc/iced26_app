import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

const _kTrackPrefix = 'Track';

/// Botón para marcar una presentación guardada como favorita.
class _SavedBookmarkButton extends ConsumerWidget {
  const _SavedBookmarkButton({
    required this.presentationId,
    required this.isFavorite,
  });
  final String presentationId;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: isFavorite
            ? colors.tertiary.withValues(alpha: 0.15)
            : null,
        foregroundColor: isFavorite ? colors.tertiary : colors.onSurfaceVariant,
      ),
      icon: Icon(
        isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkOff,
        size: 20,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(togglePresentationFavoriteUseCaseProvider)
            .execute(presentationId);
      },
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }
}

/// Tarjeta para mostrar una presentación guardada dentro de la pantalla 'My Schedule'.
class SavedPresentationCard extends ConsumerWidget {
  const SavedPresentationCard({super.key, required this.presentation});
  final Presentation presentation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final colors = Theme.of(context).colorScheme;

    final title =
        presentation.title?.resolve(locale) ?? presentation.externalRef ?? '—';
    final timeRange = DateHelper.formatTimeRange(
      presentation.startDate,
      presentation.endDate,
    );
    final subtitle = presentation.track != null
        ? '$_kTrackPrefix ${presentation.track!}'
        : null;
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
        child: ScheduleCardRow(
          title: title,
          infoBadges: [
            if (subtitle != null)
              ScheduleInfoChip(label: subtitle, icon: AppIcons.category),
          ],
          time: timeRange.isNotEmpty ? timeRange : null,
          topAction: _SavedBookmarkButton(
            presentationId: presentation.id,
            isFavorite: isFavorite,
          ),
          bottomAction: Icon(
            AppIcons.chevronRight,
            color: colors.onSurfaceVariant,
            size: 22,
          ),
        ),
      ),
    );
  }
}
