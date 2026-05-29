import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_card_row.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/session_slot_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';

const _kTimelineColumnWidth = 56.0;

/// Vista agenda del schedule: timeline vertical con hora, dot y línea.
/// Alternativa a la vista de lista — mismos datos, distinta presentación.
class ScheduleAgendaView extends StatelessWidget {
  const ScheduleAgendaView({super.key, required this.items});

  final List<ScheduleItem> items;

  @override
  Widget build(BuildContext context) {
    // Los DaySeparatorItem solo aparecen con filtro activo, y el toggle
    // de agenda se oculta en ese caso. Los filtramos por defensividad.
    final agendaItems = items
        .where((item) => item is! DaySeparatorItem)
        .toList();

    if (agendaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: agendaItems.indexed.map((entry) {
        final (index, item) = entry;
        return _AgendaItem(item: item, isLast: index == agendaItems.length - 1);
      }).toList(),
    );
  }
}

/// Un elemento del timeline: columna izquierda (hora + línea/dot) + contenido.
class _AgendaItem extends StatelessWidget {
  const _AgendaItem({required this.item, required this.isLast});

  final ScheduleItem item;
  final bool isLast;

  Event _event() {
    return switch (item) {
      SingleEventItem(:final event) => event,
      SessionSlotItem(:final event) => event,
      DaySeparatorItem() => throw StateError('DaySeparatorItem in agenda'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final event = _event();
    final time = event.filterTime ?? '--:--';
    final isLive = EventStatusResolver.resolve(event) == EventStatus.live;
    final dotColor = isLive ? colors.primary : colors.outlineVariant;
    final lineColor = colors.outlineVariant.withValues(alpha: 0.5);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Columna izquierda: hora + dot/línea
          SizedBox(
            width: _kTimelineColumnWidth,
            child: Column(
              children: [
                Text(
                  time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isLive ? colors.primary : colors.onSurfaceVariant,
                    fontWeight: isLive ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: CustomPaint(
                    painter: _TimelinePainter(
                      dotColor: dotColor,
                      lineColor: lineColor,
                      isLast: isLast,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          // Columna derecha: contenido del evento
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.m),
              child: _AgendaItemContent(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

/// Delega al widget concreto según el tipo de item.
class _AgendaItemContent extends StatelessWidget {
  const _AgendaItemContent({required this.item});

  final ScheduleItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      SingleEventItem(:final event) => _SingleEventCard(event: event),
      SessionSlotItem() => _SessionSlotCard(item: item as SessionSlotItem),
      DaySeparatorItem() => const SizedBox.shrink(),
    };
  }
}

/// Card de evento simple en la vista agenda.
class _SingleEventCard extends StatelessWidget {
  const _SingleEventCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final colors = theme.colorScheme;
    final typeStyle = event.type.style(colors);

    return InkWell(
      onTap: () => showEventDetail(context, event),
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ScheduleInfoChip(label: event.type.label, icon: typeStyle.icon),
            const SizedBox(height: AppSpacing.xs),
            Text(
              event.title.resolve(locale),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de slot paralelo en la vista agenda.
class _SessionSlotCard extends StatelessWidget {
  const _SessionSlotCard({required this.item});

  final SessionSlotItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final colors = theme.colorScheme;
    final trackCount = item.blocks.length;
    final trackLabel = l10n.scheduleTracks(trackCount);

    return InkWell(
      onTap: () => showSessionSlotDetail(context, item, locale),
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.event.title.resolve(locale),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ScheduleInfoChip(
                    label: trackLabel,
                    icon: AppIcons.sessions,
                    variant: ScheduleChipVariant.tertiary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Icon(
              AppIcons.chevronRight,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter del timeline: dot en la parte superior + línea hacia abajo (salvo en el último item).
class _TimelinePainter extends CustomPainter {
  const _TimelinePainter({
    required this.dotColor,
    required this.lineColor,
    required this.isLast,
  });

  final Color dotColor;
  final Color lineColor;
  final bool isLast;

  static const _kDotRadius = 4.0;
  static const _kLineStroke = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    const dotY = _kDotRadius;

    canvas.drawCircle(Offset(x, dotY), _kDotRadius, Paint()..color = dotColor);

    if (!isLast) {
      canvas.drawLine(
        Offset(x, dotY + _kDotRadius + 2),
        Offset(x, size.height),
        Paint()
          ..color = lineColor
          ..strokeWidth = _kLineStroke,
      );
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) {
    return dotColor != old.dotColor ||
        lineColor != old.lineColor ||
        isLast != old.isLast;
  }
}
