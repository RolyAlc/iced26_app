import 'package:flutter/material.dart';

/// Par (icono, color) reutilizable para resolver el estilo visual de cualquier
/// tipo enumerado — EventType, CategoryType, etc.
class IconColorStyle {
  const IconColorStyle(this.icon, this.color);
  final IconData icon;
  final Color color;
}
