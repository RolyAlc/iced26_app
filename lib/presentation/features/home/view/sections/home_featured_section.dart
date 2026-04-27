import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/featured_card/featured_card.dart';
import 'package:iced26/presentation/widgets/app_dots_indicator.dart';

/// Sección de eventos destacados — carousel con snap, peek y dots.
class HomeFeaturedSection extends StatefulWidget {
  const HomeFeaturedSection({super.key, required this.featuredEvents});

  final List<EventUIModel> featuredEvents;

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

  List<EventUIModel> get _items =>
      widget.featuredEvents.take(_maxItems).toList();

  @override
  Widget build(BuildContext context) {
    if (widget.featuredEvents.isEmpty) return const _FeaturedEmptyState();

    final items = _items;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCarousel(items),
        if (items.length > 1) ...[
          const SizedBox(height: AppSpacing.m),
          AppDotsIndicator(count: items.length, current: _currentPage),
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                child: FeaturedCard(event: items[index]),
              );
            },
          ),
        );
      },
    );
  }
}

/// Estado vacío para la sección de eventos destacados.
class _FeaturedEmptyState extends StatelessWidget {
  const _FeaturedEmptyState();

  static const double _height = 100;

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
