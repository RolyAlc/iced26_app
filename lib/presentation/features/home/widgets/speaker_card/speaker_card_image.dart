import 'package:flutter/material.dart';

import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';

/// Imagen de fondo del speaker (ocupa toda la card).
class SpeakerCardImage extends StatelessWidget {
  const SpeakerCardImage({super.key, required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppNetworkImage(
      url: photoUrl ?? '',
      placeholder: ColoredBox(
        color: colors.surfaceContainerHigh,
        child: Center(
          child: Icon(
            AppIcons.person,
            size: 48,
            color: colors.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
