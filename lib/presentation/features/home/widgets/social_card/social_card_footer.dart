import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Pie de card (acción secundaria / navegación).
class SocialCardFooter extends StatelessWidget {
  const SocialCardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(AppIcons.arrowForward, size: 14, color: colors.tertiary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'View details',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
