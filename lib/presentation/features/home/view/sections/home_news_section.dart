import 'package:flutter/material.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/news_card.dart';
import 'package:iced26/presentation/features/home/widgets/news_card_variant.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';

import 'package:url_launcher/url_launcher.dart';

const _kReadFullArticle = 'Read full article';
const _kAllNewsSheetTitle = 'All news';
const _kModalImageHeight = 200.0;

void _showNewsDetails(BuildContext context, NewsItemUIModel item) {
  AppBottomSheet.show(
    context: context,
    title: item.title,
    actions: [
      FilledButton.icon(
        onPressed: () {
          Navigator.pop(context);
          _launchURL(context, item.webUrl);
        },
        icon: const Icon(AppIcons.openInNew, size: 18),
        label: const Text(_kReadFullArticle),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        ),
      ),
    ],
    child: _NewsDetailContent(item: item),
  );
}

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

void _showError(BuildContext context, String urlString) {
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Could not open the link: $urlString')),
  );
}

/// Sección de noticias con cap de visibilidad y bottom sheet de detalle.
///
/// Muestra hasta [maxVisible] noticias. Si hay más, el padre puede
/// ofrecer un "See all" que abre [HomeNewsAllSheet].
class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key, required this.news});

  final List<NewsItemUIModel> news;

  /// Máximo de noticias visibles en la home antes de necesitar "See all".
  static const int maxVisible = 4;

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) {
      return const SizedBox.shrink();
    }

    final visible = news.take(maxVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, item) in visible.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          NewsCard(
            variant: i == 0 ? NewsCardVariant.hero : NewsCardVariant.compact,
            title: item.title,
            subtitle: item.content,
            imageUrl: item.imgUrl,
            onTap: () => _showNewsDetails(context, item),
          ),
        ],
      ],
    );
  }
}

/// Bottom sheet que muestra todas las noticias en formato compacto.
///
/// Se abre desde [home_view.dart] cuando hay más de [HomeNewsSection.maxVisible]
/// noticias. Cada ítem sigue abriendo el detalle completo al tocar.
class HomeNewsAllSheet extends StatelessWidget {
  const HomeNewsAllSheet({super.key, required this.news});

  final List<NewsItemUIModel> news;

  static void show(BuildContext context, List<NewsItemUIModel> news) {
    AppBottomSheet.show(
      context: context,
      title: _kAllNewsSheetTitle,
      child: HomeNewsAllSheet(news: news),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (i, item) in news.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          NewsCard(
            title: item.title,
            subtitle: item.content,
            imageUrl: item.imgUrl,
            onTap: () => _showNewsDetails(context, item),
          ),
        ],
      ],
    );
  }
}

/// Contenido del bottom sheet de detalle de una noticia.
class _NewsDetailContent extends StatelessWidget {
  const _NewsDetailContent({required this.item});

  final NewsItemUIModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.l),
            child: AppNetworkImage(
              url: item.imgUrl,
              height: _kModalImageHeight,
              width: double.infinity,
              placeholder: const AppNetworkImageAssetPlaceholder(
                assetPath: Assets.expressiveShape,
                height: _kModalImageHeight,
                width: double.infinity,
              ),
            ),
          ),
        ),
        Text(
          item.content,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
