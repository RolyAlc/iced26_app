import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/state/recent_searches_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/view/search_helper.dart';
import 'package:iced26/presentation/features/search/view/recent_searches_section.dart';
import 'package:iced26/presentation/features/search/widgets/person_result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';

/// Sección que muestra los resultados de la búsqueda.
class ResultsSection extends ConsumerWidget {
  final SearchState state;
  final ValueChanged<String> onRecentQueryTap;

  const ResultsSection({
    super.key,
    required this.state,
    required this.onRecentQueryTap,
  });

  /// Filtra personas por nombre en todos los locales disponibles en I18nStr.
  List<Person> _filterPeople(Map<String, Person> allPeople, String query) {
    if (query.isEmpty) {
      return [];
    }
    final q = query.toLowerCase();
    return allPeople.values
        .where(
          (p) => p.name.values.values.any((v) => v.toLowerCase().contains(q)),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    final hasNoActiveSearch = state.query.isEmpty && !state.filters.isActive;

    if (hasNoActiveSearch) {
      if (recent.isEmpty) {
        return const SearchHelper(
          title: 'Explore',
          subtitle: 'Search by text, or filter by day, type and language.',
          icon: AppIcons.empty,
        );
      }
      return RecentSearchesSection(
        queries: recent,
        onQueryTap: onRecentQueryTap,
        onRemove: (q) {
          ref.read(recentSearchesProvider.notifier).remove(q);
        },
        onClearAll: () {
          ref.read(recentSearchesProvider.notifier).clearAll();
        },
      );
    }

    /// allPeopleIndexProvider se watchea aquí para que el Future esté cargado
    /// antes de filtrar — evita el race condition con ref.read en el notifier.
    final allPeople = ref.watch(allPeopleIndexProvider).value ?? {};
    final people = _filterPeople(allPeople, state.query);

    final hasNoResults = state.results.isEmpty && people.isEmpty;

    if (hasNoResults) {
      return const SearchHelper(
        title: 'No results',
        subtitle: 'Try adjusting your search or filters.',
        icon: AppIcons.searchEmpty,
      );
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
              showEventDetail(context, event);
            },
          ),
        ),
      ],
    );
  }
}

/// Lista unificada con sección de ponentes (si hay) seguida de sesiones (si hay).
class _CombinedResultsList extends StatelessWidget {
  const _CombinedResultsList({
    required this.events,
    required this.people,
    required this.onEventTap,
  });

  final List<Event> events;
  final List<Person> people;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    if (people.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: SectionLabel(label: 'People · ${people.length}'),
        ),
      );
      for (final p in people) {
        items.add(PersonResultTile(key: ValueKey(p.id), person: p));
      }
    }

    if (events.isNotEmpty) {
      if (people.isNotEmpty) {
        items.add(const SizedBox(height: AppSpacing.m));
      }
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: SectionLabel(label: 'Sessions · ${events.length}'),
        ),
      );
      for (final e in events) {
        items.add(
          ResultTile(
            key: ValueKey(e.id),
            event: e,
            onTap: () {
              onEventTap(e);
            },
          ),
        );
      }
    }

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: items,
    );
  }
}
