import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Etiqueta reutilizable que muestra la hora de un slot y resalta si está en vivo.
class SlotTimeLabel extends StatelessWidget {
  const SlotTimeLabel({super.key, required this.time, this.isLive = false});
  final String time;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeColor = isLive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return SizedBox(
      width: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: timeColor,
            ),
          ),
          if (isLive)
            Text(
              'LIVE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: AppTextStyle.timeLetterSpacing,
              ),
            ),
        ],
      ),
    );
  }
}
