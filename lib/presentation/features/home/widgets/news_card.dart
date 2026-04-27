import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/widgets/news_card_variant.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

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

  static const double _heroHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.m,
      child: switch (variant) {
        NewsCardVariant.hero => _buildFeaturedLayout(context),
        NewsCardVariant.compact => _buildStandardLayout(context),
      },
    );
  }

  Widget _buildFeaturedLayout(BuildContext context) {
    return SizedBox(
      height: _heroHeight,
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

  Widget _buildStandardLayout(BuildContext context) {
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
              placeholder: AppNetworkImageAssetPlaceholder(
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

class _HeroOverlay extends StatelessWidget {
  const _HeroOverlay();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
          stops: [0.4, 1.0],
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroContent({required this.title, required this.subtitle});

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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;

  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      url: imageUrl,
      fit: BoxFit.cover,
      placeholder: AppNetworkImageAssetPlaceholder(
        assetPath: Assets.expressiveShape,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
