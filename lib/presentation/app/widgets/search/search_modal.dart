import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/widgets/search/search_filter_bar.dart';
import 'package:iced26/presentation/app/widgets/search/search_filter_panel.dart';

/// Modal de búsqueda con estado local
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

/// Estado del modal de búsqueda
class SearchModalBodyState extends ConsumerState<SearchModalBody> {
  late bool _filtersExpanded;

  @override
  void initState() {
    super.initState();
    _filtersExpanded = widget.initiallyExpandedFilters;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchHeader(
          notifier: widget.notifier,
          query: state.query,
          filtersExpanded: _filtersExpanded,
          onToggleFilters: _toggleFilters,
        ),
        const SizedBox(height: AppSpacing.s),
        Expanded(
          child: _SearchBody(
            state: state,
            notifier: widget.notifier,
            filtersExpanded: _filtersExpanded,
          ),
        ),
      ],
    );
  }

  /// Togglea la expansión de filtros
  void _toggleFilters() {
    setState(() {
      _filtersExpanded = !_filtersExpanded;
    });
  }
}

/// Header del modal de búsqueda
class _SearchHeader extends StatelessWidget {
  final Search notifier;
  final String query;
  final bool filtersExpanded;
  final VoidCallback onToggleFilters;

  const _SearchHeader({
    required this.notifier,
    required this.query,
    required this.filtersExpanded,
    required this.onToggleFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchInputField(onChanged: notifier.performSearch, query: query),
        const SizedBox(height: AppSpacing.s),
        FilterBar(
          notifier: notifier,
          isExpanded: filtersExpanded,
          onToggle: onToggleFilters,
        ),
      ],
    );
  }
}

/// Cuerpo del modal de búsqueda
class _SearchBody extends StatelessWidget {
  final SearchState state;
  final Search notifier;
  final bool filtersExpanded;

  const _SearchBody({
    required this.state,
    required this.notifier,
    required this.filtersExpanded,
  });

  @override
  Widget build(BuildContext context) {
    if (filtersExpanded) {
      return _FiltersSection(notifier: notifier);
    }

    return _ResultsSection(state: state, notifier: notifier);
  }
}

/// Sección de filtros
class _FiltersSection extends StatelessWidget {
  final Search notifier;

  const _FiltersSection({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: FilterPanel(notifier: notifier));
  }
}

/// Sección de resultados
class _ResultsSection extends StatelessWidget {
  final SearchState state;
  final Search notifier;

  const _ResultsSection({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final builder = _SearchResultBuilder();

    return builder.build(context: context, state: state, notifier: notifier);
  }
}

/// Encapsula lógica de decisión de UI.
class _SearchResultBuilder {
  Widget build({
    required BuildContext context,
    required SearchState state,
    required Search notifier,
  }) {
    if (_isEmptyContext(state)) {
      return const SearchHelper(
        title: 'Explore',
        subtitle: 'Search by text, or filter by day, type and language.',
        icon: AppIcons.empty,
      );
    }

    if (_hasNoResults(state)) {
      return const SearchHelper(
        title: 'No results',
        subtitle: 'Try adjusting your search or filters.',
        icon: AppIcons.searchEmpty,
      );
    }

    return _ResultsList(results: state.results, notifier: notifier);
  }

  bool _isEmptyContext(SearchState state) {
    return state.query.isEmpty && !state.filters.isActive;
  }

  bool _hasNoResults(SearchState state) {
    return state.results.isEmpty;
  }
}

/// Lista de resultados de la búsqueda
class _ResultsList extends StatelessWidget {
  final List<Event> results;
  final Search notifier;

  const _ResultsList({required this.results, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ResultTile(event: results[index]);
      },
    );
  }
}

/// Input field para la búsqueda
class SearchInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String query;

  const SearchInputField({
    super.key,
    required this.onChanged,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      autofocus: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Type Author, Title or Room...',
        prefixIcon: Icon(AppIcons.search, color: colors.primary),
        filled: true,
        fillColor: colors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(AppIcons.close),
                onPressed: () => onChanged(''),
              )
            : null,
      ),
    );
  }
}

/// Helper para mostrar cuando no hay resultados
class SearchHelper extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SearchHelper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 64,
                    color: colors.primary.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tile para mostrar un resultado de la búsqueda
class ResultTile extends ConsumerWidget {
  final Event event;

  const ResultTile({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final roomsIndex = ref.watch(allRoomsIndexProvider).value ?? {};
    final roomName = roomsIndex[event.roomId]?.name.resolve('en') ?? 'No room';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer.withValues(alpha: 0.2),
        child: Icon(AppIcons.event, color: colors.primary, size: 20),
      ),
      title: Text(
        event.title.resolve('en'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(roomName),
      onTap: () => Navigator.pop(context),
    );
  }
}
