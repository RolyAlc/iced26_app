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
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/slot_presentation_tile.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

// TODO: Revisar if muchos

const _kSingularTalk = 'talk';
const _kPluralTalks = 'talks';
const _kSingularSession = 'session';
const _kPluralSessions = 'sessions';
const _kNoPresentations = 'No presentations';
const _kCollapseLabel = 'Collapse';
const _kCollapseThreshold = 4;
const _kCollapseIconSize = 18.0;

/// Muestra el sheet interior del slot desde cualquier contexto.
void showSessionSlotDetail(
  BuildContext context,
  SessionSlotItem item,
  String locale,
) {
  AppBottomSheet.show(
    context: context,
    title: item.event.title.resolve(locale),
    isFullHeight: true,
    child: _SlotPresentationList(blocks: item.blocks),
  );
}

/// Slot que contiene varias presentaciones en un mismo bloque.
class SessionSlotBlock extends StatelessWidget {
  const SessionSlotBlock({super.key, required this.item});
  final SessionSlotItem item;

  void _showSheet(BuildContext context, String locale) {
    showSessionSlotDetail(context, item, locale);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final time = item.event.filterTime;
    final isLive = EventStatusResolver.resolve(item.event) == EventStatus.live;

    // Sin bookmark — los favoritos son de presentaciones individuales,
    // no del slot contenedor. El usuario guarda desde el sheet interior.
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showSheet(context, locale),
        child: ScheduleCardRow(
          title: item.event.title.resolve(locale),
          infoBadges: [
            if (item.event.subtype != null && item.event.subtype!.isNotEmpty)
              ScheduleInfoChip(
                label: item.event.subtype!,
                icon: item.event.type.style(Theme.of(context).colorScheme).icon,
              ),
            ScheduleInfoChip(
              label:
                  '${item.blocks.length} ${item.blocks.length == 1 ? _kSingularSession : _kPluralSessions}',
              icon: AppIcons.sessions,
              variant: ScheduleChipVariant.tertiary,
            ),
          ],
          time: time,
          isLive: isLive,
          bottomAction: Icon(
            AppIcons.chevronRight,
            color: theme.colorScheme.onSurfaceVariant,
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// Lista de presentaciones agrupadas por bloque.
class _SlotPresentationList extends ConsumerWidget {
  _SlotPresentationList({required this.blocks})
    : blockIds = blocks.map((b) => b.id).toList();

  final List<SessionBlock> blocks;
  final List<String> blockIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPresentations = ref.watch(
      presentationsForSlotProvider(blockIds),
    );
    final peopleIndex = ref.watch(allPeopleIndexProvider).value ?? {};
    final roomsIndex = ref.watch(allRoomsIndexProvider).value ?? {};
    final locale = Localizations.localeOf(context).languageCode;

    return asyncPresentations.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (grouped) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks.asMap().entries.map((entry) {
          final block = entry.value;
          // Fallback al roomId raw si el nombre no está en el índice.
          final roomName =
              roomsIndex[block.roomId]?.name.resolve(locale) ?? block.roomId;
          return _BlockSection(
            block: block,
            presentations: grouped[block.id] ?? [],
            peopleIndex: peopleIndex,
            isFirstBlock: entry.key == 0,
            roomName: roomName,
          );
        }).toList(),
      ),
    );
  }
}

/// Sección que muestra las presentaciones de un bloque.
class _BlockSection extends StatefulWidget {
  const _BlockSection({
    required this.block,
    required this.presentations,
    required this.peopleIndex,
    required this.isFirstBlock,
    this.roomName,
  });

  final SessionBlock block;
  final List<Presentation> presentations;
  final Map<String, Person> peopleIndex;
  final bool isFirstBlock;
  final String? roomName;

  @override
  State<_BlockSection> createState() {
    return _BlockSectionState();
  }
}

class _BlockSectionState extends State<_BlockSection> {
  late final ExpansibleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpansibleController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeRange = DateHelper.formatTimeRange(
      widget.block.startDate,
      widget.block.endDate,
    );
    final talkCount = widget.presentations.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          controller: _controller,
          initiallyExpanded: widget.isFirstBlock,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          tilePadding: const EdgeInsets.fromLTRB(
            AppSpacing.m,
            AppSpacing.m,
            AppSpacing.m,
            AppSpacing.m,
          ),
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.xs,
            children: [
              if (widget.block.track != null)
                ScheduleInfoChip(
                  label: widget.block.track!,
                  variant: ScheduleChipVariant.primary,
                ),
              if (widget.roomName != null)
                ScheduleInfoChip(
                  label: widget.roomName!,
                  icon: AppIcons.meetingRoom,
                  size: ScheduleChipSize.medium,
                ),
              if (timeRange.isNotEmpty)
                ScheduleInfoChip(
                  label: timeRange,
                  icon: AppIcons.time,
                  size: ScheduleChipSize.medium,
                ),
              if (talkCount > 0)
                ScheduleInfoChip(
                  label:
                      '$talkCount ${talkCount == 1 ? _kSingularTalk : _kPluralTalks}',
                  icon: AppIcons.mic,
                  size: ScheduleChipSize.medium,
                ),
            ],
          ),
          children: [
            Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            if (widget.presentations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                child: Text(
                  _kNoPresentations,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              )
            else
              ...widget.presentations.map(
                (p) => SlotPresentationTile(
                  presentation: p,
                  peopleIndex: widget.peopleIndex,
                ),
              ),
            if (talkCount > _kCollapseThreshold)
              _CollapseFooter(controller: _controller),
          ],
        ),
      ),
    );
  }
}

/// Footer "Collapse" visible solo cuando el bloque tiene más de [_kCollapseThreshold] charlas.
/// Evita que el usuario tenga que hacer scroll hasta el header para colapsar.
class _CollapseFooter extends StatelessWidget {
  const _CollapseFooter({required this.controller});

  final ExpansibleController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = theme.colorScheme.primary;

    return InkWell(
      onTap: controller.collapse,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppRadius.m),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.collapse,
              size: _kCollapseIconSize,
              color: actionColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _kCollapseLabel,
              style: theme.textTheme.labelMedium?.copyWith(color: actionColor),
            ),
          ],
        ),
      ),
    );
  }
}
