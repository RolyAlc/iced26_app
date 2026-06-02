import 'package:flutter/material.dart';
import 'package:iced26/l10n/app_localizations.dart';

/// Devuelve la etiqueta localizada de [mode].
String themeModeLabel(ThemeMode mode, AppLocalizations l10n) {
  return switch (mode) {
    ThemeMode.light => l10n.settingsThemeLight,
    ThemeMode.system => l10n.settingsThemeSystem,
    ThemeMode.dark => l10n.settingsThemeDark,
  };
}
