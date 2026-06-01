import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/app_shell.dart';
import 'package:iced26/presentation/app/state/locale_provider.dart';
import 'package:iced26/presentation/app/state/text_size_provider.dart';
import 'package:iced26/presentation/app/state/theme_mode_provider.dart';
import 'package:iced26/presentation/app/state/theme_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/theme/app_theme.dart';
import 'package:iced26/presentation/shared/widgets/loading_screen.dart';

/// Widget raíz de la aplicación. Permite gestionar el estado inicial de la aplicación,
/// como el tema, el tamaño de la fuente y el idioma,
/// así como el arranque de la aplicación.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(bootstrapProvider);
    final themeAsync = ref.watch(appThemeStateProvider);

    final isReady = bootstrapAsync.hasValue && themeAsync.hasValue;
    final hasError = bootstrapAsync.hasError || themeAsync.hasError;

    final themeModeAsync = ref.watch(themeModeProvider);
    final textSizeAsync = ref.watch(textSizeProvider);
    final localeAsync = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeAsync.value,
      theme: themeAsync.value ?? AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      highContrastTheme: AppTheme.highContrastTheme,
      highContrastDarkTheme: AppTheme.highContrastDarkTheme,
      themeMode: themeModeAsync.value ?? ThemeMode.system,
      themeAnimationDuration: AppDuration.medium,
      themeAnimationCurve: Curves.easeInOut,
      builder: (context, child) {
        final pref = textSizeAsync.value ?? TextSizePreference.medium;
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(pref.scaleFactor)),
          child: child!,
        );
      },
      home: _buildHome(isReady: isReady, hasError: hasError),
    );
  }

  static Widget _buildHome({required bool isReady, required bool hasError}) {
    if (hasError) {
      return const _StartupErrorScreen();
    }
    if (isReady) {
      return const AppShell();
    }
    return const LoadingScreen();
  }
}

/// Pantalla de error que se muestra si el arranque de la aplicación falla.
class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.error,
              size: AppIconSize.errorStartup,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(l10n.startupErrorTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s),
            Text(
              l10n.startupErrorMessage,
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
