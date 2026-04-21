/// Espaciado utilizado en la aplicación basado en 8px.
class AppSpacing {
  static const double xs = 4.0; // 4px
  static const double s = 8.0; // 8px
  static const double sm = 12.0; // 12px
  static const double m = 16.0; // 16px
  static const double l = 24.0; // 24px
  static const double xl = 32.0; // 32px
}

/// Constantes de layout del motor de página.
class AppLayout {
  /// Altura inicial del header pinned hasta la primera medición real.
  static const double pageHeaderFallbackHeight = 142.0;

  /// Espacio bajo el contenido si la nav aún no reportó altura.
  static const double navBarClearanceFallback = 120.0;
}

/// Constantes de opacidad para los elementos de la aplicación.
class AppOpacity {
  static const double placeholder = 0.75;
}

/// Constantes de radio para los elementos de la aplicación.
class AppRadius {
  /// Para elementos pequeños o internos.
  static const double s = 12.0;

  /// Radio estándar para tarjetas (Card).
  static const double m = 20.0;

  /// Para elementos muy redondeados o contenedores grandes (Buscador, Nav bar).
  static const double l = 32.0;
}
