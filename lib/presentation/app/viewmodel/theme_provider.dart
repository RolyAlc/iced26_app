import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/presentation/app/theme/app_theme.dart';
import 'package:iced26/di/core_providers.dart';

part 'theme_provider.g.dart';

/// Provee el ThemeData de la aplicación de forma reactiva desde la DB.
/// Devuelve ThemeData.light() si no hay nada en la DB.
@riverpod
class AppThemeState extends _$AppThemeState {
  @override
  Future<ThemeData> build() async {
    final configRepo = ref.watch(configRepositoryProvider);
    final result = await configRepo.getThemeConfig();
    return switch (result) {
      Success(data: final config) =>
        config != null ? AppTheme.fromThemeConfig(config) : AppTheme.lightTheme,
      Failure(message: final msg) => throw msg,
    };
  }

  /// Permite refrescar el tema manualmente
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final configRepo = ref.read(configRepositoryProvider);
      final result = await configRepo.getThemeConfig();

      return switch (result) {
        Success(data: final config) =>
          config != null
              ? AppTheme.fromThemeConfig(config)
              : AppTheme.lightTheme,
        Failure(message: final msg) => throw msg,
      };
    });
  }
}
