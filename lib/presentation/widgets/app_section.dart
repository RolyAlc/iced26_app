import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/widgets/app_skeleton.dart';

/// Un contenedor para secciones de contenido con márgenes consistentes.
class AppSection extends StatelessWidget {
  /// Valor por defecto para los paddings verticales (ritmo estándar).
  static const double defaultVerticalPadding = AppSpacing.m;

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
    this.topPadding = defaultVerticalPadding,
    this.bottomPadding = defaultVerticalPadding,
  });

  /// Sección con **un solo** cuerpo según prioridad: `isLoading` → sin datos con
  /// `emptyChild` → `dataChild`.
  factory AppSection.resolved({
    Key? key,
    String? title,
    Widget? trailing,
    bool edgeToEdge = false,
    double topPadding = defaultVerticalPadding,
    double bottomPadding = defaultVerticalPadding,
    bool isLoading = false,
    Widget? loadingChild,
    required bool hasData,
    required Widget dataChild,
    Widget? emptyChild,
  }) {
    final Widget body;
    if (isLoading) {
      body = loadingChild ?? _defaultSectionSkeleton();
    } else if (!hasData && emptyChild != null) {
      body = emptyChild;
    } else {
      body = dataChild;
    }
    return AppSection(
      key: key,
      title: title,
      trailing: trailing,
      edgeToEdge: edgeToEdge,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      child: body,
    );
  }

  /// Skeleton por defecto para secciones.
  static Widget _defaultSectionSkeleton() {
    return const AppSkeleton(
      height: 132,
      textLines: 2,
      imagePlaceholders: 1,
      spacing: AppSpacing.sm,
    );
  }

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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
            ),
          if (title != null || trailing != null)
            const SizedBox(height: AppSpacing.sm),
          if (edgeToEdge)
            child
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: child,
            ),
        ],
      ),
    );
  }
}
