import 'package:flutter/material.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Secciones principales de la app.
enum AppFeature { home, schedule, search, diary, settings }

/// Define una pestaña de navegación principal.
class NavigationItem {
  final AppFeature feature;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.feature,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  bool get isAction => feature == AppFeature.search;
}

/// Lista de pestañas de navegación principales.
const List<NavigationItem> mainNavigationItems = [
  NavigationItem(
    feature: AppFeature.home,
    icon: AppIcons.homeOff,
    selectedIcon: AppIcons.homeOn,
    label: 'Home',
  ),
  NavigationItem(
    feature: AppFeature.schedule,
    icon: AppIcons.scheduleOff,
    selectedIcon: AppIcons.scheduleOn,
    label: 'Schedule',
  ),
  NavigationItem(
    feature: AppFeature.search,
    icon: AppIcons.searchOff,
    selectedIcon: AppIcons.searchOn,
    label: 'Search',
  ),
  NavigationItem(
    feature: AppFeature.diary,
    icon: AppIcons.diaryOff,
    selectedIcon: AppIcons.diaryOn,
    label: 'Diary',
  ),
  NavigationItem(
    feature: AppFeature.settings,
    icon: AppIcons.settingsOff,
    selectedIcon: AppIcons.settingsOn,
    label: 'Settings',
  ),
];
