import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

const _kListHeight = 40.0;
const _kCircleSize = 32.0;
const _kCheckIconSize = 18.0;
const _kSelectedBorderWidth = 2.0;
const _kDefaultBorderWidth = 1.0;

/// Selector horizontal de colores para notas del diario.
/// El primer elemento (null) representa "sin color".
class DiaryEditorColorSelector extends StatelessWidget {
  const DiaryEditorColorSelector({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });

  final NoteColor? selectedColor;
  final ValueChanged<NoteColor?> onSelected;

  static const List<NoteColor?> _options = [
    null, // sin color seleccionado
    ...NoteColor.values,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _kListHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
        itemBuilder: (context, index) {
          return _buildColorOption(context, _options[index], scheme);
        },
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    NoteColor? option,
    ColorScheme scheme,
  ) {
    final Color? paintColor;

    if (option != null) {
      paintColor = AppNoteColors.colorOf(option);
    } else {
      paintColor = null;
    }
    final isSelected = selectedColor == option;

    // Material con clipBehavior recorta el ripple a la forma circular.
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onSelected(option),
        child: AnimatedContainer(
          duration: AppDuration.fast,
          width: _kCircleSize,
          height: _kCircleSize,
          decoration: BoxDecoration(
            color: paintColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outlineVariant,
              width: isSelected ? _kSelectedBorderWidth : _kDefaultBorderWidth,
            ),
          ),
          child: isSelected ? _buildCheckIcon(paintColor, scheme) : null,
        ),
      ),
    );
  }

  Widget _buildCheckIcon(Color? paintColor, ColorScheme scheme) {
    return Icon(
      AppIcons.check,
      size: _kCheckIconSize,
      // Sobre fondo coloreado: blanco fijo (overlay). Sin color: primary del tema.
      color: paintColor != null ? AppOverlayColors.heroText : scheme.primary,
    );
  }
}
