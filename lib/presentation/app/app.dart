import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/app_shell.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/theme/app_theme.dart';
import 'package:iced26/presentation/app/widgets/loading_screen.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/presentation/app/state/theme_provider.dart';

const _kAppTitle = 'ICED26';

/// Raíz de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);
    final themeAsync = ref.watch(appThemeStateProvider);

    final isReady = bootstrapAsync.hasValue && themeAsync.hasValue;
    final hasError = bootstrapAsync.hasError || themeAsync.hasError;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _kAppTitle,
      theme: themeAsync.value ?? AppTheme.lightTheme,
      home: switch ((isReady, hasError)) {
        (_, true) => const _StartupErrorScreen(),
        (true, _) => const AppShell(),
        _ => const LoadingScreen(),
      },
    );
  }
}

/// Pantalla de error que se muestra si el arranque de la aplicación falla.
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Could not start the app', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Try restarting the application',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
