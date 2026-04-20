import 'package:flutter/material.dart';

/// Clase que define los elementos de navegación y sus propiedades.
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Espacio vertical necesario para que el contenido no quede oculto tras la Nav Bar flotante.
const double kAppBottomNavigationBarHeight = 0.0;

/// La lista maestra de navegación.
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
