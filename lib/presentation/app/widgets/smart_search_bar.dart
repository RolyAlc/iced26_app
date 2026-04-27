import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/search/search_modal.dart';

/// Barra de búsqueda inteligente.
class SmartSearchBar extends ConsumerWidget {
  final Search searchNotifier;

  const SmartSearchBar({super.key, required this.searchNotifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFilterActive = _getIsFilterActive(ref);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: () => _handleOpenSearch(context),
        child: _SearchBarVisualContainer(
          isFilterActive: isFilterActive,
          onFilterTap: () => _handleOpenFilters(context),
        ),
      ),
    );
  }

  /// Obtiene si hay filtros activos desde el provider
  bool _getIsFilterActive(WidgetRef ref) {
    return ref.watch(searchProvider.select((s) => s.filters.isActive));
  }

  /// Maneja apertura estándar del buscador
  void _handleOpenSearch(BuildContext context) {
    open(context, searchNotifier);
  }

  /// Maneja apertura con filtros expandidos
  void _handleOpenFilters(BuildContext context) {
    open(context, searchNotifier, expandFilters: true);
  }

  static BorderRadius get _borderRadius {
    return BorderRadius.circular(AppRadius.l);
  }

  /// Abre el modal de búsqueda
  static void open(
    BuildContext context,
    Search notifier, {
    bool expandFilters = false,
  }) {
    AppBottomSheet.show(
      context: context,
      title: 'Search ICED26',
      isFullHeight: true,
      scrollable: false,
      child: _buildSearchModal(notifier, expandFilters),
    );
  }

  /// Construye el contenido del modal
  static Widget _buildSearchModal(Search notifier, bool expandFilters) {
    return SearchModalBody(
      notifier: notifier,
      initiallyExpandedFilters: expandFilters,
    );
  }
}

/// Contenedor visual de la barra de búsqueda.
class _SearchBarVisualContainer extends StatelessWidget {
  final bool isFilterActive;
  final VoidCallback onFilterTap;

  const _SearchBarVisualContainer({
    required this.isFilterActive,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);

    return Container(
      height: _height,
      padding: _padding,
      decoration: _buildDecoration(colors),
      child: Row(
        children: [
          _buildSearchIcon(colors),
          _buildSpacing(),
          _buildPlaceholderText(),
          _buildFilterButton(colors),
        ],
      ),
    );
  }

  ColorScheme _getColors(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static const double _height = 56;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.m,
  );

  Widget _buildSearchIcon(ColorScheme colors) {
    return Icon(Icons.search_rounded, color: colors.primary);
  }

  Widget _buildSpacing() {
    return const SizedBox(width: AppSpacing.sm);
  }

  Widget _buildPlaceholderText() {
    return const Expanded(child: Text('Search sessions, authors, rooms...'));
  }

  Widget _buildFilterButton(ColorScheme colors) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onFilterTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: _FilterIcon(isActive: isFilterActive, colors: colors),
      ),
    );
  }

  BoxDecoration _buildDecoration(ColorScheme colors) {
    return BoxDecoration(
      color: _buildBackgroundColor(colors),
      borderRadius: BorderRadius.circular(AppRadius.l),
      border: Border.all(color: colors.outlineVariant, width: 1.2),
    );
  }

  Color _buildBackgroundColor(ColorScheme colors) {
    return Color.alphaBlend(
      colors.primary.withValues(alpha: 0.08),
      colors.surface,
    );
  }
}

/// Icono de filtros con indicador de estado.
class _FilterIcon extends StatelessWidget {
  final bool isActive;
  final ColorScheme colors;

  const _FilterIcon({required this.isActive, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [_buildIcon(), if (isActive) _buildActiveDot()],
    );
  }

  Widget _buildIcon() {
    return Icon(
      Icons.tune_rounded,
      color: isActive ? colors.primary : colors.secondary,
    );
  }

  Widget _buildActiveDot() {
    return Positioned(
      top: -3,
      right: -3,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
