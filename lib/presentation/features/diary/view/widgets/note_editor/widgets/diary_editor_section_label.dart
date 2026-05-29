import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Etiqueta de sección para el editor de notas del diario.
class DiaryEditorSectionLabel extends StatelessWidget {
  const DiaryEditorSectionLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.s),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
