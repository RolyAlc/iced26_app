import 'package:flutter/material.dart';

/// Configuración de estilo para las tarjetas de categoría en la sección de categorías.
class CategoryStyleConfig {
  final IconData icon;
  final Color color;

  CategoryStyleConfig(this.icon, this.color);

  static CategoryStyleConfig fromName(String name) {
    final n = name.toLowerCase();
    if (n.contains('workshop')) {
      return CategoryStyleConfig(Icons.handyman, Colors.orange);
    }
    if (n.contains('paper')) {
      return CategoryStyleConfig(Icons.article, Colors.blue);
    }
    if (n.contains('poster')) {
      return CategoryStyleConfig(Icons.collections, Colors.green);
    }
    if (n.contains('talks')) {
      return CategoryStyleConfig(Icons.record_voice_over, Colors.red);
    }
    if (n.contains('symposia')) {
      return CategoryStyleConfig(Icons.forum, Colors.purple);
    }
    return CategoryStyleConfig(Icons.grid_view, Colors.teal);
  }
}
