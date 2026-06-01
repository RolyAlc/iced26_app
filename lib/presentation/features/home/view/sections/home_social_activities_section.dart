import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/social_activity_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/social_card.dart';

/// Sección de actividades sociales — carrusel horizontal edge-to-edge.
class HomeSocialActivitiesSection extends StatelessWidget {
  const HomeSocialActivitiesSection({
    super.key,
    required this.socials,
    this.onTap,
  });

  final List<SocialActivityUIModel> socials;
  // Callback al pulsar una tarjeta. null = sin navegación (pendiente de implementar).
  final void Function(SocialActivityUIModel)? onTap;

  @override
  Widget build(BuildContext context) {
    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }

    final orientation = MediaQuery.orientationOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = _CardDimensions.from(constraints, orientation);

        return _SocialCarousel(
          socials: socials,
          dimensions: dimensions,
          onTap: onTap,
        );
      },
    );
  }
}

/// Calcula el ancho y alto de cada [SocialCard] a partir de los constraints
/// del [LayoutBuilder] padre.
class _CardDimensions {
  const _CardDimensions({required this.width, required this.height});

  factory _CardDimensions.from(
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    final isLandscape = orientation == Orientation.landscape;

    final widthFactor = isLandscape
        ? AppLayout.landscapeSocialWidthFactor
        : SocialCard.widthFactor;
    final aspectRatio = isLandscape
        ? AppLayout.landscapeSocialAspectRatio
        : SocialCard.aspectRatio;

    final width = constraints.maxWidth * widthFactor;
    final height = width / aspectRatio;
    return _CardDimensions(width: width, height: height);
  }

  final double width;
  final double height;
}

/// Lista horizontal con separadores que muestra una [SocialCard] por actividad.
class _SocialCarousel extends StatelessWidget {
  const _SocialCarousel({
    required this.socials,
    required this.dimensions,
    this.onTap,
  });

  final List<SocialActivityUIModel> socials;
  final _CardDimensions dimensions;
  final void Function(SocialActivityUIModel)? onTap;

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

    return _SocialCardItem(
      activity: activity,
      cardWidth: dimensions.width,
      onTap: onTap,
    );
  }
}

/// Wrapper de ancho fijo alrededor de [SocialCard].
class _SocialCardItem extends StatelessWidget {
  const _SocialCardItem({
    required this.activity,
    required this.cardWidth,
    this.onTap,
  });

  final SocialActivityUIModel activity;
  final double cardWidth;
  final void Function(SocialActivityUIModel)? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: SocialCard(
        activity: activity,
        onTap: () {
          onTap?.call(activity);
        },
      ),
    );
  }
}
