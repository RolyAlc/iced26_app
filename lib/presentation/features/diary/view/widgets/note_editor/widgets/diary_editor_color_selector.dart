import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

// TODO: doble return

/// Selector de colores para notas del diario que permite elegir un color o ninguno.
class DiaryEditorColorSelector extends StatelessWidget {
  const DiaryEditorColorSelector({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });
  final NoteColor? selectedColor;
  final ValueChanged<NoteColor?> onSelected;

  // null (primer elemento) = sin color.
  static final _options = <NoteColor?>[null, ...NoteColor.values];

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
                      AppIcons.check,
                      size: 18,
                      color: paintColor != null
                          ? AppOverlayColors.heroText
                          : scheme.primary,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
