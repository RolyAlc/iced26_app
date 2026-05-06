import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';
import 'package:iced26/presentation/widgets/app_page_header_delegate.dart';

/// Contenedor maestro que gestiona el layout de una página completa.
class AppPage extends StatefulWidget {
  final List<Widget> children;
  final Widget? header;
  final Widget? collapsedHeader;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? headerFallbackHeight;
  final double? collapsedHeaderFallbackHeight;

  const AppPage({
    super.key,
    required this.children,
    this.header,
    this.collapsedHeader,
    this.padding,
    this.backgroundColor,
    this.headerFallbackHeight,
    this.collapsedHeaderFallbackHeight,
  }) : assert(
         collapsedHeaderFallbackHeight == null || collapsedHeader != null,
         'collapsedHeaderFallbackHeight requires collapsedHeader',
       );

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  // TODO: Mejorar medición del header.
  double _headerHeight = 0;

  void _onHeaderHeightChanged(double newHeight) {
    if ((newHeight - _headerHeight).abs() > 0.5) {
      setState(() => _headerHeight = newHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    return NotificationListener<UIMetricsNotification>(
      onNotification: (notification) {
        final height = notification.headerHeight;
        if (height != null) _onHeaderHeightChanged(height);
        return false;
      },
      child: Material(color: bgColor, child: _buildSliverLayout(bgColor)),
    );
  }

  /// Construye el layout basado en slivers.
  Widget _buildSliverLayout(Color bgColor) {
    return CustomScrollView(
      primary: false,
      clipBehavior: Clip.hardEdge,
      slivers: [
        if (widget.header != null) _buildSliverHeader(bgColor),
        _buildSliverContent(),
        const SliverClearanceSpacer(),
      ],
    );
  }

  /// Construye el [SliverAppBar] con snap nativo y crossfade entre estados.
  Widget _buildSliverHeader(Color bgColor) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      expandedHeight: _resolveExpandedHeaderHeight() + AppSpacing.s,
      toolbarHeight: _resolveCollapsedHeaderHeight() + AppSpacing.s,
      flexibleSpace: AppPageFlexibleSpace(
        expandedChild: UIMetricsReporter(
          onReportHeader: (size) => size.height,
          child: widget.header!,
        ),
        collapsedChild: widget.collapsedHeader,
        bgColor: bgColor,
      ),
    );
  }

  /// Construye el sliver de contenido principal con padding aplicado.
  Widget _buildSliverContent() {
    return SliverPadding(
      padding: widget.padding ?? EdgeInsets.zero,
      sliver: SliverList.list(children: widget.children),
    );
  }

  /// Altura expandida del header: medida real → fallback prop → fallback global.
  double _resolveExpandedHeaderHeight() {
    if (_headerHeight > 0) {
      return _headerHeight;
    }
    return widget.headerFallbackHeight ?? AppLayout.pageHeaderFallbackHeight;
  }

  double _resolveCollapsedHeaderHeight() {
    return widget.collapsedHeaderFallbackHeight ??
        _resolveExpandedHeaderHeight();
  }
}
