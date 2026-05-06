import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_provider.g.dart';

/// Estado del modo de tema, light, dark o system.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _kKey = 'theme_mode';

  /// Inicializa el estado del modo de tema guardado en [SharedPreferences].
  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _parse(prefs.getString(_kKey));
  }

  /// Cambia el modo de tema y lo guarda en [SharedPreferences].
  Future<void> setMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, _serialize(mode));
    state = AsyncData(mode);
  }

  /// Convierte una cadena en un [ThemeMode].
  static ThemeMode _parse(String? value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  /// Convierte un [ThemeMode] en una cadena.
  static String _serialize(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
