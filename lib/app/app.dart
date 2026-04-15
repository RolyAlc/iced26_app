import 'package:flutter/material.dart';
import 'package:iced26/app/app_shell.dart';
import 'package:iced26/app/theme/app_theme.dart';
import 'package:iced26/core/data/app_data_repository.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/app/widgets/loading_screen.dart';
import 'package:iced26/app/widgets/error_screen.dart';

void main() => runApp(const MyApp());

/// La clase principal de la aplicación que se encarga de cargar los datos y mostrar la pantalla adecuada.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AppDataRepository();
    const String appTitle = 'ICED26'; // TODO: Extraer del fichero JSON

    return FutureBuilder<AppData>(
      future: _loadDataWithSplash(repository),
      builder: (context, snapshot) {
        final Widget screen;
        ThemeData currentTheme = AppTheme.lightTheme;

        if (snapshot.connectionState == ConnectionState.waiting) {
          screen = const LoadingScreen();
        } else if (snapshot.hasError) {
          screen = ErrorScreen(error: snapshot.error.toString());
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          currentTheme = AppTheme.fromAppData(data);
          screen = AppShell(data: data);
        } else {
          screen = const ErrorScreen(
            error: 'No se encontraron datos disponibles.',
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appTitle,
          theme: currentTheme,
          home: screen,
        );
      },
    );
  }

  Future<AppData> _loadDataWithSplash(AppDataRepository repository) async {
    await Future.delayed(const Duration(seconds: 2));
    return repository.load();
  }
}
