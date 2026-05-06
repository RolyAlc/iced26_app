import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Extensión para convertir texto a color.
/// Returns: El color en formato ARGB.
extension ColorParser on String {
  Color? toColor() {
    final hex = replaceFirst('#', '');
    final buffer = StringBuffer();
    final value = int.tryParse(buffer.toString(), radix: 16);

    if (hex.length != 6 && hex.length != 8) {
      return null;
    }

    if (hex.length == 6) {
      buffer.write('ff');
    }
    buffer.write(hex);

    if (value == null) {
      return null;
    }

    return Color(value);
  }
}

// TODO: Mirar si en 'app_data.json' existe la posibilidad de sacar
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
  /// Tema claro.
  static ThemeData get lightTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
  );

  /// Tema oscuro.
  static ThemeData get darkTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
    brightness: Brightness.dark,
  );

  /// Crea un [ThemeData] a partir de una [ThemeConfig].
  static ThemeData fromThemeConfig(ThemeConfig config) {
    return _generate(
      primary: config.colors['primary']?.toColor() ?? AppBrandColors.primary,
      secondary:
          config.colors['secondary']?.toColor() ?? AppBrandColors.secondary,
      accent: config.colors['accent']?.toColor() ?? AppBrandColors.accent,
    );
  }

  /// Genera el tema.
  static ThemeData _generate({
    required Color primary,
    required Color secondary,
    required Color accent,
    Brightness brightness = Brightness.light,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      secondary: secondary,
      tertiary: accent,
      surface: brightness == Brightness.light ? AppBrandColors.surface : null,
      brightness: brightness,
    );

    final textTheme = _buildTextTheme(brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surfaceContainerLow,
      cardTheme: _buildCardTheme(scheme),
      chipTheme: _buildChipTheme(scheme, textTheme),
      searchBarTheme: _buildSearchBarTheme(scheme),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // TODO: Mirar si en 'styles.json' existe la posibilidad de sacar y mapear
  static TextTheme _buildTextTheme({Brightness brightness = Brightness.light}) {
    final seed = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final base = GoogleFonts.latoTextTheme(seed);
    final display = GoogleFonts.outfitTextTheme(seed);
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
