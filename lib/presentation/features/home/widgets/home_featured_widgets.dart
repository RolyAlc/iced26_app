import 'package:flutter/material.dart';
import 'package:iced26/core/constants/assets.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';

/// Tarjeta de sesión destacada con estética "Studio/Editorial"
class FeaturedCard extends StatelessWidget {
  final EventUIModel event;

  const FeaturedCard({super.key, required this.event});

  static const double widthFactor = 0.85;
  static const double aspectRatio = 0.8;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppCard(
      onTap: () {}, // TODO: Navegar al detalle
      borderRadius: AppRadius.container,
      color: colors.surfaceContainerLowest,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _ImageSection(event: event)),
          const SizedBox(height: AppSpacing.l),
          _TitleSection(event: event),
          const SizedBox(height: AppSpacing.m),
          _FooterSection(event: event),
        ],
      ),
    );
  }
}

/// Imagen de la sesión destacada
class _ImageSection extends StatelessWidget {
  final EventUIModel event;

  const _ImageSection({required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        _EventImage(event: event, colors: colors),
        _TimeBadge(time: event.timeRange),
        _StatusBadge(status: event.status),
      ],
    );
  }
}

/// Evento imagen destacada
class _EventImage extends StatelessWidget {
  final EventUIModel event;
  final ColorScheme colors;

  const _EventImage({required this.event, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.m),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AppNetworkImage(
        url: event.imageUrl ?? '',
        fit: BoxFit.cover,
        placeholder: AppNetworkImageAssetPlaceholder(
          assetPath: Assets.expressiveShape,
        ),
      ),
    );
  }
}

/// Etiqueta de tiempo
class _TimeBadge extends StatelessWidget {
  final String time;

  const _TimeBadge({required this.time});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.s,
      left: AppSpacing.s,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
        child: Text(
          time.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Etiqueta de estado
class _StatusBadge extends StatelessWidget {
  final dynamic status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.s,
      right: AppSpacing.s,
      child: EventStatusChip(status: status),
    );
  }
}

/// Título de la sesión destacada
class _TitleSection extends StatelessWidget {
  final EventUIModel event;

  const _TitleSection({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final double titleHeight =
        (theme.textTheme.headlineSmall?.fontSize ?? 24) * 2 * 1.1;

    return SizedBox(
      height: titleHeight,
      child: Text(
        event.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w900,
          color: colors.onSurface,
          height: 1.1,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

/// Pie de la sesión destacada
class _FooterSection extends StatelessWidget {
  final EventUIModel event;

  const _FooterSection({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _EventInfo(event: event),
        const _SaveButton(),
      ],
    );
  }
}

/// Información de la sesión destacada
class _EventInfo extends StatelessWidget {
  final EventUIModel event;

  const _EventInfo({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.meeting_room_outlined,
          text: event.room,
          color: colors.primary,
          textStyle: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        _InfoRow(
          icon: Icons.schedule_outlined,
          text: event.duration,
          color: colors.primary,
          textStyle: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// Información de la sesión destacada
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final TextStyle? textStyle;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(text, style: textStyle),
      ],
    );
  }
}

/// Botón de guardar la sesión destacada
class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.onSurface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
