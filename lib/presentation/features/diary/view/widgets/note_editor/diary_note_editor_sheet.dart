import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_color_selector.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_header.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_inputs.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_section_label.dart';
import 'package:iced26/presentation/widgets/app_button.dart';

/// Sheet para editar o crear una nota del diario.
class DiaryNoteEditorSheet extends ConsumerStatefulWidget {
  final DateTime date;
  final DiaryNote? existingNote;

  const DiaryNoteEditorSheet({
    super.key,
    required this.date,
    this.existingNote,
  });

  /// Muestra el sheet para editar o crear una nota.
  static Future<void> show(
    BuildContext context, {
    required DateTime date,
    DiaryNote? existingNote,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return DiaryNoteEditorSheet(date: date, existingNote: existingNote);
      },
    );
  }

  @override
  ConsumerState<DiaryNoteEditorSheet> createState() =>
      _DiaryNoteEditorSheetState();
}

class _DiaryNoteEditorSheetState extends ConsumerState<DiaryNoteEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late DateTime _selectedDate;
  int _selectedColorIndex = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title);
    _contentController = TextEditingController(
      text: widget.existingNote?.content,
    );
    _selectedDate = widget.existingNote?.date ?? widget.date;
    _selectedColorIndex = widget.existingNote?.colorIndex ?? 0;

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _canSave {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (content.isEmpty) return false;

    final isNew = widget.existingNote == null;
    if (isNew) return true;

    final hasChanges =
        title != (widget.existingNote?.title ?? '') ||
        content != (widget.existingNote?.content ?? '') ||
        _selectedColorIndex != widget.existingNote?.colorIndex ||
        !DateUtils.isSameDay(_selectedDate, widget.existingNote!.date);

    return hasChanges;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );
    if (picked != null && picked != _selectedDate) {
      HapticFeedback.selectionClick();
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (content.isEmpty) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(saveDiaryNoteUseCaseProvider)
          .execute(
            id: widget.existingNote?.id,
            date: _selectedDate,
            title: title.isEmpty ? null : title,
            content: content,
            colorIndex: _selectedColorIndex,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving note: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DiaryEditorHeader(
                date: _selectedDate,
                onTapDate: _selectDate,
                colorIndex: _selectedColorIndex,
              ),
              const SizedBox(height: AppSpacing.l),
              DiaryEditorSectionLabel(
                icon: Icons.title_rounded,
                label: 'Title',
                color: colorScheme.onSurfaceVariant,
              ),
              DiaryEditorTitleInput(controller: _titleController),
              const SizedBox(height: AppSpacing.m),
              DiaryEditorSectionLabel(
                icon: Icons.palette_outlined,
                label: 'Mood Tag',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.s),
              DiaryEditorColorSelector(
                selectedIndex: _selectedColorIndex,
                onSelected: (index) {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedColorIndex = index);
                },
              ),
              const SizedBox(height: AppSpacing.l),
              DiaryEditorSectionLabel(
                icon: Icons.notes_rounded,
                label: 'Content',
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.s),
              DiaryEditorContentInput(
                controller: _contentController,
                autofocus: widget.existingNote == null,
              ),
              const SizedBox(height: AppSpacing.l),
              AppButton(
                onPressed: (_saving || !_canSave) ? null : _save,
                isLoading: _saving,
                label: _saving ? 'Saving...' : 'Save note',
                icon: _saving ? null : Icons.check_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
