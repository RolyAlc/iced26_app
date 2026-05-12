import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Selector de colores (Mood Tag) para las notas.
class DiaryEditorColorSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DiaryEditorColorSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppNoteColors.palette.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          final color = AppNoteColors.palette[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: AppDuration.fast,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color == Colors.transparent ? null : color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: color == Colors.transparent
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
