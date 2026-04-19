import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/presentation/app/theme/app_theme.dart';
import 'package:iced26/di/core_providers.dart';

part 'theme_provider.g.dart';

/// Provee el ThemeData de la aplicación de forma reactiva desde la DB.
/// Devuelve ThemeData.light() si no hay nada en la DB.
@riverpod
class AppThemeState extends _$AppThemeState {
  @override
  Future<ThemeData> build() async {
    final repository = ref.watch(appRepositoryProvider);
    final config = await repository.getThemeConfig();

    // Tema por defecto si no hay nada en la DB.
    if (config == null) {
      return AppTheme.lightTheme;
    }

    return AppTheme.fromThemeConfig(config);
  }

  /// Permite refrescar el tema manualmente
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(appRepositoryProvider);
      final config = await repository.getThemeConfig();
      return config != null
          ? AppTheme.fromThemeConfig(config)
          : AppTheme.lightTheme;
    });
  }
}
