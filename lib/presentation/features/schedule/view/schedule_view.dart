import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/parallel_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';
import 'package:iced26/presentation/widgets/app_page.dart';

/// Vista principal del schedule.
class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleStateAsync = ref.watch(scheduleViewModelProvider);

    return AppAsyncValueWidget(
      asyncValue: scheduleStateAsync,
      data: (state) => _ScheduleContent(state: state),
    );
  }
}

/// Contenido principal del schedule.
class _ScheduleContent extends ConsumerWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = _ScheduleUiState.fromRef(ref, state);

    return DefaultTabController(
      length: state.sections.length,
      initialIndex: uiState.safeDayIndex,
      child: AppPage(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        header: _ScheduleHeader.fromState(
          state: state,
          uiState: uiState,
          ref: ref,
        ),
        children: [
          const SizedBox(height: AppSpacing.m),
          _ScheduleBody(uiState: uiState),
        ],
      ),
    );
  }
}

/// Estado derivado de UI.
class _ScheduleUiState {
  _ScheduleUiState({
    required this.selectedDayIndex,
    required this.selectedCategory,
    required this.showFavorites,
    required this.visibleItems,
    required this.sectionsLength,
  });

  final int selectedDayIndex;
  final EventType? selectedCategory;
  final bool showFavorites;
  final List<ScheduleItem> visibleItems;
  final int sectionsLength;

  int get safeDayIndex {
    if (sectionsLength == 0) {
      return 0;
    }
    return selectedDayIndex.clamp(0, sectionsLength - 1);
  }

  static _ScheduleUiState fromRef(WidgetRef ref, ScheduleState state) {
    return _ScheduleUiState(
      selectedDayIndex: ref.watch(selectedDayIndexProvider),
      selectedCategory: ref.watch(selectedScheduleCategoryProvider),
      showFavorites: ref.watch(showOnlyFavoritesProvider),
      visibleItems: ref.watch(visibleItemsProvider),
      sectionsLength: state.sections.length,
    );
  }
}

/// Cuerpo del schedule.
class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({required this.uiState});

  final _ScheduleUiState uiState;

  @override
  Widget build(BuildContext context) {
    if (uiState.showFavorites && uiState.visibleItems.isEmpty) {
      return const _EmptyFavorites();
    }

    return Column(
      children: uiState.visibleItems.map(_ScheduleItemBuilder.build).toList(),
    );
  }
}

/// Builder de items.
class _ScheduleItemBuilder {
  static Widget build(ScheduleItem item) {
    return switch (item) {
      SingleEventItem(:final event) => EventCard(event: event),
      ParallelGroupItem() => ParallelBlock(group: item),
      DaySeparatorItem(:final label, :final date) => _DaySeparator(
        label: label,
        date: date,
      ),
    };
  }
}

/// Separador de días.
class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label, required this.date});

  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l, bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            DateHelper.formatShortDate(date),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header refactorizado.
class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelect,
    required this.sections,
    required this.onDaySelect,
    required this.showFavorites,
    required this.onFavoritesToggle,
  });

  final List<EventType> categories;
  final EventType? selectedCategory;
  final ValueChanged<EventType?> onCategorySelect;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelect;
  final bool showFavorites;
  final VoidCallback onFavoritesToggle;

  static Widget fromState({
    required ScheduleState state,
    required _ScheduleUiState uiState,
    required WidgetRef ref,
  }) {
    return _ScheduleHeader(
      categories: state.categories,
      selectedCategory: uiState.selectedCategory,
      onCategorySelect: (cat) =>
          ref.read(selectedScheduleCategoryProvider.notifier).state = cat,
      sections: state.sections,
      onDaySelect: (index) =>
          ref.read(selectedDayIndexProvider.notifier).state = index,
      showFavorites: uiState.showFavorites,
      onFavoritesToggle: () =>
          ref.read(showOnlyFavoritesProvider.notifier).update((v) => !v),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered = selectedCategory != null || showFavorites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: Text(
            'Schedule',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (sections.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: AnimatedOpacity(
              opacity: isFiltered ? 0.35 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: isFiltered,
                child: TabBar(
                  onTap: onDaySelect,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.zero,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                  unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  tabs: sections
                      .map((s) => Tab(text: DateHelper.formatShortDate(s.date)))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
        if (categories.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          ScheduleCategoryFilterBar(
            categories: categories,
            selected: selectedCategory,
            onSelect: onCategorySelect,
            isFavoritesMode: showFavorites,
            onFavoritesTap: onFavoritesToggle,
          ),
        ],
      ],
    );
  }
}

/// Empty state
class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'No saved sessions yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap the bookmark on any session to save it',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
