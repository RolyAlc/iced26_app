import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';
import 'package:iced26/presentation/helpers/diary_helpers.dart';

/// Calendario del diario donde se pueden ver las notas y eventos.
class DiaryCalendar extends StatefulWidget {
  final List<DiaryNote> allNotes;
  final Map<DateTime, List<Event>> eventsByDay;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final void Function(DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const DiaryCalendar({
    super.key,
    required this.allNotes,
    required this.eventsByDay,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

final _kFirstDay = DateTime(2025, 1, 1);
final _kLastDay = DateTime(2027, 12, 31);

/// Formatos disponibles para el calendario.
const _kCalendarFormats = {
  CalendarFormat.month: 'Month',
  CalendarFormat.week: 'Week',
};

/// Estado del calendario del diario.
class _DiaryCalendarState extends State<DiaryCalendar> {
  /// Formato actual del calendario.
  CalendarFormat _format = CalendarFormat.week;

  /// Establece el formato del calendario.
  void _setFormat(CalendarFormat format) {
    setState(() => _format = format);
  }

  /// Alterna el formato del calendario.
  void _toggleFormat() {
    _setFormat(
      _format == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final daysOfWeekHeight = textScaler.scale(20.0) + 4;

    return Column(
      children: [
        TableCalendar<Object>(
          firstDay: _kFirstDay,
          lastDay: _kLastDay,
          focusedDay: widget.focusedMonth,
          calendarFormat: _format,
          availableCalendarFormats: _kCalendarFormats,
          selectedDayPredicate: (day) => isSameDay(day, widget.selectedDate),
          onDaySelected: (selected, _) => widget.onDaySelected(selected),
          onPageChanged: widget.onPageChanged,
          onFormatChanged: _setFormat,
          eventLoader: (day) => DiaryHelpers.itemsForDay(
            day: day,
            notes: widget.allNotes,
            eventsByDay: widget.eventsByDay,
          ),
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, focusedDay) =>
                _buildHeaderTitle(context, focusedDay, colors),
            markerBuilder: (context, day, _) =>
                _buildMarkers(context, day, colors),
          ),
          calendarStyle: _calendarStyle(colors),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: colors.onSurfaceVariant),
            weekendStyle: TextStyle(color: colors.onSurfaceVariant),
          ),
          daysOfWeekHeight: daysOfWeekHeight,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronIcon: Icon(
              AppIcons.chevronRight,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
            rightChevronPadding: const EdgeInsets.all(AppSpacing.s),
            rightChevronMargin: EdgeInsets.zero,
            headerPadding: const EdgeInsets.only(bottom: AppSpacing.s),
          ),
        ),
        GestureDetector(
          onTap: _toggleFormat,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 24,
            child: Center(
              child: AnimatedRotation(
                turns: _format == CalendarFormat.month ? 0.5 : 0.0,
                duration: AppDuration.medium,
                child: Icon(
                  AppIcons.expand,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el botón de anterior.
  Widget _buildPrevButton(DateTime focusedDay, ColorScheme colors) {
    final prevMonth = DateTime(focusedDay.year, focusedDay.month - 1);
    final canGoBack = !prevMonth.isBefore(_kFirstDay);

    return InkWell(
      onTap: canGoBack ? () => widget.onPageChanged(prevMonth) : null,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Icon(
          AppIcons.chevronLeft,
          size: 20,
          color: canGoBack
              ? colors.onSurfaceVariant
              : colors.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  /// Construye el título del header.
  Widget _buildHeaderTitle(
    BuildContext context,
    DateTime focusedDay,
    ColorScheme colors,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          DateHelper.formatMonthYear(focusedDay),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _buildPrevButton(focusedDay, colors),
      ],
    );
  }

  /// Construye los marcadores del día.
  Widget? _buildMarkers(
    BuildContext context,
    DateTime day,
    ColorScheme colors,
  ) {
    final eventExists = DiaryHelpers.hasEvent(widget.eventsByDay, day);
    final noteExists = DiaryHelpers.hasNote(widget.allNotes, day);

    if (!eventExists && !noteExists) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (eventExists) _Dot(color: colors.primary),
        if (noteExists) _Dot(color: colors.secondary),
      ],
    );
  }

  /// Estilo del calendario.
  CalendarStyle _calendarStyle(ColorScheme colors) {
    final defaultText = TextStyle(color: colors.onSurface);
    final mutedText = TextStyle(color: colors.onSurface.withValues(alpha: 0.4));

    return CalendarStyle(
      defaultTextStyle: defaultText,
      weekendTextStyle: defaultText,
      outsideTextStyle: mutedText,
      disabledTextStyle: mutedText,
      selectedTextStyle: TextStyle(color: colors.onPrimary),
      selectedDecoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      todayDecoration: BoxDecoration(
        color: colors.primaryContainer,
        shape: BoxShape.circle,
      ),
      todayTextStyle: TextStyle(color: colors.onPrimaryContainer),
      markerDecoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      markersMaxCount: 2,
    );
  }
}

/// Punto indicador de que hay una nota o evento en el día.
class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

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
