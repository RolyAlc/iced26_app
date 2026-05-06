import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/diary_note.dart';

// TODO: reutilizable method¿??¿?

/// Sheet para crear o editar una nota del diario.
class NoteEditorSheet extends ConsumerStatefulWidget {
  final DateTime date;
  final DiaryNote? existingNote;

  const NoteEditorSheet({super.key, required this.date, this.existingNote});

  /// Muestra el bottom sheet de edición de notas.
  static Future<void> show(
    BuildContext context, {
    required DateTime date,
    DiaryNote? existingNote,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NoteEditorSheet(date: date, existingNote: existingNote),
    );
  }

  @override
  ConsumerState<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

/// Estado del bottom sheet de edición de notas.
class _NoteEditorSheetState extends ConsumerState<NoteEditorSheet> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingNote?.content);
  }

  /// Libera los recursos del controlador.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Guarda la nota del diario.
  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _saving = true);
    await ref
        .read(saveDiaryNoteUseCaseProvider)
        .execute(id: widget.existingNote?.id, date: widget.date, content: text);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = _monthDay(widget.date);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.l,
        right: AppSpacing.l,
        top: AppSpacing.l,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.l,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.m),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 6,
            minLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your note...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }

  /// Formatea la fecha a un formato legible (ej: 14 de abril de 2026).
  String _monthDay(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}
