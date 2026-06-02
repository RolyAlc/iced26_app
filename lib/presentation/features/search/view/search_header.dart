import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/view/search_filter_bar.dart';
import 'package:iced26/presentation/features/search/view/search_input_field.dart';

/// Cabecera de la búsqueda.
class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.notifier,
    required this.controller,
    required this.filtersExpanded,
    required this.onToggleFilters,
    this.onSubmitted,
  });
  final Search notifier;
  final TextEditingController controller;
  final bool filtersExpanded;
  final VoidCallback onToggleFilters;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    if (isLandscape) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: AppSpacing.s),
              icon: const Icon(AppIcons.arrowBack),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: SearchInputField(
                controller: controller,
                onChanged: notifier.performSearch,
                onSubmitted: onSubmitted,
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            _CompactFilterButton(
              isExpanded: filtersExpanded,
              onToggle: onToggleFilters,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
          ),
          child: Row(
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: AppSpacing.s),
                icon: const Icon(AppIcons.arrowBack),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: SearchInputField(
                  controller: controller,
                  onChanged: notifier.performSearch,
                  onSubmitted: onSubmitted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        FilterBar(
          notifier: notifier,
          isExpanded: filtersExpanded,
          onToggle: onToggleFilters,
        ),
      ],
    );
  }
}

class _CompactFilterButton extends ConsumerWidget {
  const _CompactFilterButton({
    required this.isExpanded,
    required this.onToggle,
  });
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(
      searchProvider.select((s) => s.filters.isActive),
    );
    final colors = Theme.of(context).colorScheme;

    return Badge(
      isLabelVisible: isActive,
      smallSize: 8,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: isActive
              ? colors.primaryContainer
              : colors.surfaceContainerHighest,
          foregroundColor: isActive
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        ),
        icon: const Icon(AppIcons.filter),
        onPressed: () {
          FocusScope.of(context).unfocus();
          onToggle();
        },
      ),
    );
  }
}
