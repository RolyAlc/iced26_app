import 'package:flutter/material.dart';

/// Header visual de la card (icono + fondo).
class SocialCardHeader extends StatelessWidget {
  const SocialCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: 20,
      backgroundColor: colors.tertiary.withValues(alpha: 0.15),
      child: Icon(Icons.celebration_rounded, color: colors.tertiary, size: 20),
    );
  }
}
