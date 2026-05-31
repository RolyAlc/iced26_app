import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/theme_config.dart';

extension ColorParser on String {
  // Prefija 'ff' en hex de 6 chars para que Color() reciba ARGB completo.
  Color? toColor() {
    final hex = replaceFirst('#', '');
    if (hex.length != 6 && hex.length != 8) return null;

    final buffer = StringBuffer();
    if (hex.length == 6) buffer.write('ff');
    buffer.write(hex);

    final value = int.tryParse(buffer.toString(), radix: 16);
    if (value == null) return null;

    return Color(value);
  }
}

// Colores fijos de marca usados como semilla y fallback cuando el JSON no los sobreescribe.
class AppBrandColors {
  static const Color primary = Color(0xFF75A49C);
  static const Color secondary = Color(0xFF7C8A84);
  static const Color accent = Color(0xFFF88E5C);
  // Token cálido reservado para badges o detalles puntuales — no usar como secondary global.
  static const Color earth = Color(0xFF927363);

  // Light surfaces: gris azulado muy suave para evitar el blanco puro.
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFF8FAFC);
  static const Color lightSurfaceContainer = Color(0xFFF1F5F9);
  static const Color lightSurfaceContainerHigh = Color(0xFFEFF4F8);
  static const Color lightSurfaceContainerHighest = Color(0xFFE2E8F0);

  // Dark surfaces: neutros casi negros, sin llegar a negro puro.
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceContainerLowest = Color(0xFF0B0B0B);
  static const Color darkSurfaceContainerLow = Color(0xFF161616);
  static const Color darkSurfaceContainer = Color(0xFF1D1D1D);
  static const Color darkSurfaceContainerHigh = Color(0xFF242424);
  static const Color darkSurfaceContainerHighest = Color(0xFF2C2C2C);
}

class AppTheme {
  static ThemeData get lightTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
  );

  static ThemeData get darkTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
    brightness: Brightness.dark,
  );

  // contrastLevel 1.0 = WCAG AAA. El OS activa estos temas automáticamente
  // desde Accesibilidad — la app no necesita ningún control manual.
  static ThemeData get highContrastTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
    contrastLevel: 1.0,
  );

  static ThemeData get highContrastDarkTheme => _generate(
    primary: AppBrandColors.primary,
    secondary: AppBrandColors.secondary,
    accent: AppBrandColors.accent,
    brightness: Brightness.dark,
    contrastLevel: 1.0,
  );

  // Los colores del JSON sobreescriben los de marca; fallback si faltan claves.
  static ThemeData fromThemeConfig(ThemeConfig config) {
    return _generate(
      primary: config.colors['primary']?.toColor() ?? AppBrandColors.primary,
      secondary:
          config.colors['secondary']?.toColor() ?? AppBrandColors.secondary,
      accent: config.colors['accent']?.toColor() ?? AppBrandColors.accent,
    );
  }

  static ThemeData _generate({
    required Color primary,
    required Color secondary,
    required Color accent,
    Brightness brightness = Brightness.light,
    double contrastLevel = 0.0,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      secondary: secondary,
      tertiary: accent,
      // Surfaces fijas para evitar blanco puro, negro puro y tintes verdosos de fromSeed.
      surface: brightness == Brightness.light
          ? AppBrandColors.lightSurface
          : AppBrandColors.darkSurface,
      surfaceContainerLowest: brightness == Brightness.light
          ? AppBrandColors.lightSurfaceContainerLowest
          : AppBrandColors.darkSurfaceContainerLowest,
      surfaceContainerLow: brightness == Brightness.light
          ? AppBrandColors.lightSurfaceContainerLow
          : AppBrandColors.darkSurfaceContainerLow,
      surfaceContainer: brightness == Brightness.light
          ? AppBrandColors.lightSurfaceContainer
          : AppBrandColors.darkSurfaceContainer,
      surfaceContainerHigh: brightness == Brightness.light
          ? AppBrandColors.lightSurfaceContainerHigh
          : AppBrandColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: brightness == Brightness.light
          ? AppBrandColors.lightSurfaceContainerHighest
          : AppBrandColors.darkSurfaceContainerHighest,
      brightness: brightness,
      contrastLevel: contrastLevel,
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

  // Cambiar la tipografía global debería requerir tocar solo estas dos funciones.
  // Heading: títulos y jerarquía visual. Body: lectura, labels y controles.
  static TextTheme _headingFont(TextTheme seed) {
    return GoogleFonts.outfitTextTheme(seed);
  }

  static TextTheme _bodyFont(TextTheme seed) {
    return GoogleFonts.latoTextTheme(seed);
  }

  // Sin seed de brightness, GoogleFonts genera texto oscuro en dark mode.
  static TextTheme _buildTextTheme({Brightness brightness = Brightness.light}) {
    final seed = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final body = _bodyFont(seed);
    final heading = _headingFont(seed);
    return body.copyWith(
      displayLarge: heading.displayLarge,
      displayMedium: heading.displayMedium,
      displaySmall: heading.displaySmall,
      headlineLarge: heading.headlineLarge,
      headlineMedium: heading.headlineMedium,
      headlineSmall: heading.headlineSmall,
      titleLarge: heading.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      titleMedium: heading.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      titleSmall: heading.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  // Tinte sutil de primary sobre surface — evita fondo neutro sin color de marca.
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

  static ChipThemeData _buildChipTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ChipThemeData(
      shape: const StadiumBorder(),
      backgroundColor: scheme.surfaceContainerHigh,
      labelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
