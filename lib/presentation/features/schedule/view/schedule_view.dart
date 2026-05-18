import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/my_schedule/view/my_schedule_view.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/my_schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_header.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_timeline_body.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

// TODO: Revisar if y else anidados

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

/// Orquestador del schedule. Gestiona el TabController y decide
/// si mostrar el timeline o MySchedule.
class _ScheduleContent extends ConsumerStatefulWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  ConsumerState<_ScheduleContent> createState() => _ScheduleContentState();
}

/// Estado del schedule content.
class _ScheduleContentState extends ConsumerState<_ScheduleContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.state.sections.length,
      vsync: this,
      initialIndex: ref.read(safeDayIndexProvider),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMySchedule =
        ref.watch(scheduleTopTabProvider) == ScheduleTab.mySchedule;

    // Sincroniza el tab cuando el día cambia externamente al TabBar
    ref.listen(safeDayIndexProvider, (_, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    Widget? fillChild;
    List<Widget> children = const [];

    if (isMySchedule) {
      final asyncItems = ref.watch(myScheduleGroupedProvider);

      if (asyncItems.isLoading) {
        fillChild = const Center(child: CircularProgressIndicator());
      } else if (asyncItems.hasError) {
        fillChild = Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.error,
              size: 48,
              color: theme.colorScheme.error,
            ),
            title: AppStrings.myScheduleErrorTitle,
            message: AppStrings.genericErrorMessage,
            actionButton: TextButton(
              onPressed: () => ref.invalidate(myScheduleItemsProvider),
              child: const Text(AppStrings.retry),
            ),
          ),
        );
      } else {
        final items = asyncItems.value ?? const [];
        if (items.isEmpty) {
          fillChild = Center(
            child: AppEmptyState(
              illustration: Icon(
                AppIcons.bookmarkOff,
                size: 48,
                color: theme.colorScheme.outlineVariant,
              ),
              title: AppStrings.myScheduleNothingSavedTitle,
              message: AppStrings.myScheduleNothingSavedMessage,
            ),
          );
        } else {
          children = [
            const SizedBox(height: AppSpacing.m),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
              ),
              child: MyScheduleContent(items: items),
            ),
          ];
        }
      }
    } else {
      children = [
        const SizedBox(height: AppSpacing.m),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
          ),
          child: const ScheduleTimelineBody(),
        ),
      ];
    }

    // AppPage único — su estado (_headerHeight) persiste al cambiar de tab
    // y al transicionar entre fillChild y children, evitando saltos de layout.
    return AppPage(
      header: ScheduleHeader(
        tabController: _tabController,
        categories: widget.state.categories,
        sections: widget.state.sections,
      ),
      fillChild: fillChild,
      children: children,
    );
  }
}
