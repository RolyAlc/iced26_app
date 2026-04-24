import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Imagen de red con estados de carga y error unificados.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Widget mostrado cuando la URL está vacía o la carga falla.
  final Widget? placeholder;

  bool get _isAsset => !url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback(context);

    if (_isAsset) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => _fallback(context),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final colors = Theme.of(context).colorScheme;
        return SizedBox(
          width: width,
          height: height,
          child: ColoredBox(
            color: colors.surfaceContainerLow,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  /// Fallback si la URL está vacía o la carga falla.
  Widget _fallback(BuildContext context) {
    if (placeholder != null) return placeholder!;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      color: colors.surfaceContainerLow,
    );
  }
}

/// Placeholder estándar: asset decorativo con opacidad reducida.
class AppNetworkImageAssetPlaceholder extends StatelessWidget {
  const AppNetworkImageAssetPlaceholder({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.opacity = AppOpacity.placeholder,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
