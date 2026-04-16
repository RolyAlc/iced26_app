import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/event_ui_model.dart';

// Widgets reutilizables para la Home, como tarjetas de eventos destacados
class FeaturedCard extends StatelessWidget {
  final EventUIModel event;

  const FeaturedCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 260,
      child: Card(
        color: colors.primaryContainer.withValues(alpha: 0.4),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              _IconInfoRow(
                icon: Icons.meeting_room_outlined,
                label: event.room,
              ),
              const SizedBox(height: 4),
              _IconInfoRow(
                icon: Icons.access_time,
                label: 'Duration: ${event.duration}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widgets auxiliares para el FeaturedCard, como el header con estado y la fila de iconos.
class _CardHeader extends StatelessWidget {
  final EventUIModel event;

  const _CardHeader({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            event.timeRange,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _StatusChip(status: event.status),
      ],
    );
  }
}

/// Chip personalizado para mostrar el estado de un evento (LIVE, ENDED, NEXT)
class _IconInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconInfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Chip personalizado para mostrar el estado de un evento (LIVE, ENDED, NEXT).
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeAll ?? () => _showSeeAllSoon(context),
            child: const Text("See all", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showSeeAllSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Próximamente: filtros por eventos del día'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Chip personalizado para mostrar el estado de un evento (LIVE, ENDED, NEXT).
class _StatusChip extends StatelessWidget {
  final EventStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Definimos las propiedades visuales según el estado
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

    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: background,
      side: BorderSide.none,
      shape: StadiumBorder(),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: foreground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
