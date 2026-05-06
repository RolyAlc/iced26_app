import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_note_card.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor_sheet.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/widgets/app_page.dart';

// TODO: Pte de revisar Refactorización

/// Pantalla del diario personal del usuario.
class DiaryView extends ConsumerWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(header: _DiaryHeader(), children: [const _DiaryBody()]);
  }
}

/// Header de la pantalla del diario.
class _DiaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Text('My Diary', style: theme.textTheme.headlineMedium),
    );
  }
}

/// Cuerpo de la pantalla del diario.
class _DiaryBody extends ConsumerWidget {
  const _DiaryBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(diaryNotesProvider);
    final eventsAsync = ref.watch(diaryConferenceEventsProvider);
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final focusedMonth = ref.watch(diaryFocusedMonthProvider);

    final allNotes = notesAsync.value ?? [];
    final eventsByDay = eventsAsync.value ?? {};

    final notesForDay = getNotesForDay(allNotes, selectedDate);
    final eventsForDay = getEventsForDay(eventsByDay, selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DiaryCalendar(
          allNotes: allNotes,
          eventsByDay: eventsByDay,
          selectedDate: selectedDate,
          focusedMonth: focusedMonth,
          onDaySelected: (day) => _onDaySelected(ref, day),
          onPageChanged: (month) => _onPageChanged(ref, month),
        ),
        const Divider(height: 1),
        _DayContent(
          selectedDate: selectedDate,
          notes: notesForDay,
          events: eventsForDay,
          ref: ref,
        ),
      ],
    );
  }

  /// Mejora: encapsular interacción con providers
  void _onDaySelected(WidgetRef ref, DateTime day) {
    ref.read(selectedDiaryDateProvider.notifier).select(day);
    ref.read(diaryFocusedMonthProvider.notifier).set(day);
  }

  /// Mejora: encapsular interacción con providers
  void _onPageChanged(WidgetRef ref, DateTime month) {
    ref.read(diaryFocusedMonthProvider.notifier).set(month);
  }
}

/// Calendario personal del diario.
class _DiaryCalendar extends StatelessWidget {
  final List<DiaryNote> allNotes;
  final Map<DateTime, List<Event>> eventsByDay;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final void Function(DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const _DiaryCalendar({
    required this.allNotes,
    required this.eventsByDay,
    required this.selectedDate,
    required this.focusedMonth,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TableCalendar<Object>(
      firstDay: DateTime(2025, 1, 1),
      lastDay: DateTime(2027, 12, 31),
      focusedDay: focusedMonth,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      onDaySelected: (selected, _) => onDaySelected(selected),
      onPageChanged: onPageChanged,
      eventLoader: (day) =>
          getItemsForDay(day: day, notes: allNotes, eventsByDay: eventsByDay),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, _) => _buildMarkers(context, day, colors),
      ),
      calendarStyle: _calendarStyle(colors),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  /// Mejora: separar builder complejo
  Widget? _buildMarkers(
    BuildContext context,
    DateTime day,
    ColorScheme colors,
  ) {
    final eventExists = hasEvent(eventsByDay, day);
    final noteExists = hasNote(allNotes, day);

    if (!eventExists && !noteExists) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (eventExists) _Dot(color: colors.primary),
        if (noteExists) _Dot(color: colors.secondary),
      ],
    );
  }

  /// Mejora: extraer estilo
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

/// Normaliza una fecha sin hora (clave para mapas)
DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Filtra notas por día
List<DiaryNote> getNotesForDay(List<DiaryNote> notes, DateTime day) {
  return notes.where((n) => isSameDay(n.date, day)).toList();
}

/// Obtiene eventos por día
List<Event> getEventsForDay(
  Map<DateTime, List<Event>> eventsByDay,
  DateTime day,
) {
  final key = normalizeDate(day);
  return eventsByDay[key] ?? [];
}

/// Combina eventos + notas (para calendar)
List<Object> getItemsForDay({
  required DateTime day,
  required List<DiaryNote> notes,
  required Map<DateTime, List<Event>> eventsByDay,
}) {
  final events = getEventsForDay(eventsByDay, day);
  final notesForDay = getNotesForDay(notes, day);

  return [...events, ...notesForDay];
}

/// Determina si hay evento en el día
bool hasEvent(Map<DateTime, List<Event>> eventsByDay, DateTime day) {
  final key = normalizeDate(day);
  return (eventsByDay[key] ?? []).isNotEmpty;
}

/// Determina si hay nota en el día
bool hasNote(List<DiaryNote> notes, DateTime day) {
  return notes.any((n) => isSameDay(n.date, day));
}

/// Contenido del día seleccionado.
class _DayContent extends StatelessWidget {
  final DateTime selectedDate;
  final List<DiaryNote> notes;
  final List<Event> events;
  final WidgetRef ref;

  const _DayContent({
    required this.selectedDate,
    required this.notes,
    required this.events,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (events.isNotEmpty) ...[
            Text(
              'Congress',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ...events.map((e) => _EventTile(event: e)),
            const SizedBox(height: AppSpacing.m),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My notes', style: theme.textTheme.labelLarge),
              IconButton.filledTonal(
                icon: const Icon(AppIcons.add),
                onPressed: () =>
                    NoteEditorSheet.show(context, date: selectedDate),
                tooltip: 'Add note',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (notes.isEmpty)
            _EmptyNotes(
              onAdd: () => NoteEditorSheet.show(context, date: selectedDate),
            )
          else
            ...notes.map(
              (note) => DiaryNoteCard(
                note: note,
                onEdit: () => NoteEditorSheet.show(
                  context,
                  date: selectedDate,
                  existingNote: note,
                ),
                onDelete: () =>
                    ref.read(deleteDiaryNoteUseCaseProvider).execute(note.id),
              ),
            ),
        ],
      ),
    );
  }
}

/// Card para mostrar un evento en el diario.
class _EventTile extends StatelessWidget {
  final Event event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(AppIcons.scheduleOff, size: 16, color: colors.primary),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              event.title.resolve('en'),
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (event.filterTime != null)
            Text(
              event.filterTime!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Mensaje de vacío cuando no hay notas.
class _EmptyNotes extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyNotes({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
      child: Column(
        children: [
          Icon(AppIcons.bookmarkOff, size: 40, color: colors.outlineVariant),
          const SizedBox(height: AppSpacing.s),
          Text(
            'No notes for this day',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          TextButton(onPressed: onAdd, child: const Text('Add note')),
        ],
      ),
    );
  }
}

/// Punto utilizado para indicar eventos o notas en el calendario.
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
