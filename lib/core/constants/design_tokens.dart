/// Design Tokens - Fuente de verdad para constantes visuales.
/// Guía detallada en: docs/design_system.md
library;

import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/note_color.dart';

// TODO: Los comentarios moverlos a library

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
  static const double navBarHeight = 72.0;
  // Gap entre la píldora de la navBar y la barra de gestos del sistema.
  static const double navBarBottomClearance = 4.0;
  // navBarHeight(72) + topPad(24) + bottomClearance(4) + margen de seguridad(20) ≈ 120.
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
  static const double full = 100.0;
}

/// Colores de categorías (AppCategoryColors)
class AppCategoryColors {
  static const workshop = Color(0xFFFF8F00); // Amber 800 — cálido/artesanal
  static const paper = Color(0xFF1976D2); // Blue 700  — académico clásico
  static const poster = Color(0xFF388E3C); // Green 700 — visual/exposición
  static const talks = Color(0xFFD32F2F); // Red 700   — energía/oratoria
  static const symposia = Color(0xFF7B1FA2); // Purple 700 — formal/académico
  static const fallback = Color(0xFF00796B); // Teal 700  — otros
}

/// Colores de notas (Mood Tags)
class AppNoteColors {
  static const _colors = {
    NoteColor.focus: Color(0xFF2196F3), // Blue 500
    NoteColor.success: Color(0xFF4CAF50), // Green 500
    NoteColor.idea: Color(0xFFFFB300), // Amber 600
    NoteColor.mood: Color(0xFF9C27B0), // Purple 500
  };

  static const _labels = {
    NoteColor.focus: 'Focus',
    NoteColor.success: 'Success',
    NoteColor.idea: 'Idea',
    NoteColor.mood: 'Mood',
  };

  static Color colorOf(NoteColor color) {
    return _colors[color]!;
  }

  static String labelOf(NoteColor? color) {
    if (color == null) return 'None';
    return _labels[color]!;
  }
}
