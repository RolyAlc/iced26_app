import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/widgets/news_card.dart';
import 'package:iced26/presentation/features/home/widgets/news_card_variant.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sección de noticias con bottom sheet de detalle.
class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key, required this.news});

  final List<NewsItem> news;

  static const double _modalImageHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    if (_isEmpty()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildNewsList(context),
    );
  }

  /// Comprueba si no hay noticias.
  bool _isEmpty() => news.isEmpty;

  /// Construye toda la lista de widgets de noticias.
  List<Widget> _buildNewsList(BuildContext context) {
    final List<Widget> items = [];

    items.add(_buildHeroNews(context));
    items.add(const SizedBox(height: AppSpacing.sm));

    if (news.length > 1) {
      items.add(_buildCompactNewsList(context));
    }

    return items;
  }

  /// Noticia principal (hero).
  Widget _buildHeroNews(BuildContext context) {
    final item = news.first;

    return NewsCard(
      variant: NewsCardVariant.hero,
      title: item.title.resolve('en'),
      subtitle: item.content.resolve('en'),
      imageUrl: item.imgUrl,
      onTap: () => _showNewsDetails(context, item),
    );
  }

  /// Lista de noticias secundarias.
  Widget _buildCompactNewsList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildCompactNewsItems(context),
    );
  }

  /// Genera los items compactos.
  List<Widget> _buildCompactNewsItems(BuildContext context) {
    final List<Widget> items = [];

    for (int i = 1; i < news.length; i++) {
      if (i > 1) {
        items.add(const SizedBox(height: AppSpacing.sm));
      }
      items.add(_buildCompactNewsCard(context, news[i]));
    }

    return items;
  }

  /// Card individual compacta.
  Widget _buildCompactNewsCard(BuildContext context, NewsItem item) {
    return NewsCard(
      title: item.title.resolve('en'),
      subtitle: item.content.resolve('en'),
      imageUrl: item.imgUrl,
      onTap: () => _showNewsDetails(context, item),
    );
  }

  /// Bottom sheet con detalle de noticia.
  void _showNewsDetails(BuildContext context, NewsItem item) {
    final theme = Theme.of(context);

    AppBottomSheet.show(
      context: context,
      title: item.title.resolve('en'),
      actions: [_buildOpenWebButton(context, item)],
      child: _buildBottomSheetContent(theme, item),
    );
  }

  /// Botón de acción para abrir la noticia.
  Widget _buildOpenWebButton(BuildContext context, NewsItem item) {
    return FilledButton.icon(
      onPressed: () {
        Navigator.pop(context);
        _launchURL(context, item.webUrl);
      },
      icon: const Icon(AppIcons.openInNew, size: 18),
      label: const Text('Read full article'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
      ),
    );
  }

  /// Contenido del bottom sheet.
  Widget _buildBottomSheetContent(ThemeData theme, NewsItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBottomSheetImage(item),
        _buildBottomSheetText(theme, item),
      ],
    );
  }

  /// Imagen del bottom sheet.
  Widget _buildBottomSheetImage(NewsItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: AppNetworkImage(
          url: item.imgUrl,
          height: _modalImageHeight,
          width: double.infinity,
          placeholder: const AppNetworkImageAssetPlaceholder(
            assetPath: Assets.expressiveShape,
            height: _modalImageHeight,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  /// Texto del bottom sheet.
  Widget _buildBottomSheetText(ThemeData theme, NewsItem item) {
    return Text(
      item.content.resolve('en'),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }

  /// Abre URL externa.
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);

    try {
      final bool canLaunch = await canLaunchUrl(url);

      if (!context.mounted) {
        return;
      }

      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
      _showError(context, urlString);
    } catch (error) {
      AppLogger.e('Error launching URL: $error');
    }
  }

  /// Error UI al abrir enlace.
  void _showError(BuildContext context, String urlString) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open the link: $urlString')),
    );
  }
}
