import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

const double _selectedItemBackgroundOpacity = 0.1;
const double _shadowOpacity = 0.08;
const double _shadowBlurRadius = 12.0;

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  static const double barHeight = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeature = ref.watch(navigationProvider);
    final notifier = ref.read(navigationProvider.notifier);
    final searchNotifier = ref.read(searchProvider.notifier);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final today = DateTime.now();
    final notes = ref.watch(diaryNotesProvider).value ?? [];
    final hasDiaryBadge = notes.any((n) => DateUtils.isSameDay(n.date, today));

    return UIMetricsReporter(
      onReportNavBar: (size) => size.height,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.l,
          right: AppSpacing.l,
          top: AppSpacing.l,
          bottom: AppSpacing.s + bottomInset,
        ),
        child: _NavContainer(
          height: barHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in mainNavigationItems)
                _NavigationItem(
                  label: item.label,
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  isSelected: !item.isAction && currentFeature == item.feature,
                  showBadge: item.feature == AppFeature.diary && hasDiaryBadge,
                  onTap: item.isAction
                      ? () => SmartSearchBar.open(context, searchNotifier)
                      : () => notifier.select(item.feature),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavContainer extends StatelessWidget {
  const _NavContainer({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _shadowOpacity),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final bool showBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: AnimatedContainer(
        duration: AppDuration.medium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: _selectedItemBackgroundOpacity)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: AnimatedSize(
          duration: AppDuration.medium,
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge(
                isLabelVisible: showBadge,
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected
                      ? activeColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AnimatedSwitcher(
                duration: AppDuration.fast,
                child: isSelected
                    ? Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
