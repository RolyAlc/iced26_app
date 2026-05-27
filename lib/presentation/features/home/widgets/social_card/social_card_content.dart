import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/social_activity_ui_model.dart';

/// Contenido principal de la card (categoría + título).
class SocialCardContent extends StatelessWidget {
  const SocialCardContent({super.key, required this.activity});

  final SocialActivityUIModel activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social activity',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.onTertiaryContainer.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: AppTextSize.chip,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          activity.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onTertiaryContainer,
          ),
        ),
      ],
    );
  }
}
