import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/parallel_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/widgets/app_page.dart';

/// Vista del schedule.
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

/// Contenido de la vista del schedule.
class _ScheduleContent extends ConsumerWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDayIndex = ref.watch(selectedDayIndexProvider);
    final selectedCategory = ref.watch(selectedScheduleCategoryProvider);
    final showFavorites = ref.watch(showOnlyFavoritesProvider);
    final favoriteIds = ref.watch(
      favoriteIdsProvider.select((ids) => ids.valueOrNull ?? <String>{}),
    );

    final safeIndex = state.sections.isEmpty
        ? 0
        : selectedDayIndex.clamp(0, state.sections.length - 1);

    final daySection = state.sections.isEmpty
        ? null
        : state.sections[safeIndex];

    // Filtro por categoría
    var visibleItems = daySection == null
        ? <ScheduleItem>[]
        : selectedCategory == null
        ? daySection.items
        : daySection.items
              .where(
                (item) => switch (item) {
                  SingleEventItem(:final event) =>
                    event.type == selectedCategory,
                  ParallelGroupItem(:final type) => type == selectedCategory,
                },
              )
              .toList();

    // Filtro por favoritos (se apila sobre el de categoría)
    if (showFavorites) {
      visibleItems = visibleItems
          .where(
            (item) => switch (item) {
              SingleEventItem(:final event) => favoriteIds.contains(event.id),
              // Muestra el grupo si al menos un evento está guardado
              ParallelGroupItem(:final events) => events.any(
                (e) => favoriteIds.contains(e.id),
              ),
            },
          )
          .toList();
    }

    return DefaultTabController(
      length: state.sections.length,
      initialIndex: safeIndex,
      child: AppPage(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        header: _ScheduleHeader(
          categories: state.categories,
          selectedCategory: selectedCategory,
          onCategorySelect: (cat) =>
              ref.read(selectedScheduleCategoryProvider.notifier).state = cat,
          sections: state.sections,
          onDaySelect: (index) =>
              ref.read(selectedDayIndexProvider.notifier).state = index,
          showFavorites: showFavorites,
          onFavoritesToggle: () =>
              ref.read(showOnlyFavoritesProvider.notifier).update((v) => !v),
        ),
        children: [
          const SizedBox(height: AppSpacing.m),
          if (showFavorites && visibleItems.isEmpty)
            _EmptyFavorites()
          else
            ...visibleItems.map(
              (item) => switch (item) {
                SingleEventItem(:final event) => EventCard(event: event),
                ParallelGroupItem() => ParallelBlock(group: item),
              },
            ),
        ],
      ),
    );
  }
}

/// Header de la vista del schedule.
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

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelect;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelect;
  final bool showFavorites;
  final VoidCallback onFavoritesToggle;

  String _tabLabel(String date) {
    final dt = DateTime.tryParse(date);
    if (dt == null) return date;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Schedule',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (sections.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          TabBar(
            onTap: onDaySelect,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            tabs: sections.map((s) => Tab(text: _tabLabel(s.date))).toList(),
          ),
        ],
        if (categories.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          ScheduleCategoryFilterBar(
            categories: categories,
            selected: selectedCategory,
            onSelect: onCategorySelect,
            showFavorites: showFavorites,
            onFavoritesToggle: onFavoritesToggle,
          ),
        ],
      ],
    );
  }
}

/// Mensaje que se muestra cuando no hay favoritos.
class _EmptyFavorites extends StatelessWidget {
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
