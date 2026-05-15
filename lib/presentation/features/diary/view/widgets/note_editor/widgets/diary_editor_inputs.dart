import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

const _kMinLines = 3;
const _kMaxLines = 6;
const _kHintTitle = 'Note title';
const _kHintContent = 'Add note content';

/// Decoración común para los inputs del editor de notas del diario.
InputDecoration _editorDecoration({
  required ColorScheme colors,
  required String hint,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.all(AppSpacing.m),
}) {
  final borderRadius = BorderRadius.circular(AppRadius.m);
  final idleBorder = BorderSide(color: colors.outlineVariant);

  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: colors.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: idleBorder,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: idleBorder,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
    contentPadding: contentPadding,
  );
}

/// Campo de texto para el título de la nota del diario.
class DiaryEditorTitleInput extends StatelessWidget {
  const DiaryEditorTitleInput({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
      decoration: _editorDecoration(
        colors: theme.colorScheme,
        hint: _kHintTitle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

/// Campo de texto para el contenido de la nota del diario.
class DiaryEditorContentInput extends StatelessWidget {
  const DiaryEditorContentInput({
    super.key,
    required this.controller,
    this.autofocus = false,
  });
  final TextEditingController controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: _kMaxLines,
      minLines: _kMinLines,
      decoration: _editorDecoration(
        colors: Theme.of(context).colorScheme,
        hint: _kHintContent,
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
