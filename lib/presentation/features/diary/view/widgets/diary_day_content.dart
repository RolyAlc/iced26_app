import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_event_tile.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_note_card.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/diary_note_editor_sheet.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';
import 'package:iced26/presentation/helpers/diary_helpers.dart';

/// Contenido del día seleccionado en el diario.
class DiaryDayContent extends StatelessWidget {
  final DateTime selectedDate;
  final List<DiaryNote> notes;
  final List<Event> events;
  final void Function(int id) onDeleteNote;

  const DiaryDayContent({
    super.key,
    required this.selectedDate,
    required this.notes,
    required this.events,
    required this.onDeleteNote,
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
          Text(
            DiaryHelpers.isToday(selectedDate)
                ? 'Today · ${DateHelper.formatDayShort(selectedDate)}'
                : DateHelper.formatDayLabel(selectedDate),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          if (events.isNotEmpty) ...[
            Text(
              'Congress',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ...events.map((e) => DiaryEventTile(event: e)),
            const SizedBox(height: AppSpacing.m),
          ],
          Text(
            'My notes',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (notes.isEmpty)
            const _EmptyNotes()
          else
            ...notes.map(
              (note) => DiaryNoteCard(
                note: note,
                onEdit: () => DiaryNoteEditorSheet.show(
                  context,
                  date: selectedDate,
                  existingNote: note,
                ),
                onDelete: () => onDeleteNote(note.id),
              ),
            ),
        ],
      ),
    );
  }
}

/// Estado cuando no hay notas en el día seleccionado.
class _EmptyNotes extends StatelessWidget {
  const _EmptyNotes();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
      child: Column(
        children: [
          Icon(AppIcons.article, size: 40, color: colors.outlineVariant),
          const SizedBox(height: AppSpacing.s),
          Text(
            'No notes for this day',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
