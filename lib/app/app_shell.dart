import 'package:flutter/material.dart';

import 'package:iced26/app/viewmodel/app_navigation_viewmodel.dart';
import 'package:iced26/app/widgets/app_navigation_bar.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/features/home/view/home_view.dart';

/// Shell principal de la aplicación que maneja la navegación entre pantallas.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.data});

  final AppData data;

  @override
  State<AppShell> createState() => _AppShellState();
}

/// El estado del 'AppShell' se encarga de manejar la navegación y el estado de la barra inferior.
class _AppShellState extends State<AppShell> {
  late final AppNavigationViewModel _navigationViewModel;

  @override
  void initState() {
    super.initState();
    _navigationViewModel = AppNavigationViewModel();
  }

  @override
  void dispose() {
    _navigationViewModel.dispose();
    super.dispose();
  }

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

  Widget _buildBody() {
    return IndexedStack(
      index: _navigationViewModel.currentIndex,
      children: [
        HomeView(data: widget.data),
        const Center(child: Text('Schedule (Próximamente)')),
        const Center(child: Text('Search (Próximamente)')),
        const Center(child: Text('Diary (Próximamente)')),
        const Center(child: Text('Settings (Próximamente)')),
      ],
    );
  }
}
