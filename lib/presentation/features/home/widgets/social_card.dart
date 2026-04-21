import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/widgets/app_card.dart';

/// Tarjeta de actividad social.
class SocialCard extends StatelessWidget {
  const SocialCard({super.key, required this.activity, required this.onTap});

  final SocialActivity activity;
  final VoidCallback onTap;

  /// Fraccion del ancho disponible que ocupa cada tarjeta en el carrusel.
  static const double widthFactor = 0.56;

  /// Relacion ancho/alto de la tarjeta. La seccion calcula la altura del ListView.
  static const double aspectRatio = 5 / 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.m,
      color: colors.tertiaryContainer.withValues(alpha: 0.3),
      bordered: true,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono de celebración con fondo circular suave
          CircleAvatar(
            radius: 20,
            backgroundColor: colors.tertiary.withValues(alpha: 0.15),
            child: Icon(
              Icons.celebration_rounded,
              color: colors.tertiary,
              size: 20,
            ),
          ),
          const Spacer(),
          // Texto dinámico: Categoría de la tarjeta
          Text(
            'SOCIAL ACTIVITY',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onTertiaryContainer.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Título real de la actividad
          Text(
            activity.title.resolve('en'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onTertiaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          // Pequeño indicador de "Próximamente" o "Ver más"
          Row(
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: colors.tertiary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'View details',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
