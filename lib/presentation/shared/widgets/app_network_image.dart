import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';

const Duration _kFadeIn = Duration(milliseconds: 300);

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
    AppLogger.i('[AppNetworkImage] build — url: $url');

    if (url.isEmpty) {
      AppLogger.i('[AppNetworkImage] url vacía → fallback');
      return _fallback(context);
    }

    if (_isAsset) {
      AppLogger.i('[AppNetworkImage] asset local → Image.asset');
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, error, _) {
          AppLogger.i('[AppNetworkImage] asset error: $error');
          return _fallback(context);
        },
      );
    }

    AppLogger.i('[AppNetworkImage] red → CachedNetworkImage');
    final colors = Theme.of(context).colorScheme;
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: _kFadeIn,
      fadeOutDuration: _kFadeIn,
      imageBuilder: (_, imageProvider) {
        AppLogger.i('[AppNetworkImage] imagen lista (caché o red): $url');
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        );
      },
      errorWidget: (_, url, error) {
        AppLogger.i('[AppNetworkImage] error cargando $url: $error');
        return _fallback(context);
      },
      placeholder: (_, url) {
        AppLogger.i('[AppNetworkImage] placeholder activo (cargando): $url');
        return DecoratedBox(
          decoration: BoxDecoration(color: colors.surfaceContainerLow),
        );
      },
    );
  }

  /// Fallback si la URL está vacía o la carga falla.
  Widget _fallback(BuildContext context) {
    if (placeholder != null) {
      return placeholder!;
    }
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: SizedBox(width: width, height: height),
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
