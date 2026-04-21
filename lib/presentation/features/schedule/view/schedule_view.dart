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

class _ScheduleContent extends ConsumerWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDayIndex = ref.watch(selectedDayIndexProvider);
    final selectedCategory = ref.watch(selectedScheduleCategoryProvider);

    final safeIndex = state.sections.isEmpty
        ? 0
        : selectedDayIndex.clamp(0, state.sections.length - 1);

    final daySection = state.sections.isEmpty
        ? null
        : state.sections[safeIndex];

    final visibleItems = daySection == null
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
        ),
        children: [
          const SizedBox(height: AppSpacing.m),
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

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelect,
    required this.sections,
    required this.onDaySelect,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelect;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelect;

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
          ),
        ],
      ],
    );
  }
}
