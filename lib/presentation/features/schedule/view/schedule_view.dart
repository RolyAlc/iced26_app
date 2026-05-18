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

const double _kEmptyStateIconSize = 48.0;

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

    final slot = isMySchedule
        ? _buildMyScheduleSlot(context, theme)
        : _ContentSlot.scrollable(
            _buildPaddedContent(context, const ScheduleTimelineBody()),
          );

    // AppPage único — su estado (_headerHeight) persiste al cambiar de tab
    // y al transicionar entre fillChild y children, evitando saltos de layout.
    return AppPage(
      header: ScheduleHeader(
        tabController: _tabController,
        categories: widget.state.categories,
        sections: widget.state.sections,
      ),
      fillChild: slot.fillChild,
      children: slot.children,
    );
  }

  _ContentSlot _buildMyScheduleSlot(BuildContext context, ThemeData theme) {
    final asyncItems = ref.watch(myScheduleGroupedProvider);

    if (asyncItems.isLoading) {
      return const _ContentSlot.fill(
        Center(child: CircularProgressIndicator()),
      );
    }
    if (asyncItems.hasError) {
      return _ContentSlot.fill(_buildMyScheduleError(theme));
    }

    final items = asyncItems.value ?? const [];
    if (items.isEmpty) {
      return _ContentSlot.fill(_buildMyScheduleEmpty(theme));
    }
    return _ContentSlot.scrollable(
      _buildPaddedContent(context, MyScheduleContent(items: items)),
    );
  }

  Widget _buildMyScheduleError(ThemeData theme) {
    return Center(
      child: AppEmptyState(
        illustration: Icon(
          AppIcons.error,
          size: _kEmptyStateIconSize,
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
  }

  Widget _buildMyScheduleEmpty(ThemeData theme) {
    return Center(
      child: AppEmptyState(
        illustration: Icon(
          AppIcons.bookmarkOff,
          size: _kEmptyStateIconSize,
          color: theme.colorScheme.outlineVariant,
        ),
        title: AppStrings.myScheduleNothingSavedTitle,
        message: AppStrings.myScheduleNothingSavedMessage,
      ),
    );
  }

  List<Widget> _buildPaddedContent(BuildContext context, Widget child) {
    return [
      const SizedBox(height: AppSpacing.m),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppLayout.horizontalPadding(context),
        ),
        child: child,
      ),
    ];
  }
}

/// Slot de contenido para AppPage.
///
/// `.fill` — un solo widget que ocupa todo el espacio disponible (loading, error, empty).
/// `.scrollable` — lista de children que se añaden al scroll de AppPage (contenido real).
class _ContentSlot {
  const _ContentSlot.fill(Widget child)
    : fillChild = child,
      children = const [];

  _ContentSlot.scrollable(List<Widget> items)
    : fillChild = null,
      children = items;

  final Widget? fillChild;
  final List<Widget> children;
}
