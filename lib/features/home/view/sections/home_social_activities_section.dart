import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/features/home/view/sections/widgets/social_card.dart';
import 'package:iced26/features/home/view/sections/widgets/home_featured_widgets.dart';

/// Sección de actividades sociales.
class HomeSocialActivitiesSection extends StatelessWidget {
  const HomeSocialActivitiesSection({super.key, required this.socials});

  final List<SocialActivity> socials;
  final String titleSection = 'Social Activities';

  /// Construye la sección de actividades sociales.
  @override
  Widget build(BuildContext context) {
    // Si no hay sociales, no mostramos nada.
    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: titleSection),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: socials.length,
            itemBuilder: (context, index) {
              return SocialCard(
                activity: socials[index],
                onTap: () {
                  // TODO: Implementar navegación al detalle social
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
