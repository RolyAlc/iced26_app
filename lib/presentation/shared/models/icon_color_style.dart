import 'package:flutter/material.dart';

/// Par (icono, color) reutilizable para resolver el estilo visual de cualquier
/// tipo enumerado — EventType, CategoryType, etc.
class IconColorStyle {
  final IconData icon;
  final Color color;

  const IconColorStyle(this.icon, this.color);
}
