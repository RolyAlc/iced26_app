import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Muestra el número de resultados.
class ResultsCount extends StatelessWidget {
  const ResultsCount({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: Text(
        '$count ${count == 1 ? 'result' : 'results'}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
