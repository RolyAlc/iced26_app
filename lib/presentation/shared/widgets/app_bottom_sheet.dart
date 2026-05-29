import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

// TODO: Revisar los Edge

const double _kMaxSheetHeightRatio = 0.70;
const double _kCeilingMarginRatio = 0.10;
const double _kGrabberWidth = 36.0;
const double _kGrabberHeight = 4.0;
const double _kCloseIconSize = 20.0;

/// Widget base para los paneles deslizantes de la app.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.stickyBottom,
    this.isFullHeight = false,
    this.scrollable = true,
  });

  static const _contentPadding = EdgeInsets.fromLTRB(
    AppSpacing.l,
    AppSpacing.m,
    AppSpacing.l,
    AppSpacing.l,
  );

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? stickyBottom;
  final bool isFullHeight;
  final bool scrollable;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget>? actions,
    Widget? stickyBottom,
    bool isFullHeight = false,
    bool scrollable = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppOverlayColors.barrierScrim,
      builder: (context) => AppBottomSheet(
        title: title,
        actions: actions,
        stickyBottom: stickyBottom,
        isFullHeight: isFullHeight,
        scrollable: scrollable,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final layout = _calculateLayout(context);

    return Padding(
      padding: EdgeInsets.only(bottom: layout.keyboardHeight),
      child: Container(
        constraints: _buildConstraints(layout),
        decoration: _buildDecoration(colors),
        child: SafeArea(
          top: false,
          bottom: layout.keyboardHeight == 0,
          child: Column(
            mainAxisSize: isFullHeight ? MainAxisSize.max : MainAxisSize.min,
            children: [
              _buildGrabber(colors),
              _buildHeader(context, theme),
              _buildContent(),
              _buildStickyBottom(),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcula el layout del bottom sheet.
  _BottomSheetLayout _calculateLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final statusBarHeight = mediaQuery.padding.top;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    final ceilingMargin = (screenHeight * _kCeilingMarginRatio).clamp(
      statusBarHeight + 12,
      100.0,
    );
    final availableHeight = screenHeight - ceilingMargin - keyboardHeight;

    return _BottomSheetLayout(
      keyboardHeight: keyboardHeight,
      availableHeight: availableHeight,
      screenHeight: screenHeight,
    );
  }

  /// Construye las restricciones del bottom sheet.
  BoxConstraints _buildConstraints(_BottomSheetLayout layout) {
    return BoxConstraints(
      maxHeight: isFullHeight
          ? layout.availableHeight
          : layout.screenHeight * _kMaxSheetHeightRatio,
    );
  }

  /// Construye la decoración del bottom sheet.
  BoxDecoration _buildDecoration(ColorScheme colors) {
    return BoxDecoration(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.container),
      ),
    );
  }

  /// Construye el grabber del bottom sheet.
  Widget _buildGrabber(ColorScheme colors) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.s),
        Container(
          width: _kGrabberWidth,
          height: _kGrabberHeight,
          decoration: BoxDecoration(
            color: colors.onSurfaceVariant.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(_kGrabberHeight / 2),
          ),
        ),
        const SizedBox(height: AppSpacing.m),
      ],
    );
  }

  /// Construye el header del bottom sheet.
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(AppIcons.close, size: _kCloseIconSize),
          ),
        ],
      ),
    );
  }

  /// Construye el contenido del bottom sheet.
  Widget _buildContent() {
    final content = scrollable
        ? SingleChildScrollView(padding: _contentPadding, child: child)
        : Padding(padding: _contentPadding, child: child);

    return Flexible(
      fit: isFullHeight ? FlexFit.tight : FlexFit.loose,
      child: content,
    );
  }

  /// Widget fijo al fondo del sheet, fuera del área de scroll.
  Widget _buildStickyBottom() {
    if (stickyBottom == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _contentPadding.left,
        AppSpacing.m,
        _contentPadding.right,
        AppSpacing.s,
      ),
      child: stickyBottom,
    );
  }

  /// Construye las acciones del bottom sheet.
  Widget _buildActions() {
    if (actions == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: _contentPadding,
      child: Row(
        children: actions!
            .map(
              (action) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  child: action,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Modelo simple para encapsular cálculos de layout.
class _BottomSheetLayout {
  const _BottomSheetLayout({
    required this.keyboardHeight,
    required this.availableHeight,
    required this.screenHeight,
  });
  final double keyboardHeight;
  final double availableHeight;
  final double screenHeight;
}
