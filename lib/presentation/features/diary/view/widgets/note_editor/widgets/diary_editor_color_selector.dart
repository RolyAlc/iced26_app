import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/note_color.dart';

/// Selector de colores para notas del diario que permite elegir un color o ninguno.
class DiaryEditorColorSelector extends StatelessWidget {
  final NoteColor? selectedColor;
  final ValueChanged<NoteColor?> onSelected;

  // null (primer elemento) = sin color.
  static final _options = <NoteColor?>[null, ...NoteColor.values];

  const DiaryEditorColorSelector({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final option = _options[index];
          final paintColor = option != null
              ? AppNoteColors.colorOf(option)
              : null;
          final isSelected = selectedColor == option;

          return GestureDetector(
            onTap: () => onSelected(option),
            child: AnimatedContainer(
              duration: AppDuration.fast,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: paintColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? scheme.primary : scheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: paintColor != null ? Colors.white : scheme.primary,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
