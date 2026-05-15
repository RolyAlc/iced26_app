import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/event_image.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/widgets/time_badge.dart';
import 'package:iced26/presentation/shared/widgets/event_status_chip.dart';

/// Contenido principal de la tarjeta de evento destacado.
class FeaturedCardContent extends StatelessWidget {
  const FeaturedCardContent({super.key, required this.event});
  final EventUIModel event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _ImageBlock(event: event)),
        const SizedBox(height: AppSpacing.l),
        _Title(event: event),
      ],
    );
  }
}

/// Bloque de imagen con badge de tiempo y estado.
class _ImageBlock extends StatelessWidget {
  const _ImageBlock({required this.event});
  final EventUIModel event;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EventImage(event: event),
        Positioned(
          top: AppSpacing.s,
          left: AppSpacing.s,
          child: TimeBadge(time: event.timeRange),
        ),
        Positioned(
          top: AppSpacing.s,
          right: AppSpacing.s,
          child: EventStatusChip(status: event.status),
        ),
      ],
    );
  }
}

/// Título del evento.
class _Title extends StatelessWidget {
  const _Title({required this.event});
  final EventUIModel event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Text(
      event.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: colors.onSurface,
        height: 1.1,
        letterSpacing: -0.5,
      ),
    );
  }
}
