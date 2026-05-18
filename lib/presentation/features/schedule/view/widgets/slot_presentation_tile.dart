import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';

// TODO: Codigo hadouken

/// Tile de presentación en la vista agenda.
class SlotPresentationTile extends ConsumerWidget {
  const SlotPresentationTile({
    super.key,
    required this.presentation,
    required this.peopleIndex,
  });
  final Presentation presentation;
  final Map<String, Person> peopleIndex;

  String? _speakerNames(String locale) {
    final names = presentation.speakers
        .map((s) => peopleIndex[s.personId]?.name.resolve(locale))
        .whereType<String>()
        .toList();
    return switch (names.length) {
      0 => null,
      1 => names.first,
      _ => '${names.first} ${AppStrings.speakersOverflow(names.length - 1)}',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final title = presentation.resolvedTitle(locale);
    final speakerNames = _speakerNames(locale);
    final isFavorite = ref.watch(
      presentationFavoriteIdsProvider.select(
        (ids) => ids.value?.contains(presentation.id) ?? false,
      ),
    );

    return Column(
      children: [
        InkWell(
          onTap: () => showPresentationDetail(context, presentation),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (speakerNames != null) ...[
                        const SizedBox(height: AppSpacing.s),
                        ScheduleInfoChip(
                          label: speakerNames,
                          icon: AppIcons.person,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                _TileActions(
                  presentationId: presentation.id,
                  isFavorite: isFavorite,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ],
    );
  }
}

/// Columna de acciones del tile: bookmark arriba, chevron abajo.
class _TileActions extends ConsumerWidget {
  const _TileActions({required this.presentationId, required this.isFavorite});
  final String presentationId;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: isFavorite
                ? colors.tertiary.withValues(alpha: 0.15)
                : null,
            foregroundColor: isFavorite
                ? colors.tertiary
                : colors.onSurfaceVariant,
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
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        ),
        Icon(AppIcons.chevronRight, color: colors.primary, size: 22),
      ],
    );
  }
}
