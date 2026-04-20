import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/presentation/features/home/view/sections/widgets/news_card.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/core/logger/logger.dart';

/// Sección de noticias con integración de AppBottomSheet (Fase 3).
/// Mejora la UX reduciendo la fricción al abrir enlaces externos.
class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key, required this.news});

  final List<NewsItem> news;
  final titleSection = 'Latest news';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (news.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            titleSection,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ),
        NewsCard(
          isFeatured: true,
          title: news[0].title.resolve('en'),
          subtitle: news[0].content.resolve('en'),
          imageUrl: news[0].imgUrl,
          onTap: () => _showNewsDetails(context, news[0]),
        ),
        const SizedBox(height: 12),
        if (news.length > 1)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.length - 1,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = news[index + 1];
              return NewsCard(
                title: item.title.resolve('en'),
                subtitle: item.content.resolve('en'),
                imageUrl: item.imgUrl,
                onTap: () => _showNewsDetails(context, item),
              );
            },
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
          label: const Text('Read Full Article'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
      // Contenido del resumen en el panel
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen en el modal (Opcional, pero da mucha calidad visual)
          if (item.imgUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  item.imgUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          Text(
            item.content.resolve('en'),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5, // Altura de línea cómoda para lectura (Lato)
            ),
          ),
        ],
      ),
    );
  }

  /// Lógica de navegación externa.
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
      logger.e('Error launching URL: $error');
    }
  }
}
