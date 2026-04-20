import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';
import 'package:iced26/presentation/app/widgets/staggered_fade_in.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/home/view/sections/home_news_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_header_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_categories_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';
import 'package:iced26/presentation/widgets/app_empty_state.dart';
import 'package:iced26/presentation/widgets/app_page.dart';
import 'package:iced26/presentation/widgets/app_section.dart';

/// Vista de la página principal.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return bootstrapAsync.when(
      data: (_) => const _HomeContent(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

/// Contenido de la página principal.
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return AppAsyncValueWidget(
      asyncValue: homeStateAsync,
      data: (state) => AppPage(
        header: AppSection(
          // Wrap HomeHeaderSection with AppSection
          topPadding:
              0, // AppPage handles top inset, so AppSection shouldn't add extra top padding here.
          bottomPadding:
              0, // Let AppSection handle vertical spacing between sections.
          child: HomeHeaderSection(
            today: DateTime.now(),
            infoLabel: state.headerInfoLabel,
          ),
        ),
        headerHeight:
            HomeHeaderSection.headerHeight +
            24, // Altura base + padding // Might need adjustment after wrapping
        children: [
          // Eventos Destacados — Carrusel horizontal (Edge-to-Edge)
          StaggeredFadeIn(
            delay: const Duration(milliseconds: 200),
            child: AppSection(
              title: 'Featured sessions',
              edgeToEdge: true,
              child: HomeFeaturedSection(featuredEvents: state.featuredEvents),
            ),
          ),

          // Categorías — Bento Grid (Con padding horizontal estándar)
          if (state.categoryLayout != null)
            StaggeredFadeIn(
              delay: const Duration(milliseconds: 300),
              child: AppSection(
                title: 'Categories',
                child: HomeCategoriesSection(layout: state.categoryLayout!),
              ),
            ),

          // Noticias — Lista vertical (Con padding horizontal estándar)
          if (state.news.isNotEmpty)
            StaggeredFadeIn(
              delay: const Duration(milliseconds: 400),
              child: AppSection(
                title: 'Latest news',
                child: HomeNewsSection(news: state.news),
              ),
            )
          else
            const AppEmptyState(
              title: 'No news available',
              message: 'Check back later for the latest updates.',
              illustration: Icon(
                Icons.newspaper_rounded,
                size: 60,
              ), // Example using Icon
            ),

          // Actividades Sociales — Carrusel horizontal (Edge-to-Edge)
          if (state.socialActivities.isNotEmpty)
            StaggeredFadeIn(
              delay: const Duration(milliseconds: 500),
              child: AppSection(
                title: 'Social activities',
                edgeToEdge: true,
                child: HomeSocialActivitiesSection(
                  socials: state.socialActivities,
                ),
              ),
            )
          else if (state.socialActivities.isNotEmpty ==
              false) // Explicit check for empty
            AppSection(
              title: 'Social activities',
              edgeToEdge: true,
              child: const AppEmptyState(
                title: 'No social activities found',
                message: 'Check back later for upcoming events.',
                illustration: Icon(
                  Icons.celebration_rounded,
                  size: 60,
                ), // Example using Icon
              ),
            ),
        ],
      ),
    );
  }
}
