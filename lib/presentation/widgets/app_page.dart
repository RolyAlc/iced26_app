import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';

/// Un contenedor maestro que gestiona el layout de una página completa.
class AppPage extends ConsumerStatefulWidget {
  final List<Widget> children;
  final Widget? header;
  final bool useSlivers;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? headerFallbackHeight;

  const AppPage({
    super.key,
    required this.children,
    this.header,
    this.useSlivers = true,
    this.padding,
    this.backgroundColor,
    this.headerFallbackHeight,
  });

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  /// Medición del header de **esta** página (no va al provider global: evita conflictos con [IndexedStack]).
  // TODO: Mejorar medición del header.
  double _headerHeight = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.of(context).padding.top;
    final double bottomInset = widget.useSlivers
        ? 0.0
        : ref.watch(uiMetricsProvider).navBarHeight;

    return NotificationListener<UIMetricsNotification>(
      onNotification: (notification) {
        final h = notification.headerHeight;
        if (h != null && (h - _headerHeight).abs() > 0.5) {
          setState(() => _headerHeight = h);
        }
        return false;
      },
      child: Material(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        child: widget.useSlivers
            ? _buildSliverLayout(context, topInset)
            : _buildNormalLayout(context, bottomInset),
      ),
    );
  }

  /// Layout normal para cuando no se usan slivers.
  Widget _buildNormalLayout(BuildContext context, double bottomInset) {
    return Column(
      children: [
        widget.header ?? const SizedBox.shrink(),
        Expanded(
          child: ListView(
            primary: false,
            padding: (widget.padding ?? EdgeInsets.zero).copyWith(
              bottom: bottomInset,
            ),
            children: widget.children,
          ),
        ),
      ],
    );
  }

  /// Layout con slivers para cuando se usa [CustomScrollView].
  Widget _buildSliverLayout(BuildContext context, double topInset) {
    final double effectiveHeaderHeight = _headerHeight > 0
        ? _headerHeight
        : (widget.headerFallbackHeight ?? AppLayout.pageHeaderFallbackHeight);

    return CustomScrollView(
      primary: false,
      clipBehavior: Clip.hardEdge,
      slivers: [
        if (widget.header != null)
          SliverPersistentHeader(
            pinned: true,
            delegate: _AppPageHeaderDelegate(
              child: UIMetricsReporter(
                onReportHeader: (size) => size.height,
                child: widget.header!,
              ),
              height: effectiveHeaderHeight,
              topPadding: topInset,
              bottomPadding: AppSpacing.s,
              backgroundColor:
                  widget.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
            ),
          ),

        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildListDelegate(widget.children),
          ),
        ),

        const SliverClearanceSpacer(),
      ],
    );
  }
}

/// Delegado para [SliverPersistentHeader] que envuelve el header de [AppPage].
class _AppPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final double topPadding;
  final double bottomPadding;
  final Color backgroundColor;

  _AppPageHeaderDelegate({
    required this.child,
    required this.height,
    required this.topPadding,
    required this.bottomPadding,
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
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: AppSpacing.l,
        right: AppSpacing.l,
      ),
      alignment: Alignment.topLeft,
      child: child,
    );
  }

  /// Altura máxima del header.
  @override
  double get maxExtent => height + topPadding + bottomPadding;

  /// Altura mínima del header.
  @override
  double get minExtent => height + topPadding + bottomPadding;

  /// Indica si el header debe reconstruirse.
  @override
  bool shouldRebuild(covariant _AppPageHeaderDelegate oldDelegate) =>
      child != oldDelegate.child ||
      height != oldDelegate.height ||
      topPadding != oldDelegate.topPadding ||
      bottomPadding != oldDelegate.bottomPadding ||
      backgroundColor != oldDelegate.backgroundColor;
}
