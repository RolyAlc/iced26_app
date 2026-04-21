import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/presentation/features/home/widgets/news_card.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';
import 'package:iced26/core/services/logger/logger.dart';

/// Sección de noticias con integración de AppBottomSheet (Fase 3).
/// Mejora la UX reduciendo la fricción al abrir enlaces externos.
class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key, required this.news});

  final List<NewsItem> news;

  static const double _modalImageHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NewsCard.hero(
          title: news[0].title.resolve('en'),
          subtitle: news[0].content.resolve('en'),
          imageUrl: news[0].imgUrl,
          onTap: () => _showNewsDetails(context, news[0]),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (news.length > 1)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 1; i < news.length; i++) ...[
                if (i > 1) const SizedBox(height: AppSpacing.sm),
                NewsCard.compact(
                  title: news[i].title.resolve('en'),
                  subtitle: news[i].content.resolve('en'),
                  imageUrl: news[i].imgUrl,
                  onTap: () => _showNewsDetails(context, news[i]),
                ),
              ],
            ],
          ),
      ],
    );
  }

  /// Muestra el panel deslizante con los detalles de la noticia.
  void _showNewsDetails(BuildContext context, NewsItem item) {
    final theme = Theme.of(context);

    AppBottomSheet.show(
      context: context,
      title: item.title.resolve('en'),
      actions: [
        // Botón de acción principal: Abrir en la web
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _launchURL(context, item.webUrl);
          },
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          label: const Text('Read full article'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
          ),
        ),
      ],
      // Contenido del resumen en el panel
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.l),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.l),
              child: AppNetworkImage(
                url: item.imgUrl,
                height: _modalImageHeight,
                width: double.infinity,
                placeholder: AppNetworkImageAssetPlaceholder(
                  assetPath: Assets.expressiveShape,
                  height: _modalImageHeight,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          Text(
            item.content.resolve('en'),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Logica de navegacion externa.
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open the link: $urlString')),
          );
        }
      }
    } catch (error) {
      AppLogger.e('Error launching URL: $error');
    }
  }
}
