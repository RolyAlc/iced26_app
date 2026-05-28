import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_event_tile.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_helpers.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_note_card.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/diary_note_editor_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';

const _kCongressLabel = 'Congress';
const _kMyNotesLabel = 'My notes';
const _kEmptyNoteTitle = 'No notes for this day';
const _kEmptyNoteMessage = 'Tap + to write your first note';

/// Renderiza las notas y los eventos del congreso de un día concreto.
/// Stateless para que el padre (DiaryBody) controle la selección del día y las callbacks de borrado.
class DiaryDayContent extends StatelessWidget {
  const DiaryDayContent({
    super.key,
    required this.selectedDate,
    required this.notes,
    required this.events,
    required this.onDeleteNote,
  });

  final DateTime selectedDate;
  final List<DiaryNote> notes;
  final List<Event> events;
  final void Function(int id) onDeleteNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
        vertical: AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDayHeader(theme, l10n),
          const SizedBox(height: AppSpacing.m),
          if (events.isNotEmpty) _CongressEventsList(events: events),
          _buildNotesLabel(theme),
          const SizedBox(height: AppSpacing.xs),
          _NotesList(
            notes: notes,
            selectedDate: selectedDate,
            onDeleteNote: onDeleteNote,
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(ThemeData theme, AppLocalizations l10n) {
    return Text(
      DiaryHelpers.formatDayHeader(selectedDate, l10n),
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNotesLabel(ThemeData theme) {
    return Text(
      _kMyNotesLabel,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// Lista de eventos del congreso para un día concreto.
class _CongressEventsList extends StatelessWidget {
  const _CongressEventsList({required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _kCongressLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final e in events) DiaryEventTile(event: e),
        const SizedBox(height: AppSpacing.m),
      ],
    );
  }
}

/// Lista de notas del usuario para un día concreto.
class _NotesList extends StatelessWidget {
  const _NotesList({
    required this.notes,
    required this.selectedDate,
    required this.onDeleteNote,
  });

  final List<DiaryNote> notes;
  final DateTime selectedDate;
  final void Function(int id) onDeleteNote;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return AppEmptyState(
        illustration: Icon(
          AppIcons.article,
          size: 40,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        title: _kEmptyNoteTitle,
        message: _kEmptyNoteMessage,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
      );
    }

    return Column(
      children: [
        for (final note in notes)
          DiaryNoteCard(
            note: note,
            onEdit: () => DiaryNoteEditorSheet.show(
              context,
              date: selectedDate,
              existingNote: note,
            ),
            onDelete: () => onDeleteNote(note.id),
          ),
      ],
    );
  }
}
