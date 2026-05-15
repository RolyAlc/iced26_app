import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/slot_presentation_tile.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';
import 'package:iced26/presentation/shared/widgets/slot_time_label.dart';

const _kSeparator = '  ·  ';

/// Slot que contiene varias presentaciones en un mismo bloque.
class SessionSlotBlock extends StatelessWidget {
  final SessionSlotItem item;

  const SessionSlotBlock({super.key, required this.item});

  void _showSheet(BuildContext context, String locale) {
    final blockIds = item.blocks.map((b) => b.id).toList();
    AppBottomSheet.show(
      context: context,
      title: item.event.title.resolve(locale),
      isFullHeight: true,
      child: _SlotPresentationList(blocks: item.blocks, blockIds: blockIds),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final time = item.event.filterTime;
    final isLive = EventStatusResolver.resolve(item.event) == EventStatus.live;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showSheet(context, locale),
        bordered: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (time != null) ...[
                SlotTimeLabel(time: time, isLive: isLive),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  item.event.title.resolve(locale),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(AppIcons.expandMore, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge que muestra el track.
class _TrackBadge extends StatelessWidget {
  final String track;
  const _TrackBadge({required this.track});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        track,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Lista de presentaciones agrupadas por bloque.
/// Resuelve `allPeopleIndexProvider` una sola vez y lo pasa hacia abajo.
class _SlotPresentationList extends ConsumerWidget {
  final List<SessionBlock> blocks;
  final List<String> blockIds;

  const _SlotPresentationList({required this.blocks, required this.blockIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPresentations = ref.watch(
      presentationsForSlotProvider(blockIds),
    );
    final peopleIndex = ref.watch(allPeopleIndexProvider).value ?? {};

    return asyncPresentations.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (grouped) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks
            .map(
              (b) => _BlockSection(
                block: b,
                presentations: grouped[b.id] ?? [],
                peopleIndex: peopleIndex,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Sección que muestra las presentaciones de un bloque.
class _BlockSection extends StatelessWidget {
  final SessionBlock block;
  final List<Presentation> presentations;
  final Map<String, Person> peopleIndex;

  const _BlockSection({
    required this.block,
    required this.presentations,
    required this.peopleIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeRange = DateHelper.formatTimeRange(
      block.startDate,
      block.endDate,
    );
    final talkCount = presentations.length;
    final headerParts = [
      if (block.roomId != null) block.roomId!,
      if (timeRange.isNotEmpty) timeRange,
      if (talkCount > 0) '$talkCount ${talkCount == 1 ? 'talk' : 'talks'}',
    ];

    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: const EdgeInsets.only(
        top: AppSpacing.m,
        bottom: AppSpacing.s,
      ),
      childrenPadding: EdgeInsets.zero,
      // Elimina los bordes por defecto del ExpansionTile
      shape: const Border(),
      collapsedShape: const Border(),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Row(
        children: [
          if (block.track != null) ...[
            _TrackBadge(track: block.track!),
            const SizedBox(width: AppSpacing.s),
          ],
          if (headerParts.isNotEmpty)
            Flexible(
              child: Text(
                headerParts.join(_kSeparator),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      children: [
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        if (presentations.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
            child: Text(
              'No presentations',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          )
        else
          ...presentations.map(
            (p) =>
                SlotPresentationTile(presentation: p, peopleIndex: peopleIndex),
          ),
      ],
    );
  }
}
