import 'package:flutter/material.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Header visual de la card (icono + fondo).
class SocialCardHeader extends StatelessWidget {
  const SocialCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 20,
      backgroundColor: colors.tertiary.withValues(alpha: 0.15),
      child: Icon(AppIcons.social, color: colors.tertiary, size: 20),
    );
  }
}
