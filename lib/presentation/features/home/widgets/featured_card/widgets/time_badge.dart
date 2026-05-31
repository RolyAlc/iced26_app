import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Etiqueta de tiempo
class TimeBadge extends StatelessWidget {
  const TimeBadge({super.key, required this.time});
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppOverlayColors.timeBadgeBackground,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        time.toUpperCase(),
        style: const TextStyle(
          color: AppOverlayColors.heroText,
          fontSize: AppTextSize.chip,
          fontWeight: FontWeight.w900,
          letterSpacing: AppTextStyle.timeLetterSpacing,
        ),
      ),
    );
  }
}
