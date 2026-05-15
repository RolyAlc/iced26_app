import 'package:flutter/material.dart';

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
  });
  final Search notifier;
  final TextEditingController controller;
  final bool filtersExpanded;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(AppIcons.arrowBack),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: SearchInputField(
                controller: controller,
                onChanged: notifier.performSearch,
              ),
            ),
          ],
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
