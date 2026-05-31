import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';
import 'package:iced26/presentation/shared/widgets/app_dots_indicator.dart';

/// Sección de eventos destacados — carousel con snap, peek y dots.
class HomeFeaturedSection extends StatefulWidget {
  const HomeFeaturedSection({
    super.key,
    required this.featuredEvents,
    required this.onExploreTap,
  });

  final List<EventUIModel> featuredEvents;
  final VoidCallback onExploreTap;

  @override
  State<HomeFeaturedSection> createState() => _HomeFeaturedSectionState();
}

/// Estado interno del HomeFeaturedSection.
class _HomeFeaturedSectionState extends State<HomeFeaturedSection> {
  late final PageController _controller;
  int _currentPage = 0;

  static const int _maxItems = 6;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: FeaturedCard.widthFactor);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final page = _controller.page?.round() ?? 0;
    if (page != _currentPage) setState(() => _currentPage = page);
  }

  List<EventUIModel> get _items {
    return widget.featuredEvents.take(_maxItems).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredEvents.isEmpty) {
      return const _FeaturedEmptyState();
    }

    final items = _items;
    final totalCount = items.length + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCarousel(items),
        if (totalCount > 1) ...[
          const SizedBox(height: AppSpacing.m),
          AppDotsIndicator(count: totalCount, current: _currentPage),
        ],
      ],
    );
  }

  Widget _buildCarousel(List<EventUIModel> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * FeaturedCard.widthFactor;
        final cardHeight = cardWidth / FeaturedCard.aspectRatio;

        return SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              final child = index == items.length
                  ? _ExploreMoreCard(onTap: widget.onExploreTap)
                  : FeaturedCard(event: items[index]);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

/// Tarjeta que invita al usuario a explorar todos los eventos.
class _ExploreMoreCard extends StatelessWidget {
  const _ExploreMoreCard({required this.onTap});

  final VoidCallback onTap;

  static const double _iconSize = AppIconSize.featureCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.container,
      color: colors.primaryContainer,
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.scheduleOn,
            size: _iconSize,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            l10n.homeFeaturedExploreMore,
            style: textTheme.titleMedium?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.homeFeaturedViewSchedule,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                AppIcons.arrowForward,
                size: AppIconSize.inline,
                color: colors.onPrimaryContainer.withValues(alpha: 0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Estado vacío para la sección de eventos destacados.
class _FeaturedEmptyState extends StatelessWidget {
  const _FeaturedEmptyState();

  static const double _height = 100.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
      ),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Center(
          child: Text(
            l10n.homeFeaturedEmptyMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
