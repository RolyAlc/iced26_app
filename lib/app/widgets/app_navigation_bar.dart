import 'package:flutter/material.dart';
import 'package:iced26/app/navigation_constants.dart';
import 'package:iced26/app/viewmodel/app_navigation_viewmodel.dart';

/// Barra de navegación principal.
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key, required this.viewModel});

  final AppNavigationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final destination = mainNavigationItems.map((item) {
      return NavigationDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(item.selectedIcon, color: Colors.white),
        label: item.label,
      );
    }).toList();
    return NavigationBar(
      selectedIndex: viewModel.currentIndex,
      onDestinationSelected: (int index) {
        viewModel.setIndex(index);
      },
      destinations: destination,
    );
  }
}
