import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/state/recent_searches_provider.dart';
import 'package:iced26/presentation/app/state/recently_viewed_people_provider.dart';
import 'package:iced26/presentation/app/state/recently_viewed_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/view/search_helper.dart';
import 'package:iced26/presentation/features/search/view/search_modal_body.dart';

const double _kBadgeSize = 8.0;
const double _kBadgeOffset = -3.0;

List<Person> _filterPeople(Map<String, Person> allPeople, String query) {
  if (query.isEmpty) {
    return [];
  }
  final q = query.toLowerCase();
  return [
    for (final p in allPeople.values)
      if (p.name.values.values.any((v) => v.toLowerCase().contains(q))) p,
  ];
}

SearchHelper? _resolveOverlay({
  required bool hasNoActiveSearch,
  required bool historyIsEmpty,
  required bool hasNoResults,
}) {
  final hasNoActiveSearchAndHistoryIsEmpty =
      hasNoActiveSearch && historyIsEmpty;
  if (hasNoActiveSearchAndHistoryIsEmpty) {
    return const SearchHelper(
      title: AppStrings.searchExploreTitle,
      subtitle: AppStrings.searchExploreSubtitle,
      icon: AppIcons.empty,
    );
  }
  if (hasNoResults) {
    return const SearchHelper(
      title: AppStrings.searchNoResultsTitle,
      subtitle: AppStrings.searchNoResultsSubtitle,
      icon: AppIcons.searchEmpty,
    );
  }
  return null;
}

/// Barra de búsqueda inteligente.
class SmartSearchBar extends ConsumerWidget {
  const SmartSearchBar({super.key, required this.searchNotifier});
  final Search searchNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFilterActive = ref.watch(
      searchProvider.select((s) => s.filters.isActive),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.l),
        onTap: () => open(context, searchNotifier),
        child: _SearchBarVisualContainer(
          isFilterActive: isFilterActive,
          onFilterTap: () => open(context, searchNotifier, expandFilters: true),
        ),
      ),
    );
  }

  static void open(
    BuildContext context,
    Search notifier, {
    bool expandFilters = false,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) =>
            _SearchScreen(notifier: notifier, expandFilters: expandFilters),
        transitionsBuilder: (context, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        reverseTransitionDuration: AppDuration.fast,
      ),
    );
  }
}

/// Página completa de búsqueda. Gestiona el overlay (Explore / No results)
/// a nivel de Scaffold para que siempre quede centrado en la pantalla visible,
/// independientemente de la altura del header o del teclado.
class _SearchScreen extends ConsumerStatefulWidget {
  const _SearchScreen({required this.notifier, required this.expandFilters});
  final Search notifier;
  final bool expandFilters;

  @override
  ConsumerState<_SearchScreen> createState() => _SearchScreenState();
}

/// Estado de [_SearchScreen].
class _SearchScreenState extends ConsumerState<_SearchScreen> {
  late bool _filtersExpanded;

  @override
  void initState() {
    super.initState();
    _filtersExpanded = widget.expandFilters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(searchProvider);
    final recent = ref.watch(recentSearchesProvider);
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final recentlyViewedPeople = ref.watch(recentlyViewedPeopleProvider);
    final allPeople = ref.watch(allPeopleIndexProvider).value ?? {};

    final hasNoActiveSearch = state.query.isEmpty && !state.filters.isActive;
    final people = hasNoActiveSearch
        ? <Person>[]
        : _filterPeople(allPeople, state.query);

    final historyIsEmpty =
        recent.isEmpty &&
        recentlyViewed.isEmpty &&
        recentlyViewedPeople.isEmpty;

    final overlay = _resolveOverlay(
      hasNoActiveSearch: hasNoActiveSearch,
      historyIsEmpty: historyIsEmpty,
      hasNoResults:
          !hasNoActiveSearch && state.results.isEmpty && people.isEmpty,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.m,
                AppSpacing.l,
                AppSpacing.m,
              ),
              child: SearchModalBody(
                notifier: widget.notifier,
                people: people,
                filtersExpanded: _filtersExpanded,
                onToggleFilters: _toggleFilters,
              ),
            ),
            if (overlay != null && !_filtersExpanded)
              Positioned.fill(child: Center(child: overlay)),
          ],
        ),
      ),
    );
  }

  void _toggleFilters() {
    setState(() {
      _filtersExpanded = !_filtersExpanded;
    });
  }
}

/// Contenedor visual de la barra de búsqueda.
class _SearchBarVisualContainer extends StatelessWidget {
  const _SearchBarVisualContainer({
    required this.isFilterActive,
    required this.onFilterTap,
  });
  final bool isFilterActive;
  final VoidCallback onFilterTap;

  static const double _kBarHeight = 56.0;
  static const double _kBorderWidth = 1.2;
  static const EdgeInsets _kPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.m,
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: _kBarHeight,
      padding: _kPadding,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.primary.withValues(alpha: 0.08),
          colors.surface,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: colors.outlineVariant, width: _kBorderWidth),
      ),
      child: Row(
        children: [
          Icon(AppIcons.search, color: colors.primary),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Text(AppStrings.searchBarHint)),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFilterTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: _FilterIcon(isActive: isFilterActive),
            ),
          ),
        ],
      ),
    );
  }
}

/// Icono del filtro.
class _FilterIcon extends StatelessWidget {
  const _FilterIcon({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          AppIcons.filter,
          color: isActive ? colors.primary : colors.secondary,
        ),
        if (isActive)
          Positioned(
            top: _kBadgeOffset,
            right: _kBadgeOffset,
            child: Container(
              width: _kBadgeSize,
              height: _kBadgeSize,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
