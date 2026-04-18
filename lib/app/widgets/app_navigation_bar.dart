import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iced26/app/navigation_constants.dart';
import 'package:iced26/app/viewmodel/app_navigation_viewmodel.dart';

/// Datos de los destinos de la barra de navegación.
class NavItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Widget que representa la barra de navegación.
class AppNavigationBar extends StatelessWidget {
  final AppNavigationViewModel viewModel;

  const AppNavigationBar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    //TODO: Cargar padding desde constantes
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: _GlassContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildNavItems(),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems() {
    return mainNavigationItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return _NavigationItem(
        label: item.label,
        icon: item.icon,
        selectedIcon: item.selectedIcon,
        isSelected: viewModel.currentIndex == index,
        onTap: () => viewModel.setIndex(index),
      );
    }).toList();
  }
}

/// Widget para el efecto Glassmorphism.
class _GlassContainer extends StatelessWidget {
  final Widget child;
  const _GlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.8,
            ),
            borderRadius: BorderRadius.circular(32),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
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
              duration: const Duration(milliseconds: 200),
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
    );
  }
}
