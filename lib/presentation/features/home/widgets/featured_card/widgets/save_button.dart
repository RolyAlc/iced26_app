import 'package:flutter/material.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Botón de guardar evento — icono bookmark.
class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.isSaved, required this.onTap});
  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(
        isSaved ? AppIcons.bookmarkOn : AppIcons.bookmarkOff,
        color: isSaved ? colors.primary : colors.onSurfaceVariant,
      ),
    );
  }
}
