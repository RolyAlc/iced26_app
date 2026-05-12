import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';
import 'package:iced26/presentation/app/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/app/widgets/staggered_fade_in.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/home/view/sections/home_news_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_header_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_featured_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_keynote_speakers_section.dart';
import 'package:iced26/presentation/features/home/view/sections/home_social_activities_section.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/widgets/app_empty_state.dart';
import 'package:iced26/presentation/widgets/app_page.dart';
import 'package:iced26/presentation/widgets/app_section.dart';

// Alturas de referencia para el header colapsable.
const double _expandedHeaderHeight = 136.0;
const double _collapsedHeaderHeight = 80.0;

/// Vista raíz de la página principal.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return bootstrapAsync.when(
      data: (_) => const _HomeContent(),
      loading: () => const LoadingScreen(),
      error: (err, stack) => _BootstrapErrorScreen(error: err),
    );
  }
}

/// Pantalla de error cuando el bootstrap falla.
class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    // TODO: reemplazar por AppErrorScreen cuando exista.
    return Center(child: Text('Error: $error'));
  }
}

/// Observa [homeViewModelProvider] y monta el [AppPage] con todas las secciones.
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
          today: DateTime.now(),
          infoLabel: state.headerInfoLabel,
          searchNotifier: searchNotifier,
        ),
        collapsedHeader: HomeHeaderSection(
          onSearchTap: () => SmartSearchBar.open(context, searchNotifier),
        ),
        headerFallbackHeight: _expandedHeaderHeight,
        collapsedHeaderFallbackHeight: _collapsedHeaderHeight,
        children: _buildSections(state, ref),
      ),
    );
  }

  /// Devuelve la lista ordenada de secciones de la Home.
  List<Widget> _buildSections(HomeState state, WidgetRef ref) {
    return [
      _buildFeaturedSection(state, ref),
      if (state.keynoteSpeakers.isNotEmpty) _buildKeynoteSection(state),
      _buildNewsSection(state),
      _buildSocialSection(state),
    ];
  }

  /// Carrusel horizontal de eventos destacados.
  Widget _buildFeaturedSection(HomeState state, WidgetRef ref) {
    return _AnimatedSection(
      delay: const Duration(milliseconds: 200),
      child: AppSection(
        title: 'Featured sessions',
        edgeToEdge: true,
        child: HomeFeaturedSection(
          featuredEvents: state.featuredEvents,
          onExploreTap: () =>
              ref.read(navigationProvider.notifier).select(AppFeature.schedule),
        ),
      ),
    );
  }

  /// Carrusel horizontal de keynote speakers.
  Widget _buildKeynoteSection(HomeState state) {
    return _AnimatedSection(
      delay: const Duration(milliseconds: 350),
      child: AppSection(
        title: 'Keynote speakers',
        edgeToEdge: true,
        child: HomeKeynoteSection(speakers: state.keynoteSpeakers),
      ),
    );
  }

  /// Lista vertical de noticias con estado vacío.
  Widget _buildNewsSection(HomeState state) {
    return _AnimatedSection(
      delay: const Duration(milliseconds: 400),
      child: AppSection.resolved(
        title: 'Latest news',
        hasData: state.news.isNotEmpty,
        dataChild: HomeNewsSection(news: state.news),
        emptyChild: const AppEmptyState(
          title: 'No news available',
          message: 'Check back later for the latest updates.',
          illustration: Icon(AppIcons.news, size: 60),
        ),
      ),
    );
  }

  /// Carrusel horizontal de actividades sociales con estado vacío.
  Widget _buildSocialSection(HomeState state) {
    return _AnimatedSection(
      delay: const Duration(milliseconds: 500),
      child: AppSection.resolved(
        title: 'Social activities',
        edgeToEdge: true,
        hasData: state.socialActivities.isNotEmpty,
        dataChild: HomeSocialActivitiesSection(socials: state.socialActivities),
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

/// Header expandido: logo + fecha/welcome + barra de búsqueda.
class _HomeExpandedHeader extends StatelessWidget {
  const _HomeExpandedHeader({
    required this.today,
    required this.infoLabel,
    required this.searchNotifier,
  });

  final DateTime today;
  final String infoLabel;
  final Search searchNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dateLabel = MaterialLocalizations.of(context).formatFullDate(today);

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(width: 4),
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

/// Envuelve cualquier sección con [StaggeredFadeIn] para animación de entrada.
class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StaggeredFadeIn(delay: delay, child: child);
  }
}
