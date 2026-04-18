import 'package:flutter/material.dart';

import 'package:iced26/app/viewmodel/app_navigation_viewmodel.dart';
import 'package:iced26/app/widgets/app_navigation_bar.dart';
import 'package:iced26/features/home/view/home_view.dart';

/// Shell principal de la aplicación que maneja la navegación entre pantallas.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

/// Estado de la shell principal.
class _AppShellState extends State<AppShell> {
  late final AppNavigationViewModel _navigationViewModel;

  /// Inicializa el estado de la shell principal.
  @override
  void initState() {
    super.initState();
    _navigationViewModel = AppNavigationViewModel();
  }

  /// Libera los recursos del estado de la shell principal.
  @override
  void dispose() {
    _navigationViewModel.dispose();
    super.dispose();
  }

  /// Construye el shell principal.
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _navigationViewModel,
      builder: (context, _) {
        return Scaffold(
          body: _buildBody(),
          bottomNavigationBar: AppNavigationBar(
            viewModel: _navigationViewModel,
          ),
        );
      },
    );
  }

  /// Construye el cuerpo de la shell principal.
  Widget _buildBody() {
    return IndexedStack(
      index: _navigationViewModel.currentIndex,
      children: [
        const HomeView(),
        const Center(child: Text('Schedule (Próximamente)')),
        const Center(child: Text('Search (Próximamente)')),
        const Center(child: Text('Diary (Próximamente)')),
        const Center(child: Text('Settings (Próximamente)')),
      ],
    );
  }
}
