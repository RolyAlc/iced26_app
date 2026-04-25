import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Boton para guardar o no un evento.
class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const SaveButton({super.key, required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final bgColor = isSaved ? colors.primaryContainer : colors.onSurface;
    final fgColor = isSaved ? colors.onPrimaryContainer : Colors.white;
    final icon = isSaved ? Icons.bookmark : Icons.add;
    final label = isSaved ? 'Saved' : 'Save';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fgColor),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: TextStyle(color: fgColor)),
          ],
        ),
      ),
    );
  }
}
