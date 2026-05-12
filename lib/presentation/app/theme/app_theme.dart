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
  static const Color secondary = Color(0xFF927363);
  static const Color accent = Color(0xFFF88E5C);
  static const Color surface = Color(0xFFFCFCFC);
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
      // Surface fija en light para evitar que fromSeed calcule un tinte verdoso.
      surface: brightness == Brightness.light ? AppBrandColors.surface : null,
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

  // Sin seed de brightness, GoogleFonts genera texto oscuro en dark mode.
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
      backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.5),
      labelStyle: textTheme.labelLarge?.copyWith(
        color: scheme.onSecondaryContainer,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
