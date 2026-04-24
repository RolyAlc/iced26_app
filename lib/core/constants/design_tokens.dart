/// Duraciones estándar de animación.
class AppDuration {
  /// Transiciones rápidas: hover, feedback táctil, cambios inline.
  static const fast = Duration(milliseconds: 200);

  /// Transiciones estándar: navegación, expansión de elementos.
  static const medium = Duration(milliseconds: 300);

  /// Entradas de sección/página: fade-in escalonado.
  static const entrance = Duration(milliseconds: 600);
}

/// Niveles de elevación (sombra) usados en la app.
class AppElevation {
  /// Sin sombra — estilo M3 flat para cards y superficies.
  static const double none = 0;

  /// Elevación leve — search header flotante sobre el contenido.
  static const double low = 2;
}

/// Tamaños de texto que escapan del TextTheme M3.
class AppTextSize {
  /// Etiquetas de chip muy compactas (EventStatusChip, EventCard badge).
  static const double chip = 10.0;
}

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

  /// Fallback para headers reducidos (solo search bar).
  static const double searchBarHeaderFallbackHeight = 70.0;

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

  /// Radio estándar para tarjetas internas.
  static const double m = 20.0;

  /// Contenedores grandes: cards M3, bottom sheets (M3 extra-large shape token).
  static const double container = 28.0;

  /// Para elementos muy redondeados (Buscador, Nav bar).
  static const double l = 32.0;
}
