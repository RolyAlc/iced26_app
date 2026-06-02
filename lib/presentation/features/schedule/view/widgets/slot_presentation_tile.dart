import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';
import 'package:iced26/presentation/shared/helpers/event_sheet_router.dart';

const _kBookmarkIconSize = 20.0;
const _kChevronIconSize = 22.0;
// 36dp intencional: lista densa. M3 recomienda 48dp — si hay problemas táctiles, subir aquí.
const _kActionButtonMinSize = 36.0;

/// Tile de presentación en la vista agenda.
class SlotPresentationTile extends ConsumerWidget {
  const SlotPresentationTile({
    super.key,
    required this.talk,
    required this.peopleIndex,
  });

  final Event talk;
  final Map<String, Person> peopleIndex;

  String? _speakerNames(String locale, AppLocalizations l10n) {
    final names = talk.speakers
        .map((s) => peopleIndex[s.personId]?.name.resolve(locale))
        .whereType<String>()
        .toList();

    if (names.isEmpty) {
      return null;
    }
    final first = names.first;

    if (names.length == 1) return first;
    final remaining = names.length - 1;

    return '$first ${l10n.scheduleSpeakersOverflow(remaining)}';
  }

  Widget _buildTileContent(
    ThemeData theme,
    String title,
    String? speakerNames,
    bool isFavorite,
  ) {
    return Padding(
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
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (speakerNames != null) ...[
                  const SizedBox(height: AppSpacing.s),
                  ScheduleInfoChip(label: speakerNames, icon: AppIcons.person),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          _TileActions(eventId: talk.id, isFavorite: isFavorite),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final title = talk.title.resolve(locale);
    final speakerNames = _speakerNames(locale, l10n);
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.value?.contains(talk.id) ?? false,
      ),
    );

    return Column(
      children: [
        InkWell(
          onTap: () => showEventSheet(context, talk),
          child: _buildTileContent(theme, title, speakerNames, isFavorite),
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
// ConsumerWidget (no StatelessWidget) porque necesita ref.read en el handler del botón.
class _TileActions extends ConsumerWidget {
  const _TileActions({required this.eventId, required this.isFavorite});

  final String eventId;
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
            size: _kBookmarkIconSize,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            ref.read(toggleFavoriteUseCaseProvider).execute(eventId);
          },
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: _kActionButtonMinSize,
            minHeight: _kActionButtonMinSize,
          ),
        ),
        Icon(
          AppIcons.chevronRight,
          color: colors.primary,
          size: _kChevronIconSize,
        ),
      ],
    );
  }
}
