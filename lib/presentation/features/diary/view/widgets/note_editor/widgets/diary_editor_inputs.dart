import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

const _kMinLines = 3;
const _kMaxLines = 6;

/// Encapsula los inputs de texto (Título y Contenido) del editor.
class DiaryEditorTitleInput extends StatelessWidget {
  final TextEditingController controller;

  const DiaryEditorTitleInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
      decoration: InputDecoration(
        hintText: 'Note title',
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

class DiaryEditorContentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const DiaryEditorContentInput({
    super.key,
    required this.controller,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: _kMaxLines,
      minLines: _kMinLines,
      decoration: InputDecoration(
        hintText: 'Add note content',
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
