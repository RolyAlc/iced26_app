import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';
import 'package:iced26/presentation/shared/widgets/smart_search_bar.dart';

const double _selectedItemBackgroundOpacity = 0.1;
const double _shadowOpacity = 0.08;
const double _shadowBlurRadius = 12.0;
const double _shadowOffsetY = 4.0;
const double _badgeDotSize = 8.0;

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

    final l10n = AppLocalizations.of(context)!;

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
          minHeight: AppLayout.navBarHeight,
          child: Row(
            children: [
              for (final item in mainNavigationItems)
                Expanded(
                  child: _NavigationItem(
                    label: _navLabel(item.feature, l10n),
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    isSelected:
                        !item.isAction && currentFeature == item.feature,
                    isAction: item.isAction,
                    showBadge:
                        item.feature == AppFeature.diary && hasDiaryBadge,
                    onTap: item.isAction
                        ? () => SmartSearchBar.open(context, searchNotifier)
                        : () => notifier.select(item.feature),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _navLabel(AppFeature feature, AppLocalizations l10n) {
  switch (feature) {
    case AppFeature.home:
      return l10n.navHome;
    case AppFeature.schedule:
      return l10n.navSchedule;
    case AppFeature.search:
      return l10n.navSearch;
    case AppFeature.diary:
      return l10n.navDiary;
    case AppFeature.settings:
      return l10n.navSettings;
  }
}

/// Widget contenedor del bottom navigation bar que aplica estilo visual.
class _NavContainer extends StatelessWidget {
  const _NavContainer({required this.child, required this.minHeight});

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.l),
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
///
/// El indicator (pill) envuelve solo el icono — patrón M3 estándar.
/// El label vive fuera del pill para no distorsionar su forma.
class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.isAction,
    required this.showBadge,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  // True cuando el item dispara una acción modal (ej. Search) en vez de navegar a una pestaña.
  final bool isAction;
  final bool showBadge;
  final VoidCallback onTap;

  Widget _buildIndicator(Color activeColor) {
    // Action items muestran siempre el icono filled — señalan disponibilidad, no selección.
    final iconData = isSelected || isAction ? selectedIcon : icon;

    return AnimatedContainer(
      duration: AppDuration.medium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        // Pill de selección — solo tabs, nunca actions.
        color: isSelected
            ? activeColor.withValues(alpha: _selectedItemBackgroundOpacity)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Badge(
        isLabelVisible: showBadge,
        smallSize: _badgeDotSize,
        child: AnimatedSwitcher(
          duration: AppDuration.fast,
          child: Icon(iconData, key: ValueKey(iconData)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurfaceVariant;

    // Action items usan onSurface (más visible que onSurfaceVariant) pero sin el color
    // de selección — comunican "disponible" sin fingir que son una pestaña activa.
    final itemColor = isSelected
        ? activeColor
        : isAction
        ? colorScheme.onSurface
        : inactiveColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: itemColor),
              child: _buildIndicator(activeColor),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: itemColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
