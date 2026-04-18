import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/app/app_shell.dart';
import 'package:iced26/app/theme/app_theme.dart';
import 'package:iced26/app/widgets/loading_screen.dart';
import 'package:iced26/app/bootstrap_provider.dart';

/// Raíz de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  /// Construye la aplicación.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado del arranque.
    final bootstrapAsync = ref.watch(bootstrapProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICED26',
      // TODO: Migrar el tema a un Provider en la siguiente fase.
      theme: AppTheme.lightTheme,
      home: bootstrapAsync.when(
        data: (_) => const AppShell(),
        loading: () => const LoadingScreen(),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error crítico: $err'))),
      ),
    );
  }
}
