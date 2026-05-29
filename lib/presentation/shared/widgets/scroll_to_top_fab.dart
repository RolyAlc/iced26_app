import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

const _kTooltip = 'Back to top';

/// Pequeño FAB circular que aparece/desaparece con animación según [visible].
/// Al tocar, hace scroll suave al principio del [scrollController].
class ScrollToTopFab extends StatelessWidget {
  const ScrollToTopFab({
    super.key,
    required this.scrollController,
    required this.visible,
  });

  final ScrollController scrollController;
  final bool visible;

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: AppDuration.entrance,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: AppDuration.fast,
      child: IgnorePointer(
        ignoring: !visible,
        child: FloatingActionButton.small(
          heroTag: null,
          onPressed: _scrollToTop,
          tooltip: _kTooltip,
          child: const Icon(AppIcons.collapse),
        ),
      ),
    );
  }
}
