import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/bootstrap_provider.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';
import 'package:iced26/presentation/app/widgets/staggered_fade_in.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/home/view/sections/home_news_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_header_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';

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

  /// Construye el scaffold de la página principal.
  /// Devuelve la estructura básica de la página principal.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de la Home para actualizar la vista.
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: homeStateAsync.when(
          data: (state) => RefreshIndicator(
            onRefresh: () => ref.refresh(homeViewModelProvider.future),
            child: CustomScrollView(
              slivers: [
                // Cabecera fija (Sticky Header)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HomeHeaderDelegate(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: HomeHeaderSection(
                      today: DateTime.now(),
                      infoLabel: state.headerInfoLabel,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // Categorías
                      if (state.categoryLayout != null)
                        StaggeredFadeIn(
                          delay: const Duration(milliseconds: 200),
                          child: HomeCategoriesSection(
                            layout: state.categoryLayout!,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Eventos
                      StaggeredFadeIn(
                        delay: const Duration(milliseconds: 300),
                        child: HomeFeaturedSection(
                          featuredEvents: state.featuredEvents,
                          sectionTitle: 'Featured Sessions',
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Noticias
                      StaggeredFadeIn(
                        delay: const Duration(milliseconds: 400),
                        child: HomeNewsSection(news: state.news),
                      ),

                      const SizedBox(height: 24),

                      // Actividades Sociales
                      StaggeredFadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: HomeSocialActivitiesSection(
                          socials: state.socialActivities,
                        ),
                      ),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
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

/// Gestiona el header fijo de la vista principal con fondo sólido.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;

  _HomeHeaderDelegate({required this.child, required this.backgroundColor});

  /// Construye el widget del header.
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.bottomCenter,
      child: child,
    );
  }

  // [:: Futuro] Constantes.
  /// Constante para el máximo de extent (Header).
  @override
  double get maxExtent => 200.0;

  /// Constante para el mínimo de extent (Header).
  @override
  double get minExtent => 200.0;

  /// Determina si el header debe reconstruirse.
  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) =>
      child != oldDelegate.child ||
      backgroundColor != oldDelegate.backgroundColor;
}
