import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_metrics.g.dart';

/// Notificación que burbujea cambios en las dimensiones de componentes clave de la UI.
class UIMetricsNotification extends Notification {
  UIMetricsNotification({this.navBarHeight, this.headerHeight});
  final double? navBarHeight;
  final double? headerHeight;
}

/// Estado que almacena métricas globales de la interfaz (solo lo compartido entre pantallas).
class UIMetrics {
  const UIMetrics({this.navBarHeight = 0.0});
  final double navBarHeight;

  UIMetrics copyWith({double? navBarHeight}) {
    return UIMetrics(navBarHeight: navBarHeight ?? this.navBarHeight);
  }
}

/// Provider que centraliza las métricas de la UI capturadas dinámicamente.
@riverpod
class UiMetrics extends _$UiMetrics {
  @override
  UIMetrics build() => const UIMetrics();
  void updateNavBarHeight(double height) =>
      state = state.copyWith(navBarHeight: height);
}

/// Widget que añade un espacio al final de un [CustomScrollView] para asegurar
/// que el contenido sea visible por encima de componentes flotantes (como la NavBar).
class SliverClearanceSpacer extends ConsumerWidget {
  const SliverClearanceSpacer({super.key, this.extraPadding = 0.0});
  final double extraPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(uiMetricsProvider);

    final clearance = metrics.navBarHeight > 0
        ? metrics.navBarHeight
        : AppLayout.navBarClearanceFallback;

    return SliverToBoxAdapter(
      child: SizedBox(height: clearance + extraPadding),
    );
  }
}

/// Widget de utilidad que mide su propio tamaño y emite una [UIMetricsNotification].
class UIMetricsReporter extends StatefulWidget {
  const UIMetricsReporter({
    super.key,
    required this.child,
    this.onReportNavBar,
    this.onReportHeader,
  });
  final Widget child;
  final double? Function(Size)? onReportNavBar;
  final double? Function(Size)? onReportHeader;

  @override
  State<UIMetricsReporter> createState() => _UIMetricsReporterState();
}

/// Estado del reporter de métricas de la UI.
class _UIMetricsReporterState extends State<UIMetricsReporter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());
  }

  void _reportSize() {
    if (!mounted) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final size = renderBox.size;

    UIMetricsNotification(
      navBarHeight: widget.onReportNavBar?.call(size),
      headerHeight: widget.onReportHeader?.call(size),
    ).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _reportSize());
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}
