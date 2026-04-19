import 'package:flutter/material.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';

/// Tarjeta de sesión destacada.
class FeaturedCard extends StatelessWidget {
  final EventUIModel event;

  const FeaturedCard({super.key, required this.event});

  /// Construye la tarjeta de sesión destacada.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 280,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: InkWell(
          onTap: () {}, // TODO: Navegar al detalle de la sesión
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                    color: colors.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                _IconInfoRow(
                  icon: Icons.meeting_room_rounded,
                  label: event.room,
                  color: colors.primary,
                ),
                const SizedBox(height: 6),
                _IconInfoRow(
                  icon: Icons.schedule_rounded,
                  label: 'Duration: ${event.duration}',
                  color: colors.secondary,
                ),
              ],
            ),
          ),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
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
  final Color color;

  const _IconInfoRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
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
              const SizedBox(width: 4),
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
        borderRadius: BorderRadius.circular(12),
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
