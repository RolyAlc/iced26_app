import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';
import 'package:iced26/presentation/shared/widgets/app_page_flexible_space.dart';

// Extra scroll clearance so the last list item is never hidden under a floatingChild.
const double _kFabExtraClearance = 64.0;

/// Contenedor maestro que gestiona el layout de una página completa.
class AppPage extends ConsumerStatefulWidget {
  const AppPage({
    super.key,
    this.children = const [],
    this.fillChild,
    this.header,
    this.collapsedHeader,
    this.padding,
    this.backgroundColor,
    this.headerFallbackHeight,
    this.collapsedHeaderFallbackHeight,
    this.floatingChild,
  }) : assert(
         children.length > 0 || fillChild != null,
         'AppPage requires either children or fillChild',
       ),
       assert(
         collapsedHeaderFallbackHeight == null || collapsedHeader != null,
         'collapsedHeaderFallbackHeight requires collapsedHeader',
       ),
       assert(
         fillChild == null || floatingChild == null,
         'fillChild and floatingChild cannot be used simultaneously — the FAB would overlap centered content',
       );
  final List<Widget> children;
  final Widget? fillChild;
  final Widget? header;
  final Widget? collapsedHeader;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? headerFallbackHeight;
  final double? collapsedHeaderFallbackHeight;
  final Widget? floatingChild;

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  double _headerHeight = 0;

  void _onHeaderHeightChanged(double newHeight) {
    final bool shouldUpdate = (newHeight - _headerHeight).abs() > 0.5;
    if (shouldUpdate) {
      setState(() {
        _headerHeight = newHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    final navMetrics = ref.watch(uiMetricsProvider);
    final navBarHeight = navMetrics.navBarHeight > 0
        ? navMetrics.navBarHeight
        : AppLayout.navBarClearanceFallback;

    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final fabBottom = isLandscape
        ? MediaQuery.paddingOf(context).bottom + AppSpacing.m
        : navBarHeight;

    return NotificationListener<UIMetricsNotification>(
      onNotification: (notification) {
        final height = notification.headerHeight;
        if (height != null) _onHeaderHeightChanged(height);
        return false;
      },
      // Material llena la pantalla completa (fondo sin cortes).
      // El contenido se acota a maxContentWidth y se centra en pantallas anchas.
      child: Material(
        color: bgColor,
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.maxContentWidth,
                ),
                child: _buildSliverLayout(bgColor),
              ),
            ),
            Positioned(
              bottom: fabBottom,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppDuration.fast,
                  child: widget.floatingChild ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el layout basado en slivers.
  Widget _buildSliverLayout(Color bgColor) {
    return CustomScrollView(
      primary: false,
      slivers: [
        if (widget.header != null) _buildSliverHeader(bgColor),
        if (widget.fillChild != null)
          SliverFillRemaining(
            hasScrollBody: false,
            // Compensa el solapamiento de la NavBar para que Center()
            // quede centrado en el área visualmente disponible.
            child: Padding(
              padding: const EdgeInsets.only(
                bottom:
                    AppLayout.navBarHeight + AppLayout.navBarBottomClearance,
              ),
              child: widget.fillChild,
            ),
          )
        else
          _buildSliverContent(),
        SliverClearanceSpacer(
          extraPadding: widget.floatingChild != null
              ? _kFabExtraClearance
              : 0.0,
        ),
      ],
    );
  }

  /// Construye el [SliverAppBar] con snap nativo y crossfade entre estados.
  /// floating + snap: al soltar el dedo a mitad de transición,
  /// el header hace snap automático al estado más cercano (expanded o collapsed).
  Widget _buildSliverHeader(Color bgColor) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      // + AppSpacing.s compensa el gap visual que SliverAppBar introduce
      // entre el flexibleSpace y el contenido del sliver al hacer snap.
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
