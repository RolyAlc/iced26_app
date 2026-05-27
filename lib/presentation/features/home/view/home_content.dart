import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/view/sections/home_conference_themes_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_expanded_header.dart';
import 'package:iced26/presentation/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_header_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_keynote_speakers_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_news_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';
import 'package:iced26/presentation/features/home/view/sheets/home_news_all_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/conference_theme_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/social_activity_ui_model.dart';
import 'package:iced26/presentation/shared/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';
import 'package:iced26/presentation/shared/widgets/app_section.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/shared/widgets/staggered_fade_in.dart';

const double _kExpandedHeaderHeight = 136.0;
const double _kCollapsedHeaderHeight = 80.0;
const double _kEmptyIllustrationSize = 60.0;

// Delays escalonados para StaggeredFadeIn — cada sección entra
// ligeramente después que la anterior para dar sensación de carga progresiva.
const Duration _kFeaturedFadeDelay = Duration(milliseconds: 200);
const Duration _kKeynoteFadeDelay = Duration(milliseconds: 350);
const Duration _kThemesFadeDelay = Duration(milliseconds: 450);
const Duration _kNewsFadeDelay = Duration(milliseconds: 500);
const Duration _kSocialFadeDelay = Duration(milliseconds: 600);

/// Contenedor principal de la vista de inicio.
///
/// Observa el [homeViewModelProvider] y distribuye el estado entre
/// cada sección de la pantalla.
class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(homeViewModelProvider);
    final searchNotifier = ref.watch(searchProvider.notifier);

    return AppAsyncValueWidget(
      asyncValue: homeStateAsync,
      data: (state) => AppPage(
        header: HomeExpandedHeader(
          infoLabel: state.headerInfoLabel,
          today: state.today,
          searchNotifier: searchNotifier,
        ),
        collapsedHeader: HomeHeaderSection(searchNotifier: searchNotifier),
        headerFallbackHeight: _kExpandedHeaderHeight,
        collapsedHeaderFallbackHeight: _kCollapsedHeaderHeight,
        children: [
          _HomeFeaturedSection(
            featuredEvents: state.featuredEvents,
            onExploreTap: () => _navigateToSchedule(ref),
          ),
          if (state.keynoteSpeakers.isNotEmpty)
            _HomeKeynoteSection(
              speakers: state.keynoteSpeakers,
              onViewAll: () => SmartSearchBar.open(context, searchNotifier),
            ),
          if (state.conferenceThemes.isNotEmpty)
            _HomeThemesSection(themes: state.conferenceThemes),
          _HomeNewsSection(news: state.news, hasMoreNews: state.hasMoreNews),
          _HomeSocialSection(socialActivities: state.socialActivities),
        ],
      ),
    );
  }

  void _navigateToSchedule(WidgetRef ref) {
    ref.read(homeViewModelProvider.notifier).navigateToScheduleTimeline();
  }
}

// Secciones privadas — wrappers que añaden animación y chrome de AppSection.

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
      delay: _kFeaturedFadeDelay,
      child: AppSection(
        title: 'Featured sessions',
        trailing: _SeeAllButton(onPressed: onExploreTap),
        edgeToEdge: true,
        child: HomeFeaturedSection(
          featuredEvents: featuredEvents,
          onExploreTap: onExploreTap,
        ),
      ),
    );
  }
}

/// Sección de keynote speakers.
class _HomeKeynoteSection extends StatelessWidget {
  const _HomeKeynoteSection({required this.speakers, required this.onViewAll});

  final List<KeynoteSpeakerUIModel> speakers;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: _kKeynoteFadeDelay,
      child: AppSection(
        title: 'Keynote speakers',
        trailing: _SeeAllButton(onPressed: onViewAll),
        edgeToEdge: true,
        child: HomeKeynoteSection(speakers: speakers),
      ),
    );
  }
}

/// Sección de temas de la conferencia.
class _HomeThemesSection extends StatelessWidget {
  const _HomeThemesSection({required this.themes});

  final List<ConferenceThemeUIModel> themes;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: _kThemesFadeDelay,
      child: AppSection(
        title: 'Conference themes',
        child: HomeConferenceThemesSection(themes: themes),
      ),
    );
  }
}

/// Sección de últimas noticias.
class _HomeNewsSection extends StatelessWidget {
  const _HomeNewsSection({required this.news, required this.hasMoreNews});

  final List<NewsItemUIModel> news;
  final bool hasMoreNews;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: _kNewsFadeDelay,
      child: AppSection.resolved(
        title: 'Latest news',
        trailing: hasMoreNews
            ? _SeeAllButton(
                onPressed: () => HomeNewsAllSheet.show(context, news),
              )
            : null,
        hasData: news.isNotEmpty,
        dataChild: HomeNewsSection(news: news),
        emptyChild: const AppEmptyState(
          title: 'No news available',
          message: 'Check back later for the latest updates.',
          illustration: Icon(AppIcons.news, size: _kEmptyIllustrationSize),
        ),
      ),
    );
  }
}

/// Sección de actividades sociales.
class _HomeSocialSection extends StatelessWidget {
  const _HomeSocialSection({required this.socialActivities});

  final List<SocialActivityUIModel> socialActivities;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(
      delay: _kSocialFadeDelay,
      child: AppSection.resolved(
        title: 'Social activities',
        edgeToEdge: true,
        hasData: socialActivities.isNotEmpty,
        dataChild: HomeSocialActivitiesSection(socials: socialActivities),
        emptyChild: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
          ),
          child: const AppEmptyState(
            title: 'No social activities found',
            message: 'Check back later for upcoming events.',
            illustration: Icon(AppIcons.social, size: _kEmptyIllustrationSize),
          ),
        ),
      ),
    );
  }
}

/// Botón "See all" compacto reutilizado en los headers de sección.
class _SeeAllButton extends StatelessWidget {
  const _SeeAllButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      label: const Text('See all'),
      iconAlignment: IconAlignment.end,
    );
  }
}
