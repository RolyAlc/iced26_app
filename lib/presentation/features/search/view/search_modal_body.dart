import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/state/recent_searches_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/search/view/search_body.dart';
import 'package:iced26/presentation/features/search/view/search_header.dart';

/// Cuerpo de la pantalla de búsqueda: header + contenido.
/// El overlay (Explore / No results) lo gestiona el padre (_SearchScreen).
class SearchModalBody extends ConsumerStatefulWidget {
  const SearchModalBody({
    super.key,
    required this.notifier,
    required this.people,
    required this.filtersExpanded,
    required this.onToggleFilters,
  });
  final Search notifier;
  final List<Person> people;
  final bool filtersExpanded;
  final VoidCallback onToggleFilters;

  @override
  ConsumerState<SearchModalBody> createState() => _SearchModalBodyState();
}

/// Estado del cuerpo de la pantalla de búsqueda.
class _SearchModalBodyState extends ConsumerState<SearchModalBody> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    AppLogger.d('SearchModal: Abriendo modal');
    _searchController = TextEditingController();

    // Limpia el estado del buscador anterior en el primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.notifier.clearQuery();
      }
    });
  }

  @override
  void dispose() {
    AppLogger.d('SearchModal: Cerrando modal');
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchHeader(
          notifier: widget.notifier,
          controller: _searchController,
          filtersExpanded: widget.filtersExpanded,
          onToggleFilters: widget.onToggleFilters,
          onSubmitted: _onSearchSubmitted,
        ),
        const SizedBox(height: AppSpacing.l),
        Expanded(
          child: SearchBody(
            state: state,
            people: widget.people,
            notifier: widget.notifier,
            filtersExpanded: widget.filtersExpanded,
            onCollapseFilters: widget.onToggleFilters,
            onRecentQueryTap: _onRecentQueryTap,
          ),
        ),
      ],
    );
  }

  void _onSearchSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return;
    }
    ref.read(recentSearchesProvider.notifier).add(trimmed);
  }

  void _onRecentQueryTap(String query) {
    AppLogger.d('SearchModal: Tap en búsqueda reciente: "$query"');
    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);
    widget.notifier.performSearch(query);
  }
}
