import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/view/sheets/home_news_detail_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/news_card.dart';
import 'package:iced26/presentation/features/home/widgets/news_card_variant.dart';

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

    final hero = news.first;
    final rest = news.skip(1).take(maxVisible - 1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        NewsCard(
          variant: NewsCardVariant.hero,
          title: hero.title,
          subtitle: hero.content,
          imageUrl: hero.imgUrl,
          onTap: () => showNewsDetail(context, hero),
        ),
        for (final item in rest)
          NewsCard(
            variant: NewsCardVariant.compact,
            title: item.title,
            subtitle: item.content,
            imageUrl: item.imgUrl,
            onTap: () => showNewsDetail(context, item),
          ),
      ],
    );
  }
}
