import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

const double _glassBackgroundOpacity = 0.8;
const double _glassBorderOpacity = 0.5;
const double _selectedItemBackgroundOpacity = 0.1;

/// Widget que representa la barra de navegación con efecto glassmorphism.
class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  static const double barHeight = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeature = ref.watch(navigationProvider);
    final notifier = ref.read(navigationProvider.notifier);
    final searchNotifier = ref.read(searchProvider.notifier);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return UIMetricsReporter(
      onReportNavBar: (size) => size.height,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.l,
          right: AppSpacing.l,
          top: AppSpacing.l,
          bottom: AppSpacing.l + bottomInset,
        ),
        child: _GlassContainer(
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

/// Contenedor con efecto glassmorphism.
class _GlassContainer extends StatelessWidget {
  const _GlassContainer({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _glassBackgroundOpacity,
            ),
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(
                alpha: _glassBorderOpacity,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Elemento de la barra de navegación.
class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
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
          horizontal: AppSpacing.m,
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
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? activeColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
              AnimatedSwitcher(
                duration: AppDuration.fast,
                child: isSelected
                    ? Text(
                        label,
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
