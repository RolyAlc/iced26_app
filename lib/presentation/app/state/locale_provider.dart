import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// Idioma activo de la app.
/// `null` = Flutter resuelve: idioma del dispositivo si está soportado,
/// o inglés como fallback.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const _kKey = 'app_locale';

  /// Idiomas disponibles para el usuario.
  /// `null` representa el idioma del sistema (automático).
  /// Este es el único lugar donde se declaran los idiomas soportados.
  static const List<Locale?> supportedLocales = [
    null,
    Locale('en'),
    Locale('es'),
  ];

  @override
  Future<Locale?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _parse(prefs.getString(_kKey));
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kKey);
    } else {
      await prefs.setString(_kKey, locale.languageCode);
    }
    state = AsyncData(locale);
  }

  // Convierte el string guardado en Locale. null = sistema.
  // Busca en supportedLocales para no duplicar la lista de idiomas.
  static Locale? _parse(String? value) {
    for (final locale in supportedLocales) {
      if (locale?.languageCode == value) {
        return locale;
      }
    }
    return null;
  }
}
