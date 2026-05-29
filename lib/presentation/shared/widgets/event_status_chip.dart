import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';

/// Estado temporal de un evento (LIVE / NEXT / ENDED).
class EventStatusChip extends StatelessWidget {
  const EventStatusChip({super.key, required this.status});

  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final (Color background, Color foreground, String label) = switch (status) {
      EventStatus.live => (
        colors.errorContainer,
        colors.onErrorContainer,
        'LIVE',
      ),
      EventStatus.next => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'NEXT',
      ),
      EventStatus.ended => (
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
        'ENDED',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppTextSize.chip,
          color: foreground,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
