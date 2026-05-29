import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// Aplica flags de debug globales. Solo tiene efecto en modo debug.
class AppConfig {
  static void applyDebugFlags() {
    // Debug flags para desarrollo.
    if (kDebugMode) {
      debugPaintSizeEnabled = false;
    }
  }
}
