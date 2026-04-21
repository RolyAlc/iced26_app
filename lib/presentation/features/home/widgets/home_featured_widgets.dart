import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

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
            url: '',
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
        _StatusChip(status: event.status),
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

/// Cabecera de la sección.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        TextButton(
          onPressed: onSeeAll ?? () => _showSeeAllSoon(context),
          child: Row(
            children: [
              Text(
                "See all",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Muestra un SnackBar con un mensaje de "Coming Soon".
  void _showSeeAllSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming Soon: Daily session filters'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Etiqueta de estado de la sesión.
class _StatusChip extends StatelessWidget {
  final EventStatus status;
  const _StatusChip({required this.status});

  /// Mapeo del estado a colores y etiquetas.
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final (Color background, Color foreground, String label) = switch (status) {
      EventStatus.live => (
        colors.errorContainer,
        colors.onErrorContainer,
        'LIVE',
      ),
      EventStatus.ended => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
        'ENDED',
      ),
      EventStatus.next => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'NEXT',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: foreground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
