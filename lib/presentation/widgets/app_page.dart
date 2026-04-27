import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/core/ui_engine/ui_metrics.dart';
import 'package:iced26/presentation/widgets/app_page_header_delegate.dart';

/// Contenedor maestro que gestiona el layout de una página completa.
class AppPage extends ConsumerStatefulWidget {
  final List<Widget> children;
  final Widget? header;
  final Widget? collapsedHeader;
  final bool useSlivers;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? headerFallbackHeight;
  final double? collapsedHeaderFallbackHeight;

  const AppPage({
    super.key,
    required this.children,
    this.header,
    this.collapsedHeader,
    this.useSlivers = true,
    this.padding,
    this.backgroundColor,
    this.headerFallbackHeight,
    this.collapsedHeaderFallbackHeight,
  });

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  /// Medición del header de **esta** página (local, no global: evita conflictos con [IndexedStack]).
  // TODO: Mejorar medición del header.
  double _headerHeight = 0;

  /// Color de fondo efectivo: prop del widget o color de superficie del tema.
  Color _resolveBackgroundColor(BuildContext context) =>
      widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

  /// Padding inferior: sólo aplica en modo normal (no sliver).
  double _resolveBottomInset() =>
      widget.useSlivers ? 0.0 : ref.watch(uiMetricsProvider).navBarHeight;

  /// Actualiza [_headerHeight] sólo si el cambio supera el umbral de 0.5 px.
  void _onHeaderHeightChanged(double newHeight) {
    if ((newHeight - _headerHeight).abs() > 0.5) {
      setState(() => _headerHeight = newHeight);
    }
  }

  /// Escucha [UIMetricsNotification] y delega el cambio a [_onHeaderHeightChanged].
  bool _handleMetricsNotification(UIMetricsNotification notification) {
    final height = notification.headerHeight;
    if (height != null) _onHeaderHeightChanged(height);
    return false; // No absorber la notificación.
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = _resolveBottomInset();
    final bgColor = _resolveBackgroundColor(context);

    return NotificationListener<UIMetricsNotification>(
      onNotification: _handleMetricsNotification,
      child: Material(
        color: bgColor,
        child: widget.useSlivers
            ? _buildSliverLayout(context, topInset, bgColor)
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
            padding: _resolveContentPadding(bottomInset),
            children: widget.children,
          ),
        ),
      ],
    );
  }

  /// Layout con slivers para cuando se usa [CustomScrollView].
  Widget _buildSliverLayout(
    BuildContext context,
    double topInset,
    Color bgColor,
  ) {
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
      sliver: SliverList(delegate: SliverChildListDelegate(widget.children)),
    );
  }

  /// Altura expandida del header: medida real → fallback prop → fallback global.
  double _resolveExpandedHeaderHeight() {
    if (_headerHeight > 0) {
      return _headerHeight;
    }
    return widget.headerFallbackHeight ?? AppLayout.pageHeaderFallbackHeight;
  }

  /// Altura colapsada del header: fallback prop → igual que la expandida.
  double _resolveCollapsedHeaderHeight() =>
      widget.collapsedHeaderFallbackHeight ?? _resolveExpandedHeaderHeight();

  /// Padding del contenido en modo normal, añadiendo el inset inferior.
  EdgeInsets _resolveContentPadding(double bottomInset) =>
      (widget.padding ?? EdgeInsets.zero).copyWith(bottom: bottomInset);
}
