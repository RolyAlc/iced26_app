import 'package:flutter/material.dart';

const _kLabelLetterSpacing = 0.8;

/// Label que representa una sección.
class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: _kLabelLetterSpacing,
      ),
    );
  }
}
