import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/person.dart';

/// Widget compartido entre sheets — evita duplicar la lógica foto/inicial en cada punto de entrada.
class SpeakerAvatar extends StatelessWidget {
  const SpeakerAvatar({
    super.key,
    required this.person,
    required this.name,
    this.radius = 20,
  });

  final Person? person;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoUrl = person?.photoUrl;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: photoUrl.startsWith('assets/')
            ? AssetImage(photoUrl) as ImageProvider
            : NetworkImage(photoUrl),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
