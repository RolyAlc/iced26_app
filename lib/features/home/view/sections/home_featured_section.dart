import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iced26/domain/entities/event.dart';

/// Sección de eventos destacados en la pantalla principal.
class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({
    super.key,
    required this.events,
    // required this.onGetZoneName,
    required this.onGetRoomName,
    this.onSeeAll,
  });

  final List<Event> events;
  // final String Function(String?) onGetZoneName;
  final String Function(String?) onGetRoomName;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final title =
        events.isEmpty ||
            events.every(
              (e) =>
                  e.startDate == null || e.startDate!.isAfter(DateTime.now()),
            )
        ? "Upcoming events"
        : "Today’s events";
    final visibleCount = events.isEmpty ? 1 : math.min(4, events.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAll ?? () => _showSeeAllSoon(context),
                child: const Text("See all", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220, // Aumentamos un pelín la altura para las 3 filas
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            scrollDirection: Axis.horizontal,
            itemCount: visibleCount,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final event = events.isEmpty ? null : events[index];
              return _FeaturedCard(
                event: event,
                // onGetZoneName: onGetZoneName,
                onGetRoomName: onGetRoomName,
              );
            },
          ),
        ),
      ],
    );
  }
}

void _showSeeAllSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Próximamente: filtros por eventos del día'),
      duration: Duration(seconds: 2),
    ),
  );
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.event,
    // required this.onGetZoneName,
    required this.onGetRoomName,
  });

  final Event? event;
  // final String Function(String?) onGetZoneName;
  final String Function(String?) onGetRoomName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = event?.title.resolve('en') ?? 'Evento destacado';
    final time = _buildTimeLabel(context);
    final status = _buildStatus();
    final colors = theme.colorScheme;

    final cardColor = colors.primaryContainer.withOpacity(0.4);

    return SizedBox(
      width: 260,
      child: Card(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      time,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(status: status),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.meeting_room_outlined,
                label: onGetRoomName(event?.roomId),
              ),
              const SizedBox(height: 4),
              // _InfoRow(
              //   icon: Icons.business_outlined,
              //   label: onGetZoneName(event?.zoneId),
              // ),
              const SizedBox(height: 4),
              _InfoRow(icon: Icons.access_time, label: _buildDurationLabel()),
            ],
          ),
        ),
      ),
    );
  }

  /// Calcula la duración real entre el inicio y el fin.
  String _buildDurationLabel() {
    final start = event?.startDate;
    final end = event?.endDate;
    if (start == null || end == null) return '--';

    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return 'Duration: ${hours}h ${minutes > 0 ? '${minutes}m' : ''}';
    }
    return 'Duration: ${minutes}m';
  }

  String _buildTimeLabel(BuildContext context) {
    if (event == null) return '09:00 - 12:00';
    final start = event?.startDate;
    final end = event?.endDate;
    if (start == null) return event?.filterTime ?? '09:00';
    final locale = MaterialLocalizations.of(context);
    final startLabel = locale.formatTimeOfDay(
      TimeOfDay.fromDateTime(start),
      alwaysUse24HourFormat: true,
    );
    if (end == null) return startLabel;
    final endLabel = locale.formatTimeOfDay(
      TimeOfDay.fromDateTime(end),
      alwaysUse24HourFormat: true,
    );
    return '$startLabel - $endLabel';
  }

  String _buildStatus() {
    if (event == null) return 'NEXT';
    final now = DateTime.now();
    final start = event?.startDate;
    final end = event?.endDate;
    if (start != null && end != null) {
      if (now.isAfter(end)) return 'ENDED';
      if (now.isBefore(start)) return 'NEXT';
      return 'LIVE';
    }
    return 'NEXT';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLive = status == 'LIVE';
    final isEnded = status == 'ENDED';
    final background = isLive
        ? colors.errorContainer
        : isEnded
        ? colors.surfaceContainerHighest
        : colors.primaryContainer;
    final foreground = isLive
        ? colors.onErrorContainer
        : isEnded
        ? colors.onSurfaceVariant
        : colors.onPrimaryContainer;

    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: background,
      label: Text(status, style: TextStyle(fontSize: 11, color: foreground)),
    );
  }
}
