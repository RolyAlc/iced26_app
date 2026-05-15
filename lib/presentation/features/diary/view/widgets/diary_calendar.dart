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

/// Formatos disponibles para el calendario.
const _kCalendarFormats = {
  CalendarFormat.month: 'Month',
  CalendarFormat.week: 'Week',
};

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
    final daysOfWeekHeight = textScaler.scale(20.0) + 4;
    final format = ref.watch(diaryCalendarFormatProvider);

    return Column(
      children: [
        TableCalendar<Object>(
          firstDay: DiaryHelpers.firstDay,
          lastDay: DiaryHelpers.lastDay,
          focusedDay: widget.focusedMonth,
          calendarFormat: format,
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
            headerTitleBuilder: _buildHeaderTitle,
            markerBuilder: (context, day, items) =>
                _buildMarkers(context, items, colors),
          ),
          calendarStyle: _calendarStyle(colors),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: colors.onSurfaceVariant),
            weekendStyle: TextStyle(color: colors.onSurfaceVariant),
          ),
          daysOfWeekHeight: daysOfWeekHeight,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            leftChevronIcon: Icon(
              AppIcons.chevronLeft,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
            leftChevronPadding: const EdgeInsets.all(AppSpacing.s),
            leftChevronMargin: EdgeInsets.zero,
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
          onTap: () => _toggleFormat(format),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 24,
            child: Center(
              child: AnimatedRotation(
                turns: format == CalendarFormat.month ? 0.5 : 0.0,
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

  Widget _buildHeaderTitle(BuildContext context, DateTime focusedDay) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s),
      child: Text(
        DateHelper.formatMonthYear(focusedDay),
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Construye los marcadores del día con dots de mood reales.
  Widget? _buildMarkers(
    BuildContext context,
    List<Object> items,
    ColorScheme colors,
  ) {
    final hasEvent = items.whereType<Event>().isNotEmpty;
    final notes = items.whereType<DiaryNote>().toList();

    if (!hasEvent && notes.isEmpty) return null;

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
