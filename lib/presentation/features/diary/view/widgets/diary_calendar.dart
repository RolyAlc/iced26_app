import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_helpers.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:table_calendar/table_calendar.dart';

// TODO: Comentar a un lugar adecuado
// TODO: Class largos

const double _kDaysOfWeekBaseHeight = 20.0;
const double _kDaysOfWeekHeightPad = 4.0;
const double _kFormatToggleHeight = 24.0;
const double _kCalendarRowHeight = 40.0;
const double _kCalendarIconSize = 20.0;
const _kCalendarFormats = {
  CalendarFormat.month: 'Month',
  CalendarFormat.week: 'Week',
};

/// Calendario del diario donde se pueden ver las notas y eventos.
class DiaryCalendar extends ConsumerStatefulWidget {
  const DiaryCalendar({
    super.key,
    required this.allNotes,
    required this.eventsByDay,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final List<DiaryNote> allNotes;
  final Map<DateTime, List<Event>> eventsByDay;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final void Function(DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  @override
  ConsumerState<DiaryCalendar> createState() => _DiaryCalendarState();
}

/// Estado del calendario del diario.
class _DiaryCalendarState extends ConsumerState<DiaryCalendar> {
  void _setFormat(CalendarFormat format) {
    ref.read(diaryCalendarFormatProvider.notifier).set(format);
  }

  void _toggleFormat(CalendarFormat current) {
    _setFormat(
      current == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final daysOfWeekHeight =
        textScaler.scale(_kDaysOfWeekBaseHeight) + _kDaysOfWeekHeightPad;
    final format = ref.watch(diaryCalendarFormatProvider);

    return Column(
      children: [
        TableCalendar<Object>(
          firstDay: DiaryHelpers.firstDay,
          lastDay: DiaryHelpers.lastDay,
          focusedDay: widget.focusedMonth,
          calendarFormat: format,
          availableCalendarFormats: _kCalendarFormats,
          selectedDayPredicate: (day) =>
              DateHelper.isSameDay(day, widget.selectedDate),
          onDaySelected: (selected, _) => widget.onDaySelected(selected),
          onPageChanged: widget.onPageChanged,
          onFormatChanged: _setFormat,
          eventLoader: (day) => DiaryHelpers.itemsForDay(
            day: day,
            notes: widget.allNotes,
            eventsByDay: widget.eventsByDay,
          ),
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, focusedDay) {
              return _CalendarHeader(
                focusedDay: focusedDay,
                // Dart resuelve el overflow de mes: month 0 → diciembre del año anterior,
                // month 13 → enero del año siguiente. No hace falta protegerlo con un if.
                onPrevMonth: () => widget.onPageChanged(
                  DateTime(focusedDay.year, focusedDay.month - 1),
                ),
                onNextMonth: () => widget.onPageChanged(
                  DateTime(focusedDay.year, focusedDay.month + 1),
                ),
              );
            },
            dowBuilder: (context, day) {
              return _CalendarDowCell(day: day);
            },
            markerBuilder: (context, day, items) {
              return _CalendarDayMarkers(items: items);
            },
          ),
          rowHeight: _kCalendarRowHeight,
          calendarStyle: _calendarStyle(colors),
          daysOfWeekHeight: daysOfWeekHeight,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            leftChevronIcon: SizedBox.shrink(),
            leftChevronPadding: EdgeInsets.zero,
            leftChevronMargin: EdgeInsets.zero,
            rightChevronIcon: SizedBox.shrink(),
            rightChevronPadding: EdgeInsets.zero,
            rightChevronMargin: EdgeInsets.zero,
            headerPadding: EdgeInsets.only(bottom: AppSpacing.s),
          ),
        ),
        GestureDetector(
          onTap: () => _toggleFormat(format),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: _kFormatToggleHeight,
            child: Center(
              child: AnimatedRotation(
                turns: format == CalendarFormat.month ? 0.5 : 0.0,
                duration: AppDuration.medium,
                child: Icon(
                  AppIcons.expand,
                  size: _kCalendarIconSize,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CalendarStyle _calendarStyle(ColorScheme colors) {
    final defaultText = TextStyle(color: colors.onSurface);
    final mutedText = TextStyle(color: colors.onSurface.withValues(alpha: 0.4));

    return CalendarStyle(
      defaultTextStyle: defaultText,
      weekendTextStyle: defaultText,
      outsideTextStyle: mutedText,
      disabledTextStyle: mutedText,
      selectedTextStyle: TextStyle(
        color: colors.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      selectedDecoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      todayDecoration: BoxDecoration(
        color: colors.primaryContainer,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(
        color: colors.onPrimaryContainer,
        fontWeight: FontWeight.bold,
      ),
      markerDecoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      markersMaxCount: 2,
    );
  }
}

/// Celda del encabezado de día de semana. Resalta en bold + primary el día de hoy.
class _CalendarDowCell extends StatelessWidget {
  const _CalendarDowCell({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isToday = day.weekday == DateTime.now().weekday;

    return Center(
      child: Text(
        DateHelper.weekdayShort(day),
        style: TextStyle(
          color: isToday ? colors.primary : colors.onSurfaceVariant,
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

/// Encabezado del calendario con el mes y los botones de navegación.
class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.focusedDay,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime focusedDay;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s),
      child: Row(
        children: [
          Expanded(
            child: Text(
              DateHelper.formatMonthYear(focusedDay),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(
              AppIcons.chevronLeft,
              size: _kCalendarIconSize,
              color: colors.onSurfaceVariant,
            ),
            onPressed: onPrevMonth,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.s,
            ),
            // Sin esto Flutter fuerza un mínimo de 48×48 px en el botón
            // y los chevrones quedan visualmente separados aunque el padding sea pequeño.
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            icon: Icon(
              AppIcons.chevronRight,
              size: _kCalendarIconSize,
              color: colors.onSurfaceVariant,
            ),
            onPressed: onNextMonth,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.s,
            ),
            // Sin esto Flutter fuerza un mínimo de 48×48 px en el botón
            // y los chevrones quedan visualmente separados aunque el padding sea pequeño.
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Marcadores de días en el calendario.
class _CalendarDayMarkers extends StatelessWidget {
  const _CalendarDayMarkers({required this.items});

  final List<Object> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasEvent = items.whereType<Event>().isNotEmpty;
    final notes = items.whereType<DiaryNote>().toList();

    if (!hasEvent && notes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Colores de mood únicos (sin "None"), máximo 3, en orden de aparición.
    final moodColors = notes
        .where((n) => n.color != null)
        .map((n) => AppNoteColors.colorOf(n.color!))
        .toSet()
        .take(3)
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasEvent) _Dot(color: colors.primary),
        if (moodColors.isNotEmpty)
          ...moodColors.map((c) => _Dot(color: c))
        else if (notes.isNotEmpty)
          _Dot(color: colors.secondary),
      ],
    );
  }
}

/// Punto indicador de que hay una nota o evento en el día.
class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
