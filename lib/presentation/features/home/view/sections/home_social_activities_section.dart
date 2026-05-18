import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/features/home/widgets/social_card.dart';

/// Sección de actividades sociales — carrusel horizontal edge-to-edge.
class HomeSocialActivitiesSection extends StatelessWidget {
  const HomeSocialActivitiesSection({
    super.key,
    required this.socials,
    this.showFadeMask = false,
  });

  final List<SocialActivity> socials;
  final bool showFadeMask;

  @override
  Widget build(BuildContext context) {
    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = _CardDimensions.from(constraints);

        final carousel = _SocialCarousel(
          socials: socials,
          dimensions: dimensions,
        );

        // Aplica la máscara sólo si el padre la solicita.
        if (showFadeMask) {
          return _FadeEdgeMask(
            surfaceColor: Theme.of(context).colorScheme.surface,
            child: carousel,
          );
        }

        return carousel;
      },
    );
  }
}

/// Calcula el ancho y alto de cada [SocialCard] a partir de los constraints
/// del [LayoutBuilder] padre.
class _CardDimensions {
  const _CardDimensions({required this.width, required this.height});

  factory _CardDimensions.from(BoxConstraints constraints) {
    final width = constraints.maxWidth * SocialCard.widthFactor;
    final height = width / SocialCard.aspectRatio;
    return _CardDimensions(width: width, height: height);
  }

  final double width;
  final double height;
}

/// Lista horizontal con separadores que muestra una [SocialCard] por actividad.
class _SocialCarousel extends StatelessWidget {
  const _SocialCarousel({required this.socials, required this.dimensions});

  final List<SocialActivity> socials;
  final _CardDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimensions.height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: socials.length,
        separatorBuilder: _buildSeparator,
        itemBuilder: _buildItem,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const SizedBox(width: AppSpacing.m);
  }

  Widget _buildItem(BuildContext context, int index) {
    final activity = socials[index];

    return _SocialCardItem(activity: activity, cardWidth: dimensions.width);
  }
}

/// Wrapper de ancho fijo alrededor de [SocialCard].
class _SocialCardItem extends StatelessWidget {
  const _SocialCardItem({required this.activity, required this.cardWidth});

  final SocialActivity activity;
  final double cardWidth;

  // TODO: Inyectar onTap desde el padre cuando se implemente la navegación.
  void _handleTap() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: SocialCard(activity: activity, onTap: _handleTap),
    );
  }
}

/// Mascara con degradado horizontal.
class _FadeEdgeMask extends StatelessWidget {
  const _FadeEdgeMask({required this.surfaceColor, required this.child});

  final Color surfaceColor;
  final Widget child;

  /// Fracción del ancho a partir de la cual empieza el fade.
  static const double _fadeStart = 0.85;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: _buildShader,
      child: child,
    );
  }

  Shader _buildShader(Rect bounds) {
    // BlendMode.dstIn usa el gradiente como máscara alpha, no como color visual.
    // Colors.white = alpha 1.0 (opaco), Colors.transparent = alpha 0.0 (invisible).
    return LinearGradient(
      stops: const [_fadeStart, 1.0],
      colors: [Colors.white, surfaceColor.withValues(alpha: 0.0)],
    ).createShader(bounds);
  }
}
