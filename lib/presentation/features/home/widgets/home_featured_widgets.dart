import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';

/// Tarjeta de sesión destacada.
class FeaturedCard extends StatelessWidget {
  final EventUIModel event;

  const FeaturedCard({super.key, required this.event});

  /// Fraccion del ancho disponible que ocupa cada tarjeta en el carrusel.
  static const double widthFactor = 0.72;

  /// Relacion ancho/alto de la tarjeta. La seccion calcula la altura del ListView.
  static const double aspectRatio = 5 / 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () {}, // TODO: Navegar al detalle de la sesión
      borderRadius: AppRadius.m,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Fallback si el asset falla: surfaceContainerHigh (color sólido de AppCard).
          AppNetworkImage(
            url: event.imageUrl ?? '',
            placeholder: AppNetworkImageAssetPlaceholder(
              assetPath: Assets.expressiveShape,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black38, Colors.black87],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardHeader(event: event),
                const Spacer(),
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _IconInfoRow(
                  icon: Icons.meeting_room_rounded,
                  label: event.room,
                  iconColor: Colors.white70,
                  labelColor: Colors.white70,
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                _IconInfoRow(
                  icon: Icons.schedule_rounded,
                  label: 'Duration: ${event.duration}',
                  iconColor: Colors.white70,
                  labelColor: Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cabecera de la tarjeta de sesión destacada.
class _CardHeader extends StatelessWidget {
  final EventUIModel event;
  const _CardHeader({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.s,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
          child: Text(
            event.timeRange,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
        ),
        EventStatusChip(status: event.status),
      ],
    );
  }
}

/// Información de la tarjeta de sesión destacada.
class _IconInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? labelColor;

  const _IconInfoRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor.withValues(alpha: 0.7)),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: labelColor ?? theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
