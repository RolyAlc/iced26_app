import 'package:flutter/material.dart';

/// Es un widget para el [flexibleSpace] de [SliverAppBar] en [AppPage]
/// que se encarga de manejar la animación de expansión y contracción.
class AppPageFlexibleSpace extends StatelessWidget {
  const AppPageFlexibleSpace({
    super.key,
    required this.expandedChild,
    this.collapsedChild,
    required this.bgColor,
  });

  final Widget expandedChild;
  final Widget? collapsedChild;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final settings = collapsedChild != null
        ? context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()
        : null;
    final progress = _computeProgress(settings);

    return Container(
      color: bgColor,
      padding: EdgeInsets.only(top: topPadding),
      child: collapsedChild != null ? _buildAnimated(progress) : expandedChild,
    );
  }

  Widget _buildAnimated(double progress) {
    return ClipRect(
      child: Stack(
        children: [
          OverflowBox(
            maxHeight: double.infinity,
            alignment: Alignment.topLeft,
            child: Opacity(opacity: 1.0 - progress, child: expandedChild),
          ),
          Opacity(
            opacity: progress,
            child: Align(alignment: Alignment.topLeft, child: collapsedChild!),
          ),
        ],
      ),
    );
  }

  double _computeProgress(FlexibleSpaceBarSettings? settings) {
    if (settings == null) return 0.0;
    final range = settings.maxExtent - settings.minExtent;
    if (range <= 0) return 1.0;
    return 1.0 -
        ((settings.currentExtent - settings.minExtent) / range).clamp(0.0, 1.0);
  }
}
