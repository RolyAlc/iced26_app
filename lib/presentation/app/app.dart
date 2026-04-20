import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/presentation/app/app_shell.dart';
import 'package:iced26/presentation/app/theme/app_theme.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/presentation/app/state/theme_provider.dart';

/// Raíz de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  final String titleApp = 'ICED26';

  /// Construye la aplicación.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado del arranque.
    final bootstrapAsync = ref.watch(bootstrapProvider);
    // Observamos el tema reactivo.
    final themeAsync = ref.watch(appThemeStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false, // banner de debug
      title: titleApp,
      theme: themeAsync.value ?? AppTheme.lightTheme, // Tema inicial
      home: bootstrapAsync.when(
        data: (_) => const AppShell(),
        loading: () => const LoadingScreen(),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error al inicializar: $err'))),
      ),
    );
  }
}
