import 'package:flutter/material.dart';

import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/search/view/filters_section.dart';
import 'package:iced26/presentation/features/search/view/results_section.dart';

/// Cuerpo principal de la búsqueda.
class SearchBody extends StatelessWidget {
  final SearchState state;
  final Search notifier;
  final bool filtersExpanded;
  final VoidCallback onCollapseFilters;
  final ValueChanged<String> onRecentQueryTap;

  const SearchBody({
    super.key,
    required this.state,
    required this.notifier,
    required this.filtersExpanded,
    required this.onCollapseFilters,
    required this.onRecentQueryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (filtersExpanded) {
      return FiltersSection(notifier: notifier, onCollapse: onCollapseFilters);
    }

    return ResultsSection(state: state, onRecentQueryTap: onRecentQueryTap);
  }
}
