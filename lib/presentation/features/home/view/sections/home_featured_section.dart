import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/view/sections/widgets/home_featured_widgets.dart';

/// Sección de eventos destacados en la Home.
/// Muestra una lista horizontal de eventos destacados del día actual,
/// con un header que incluye un título y una acción "See all".
class HomeFeaturedSection extends StatelessWidget {
  final List<EventUIModel> featuredEvents;
  final String sectionTitle;
  final VoidCallback? onSeeAll;

  const HomeFeaturedSection({
    super.key,
    required this.featuredEvents,
    required this.sectionTitle,
    this.onSeeAll,
    TextStyle? style,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay eventos, mostramos un estado vacío o una cantidad mínima
    final visibleCount = math.min(4, featuredEvents.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: sectionTitle, onSeeAll: onSeeAll),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            scrollDirection: Axis.horizontal,
            itemCount: visibleCount,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return FeaturedCard(event: featuredEvents[index]);
            },
          ),
        ),
      ],
    );
  }
}
