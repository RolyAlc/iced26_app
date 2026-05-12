import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/search/sections/search_body.dart';
import 'package:iced26/presentation/app/widgets/search/sections/search_header.dart';

/// Cuerpo principal del modal de búsqueda.
class SearchModalBody extends ConsumerStatefulWidget {
  final Search notifier;
  final bool initiallyExpandedFilters;

  const SearchModalBody({
    super.key,
    required this.notifier,
    this.initiallyExpandedFilters = false,
  });

  @override
  ConsumerState<SearchModalBody> createState() => SearchModalBodyState();
}

class SearchModalBodyState extends ConsumerState<SearchModalBody> {
  late bool _filtersExpanded;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    AppLogger.d('SearchModal: Abriendo modal');
    _filtersExpanded = widget.initiallyExpandedFilters;
    _searchController = TextEditingController();

    // Limpia el estado del buscador anterior en el primer frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.notifier.clear();
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
          filtersExpanded: _filtersExpanded,
          onToggleFilters: _toggleFilters,
        ),
        const SizedBox(height: AppSpacing.l),
        Expanded(
          child: SearchBody(
            state: state,
            notifier: widget.notifier,
            filtersExpanded: _filtersExpanded,
            onCollapseFilters: _toggleFilters,
            onRecentQueryTap: _onRecentQueryTap,
          ),
        ),
      ],
    );
  }

  void _toggleFilters() {
    setState(() {
      _filtersExpanded = !_filtersExpanded;
    });
  }

  void _onRecentQueryTap(String query) {
    AppLogger.d('SearchModal: Tap en búsqueda reciente: "$query"');
    _searchController.text = query;
    _searchController.selection = TextSelection.collapsed(offset: query.length);
    widget.notifier.performSearch(query);
  }
}
