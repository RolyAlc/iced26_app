import 'package:flutter/material.dart';

/// Botón de guardar evento — icono bookmark.
class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const SaveButton({super.key, required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: isSaved ? colors.primary : colors.onSurfaceVariant,
      ),
    );
  }
}
