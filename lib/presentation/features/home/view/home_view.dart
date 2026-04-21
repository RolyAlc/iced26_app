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
import 'package:iced26/presentation/features/home/view/sections/home_keynote_speakers_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';
import 'package:iced26/core/constants/design_tokens.dart';
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
        header: HomeHeaderSection(
          today: DateTime.now(),
          infoLabel: state.headerInfoLabel,
        ),
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

          // Keynote Speakers — Carrusel horizontal (Edge-to-Edge)
          if (state.keynoteSpeakers.isNotEmpty)
            StaggeredFadeIn(
              delay: const Duration(milliseconds: 350),
              child: AppSection(
                title: 'Keynote speakers',
                edgeToEdge: true,
                child: HomeKeynoteSection(speakers: state.keynoteSpeakers),
              ),
            ),

          // Noticias — Lista vertical
          StaggeredFadeIn(
            delay: const Duration(milliseconds: 400),
            child: AppSection.resolved(
              title: 'Latest news',
              hasData: state.news.isNotEmpty,
              dataChild: HomeNewsSection(news: state.news),
              emptyChild: const AppEmptyState(
                title: 'No news available',
                message: 'Check back later for the latest updates.',
                illustration: Icon(Icons.newspaper_rounded, size: 60),
              ),
            ),
          ),

          // Actividades Sociales — Carrusel horizontal (Edge-to-Edge)
          StaggeredFadeIn(
            delay: const Duration(milliseconds: 500),
            child: AppSection.resolved(
              title: 'Social activities',
              edgeToEdge: true,
              hasData: state.socialActivities.isNotEmpty,
              dataChild: HomeSocialActivitiesSection(
                socials: state.socialActivities,
              ),
              // Empty state sin padding extra
              emptyChild: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: AppEmptyState(
                  title: 'No social activities found',
                  message: 'Check back later for upcoming events.',
                  illustration: Icon(Icons.celebration_rounded, size: 60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
