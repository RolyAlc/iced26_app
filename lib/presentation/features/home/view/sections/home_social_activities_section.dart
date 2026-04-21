import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/features/home/widgets/social_card.dart';

/// Sección de actividades sociales.
/// Diseño edge-to-edge: misma lógica que HomeFeaturedSection.
class HomeSocialActivitiesSection extends StatelessWidget {
  const HomeSocialActivitiesSection({
    super.key,
    required this.socials,
    this.showFadeMask = false,
  });

  final List<SocialActivity> socials;
  final bool showFadeMask;

  /// Construye la sección de actividades sociales.
  @override
  Widget build(BuildContext context) {
    if (socials.isEmpty) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * SocialCard.widthFactor;
        final listHeight = cardWidth / SocialCard.aspectRatio;

        final content = SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: socials.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: SocialCard(
                activity: socials[index],
                onTap: () {
                  // TODO: Implementar navegación al detalle social
                },
              ),
            ),
          ),
        );

        if (showFadeMask) {
          return ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.85, 1.0],
              colors: [Colors.white, colors.surface.withValues(alpha: 0.0)],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: content,
          );
        }

        return content;
      },
    );
  }
}
