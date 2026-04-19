import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/social_activity.dart';

/// Tarjeta de actividad social.
class SocialCard extends StatelessWidget {
  const SocialCard({super.key, required this.activity, required this.onTap});

  final SocialActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      width: 220, // Ancho fijo para el scroll horizontal
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Usamos tertiaryContainer (basado en el Accent #F88E5C)
            // para darle ese toque "social/festivo".
            color: colors.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colors.tertiary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
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
              // Texto dinámico: Usamos el ID de forma elegante
              Text(
                'Social Activity',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onTertiaryContainer.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              // Título de la actividad (o ID si no hay más)
              Text(
                '#${activity.id}', // Formato editorial para el ID
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              // Pequeño indicador de "Próximamente" o "Ver más"
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: colors.tertiary,
                  ),
                  const SizedBox(width: 4),
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
        ),
      ),
    );
  }
}
