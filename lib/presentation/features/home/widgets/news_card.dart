import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/widgets/news_card_variant.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';

const double _kHeroHeight = 220.0;

/// Tarjeta de noticia.
class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.variant = NewsCardVariant.compact,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final NewsCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: switch (variant) {
        NewsCardVariant.hero => _FeaturedLayout(
          imageUrl: imageUrl,
          title: title,
          subtitle: subtitle,
        ),
        NewsCardVariant.compact => _StandardLayout(
          imageUrl: imageUrl,
          title: title,
          subtitle: subtitle,
        ),
      },
    );
  }
}

//// Canva para la vista destacada
class _FeaturedLayout extends StatelessWidget {
  const _FeaturedLayout({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final String imageUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kHeroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _HeroImage(imageUrl: imageUrl),
          const _HeroOverlay(),
          _HeroContent(title: title, subtitle: subtitle),
        ],
      ),
    );
  }
}

/// Canva para la vista compacta
class _StandardLayout extends StatelessWidget {
  const _StandardLayout({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final String imageUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: AppNetworkImage(
              url: imageUrl,
              width: 80,
              height: 80,
              placeholder: const AppNetworkImageAssetPlaceholder(
                assetPath: Assets.expressiveShape,
                width: 80,
                height: 80,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Canva para el overlay de la vista destacada
class _HeroOverlay extends StatelessWidget {
  const _HeroOverlay();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppOverlayColors.heroGradientStart,
            AppOverlayColors.heroGradientEnd,
          ],
          stops: [0.4, 1.0],
        ),
      ),
    );
  }
}

/// Canva para el contenido de la vista destacada
class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppOverlayColors.heroText,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppOverlayColors.heroTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Canva para la imagen de la vista destacada.ss
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      url: imageUrl,
      placeholder: const AppNetworkImageAssetPlaceholder(
        assetPath: Assets.expressiveShape,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
