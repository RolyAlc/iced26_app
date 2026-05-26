/// Design Tokens - Fuente de verdad para constantes visuales.
/// Guía detallada en: docs/design_system.md
library;

import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/note_color.dart';

/// fast → micro-interacciones (ripples, snackbars). entrance → transiciones de pantalla completa.
class AppDuration {
  static const fast = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 300);
  static const entrance = Duration(milliseconds: 600);
}

/// M3 usa color tonal para jerarquía visual — la sombra se reserva solo para elementos flotantes.
class AppElevation {
  static const double none = 0;
  static const double low = 2;
}

/// Tamaños puntuales fuera de textTheme (chips, badges). El resto de tipografía usa theme.textTheme.
class AppTextSize {
  static const double chip = 12.0;
}

/// Overrides que complementan textTheme. 0.8 sigue la guía M3 para labels en caps (labelSmall/Medium bold).
class AppTextStyle {
  // Espaciado de letras para etiquetas de sección en mayúsculas (labelSmall/labelMedium bold).
  static const double labelLetterSpacing = 0.8;
}

class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double sm = 12.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
}

class AppLayout {
  static const double pageHeaderFallbackHeight = 142.0;
  static const double searchBarHeaderFallbackHeight = 70.0;
  static const double navBarHeight = 72.0;
  // Gap entre la píldora de la navBar y la barra de gestos del sistema.
  static const double navBarBottomClearance = 4.0;
  // navBarHeight(72) + topPad(24) + bottomClearance(4) + margen de seguridad(20) ≈ 120.
  static const double navBarClearanceFallback = 120.0;
  // Ancho máximo del área de contenido. En pantallas más anchas (tablet, web)
  // el contenido se centra horizontalmente respetando este límite.
  static const double maxContentWidth = 750.0;
  // Margen horizontal adaptativo entre el borde del dispositivo y el contenido.
  // Se adapta al ancho de pantalla: móvil pequeño → s, móvil → m, tablet/web → l.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return AppSpacing.s;
    if (width < 600) return AppSpacing.m;
    return AppSpacing.l;
  }
}

/// Opacidades semánticas — evita literales dispersos. placeholder = contenido pendiente de carga.
class AppOpacity {
  static const double placeholder = 0.75;
}

/// container (28) para cards/sheets M3; l (32) para modales y drawers de mayor prominencia.
class AppRadius {
  static const double s = 12.0;
  static const double m = 20.0;
  static const double container = 28.0;
  static const double l = 32.0;
  static const double full = 100.0;
}

/// Colores fijos (AppOverlayColors)
/// No siguen el tema — se usan sobre imágenes o superficies opacas donde
/// el contraste está garantizado por el contexto visual, no por el tema.
class AppOverlayColors {
  // Gradiente inferior del hero de noticias.
  static const Color heroGradientStart = Color(0x00000000); // transparent
  static const Color heroGradientEnd = Color(0xDD000000); // black 87%
  // Texto blanco fijo sobre imagen (el gradiente/fondo garantiza la legibilidad).
  static const Color heroText = Color(0xFFFFFFFF); // white
  static const Color heroTextSecondary = Color(0xB3FFFFFF); // white 70%
  // Texto secundario sobre cards con imagen de fondo.
  static const Color cardTextSecondary = Color(0xCCFFFFFF); // white 80%
  // Extremo oscuro del degradado en speaker cards (negro 80% — más suave que heroGradientEnd).
  static const Color speakerCardGradientEnd = Color(0xCC000000); // black 80%
  // Fondo semitransparente del badge de tiempo sobre imagen.
  static const Color timeBadgeBackground = Color(0x66000000); // black 40%
  // Scrim (barrera) de bottom sheets y modales.
  static const Color barrierScrim = Color(0x8A000000); // black 54%
  // Color base para sombras con opacidad dinámica.
  static const Color shadowBase = Color(0xFF000000); // black
}

class AppCategoryColors {
  static const workshop = Color(0xFFFF8F00); // Amber 800 — cálido/artesanal
  static const paper = Color(0xFF1976D2); // Blue 700  — académico clásico
  static const poster = Color(0xFF388E3C); // Green 700 — visual/exposición
  static const talks = Color(0xFFD32F2F); // Red 700   — energía/oratoria
  static const symposia = Color(0xFF7B1FA2); // Purple 700 — formal/académico
  static const fallback = Color(0xFF00796B); // Teal 700  — otros
}

/// Color fijo de cada etiqueta de nota. No sigue el ColorScheme.
/// Switch exhaustivo: añadir un NoteColor sin actualizar aquí produce error de compilación.
extension NoteColorX on NoteColor {
  Color get color => switch (this) {
    NoteColor.insight => const Color(0xFF2196F3), // Blue 500
    NoteColor.action => const Color(0xFF4CAF50), // Green 500
    NoteColor.question => const Color(0xFFFFB300), // Amber 600
    NoteColor.highlight => const Color(0xFF9C27B0), // Purple 500
  };
}
