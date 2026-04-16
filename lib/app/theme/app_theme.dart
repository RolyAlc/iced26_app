import 'package:flutter/material.dart';
import 'package:iced26/domain/entities/app_data.dart';
// TODO: Extraer del JSON y aplicar en el tema.

// Colores personalizados para la app
class AppColors {
  static const Color navBackground = Color(0xFFF1F8E9);
  static const Color navIndicator = Color(0xFF7DA097);
}

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    searchBarTheme: _buildSearchBarTheme(
      ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    searchViewTheme: _buildSearchViewTheme(
      ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  );

  /// Creamos el tema usando los colores del JSON.
  static ThemeData fromAppData(AppData data) {
    final colors = data.theme.colors;
    final primary = _hexToColor(colors['primary']) ?? Colors.blue;
    final secondary = _hexToColor(colors['secondary']);

    // Usamos el color principal como base del esquema.
    var scheme = ColorScheme.fromSeed(seedColor: primary);
    if (secondary != null) {
      scheme = scheme.copyWith(secondary: secondary);
    }

    // Aplicamos el esquema al tema Material 3.
    // TODO: Pasar a M3 expression
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      searchBarTheme: _buildSearchBarTheme(scheme),
      searchViewTheme: _buildSearchViewTheme(scheme),
    );
  }
}

Color? _hexToColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;

  final cleaned = hex.replaceAll('#', '');
  final value = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
  final intValue = int.tryParse(value, radix: 16);

  if (intValue == null) return null;

  return Color(intValue);
}

// Personalización de la barra de búsqueda para que se integre
// con el diseño moderno de la app.
SearchBarThemeData _buildSearchBarTheme(ColorScheme colorScheme) {
  return SearchBarThemeData(
    elevation: const WidgetStatePropertyAll(0),
    backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    side: WidgetStatePropertyAll(
      BorderSide(color: colorScheme.outlineVariant, width: 1.2),
    ),
    textStyle: WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
    ),
    hintStyle: WidgetStatePropertyAll(
      TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
    ),
  );
}

// Personalización de la vista expandida de búsqueda para que se sienta
// como una "capa" moderna que se desliza desde abajo.
SearchViewThemeData _buildSearchViewTheme(ColorScheme colorScheme) {
  return SearchViewThemeData(
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
  );
}
