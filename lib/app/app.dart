import 'package:flutter/material.dart';
import 'package:iced26/app/theme/app_theme.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/data/app_data_repository.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/features/home/view/home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AppDataRepository();

    // Cargamos el JSON antes de construir la app principal.
    return FutureBuilder<AppData>(
      // Damos un pequeño tiempo para que el splash sea visible.
      future: _loadWithDelay(repository),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'ICED26',
            theme: AppTheme.lightTheme,
            home: const _LoadingScreen(),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            title: 'ICED26',
            theme: AppTheme.lightTheme,
            home: _ErrorScreen(error: snapshot.error.toString()),
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return MaterialApp(
            title: 'ICED26',
            theme: AppTheme.lightTheme,
            home: const _ErrorScreen(error: 'No se recibió data.'),
          );
        }

        // Aplicamos el tema real desde el JSON.
        return MaterialApp(
          title: 'ICED26',
          theme: AppTheme.fromAppData(data),
          home: HomeView(data: data),
        );
      },
    );
  }
}

Future<AppData> _loadWithDelay(AppDataRepository repository) async {
  // Esperamos un poco para ver el logo en el splash.
  await Future.delayed(const Duration(seconds: 2));
  return repository.load();
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    // Mostramos el logo mientras llega el JSON.
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(Assets.logoIced26IconApp),
          width: 240,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    // Mostramos un mensaje claro si falla la carga.
    return Scaffold(body: Center(child: Text('Error al cargar JSON: $error')));
  }
}
