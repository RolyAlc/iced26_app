import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';

const double _selectedItemBackgroundOpacity = 0.1;
const double _shadowOpacity = 0.08;
const double _shadowBlurRadius = 12.0;
const double _shadowOffsetY = 4.0;

/// Bottom navigation bar principal con navegación por features.
class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFeature = ref.watch(navigationProvider);
    final notifier = ref.read(navigationProvider.notifier);
    final searchNotifier = ref.read(searchProvider.notifier);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final hasDiaryBadge = ref.watch(hasDiaryNoteForTodayProvider);

    return UIMetricsReporter(
      onReportNavBar: (size) => size.height,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppLayout.horizontalPadding(context),
          right: AppLayout.horizontalPadding(context),
          top: AppSpacing.l,
          bottom: AppLayout.navBarBottomClearance + bottomInset,
        ),
        child: _NavContainer(
          height: AppLayout.navBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final item in mainNavigationItems)
                _NavigationItem(
                  label: item.label,
                  icon: item.feature == AppFeature.diary && hasDiaryBadge
                      ? item.selectedIcon
                      : item.icon,
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

/// Widget contenedor del bottom navigation bar que aplica estilo visual.
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
            color: AppOverlayColors.shadowBase.withValues(
              alpha: _shadowOpacity,
            ),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffsetY),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Widget que representa un único item del bottom navigation bar.
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

  Widget _buildIcon(Color activeColor, Color inactiveColor) {
    return AnimatedSwitcher(
      duration: AppDuration.fast,
      child: Icon(
        isSelected ? selectedIcon : icon,
        // ValueKey explícito — AnimatedSwitcher necesita keys distintas
        // para identificar los hijos y animar la transición correctamente.
        key: ValueKey(isSelected),
        color: isSelected ? activeColor : inactiveColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: AnimatedContainer(
        duration: AppDuration.medium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.m,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: _selectedItemBackgroundOpacity)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: _buildIcon(activeColor, inactiveColor),
      ),
    );
  }
}
