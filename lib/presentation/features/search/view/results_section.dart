import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/state/recent_searches_provider.dart';
import 'package:iced26/presentation/app/state/recently_viewed_people_provider.dart';
import 'package:iced26/presentation/app/state/recently_viewed_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/search/view/recent_searches_section.dart';
import 'package:iced26/presentation/features/search/view/recently_viewed_people_section.dart';
import 'package:iced26/presentation/features/search/view/recently_viewed_section.dart';
import 'package:iced26/presentation/features/search/widgets/person_result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';

// Límites independientes: pueden divergir si el diseño lo requiere
const _kPeopleCap = 6;
const _kSessionsCap = 6;

/// Sección que muestra los resultados de la búsqueda.
class ResultsSection extends ConsumerWidget {
  const ResultsSection({
    super.key,
    required this.state,
    required this.people,
    required this.onRecentQueryTap,
  });
  final SearchState state;
  final List<Person> people;
  final ValueChanged<String> onRecentQueryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    final recentlyViewed = ref.watch(recentlyViewedProvider);
    final recentlyViewedPeople = ref.watch(recentlyViewedPeopleProvider);
    final hasNoActiveSearch = state.query.isEmpty && !state.filters.isActive;

    if (hasNoActiveSearch) {
      // Overlay en SearchModalBody cubre el estado "Explore" cuando todas las listas están vacías.
      final allEmpty =
          recent.isEmpty &&
          recentlyViewed.isEmpty &&
          recentlyViewedPeople.isEmpty;
      if (allEmpty) {
        return const SizedBox.shrink();
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recent.isNotEmpty)
              RecentSearchesSection(
                queries: recent,
                onQueryTap: onRecentQueryTap,
                onRemove: (q) {
                  ref.read(recentSearchesProvider.notifier).remove(q);
                },
                onClearAll: () {
                  ref.read(recentSearchesProvider.notifier).clearAll();
                },
              ),
            if (recentlyViewed.isNotEmpty)
              RecentlyViewedSection(
                eventIds: recentlyViewed,
                onEventTap: (event) {
                  // Re-sube al tope del historial al volver a visitar.
                  ref.read(recentlyViewedProvider.notifier).add(event.id);
                  showEventDetail(context, event);
                },
              ),
            if (recentlyViewedPeople.isNotEmpty)
              RecentlyViewedPeopleSection(personIds: recentlyViewedPeople),
          ],
        ),
      );
    }

    // Overlay en SearchModalBody cubre el estado "No results".
    if (state.results.isEmpty && people.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.s),
        Expanded(
          child: _CombinedResultsList(
            events: state.results,
            people: people,
            onEventTap: (event) {
              if (state.query.isNotEmpty) {
                ref.read(recentSearchesProvider.notifier).add(state.query);
              }
              ref.read(recentlyViewedProvider.notifier).add(event.id);
              showEventDetail(context, event);
            },
            onPersonTap: (person) {
              if (state.query.isNotEmpty) {
                ref.read(recentSearchesProvider.notifier).add(state.query);
              }
              ref.read(recentlyViewedPeopleProvider.notifier).add(person.id);
            },
          ),
        ),
      ],
    );
  }
}

/// Lista unificada con sección de ponentes (si hay) seguida de sesiones (si hay).
/// Muestra un cap inicial por sección y un botón "Show more" para expandir.
class _CombinedResultsList extends StatefulWidget {
  const _CombinedResultsList({
    required this.events,
    required this.people,
    required this.onEventTap,
    this.onPersonTap,
  });

  final List<Event> events;
  final List<Person> people;
  final ValueChanged<Event> onEventTap;
  final ValueChanged<Person>? onPersonTap;

  @override
  State<_CombinedResultsList> createState() => _CombinedResultsListState();
}

class _CombinedResultsListState extends State<_CombinedResultsList> {
  bool _allPeopleVisible = false;
  bool _allEventsVisible = false;

  @override
  void didUpdateWidget(_CombinedResultsList old) {
    super.didUpdateWidget(old);
    // Comparación por referencia (!=) es suficiente e intencional:
    // Riverpod crea una lista nueva en cada rebuild, por lo que
    // cualquier cambio en los resultados produce una referencia distinta.
    if (old.people != widget.people || old.events != widget.events) {
      _allPeopleVisible = false;
      _allEventsVisible = false;
    }
  }

  List<Widget> _buildPeopleItems(List<Person> visible, int remaining) {
    final onPersonTap = widget.onPersonTap;
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s),
        child: SectionLabel(
          label: AppStrings.searchPeopleLabel,
          icon: AppIcons.peopleOutline,
          count: widget.people.length,
        ),
      ),
      for (final p in visible)
        PersonResultTile(
          key: ValueKey(p.id),
          person: p,
          onTap: onPersonTap != null
              ? () {
                  onPersonTap(p);
                }
              : null,
        ),
      if (remaining > 0)
        _ShowMoreButton(
          remaining: remaining,
          onTap: () {
            setState(() {
              _allPeopleVisible = true;
            });
          },
        ),
    ];
  }

  List<Widget> _buildEventsItems(
    List<Event> visible,
    int remaining, {
    required bool hasPeopleAbove,
  }) {
    return [
      if (hasPeopleAbove) const SizedBox(height: AppSpacing.m),
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s),
        child: SectionLabel(
          label: AppStrings.searchSessionsLabel,
          icon: AppIcons.sessions,
          count: widget.events.length,
        ),
      ),
      for (final e in visible)
        ResultTile(
          key: ValueKey(e.id),
          event: e,
          onTap: () {
            widget.onEventTap(e);
          },
        ),
      if (remaining > 0)
        _ShowMoreButton(
          remaining: remaining,
          onTap: () {
            setState(() {
              _allEventsVisible = true;
            });
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final visiblePeople = _allPeopleVisible
        ? widget.people
        : widget.people.take(_kPeopleCap).toList();
    final visibleEvents = _allEventsVisible
        ? widget.events
        : widget.events.take(_kSessionsCap).toList();

    final remainingPeople = widget.people.length - visiblePeople.length;
    final remainingEvents = widget.events.length - visibleEvents.length;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        _ResultsCount(total: widget.people.length + widget.events.length),
        if (widget.people.isNotEmpty)
          ..._buildPeopleItems(visiblePeople, remainingPeople),
        if (widget.events.isNotEmpty)
          ..._buildEventsItems(
            visibleEvents,
            remainingEvents,
            hasPeopleAbove: widget.people.isNotEmpty,
          ),
      ],
    );
  }
}

class _ResultsCount extends StatelessWidget {
  const _ResultsCount({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Text(
        AppStrings.searchResultsCount(total),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}

class _ShowMoreButton extends StatelessWidget {
  const _ShowMoreButton({required this.remaining, required this.onTap});
  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(AppIcons.expandMore, size: 18),
          label: Text(AppStrings.searchShowMore(remaining)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.s,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
          ),
        ),
      ),
    );
  }
}
