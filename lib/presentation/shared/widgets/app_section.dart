import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/shared/widgets/app_skeleton.dart';

/// Un contenedor para secciones de contenido con márgenes consistentes.
class AppSection extends StatelessWidget {
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
    final Widget resolvedChild = _resolveChild(
      isLoading: isLoading,
      hasData: hasData,
      dataChild: dataChild,
      loadingChild: loadingChild,
      emptyChild: emptyChild,
    );

    return AppSection(
      key: key,
      title: title,
      trailing: trailing,
      edgeToEdge: edgeToEdge,
      topPadding: topPadding,
      bottomPadding: bottomPadding,
      child: resolvedChild,
    );
  }
  const AppSection({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.edgeToEdge = false,
    this.topPadding = defaultVerticalPadding,
    this.bottomPadding = defaultVerticalPadding,
  });
  // Declarados antes de los constructores porque se usan como valores por defecto.
  static const double defaultVerticalPadding = AppSpacing.m;
  static const double _kTitleLetterSpacing = -0.5;

  final String? title;
  final Widget? trailing;
  final Widget child;
  final bool edgeToEdge;
  final double topPadding;
  final double bottomPadding;

  static Widget _resolveChild({
    required bool isLoading,
    required bool hasData,
    required Widget dataChild,
    Widget? loadingChild,
    Widget? emptyChild,
  }) {
    if (isLoading) {
      return loadingChild ?? _defaultSectionSkeleton();
    }

    if (!hasData && emptyChild != null) {
      return emptyChild;
    }

    // Fallthrough intencional: si no hay datos pero no se proporcionó emptyChild,
    // el dataChild es responsable de mostrar su propio estado vacío.
    return dataChild;
  }

  /// Skeleton por defecto para secciones.
  static Widget _defaultSectionSkeleton() {
    return const AppSkeleton(height: 132, textLines: 2);
  }

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || trailing != null;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: _kTitleLetterSpacing,
                        ),
                      ),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (edgeToEdge)
            child
          else
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppLayout.horizontalPadding(context),
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
