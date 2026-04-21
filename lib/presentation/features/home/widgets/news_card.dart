import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

/// Tarjeta de noticia.
class NewsCard extends StatelessWidget {
  const NewsCard.hero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  }) : _isHero = true;

  const NewsCard.compact({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  }) : _isHero = false;

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final bool _isHero;

  static const double _heroHeight = 220.0;

  /// Construye la tarjeta de noticia.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.m,
      child: _isHero
          ? _buildFeaturedLayout(theme, colors)
          : _buildStandardLayout(theme, colors),
    );
  }

  /// Layout Destacado: Imagen de fondo con gradiente y texto superpuesto.
  Widget _buildFeaturedLayout(ThemeData theme, ColorScheme colors) {
    return SizedBox(
      height: _heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            url: imageUrl,
            height: _heroHeight,
            width: double.infinity,
            placeholder: AppNetworkImageAssetPlaceholder(
              assetPath: Assets.expressiveShape,
              height: _heroHeight,
              width: double.infinity,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.4, 1.0],
              ),
            ),
          ),
          Padding(
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
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Layout Estándar: Diseño horizontal compacto.
  Widget _buildStandardLayout(ThemeData theme, ColorScheme colors) {
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
