import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/widgets/app_skeleton.dart';

/// Un contenedor para secciones de contenido con márgenes consistentes.
class AppSection extends StatelessWidget {
  static const double defaultVerticalPadding = AppSpacing.m;

  final String? title;
  final Widget? trailing;
  final Widget child;
  final bool edgeToEdge;
  final double topPadding;
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

    return dataChild;
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
    final hasHeader = title != null || trailing != null;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasHeader) ...[
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
            const SizedBox(height: AppSpacing.sm),
          ],
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
