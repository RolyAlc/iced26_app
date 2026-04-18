import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/app/bootstrap_provider.dart';
import 'package:iced26/app/widgets/loading_screen.dart';
import 'package:iced26/app/widgets/staggered_fade_in.dart';
import 'package:iced26/features/home/viewmodel/home_provider.dart';
import 'package:iced26/features/home/view/sections/home_news_section.dart';
import 'package:iced26/features/home/view/sections/home_header_section.dart';
import 'package:iced26/features/home/viewmodel/search_viewmodel_provider.dart';
import 'package:iced26/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/features/home/view/sections/home_social_activities_section.dart';

/// Vista de la página principal.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  /// Construye la vista de la página principal.
  /// Devuelve la estructura básica de la página principal.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Esperamos a que la base de datos esté lista.
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return bootstrapAsync.when(
      data: (_) => const _HomeScaffold(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}

/// Scaffold de la página principal.
class _HomeScaffold extends ConsumerWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de la Home.
    final homeStateAsync = ref.watch(homeProvider);

    // TODO: Migrar SearchViewModel a Riverpod en la siguiente fase.
    final searchViewModel = ref.watch(searchViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: homeStateAsync.when(
          data: (state) => RefreshIndicator(
            onRefresh: () => ref.refresh(homeProvider.future),
            child: CustomScrollView(
              slivers: [
                // Cabecera fija (Sticky Header)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HomeHeaderDelegate(
                    child: HomeHeaderSection(
                      today: DateTime.now(),
                      infoLabel: state.headerInfoLabel,
                      searchViewModel: searchViewModel,
                    ),
                  ),
                ),

                // Categorías
                if (state.categoryLayout != null)
                  SliverToBoxAdapter(
                    child: StaggeredFadeIn(
                      delay: const Duration(milliseconds: 200),
                      child: HomeCategoriesSection(
                        layout: state.categoryLayout!,
                      ),
                    ),
                  ),

                // Eventos
                SliverToBoxAdapter(
                  child: StaggeredFadeIn(
                    delay: const Duration(milliseconds: 300),
                    child: HomeFeaturedSection(
                      featuredEvents: state.featuredEvents,
                      sectionTitle: 'Featured Sessions',
                    ),
                  ),
                ),

                // Noticias
                SliverToBoxAdapter(
                  child: StaggeredFadeIn(
                    delay: const Duration(milliseconds: 400),
                    child: HomeNewsSection(news: state.news),
                  ),
                ),

                // Actividades Sociales
                SliverToBoxAdapter(
                  child: StaggeredFadeIn(
                    delay: const Duration(milliseconds: 500),
                    child: HomeSocialActivitiesSection(
                      socials: state.socialActivities,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          loading: () => const LoadingScreen(),
          error: (err, stack) =>
              Center(child: Text('Error al cargar datos: $err')),
        ),
      ),
    );
  }
}

/// Gestiona el header fijo de la vista principal.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _HomeHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 180.0;
  @override
  double get minExtent => 180.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
