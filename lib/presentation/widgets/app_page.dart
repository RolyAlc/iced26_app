import 'package:flutter/material.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';

/// Un contenedor maestro que gestiona el layout de una página completa.
///
/// Se encarga de:
/// 1. Gestionar el scroll (Slivers o Normal).
/// 2. Inyectar automáticamente el padding inferior para la Navigation Bar.
/// 3. Ofrecer un punto de entrada para headers pegajosos (sticky).
class AppPage extends StatelessWidget {
  /// Lista de secciones o widgets que componen la página.
  final List<Widget> children;

  /// Header opcional que se mantiene fijo en la parte superior.
  final Widget? header;

  /// Altura fija del header. Si es null, se intenta calcular.
  final double? headerHeight;

  /// Si es true, usa [CustomScrollView] con Slivers. Ideal para efectos premium.
  final bool useSlivers;

  /// Padding interno del scroll.
  final EdgeInsets? padding;

  /// Color de fondo de la página.
  final Color? backgroundColor;

  const AppPage({
    super.key,
    required this.children,
    this.header,
    this.headerHeight,
    this.useSlivers = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el padding inferior automáticamente.
    final bottomInset =
        MediaQuery.of(context).padding.bottom + kAppBottomNavigationBarHeight;
    final topInset = MediaQuery.of(context).padding.top;

    if (!useSlivers) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            header ?? const SizedBox.shrink(),
            Expanded(
              child: ListView(
                padding: (padding ?? EdgeInsets.zero).copyWith(
                  bottom: bottomInset,
                ),
                children: children,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          if (header != null)
            SliverPersistentHeader(
              pinned: true,
              delegate: _AppPageHeaderDelegate(
                child: header!,
                height: headerHeight ?? 80, // Valor por defecto sensato
                topPadding: topInset,
                backgroundColor:
                    backgroundColor ?? Theme.of(context).colorScheme.surface,
              ),
            ),

          SliverPadding(
            padding: (padding ?? EdgeInsets.zero).copyWith(bottom: bottomInset),
            sliver: SliverList(delegate: SliverChildListDelegate(children)),
          ),
        ],
      ),
    );
  }
}

class _AppPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final double topPadding;
  final Color backgroundColor;

  _AppPageHeaderDelegate({
    required this.child,
    required this.height,
    required this.topPadding,
    required this.backgroundColor,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(top: topPadding),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => height + topPadding;

  @override
  double get minExtent => height + topPadding;

  @override
  bool shouldRebuild(covariant _AppPageHeaderDelegate oldDelegate) =>
      child != oldDelegate.child ||
      height != oldDelegate.height ||
      topPadding != oldDelegate.topPadding ||
      backgroundColor != oldDelegate.backgroundColor;
}
