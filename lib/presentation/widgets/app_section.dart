import 'package:flutter/material.dart';

/// Un contenedor para secciones de contenido con márgenes consistentes.
///
/// Se encarga de:
/// 1. Aplicar el padding horizontal centralizado de la app (20px).
/// 2. Gestionar el título de la sección de forma tipográficamente coherente.
/// 3. Ofrecer una estructura clara para el contenido.
class AppSection extends StatelessWidget {
  /// Título opcional de la sección.
  final String? title;

  /// Widget que se muestra a la derecha del título (ej. "Ver más").
  final Widget? trailing;

  /// El contenido principal de la sección.
  final Widget child;

  /// Si es true, la sección NO aplica padding horizontal al contenido.
  /// Útil para carruseles horizontales que deben ir de borde a borde.
  final bool edgeToEdge;

  /// Espaciado vertical antes de la sección.
  final double topPadding;

  /// Espaciado vertical después de la sección.
  final double bottomPadding;

  const AppSection({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.edgeToEdge = false,
    this.topPadding = 16,
    this.bottomPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || trailing != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
            ),

          if (title != null || trailing != null) const SizedBox(height: 12),

          if (edgeToEdge)
            child
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: child,
            ),
        ],
      ),
    );
  }
}
