import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/features/home/widgets/social_card/social_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/social_card/social_card_footer.dart';
import 'package:iced26/presentation/features/home/widgets/social_card/social_card_header.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta de actividad social (composición de subcomponentes).
class SocialCard extends StatelessWidget {
  const SocialCard({super.key, required this.activity, required this.onTap});

  final SocialActivity activity;
  final VoidCallback onTap;

  static const double widthFactor = 0.56;
  static const double aspectRatio = 5 / 4;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: Theme.of(
        context,
      ).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
      bordered: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SocialCardHeader(),
          const Spacer(),
          SocialCardContent(activity: activity),
          const SizedBox(height: AppSpacing.s),
          const SocialCardFooter(),
        ],
      ),
    );
  }
}
