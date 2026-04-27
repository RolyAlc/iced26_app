/// Design Tokens - Fuente de verdad para constantes visuales.
/// Guía detallada en: docs/design_system.md
library;

/// Animaciones (AppDuration)
class AppDuration {
  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 300);
  static const entrance = Duration(milliseconds: 600);
}

/// Elevación (AppElevation)
class AppElevation {
  static const double none = 0;
  static const double low = 2;
}

/// Tipografía (AppTextSize)
class AppTextSize {
  static const double chip = 12.0;
}

/// Espaciados (AppSpacing)
class AppSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double sm = 12.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
}

/// Layout (AppLayout)
class AppLayout {
  static const double pageHeaderFallbackHeight = 142.0;
  static const double searchBarHeaderFallbackHeight = 70.0;
  static const double navBarClearanceFallback = 120.0;
}

/// Opacidad (AppOpacity)
class AppOpacity {
  static const double placeholder = 0.75;
}

/// Radios (AppRadius)
class AppRadius {
  static const double s = 12.0;
  static const double m = 20.0;
  static const double container = 28.0;
  static const double l = 32.0;
}
