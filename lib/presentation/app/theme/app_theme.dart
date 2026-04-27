import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Extensión para convertir texto a color.
extension ColorParser on String {
  Color? toColor() {
    final hex = replaceFirst('#', '');
    if (hex.length != 6 && hex.length != 8) {
      return null;
    }

    final buffer = StringBuffer();
    if (hex.length == 6) buffer.write('ff');
    buffer.write(hex);

    final value = int.tryParse(buffer.toString(), radix: 16);
    if (value == null) {
      return null;
    }

    return Color(value);
  }
}

// TODO: M3 expression soportar colores deribados de los colores Brand (como flat, contrastes, etc...)?¿
// TODO: Exportar desde el JSON.
/// Centraliza los colores constantes de la marca.
class AppBrandColors {
  static const Color primary = Color(0xFF75A49C);
  static const Color secondary = Color(0xFF927363);
  static const Color accent = Color(0xFFF88E5C);
  static const Color surface = Color(0xFFFCFCFC);
  static const Color navIndicator = Color(0xFF7DA097);
}

/// Clase que construye el tema.
/// Usa el método [_generate] para generar el tema desde los colores de la marca.
class AppTheme {
  /// Tema por defecto (Light)
  static ThemeData get lightTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
  );

  /// Construye el tema desde la entidad de configuración.
  static ThemeData fromThemeConfig(ThemeConfig config) {
    return _generate(
      primary: config.colors['primary']?.toColor() ?? AppBrandColors.primary,
      secondary:
          config.colors['secondary']?.toColor() ?? AppBrandColors.secondary,
      accent: config.colors['accent']?.toColor() ?? AppBrandColors.accent,
    );
  }

  /// Genera el tema desde los colores de la marca.
  static ThemeData _generate({
    required Color primary,
    required Color secondary,
    required Color accent,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      secondary: secondary,
      tertiary: accent,
      surface: AppBrandColors.surface,
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surfaceContainerLow,
      cardTheme: _buildCardTheme(scheme),
      chipTheme: _buildChipTheme(scheme, textTheme),
      searchBarTheme: _buildSearchBarTheme(scheme),
      visualDensity:
          VisualDensity.adaptivePlatformDensity, // Added for consistent spacing
    );
  }

  /// Genera el text theme.
  // Fuentes definidas en styles.json > typography: primary="Lato", secondary="Lato".
  // Outfit cubre los estilos de display (no incluido en el contrato).
  // Si cambia la fuente en el JSON, actualizar aquí también.
  static TextTheme _buildTextTheme() {
    final base = GoogleFonts.latoTextTheme();
    final display = GoogleFonts.outfitTextTheme();
    return base.copyWith(
      displayLarge: display.displayLarge,
      headlineMedium: display.headlineMedium,
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  /// Genera el card theme.
  static CardThemeData _buildCardTheme(ColorScheme scheme) {
    return CardThemeData(
      elevation: AppElevation.none,
      color: Color.alphaBlend(
        scheme.primary.withValues(alpha: 0.05),
        scheme.surface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.container),
      ),
    );
  }

  /// Genera el search bar theme.
  static SearchBarThemeData _buildSearchBarTheme(ColorScheme scheme) {
    return SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(AppElevation.none),
      backgroundColor: WidgetStatePropertyAll(
        Color.alphaBlend(
          scheme.primary.withValues(alpha: 0.08),
          scheme.surface,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
      ),
      side: WidgetStatePropertyAll(BorderSide(color: scheme.outlineVariant)),
    );
  }

  /// Genera el chip theme.
  static ChipThemeData _buildChipTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ChipThemeData(
      shape: const StadiumBorder(),
      backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      labelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSecondaryContainer,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
