import 'package:flutter/material.dart';

/// Define una pestaña de navegación principal.
///
/// [isAction] marca items que disparan una acción en lugar de navegar
/// (p.ej. abrir el buscador). Nunca aparecen como "seleccionados".
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isAction;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.isAction = false,
  });
}

/// Lista de pestañas de navegación principales.
const List<NavigationItem> mainNavigationItems = [
  NavigationItem(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_filled,
    label: 'Home',
  ),
  NavigationItem(
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month,
    label: 'Schedule',
  ),
  NavigationItem(
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
    label: 'Search',
    isAction: true,
  ),
  NavigationItem(
    icon: Icons.bookmark_outline,
    selectedIcon: Icons.bookmark,
    label: 'Diary',
  ),
  NavigationItem(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Settings',
  ),
];
