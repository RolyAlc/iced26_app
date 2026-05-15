import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/search/view/search_filter_panel.dart';

/// Sección que contiene los filtros de búsqueda.
class FiltersSection extends StatelessWidget {
  const FiltersSection({
    super.key,
    required this.notifier,
    required this.onCollapse,
  });
  final Search notifier;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(child: FilterPanel(notifier: notifier)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onCollapse,
              child: const Text('Done'),
            ),
          ),
        ),
      ],
    );
  }
}
