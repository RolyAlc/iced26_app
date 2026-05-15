import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/shared/widgets/error_screen.dart';
import 'package:iced26/presentation/shared/widgets/loading_screen.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/shared/widgets/staggered_fade_in.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_header_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_keynote_speakers_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_news_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';
import 'package:iced26/presentation/shared/widgets/app_section.dart';

const double _expandedHeaderHeight = 136.0;
const double _collapsedHeaderHeight = 80.0;

/// Vista principal de la pantalla de inicio.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return bootstrapAsync.when(
      data: (_) => const _HomeContent(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => ErrorScreen(error: err.toString()),
    );
  }
}

/// Contenedor principal de la vista de inicio.
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(homeViewModelProvider);
    final searchNotifier = ref.watch(searchProvider.notifier);

    return AppAsyncValueWidget(
      asyncValue: homeStateAsync,
      data: (state) => AppPage(
        header: _HomeExpandedHeader(
          infoLabel: state.headerInfoLabel,
          searchNotifier: searchNotifier,
        ),
        collapsedHeader: HomeHeaderSection(
          onSearchTap: () => SmartSearchBar.open(context, searchNotifier),
        ),
        headerFallbackHeight: _expandedHeaderHeight,
        collapsedHeaderFallbackHeight: _collapsedHeaderHeight,
        children: [
          _HomeFeaturedSection(
            featuredEvents: state.featuredEvents,
            onExploreTap: () => ref
                .read(navigationProvider.notifier)
                .select(AppFeature.schedule),
          ),
          if (state.keynoteSpeakers.isNotEmpty)
            _HomeKeynoteSection(speakers: state.keynoteSpeakers),
          _HomeNewsSection(news: state.news),
          _HomeSocialSection(socialActivities: state.socialActivities),
        ],
      ),
    );
  }
}

/// Sección de eventos destacados.
class _HomeFeaturedSection extends StatelessWidget {
  const _HomeFeaturedSection({
    required this.featuredEvents,
    required this.onExploreTap,
  });

  final List<EventUIModel> featuredEvents;
  final VoidCallback onExploreTap;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: const Duration(milliseconds: 200),
      child: AppSection(
        title: 'Featured sessions',
        edgeToEdge: true,
        child: HomeFeaturedSection(
          featuredEvents: featuredEvents,
          onExploreTap: onExploreTap,
        ),
      ),
    );
  }
}

/// Sección de keynotes.
class _HomeKeynoteSection extends StatelessWidget {
  const _HomeKeynoteSection({required this.speakers});

  final List<KeynoteSpeakerUIModel> speakers;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: const Duration(milliseconds: 350),
      child: AppSection(
        title: 'Keynote speakers',
        edgeToEdge: true,
        child: HomeKeynoteSection(speakers: speakers),
      ),
    );
  }
}

/// Sección de últimas noticias.
class _HomeNewsSection extends StatelessWidget {
  const _HomeNewsSection({required this.news});

  final List<NewsItem> news;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: const Duration(milliseconds: 400),
      child: AppSection.resolved(
        title: 'Latest news',
        hasData: news.isNotEmpty,
        dataChild: HomeNewsSection(news: news),
        emptyChild: const AppEmptyState(
          title: 'No news available',
          message: 'Check back later for the latest updates.',
          illustration: Icon(AppIcons.news, size: 60),
        ),
      ),
    );
  }
}

/// Sección de actividades sociales.
class _HomeSocialSection extends StatelessWidget {
  const _HomeSocialSection({required this.socialActivities});

  final List<SocialActivity> socialActivities;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: const Duration(milliseconds: 500),
      child: AppSection.resolved(
        title: 'Social activities',
        edgeToEdge: true,
        hasData: socialActivities.isNotEmpty,
        dataChild: HomeSocialActivitiesSection(socials: socialActivities),
        emptyChild: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: AppEmptyState(
            title: 'No social activities found',
            message: 'Check back later for upcoming events.',
            illustration: Icon(AppIcons.social, size: 60),
          ),
        ),
      ),
    );
  }
}

/// Header expandido de la vista de inicio.
class _HomeExpandedHeader extends StatelessWidget {
  const _HomeExpandedHeader({
    required this.infoLabel,
    required this.searchNotifier,
  });

  final String infoLabel;
  final Search searchNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatFullDate(DateTime.now());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(Assets.logoIced26, height: 48, fit: BoxFit.contain),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.calendarOutline,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        dateLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    infoLabel,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: SmartSearchBar(searchNotifier: searchNotifier),
        ),
      ],
    );
  }
}
