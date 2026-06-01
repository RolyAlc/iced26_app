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

// Cambios manuales implementado en las variables.
const double _kDaysOfWeekBaseHeight = 20.0;
const double _kDaysOfWeekHeightPad = 4.0;
const double _kFormatToggleHeight = 24.0;
const double _kCalendarRowHeight = 44.0;
const double _kCalendarIconSize = 20.0;
const double _kDotSize = 6.0;
const double _kDotMargin = 1.0;
const double _kCellMarginBottom = 10.0;
const double _kNoteBorderWidth = 1.5;
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
    required this.today,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final List<DiaryNote> allNotes;
  final Map<DateTime, List<Event>> eventsByDay;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final DateTime today;
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

    final daysWithNotes = {
      for (final note in widget.allNotes)
        DateTime(note.date.year, note.date.month, note.date.day),
    };

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
              return _CalendarDowCell(day: day, today: widget.today);
            },
            defaultBuilder: (context, day, focusedDay) {
              final normalized = DateTime(day.year, day.month, day.day);
              if (!daysWithNotes.contains(normalized)) {
                return null;
              }
              return _NoteOutlineCell(day: day, colors: colors);
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
        InkWell(
          onTap: () => _toggleFormat(format),
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

  static CalendarStyle _calendarStyle(ColorScheme colors) {
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
      cellMargin: const EdgeInsets.fromLTRB(6, 6, 6, _kCellMarginBottom),
    );
  }
}

/// Celda del encabezado de día de semana. Resalta en bold + primary el día de hoy.
class _CalendarDowCell extends StatelessWidget {
  const _CalendarDowCell({required this.day, required this.today});

  final DateTime day;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isToday = day.weekday == today.weekday;

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
          _ChevronButton(icon: AppIcons.chevronLeft, onPressed: onPrevMonth),
          _ChevronButton(icon: AppIcons.chevronRight, onPressed: onNextMonth),
        ],
      ),
    );
  }
}

/// Botón de chevron compacto para navegar entre meses.
class _ChevronButton extends StatelessWidget {
  const _ChevronButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(
        icon,
        size: _kCalendarIconSize,
        color: colors.onSurfaceVariant,
      ),
      onPressed: onPressed,
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
    // Set<Color> elimina duplicados preservando el orden de inserción (LinkedHashSet).
    final moodColors = <Color>{
      for (final n in notes)
        if (n.color case final c?) c.color,
    }.take(3).toList();

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

/// Celda de día con nota — círculo outline sin relleno.
///
/// `defaultBuilder` en table_calendar no aplica cellMargin automáticamente,
/// por eso este widget incluye el mismo margin que CalendarStyle.cellMargin.
class _NoteOutlineCell extends StatelessWidget {
  const _NoteOutlineCell({required this.day, required this.colors});

  final DateTime day;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.fromLTRB(6, 6, 6, _kCellMarginBottom),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: _kNoteBorderWidth),
      ),
      alignment: Alignment.center,
      child: Text('${day.day}', style: TextStyle(color: colors.onSurface)),
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
      width: _kDotSize,
      height: _kDotSize,
      margin: const EdgeInsets.symmetric(horizontal: _kDotMargin),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
