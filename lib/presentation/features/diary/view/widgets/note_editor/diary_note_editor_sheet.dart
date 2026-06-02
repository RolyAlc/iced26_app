import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_color_selector.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_header.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_inputs.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/widgets/diary_editor_section_label.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

/// Hoja modal para editar o crear una nota del diario.
class DiaryNoteEditorSheet extends ConsumerStatefulWidget {
  const DiaryNoteEditorSheet({
    super.key,
    required this.date,
    this.existingNote,
  });
  final DateTime date;
  final DiaryNote? existingNote;

  static Future<void> show(
    BuildContext context, {
    required DateTime date,
    DiaryNote? existingNote,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            DiaryNoteEditorSheet(date: date, existingNote: existingNote),
      ),
    );
  }

  @override
  ConsumerState<DiaryNoteEditorSheet> createState() =>
      _DiaryNoteEditorSheetState();
}

/// State de la hoja modal para editar o crear una nota del diario.
class _DiaryNoteEditorSheetState extends ConsumerState<DiaryNoteEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late DateTime _selectedDate;
  NoteColor? _selectedColor;
  bool _saving = false;

  bool get _isEditing {
    return widget.existingNote != null;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title);
    _contentController = TextEditingController(
      text: widget.existingNote?.content,
    );
    _selectedDate = widget.existingNote?.date ?? widget.date;
    _selectedColor = widget.existingNote?.color;

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

  // Fuerza rebuild para re-evaluar _canSave: TextEditingController no notifica
  // a setState automáticamente cuando cambia el texto.
  void _onTextChanged() {
    setState(() {});
  }

  bool get _canSave {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      return false;
    }
    if (!_isEditing) {
      return true;
    }

    // _isEditing garantiza existingNote != null — variable local evita
    // repetir la comprobación y el operador ! en cada campo.
    final existing = widget.existingNote!;
    final title = _titleController.text.trim();
    final titleChanged = title != (existing.title ?? '');
    final contentChanged = content != existing.content;
    final colorChanged = _selectedColor != existing.color;
    final dateChanged = !DateUtils.isSameDay(_selectedDate, existing.date);

    return titleChanged || contentChanged || colorChanged || dateChanged;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: AppConfig.firstDay,
      lastDate: AppConfig.lastDay,
    );
    if (picked != null && picked != _selectedDate) {
      unawaited(HapticFeedback.selectionClick());
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(saveDiaryNoteUseCaseProvider)
          .execute(
            id: widget.existingNote?.id,
            date: _selectedDate,
            title: title.isEmpty ? null : title,
            content: content,
            color: _selectedColor,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.diaryErrorSavingNote('$e'),
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.diaryDeleteNoteTitle),
          content: Text(AppLocalizations.of(context)!.diaryDeleteNoteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(dialogContext, true);
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await ref
          .read(deleteDiaryNoteUseCaseProvider)
          .execute(widget.existingNote!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildScrollableForm(context)),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.s,
        AppSpacing.l,
        AppSpacing.l,
      ),
      child: AppButton(
        onPressed: (_saving || !_canSave) ? null : _save,
        isLoading: _saving,
        label: _saving
            ? AppLocalizations.of(context)!.diaryNoteEditorSaving
            : AppLocalizations.of(context)!.diaryNoteEditorSaveNote,
        icon: _saving ? null : AppIcons.check,
      ),
    );
  }

  Widget _buildScrollableForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DiaryEditorHeader(
            date: _selectedDate,
            onTapDate: _selectDate,
            color: _selectedColor,
            onDelete: _isEditing ? _confirmDelete : null,
          ),
          const SizedBox(height: AppSpacing.l),
          DiaryEditorSectionLabel(
            icon: AppIcons.title,
            label: AppLocalizations.of(context)!.diaryNoteEditorLabelTitle,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.s),
          DiaryEditorTitleInput(controller: _titleController),
          const SizedBox(height: AppSpacing.m),
          DiaryEditorSectionLabel(
            icon: AppIcons.notes,
            label: AppLocalizations.of(context)!.diaryNoteEditorLabelContent,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.s),
          DiaryEditorContentInput(controller: _contentController),
          const SizedBox(height: AppSpacing.l),
          DiaryEditorSectionLabel(
            icon: AppIcons.palette,
            label: AppLocalizations.of(context)!.diaryNoteEditorLabelMoodTag,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.s),
          DiaryEditorColorSelector(
            selectedColor: _selectedColor,
            onSelected: (color) {
              HapticFeedback.selectionClick();
              setState(() => _selectedColor = color);
            },
          ),
        ],
      ),
    );
  }
}
