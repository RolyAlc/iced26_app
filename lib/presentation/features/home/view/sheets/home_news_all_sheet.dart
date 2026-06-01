import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/view/sheets/home_news_detail_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/news_card.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';

const _kAllNewsSheetTitle = 'All news';

/// Bottom sheet que muestra todas las noticias en formato compacto.
///
/// Se abre desde home_content.dart cuando hay más de [HomeNewsSection.maxVisible]
/// noticias. Cada ítem abre el detalle completo al tocar.
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
      spacing: AppSpacing.sm,
      children: [
        for (final item in news)
          NewsCard(
            title: item.title,
            subtitle: item.content,
            imageUrl: item.imgUrl,
            onTap: () => showNewsDetail(context, item),
          ),
      ],
    );
  }
}
