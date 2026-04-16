import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/features/home/view/sections/home_filter_chips_section.dart';
import 'package:iced26/features/home/view/sections/home_header_section.dart';
import 'package:iced26/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/features/home/view/sections/home_news_section.dart';
import 'package:iced26/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/features/home/view/sections/home_social_activities_section.dart';

/// Pantalla principal de la aplicación.
/// Muestra un resumen de la conferencia, eventos destacados,
/// categorías, noticias y actividades sociales.
class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.data});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    final hvm = HomeViewModel(data);

    // Mostramos un layout general con scroll.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HomeHeaderDelegate(
                child: HomeHeaderSection(
                  today: DateTime.now(),
                  infoLabel: hvm.headerInfoLabel,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: HomeFilterChipsSection()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  HomeFeaturedSection(
                    featuredEvents: hvm.featuredEvents,
                    sectionTitle: 'Featured Events',
                    onSeeAll: () {
                      // TODO: Acción al presionar "See all"
                    },
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeCategoriesSection(items: hvm.categoryLabels),
                        const SizedBox(height: 24),
                        HomeNewsSection(news: hvm.news),
                        const SizedBox(height: 24),
                        HomeSocialActivitiesSection(socials: hvm.socials),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Persistentencia de la pantalla principal.
/// Permite mostrar la cabecera fija con el logo y la fecha.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 140;

  @override
  double get maxExtent => 140;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
