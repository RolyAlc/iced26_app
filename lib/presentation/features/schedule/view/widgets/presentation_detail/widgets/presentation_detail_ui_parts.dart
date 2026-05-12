import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// chip genérico para Track, tiempo y duración — evita repetir el Container de estilos.
class PresentationChip extends StatelessWidget {
  final String label;
  final bool primary;

  const PresentationChip({
    super.key,
    required this.label,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: primary
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: primary
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// encapsula el color semitransparente del tema para no repetirlo en cada sección.
class PresentationDivider extends StatelessWidget {
  const PresentationDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}
