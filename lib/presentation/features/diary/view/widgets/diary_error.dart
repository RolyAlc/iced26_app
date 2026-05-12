import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Muestra un mensaje de error cuando ocurre un problema al cargar el diario.
class DiaryError extends StatelessWidget {
  final Object error;

  const DiaryError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Text(
        'Error loading diary: $error',
        style: TextStyle(color: colors.error),
      ),
    );
  }
}
