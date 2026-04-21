import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/home_featured_widgets.dart';

/// Sección de eventos destacados en la Home.
class HomeFeaturedSection extends StatelessWidget {
  final List<EventUIModel> featuredEvents;
  final bool showFadeMask;

  const HomeFeaturedSection({
    super.key,
    required this.featuredEvents,
    this.showFadeMask = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (featuredEvents.isEmpty) {
      return const _FeaturedEmptyState();
    }

    final visibleCount = math.min(6, featuredEvents.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * FeaturedCard.widthFactor;
        final listHeight = cardWidth / FeaturedCard.aspectRatio;

        final content = SizedBox(
          height: listHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: visibleCount,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: FeaturedCard(event: featuredEvents[index]),
            ),
          ),
        );

        if (showFadeMask) {
          return ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.85, 1.0],
              colors: [Colors.white, colors.surface.withValues(alpha: 0.0)],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: content,
          );
        }

        return content;
      },
    );
  }
}

/// Estado vacío para cuando no hay eventos destacados.
class _FeaturedEmptyState extends StatelessWidget {
  const _FeaturedEmptyState();

  static const double _height = 100.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Center(
          child: Text(
            'No sessions available today',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
