import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/features/home/view/sections/home_bottom_bar.dart';
import 'package:iced26/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/features/home/view/sections/home_header_section.dart';
import 'package:iced26/features/home/view/sections/home_social_news_section.dart';
import 'package:iced26/features/home/viewmodel/home_viewmodel.dart';

/// Pantalla principal de la aplicación.
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  HomeFeaturedSection(events: hvm.featuredEvents),
                  const SizedBox(height: 16),
                  HomeCategoriesSection(items: hvm.categoryLabels),
                  const SizedBox(height: 16),
                  const HomeSocialNewsSection(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomBar(),
    );
  }
}

/// Persistentencia de la pantalla principal.
/// Permite mostrar la cabecera fija con el logo y la fecha.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 150;

  @override
  double get maxExtent => 150;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
