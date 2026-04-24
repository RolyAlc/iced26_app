import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/smart_search_bar.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

/// Widget que representa la barra de navegación.
class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  /// Altura del contenedor interno de la barra.
  static const double barHeight = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);
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
            children: _buildNavItems(
              context,
              currentIndex,
              notifier,
              searchNotifier,
            ),
          ),
        ),
      ),
    );
  }

  // Indice del tab Search en mainNavigationItems.
  static const int _searchIndex = 2;

  /// Construye la lista de items de la barra de navegación.
  List<Widget> _buildNavItems(
    BuildContext context,
    int currentIndex,
    Navigation notifier,
    Search searchNotifier,
  ) {
    return mainNavigationItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSearch = index == _searchIndex;

      return _NavigationItem(
        label: item.label,
        icon: item.icon,
        selectedIcon: item.selectedIcon,
        // Search nunca aparece como destino seleccionado — es una accion.
        isSelected: isSearch ? false : currentIndex == index,
        onTap: isSearch
            ? () => SmartSearchBar.open(context, searchNotifier)
            : () => notifier.setIndex(index),
      );
    }).toList();
  }
}

/// Widget para el efecto Glassmorphism.
class _GlassContainer extends StatelessWidget {
  final Widget child; // Widget envuelto por Glassmorphism.
  final double height;
  const _GlassContainer({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.8,
            ),
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Widget que representa un item de la barra de navegación.
class _NavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  /// Construye el item de la barra de navegación.
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
              ? activeColor.withValues(alpha: 0.1)
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
