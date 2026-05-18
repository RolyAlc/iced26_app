import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/search/view/search_filter_panel.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

/// Sección que contiene los filtros de búsqueda.
/// Muestra en tiempo real cuántos resultados hay mientras el usuario filtra.
class FiltersSection extends ConsumerWidget {
  const FiltersSection({
    super.key,
    required this.notifier,
    required this.onCollapse,
  });
  final Search notifier;
  final VoidCallback onCollapse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsCount = ref.watch(
      searchProvider.select((s) => s.results.length),
    );
    final filtersActive = ref.watch(
      searchProvider.select((s) => s.filters.isActive),
    );

    final buttonLabel = filtersActive
        ? AppStrings.searchShowResults(resultsCount)
        : AppStrings.searchDone;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(child: FilterPanel(notifier: notifier)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          child: AppButton(label: buttonLabel, onPressed: onCollapse),
        ),
      ],
    );
  }
}
