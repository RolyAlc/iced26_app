import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

// Ventana del crossfade entre expanded y collapsed header [0 -> 1].
// Fuera de [_kFadeStart, _kFadeEnd] solo un header tiene opacity > 0.
const double _kFadeStart = 0.45;
const double _kFadeEnd = 0.55;
const double _kFadeRange = _kFadeEnd - _kFadeStart;

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
    final progress = collapsedChild != null
        ? _computeProgress(
            context
                .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>(),
          )
        : 0.0;

    return ColoredBox(
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: collapsedChild != null
            ? _buildAnimated(progress)
            : _buildExpanded(),
      ),
    );
  }

  Widget _buildExpanded() {
    return _clippedOverflow(expandedChild);
  }

  // Animación de crossfade entre expandedChild y collapsedChild
  // en ventana estrecha [0.45 -> 0.55] del recorrido total para evitar
  // que ambos headers sean visibles a la vez durante el scroll.
  // Fuera de esa ventana, solo un header tiene opacity > 0.
  Widget _buildAnimated(double progress) {
    return ClipRect(
      child: Stack(
        children: [
          _clippedOverflow(
            AnimatedOpacity(
              duration: AppDuration.fast,
              opacity: _expandedOpacity(progress),
              child: expandedChild,
            ),
          ),
          AnimatedOpacity(
            duration: AppDuration.fast,
            opacity: _collapsedOpacity(progress),
            child: Align(alignment: Alignment.topLeft, child: collapsedChild!),
          ),
        ],
      ),
    );
  }

  // Visible completo [0 -> _kFadeStart], fade-out rápido, invisible [_kFadeEnd -> 1].
  double _expandedOpacity(double progress) {
    return ((_kFadeEnd - progress) / _kFadeRange).clamp(0.0, 1.0);
  }

  // Invisible [0 -> _kFadeStart], fade-in rápido, visible completo [_kFadeEnd -> 1].
  double _collapsedOpacity(double progress) {
    return ((progress - _kFadeStart) / _kFadeRange).clamp(0.0, 1.0);
  }

  // OverflowBox permite que el header crezca más allá del maxExtent del SliverAppBar
  // sin ser recortado por el sliver — ClipRect limita el área visible.
  Widget _clippedOverflow(Widget child) {
    return ClipRect(
      child: OverflowBox(
        maxHeight: double.infinity,
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }

  // FlexibleSpaceBarSettings es inyectado por SliverAppBar vía InheritedWidget —
  // es la única API pública para leer el extent actual sin un ScrollController propio.
  double _computeProgress(FlexibleSpaceBarSettings? settings) {
    if (settings == null) {
      return 0.0;
    }
    final range = settings.maxExtent - settings.minExtent;
    if (range <= 0) {
      return 1.0;
    }
    return 1.0 -
        ((settings.currentExtent - settings.minExtent) / range).clamp(0.0, 1.0);
  }
}
