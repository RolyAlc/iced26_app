import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Botón de acción principal de la aplicación.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.trailingIcon,
    this.height = defaultHeight,
    this.isFullWidth = true,
  });

  static const double defaultHeight = 56.0;
  static const double _kIconSize = 20.0;
  static const double _kSpinnerSize = 20.0;
  static const double _kSpinnerStroke = 2.0;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final IconData? trailingIcon;
  final double height;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        ),
        child: _buildChild(colorScheme),
      ),
    );
  }

  Widget _buildChild(ColorScheme colorScheme) {
    if (isLoading) {
      return _buildLoadingIndicator(colorScheme);
    }
    return _buildLabel();
  }

  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return SizedBox(
      width: _kSpinnerSize,
      height: _kSpinnerSize,
      child: CircularProgressIndicator(
        strokeWidth: _kSpinnerStroke,
        color: colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        bool iconAdded = icon != null
        if (iconAdded) ...[
          Icon(icon, size: _kIconSize),
          const SizedBox(width: AppSpacing.s),
        ],
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        
        bool trailingIconAdded = trailingIcon != null
        if (trailingIconAdded) ...[
          const SizedBox(width: AppSpacing.s),
          Icon(trailingIcon, size: _kIconSize),
        ],
      ],
    );
  }
}
