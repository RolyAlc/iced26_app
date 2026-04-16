import 'package:flutter/material.dart';
import 'package:iced26/domain/entities/social_activity.dart';

/// Sección de actividades sociales para la Home.
class HomeSocialActivitiesSection extends StatelessWidget {
  const HomeSocialActivitiesSection({super.key, required this.socials});

  final List<SocialActivity> socials;

  @override
  Widget build(BuildContext context) {
    if (socials.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Social Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Por ahora mostramos una lista simple de actividades destacadas
        ...socials.map((activity) => _SocialActivityCard(activity: activity)),
      ],
    );
  }
}

class _SocialActivityCard extends StatelessWidget {
  const _SocialActivityCard({required this.activity});

  final SocialActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondary,
          child: const Icon(Icons.celebration, color: Colors.white, size: 20),
        ),
        title: Text(
          'Activity: ${activity.id}', // TODO: Usar nombre real cuando el JSON lo incluya
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navegar al detalle de la actividad social
        },
      ),
    );
  }
}
