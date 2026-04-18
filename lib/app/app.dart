import 'package:flutter/material.dart';

import 'package:iced26/app/app_shell.dart';
import 'package:iced26/app/theme/app_theme.dart';
import 'package:iced26/core/data/app_data_repository.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/app/widgets/loading_screen.dart';
import 'package:iced26/app/widgets/error_screen.dart';

void main() {
  // Inyección de dependencias: Creamos el repositorio en lugar de MyApp.
  final repository = AppDataRepository();

  runApp(MyApp(repository: repository));
}

/// Representa el estado de configuración inicial tras cargar los datos.
class AppInitialConfig {
  final AppData data;
  final ThemeData theme;

  AppInitialConfig({required this.data, required this.theme});
}

/// MyApp solo se preocupa por construir la UI.
class MyApp extends StatelessWidget {
  final AppDataRepository repository;

  // Recibimos el repositorio por inyección de dependencias.
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final String appTitle = 'ICED26';

    return FutureBuilder<AppInitialConfig>(
      future: _prepareAppConfiguration(),
      builder: (context, snapshot) {
        // Extraemos la lógica de selección de tema y datos.
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          // Si no tenemos datos aún, usamos un tema por defecto para no romper el MaterialApp
          theme: snapshot.data?.theme ?? AppTheme.lightTheme,
          home: _buildHome(snapshot),
        );
      },
    );
  }

  /// Lógica de orquestación: Carga datos y prepara el tema.
  Future<AppInitialConfig> _prepareAppConfiguration() async {
    // Simulamos una carga de datos con un retraso para mostrar la pantalla de carga.
    await Future.delayed(const Duration(seconds: 2));

    final data = await repository.load();

    return AppInitialConfig(
      data: data,
      theme: AppTheme.fromThemeConfig(data.theme),
    );
  }

  /// Método de soporte para decidir qué mostrar en el 'home'.
  Widget _buildHome(AsyncSnapshot<AppInitialConfig> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingScreen();
    }

    if (snapshot.hasError) {
      return ErrorScreen(error: snapshot.error.toString());
    }

    if (snapshot.hasData) {
      return AppShell(data: snapshot.data!.data);
    }

    return const ErrorScreen(error: 'No se encontraron datos disponibles.');
  }
}
