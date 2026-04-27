import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Etiqueta de tiempo
class TimeBadge extends StatelessWidget {
  final String time;

  const TimeBadge({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        time.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppTextSize.chip,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
