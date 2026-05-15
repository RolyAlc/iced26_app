import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Tile que muestra un resultado de la búsqueda.
class ResultTile extends ConsumerWidget {
  const ResultTile({super.key, required this.event, required this.onTap});
  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final roomsIndex = ref.watch(allRoomsIndexProvider).value ?? {};
    final roomName =
        roomsIndex[event.roomId]?.name.resolve(locale) ?? 'No room';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer.withValues(alpha: 0.2),
        child: Icon(AppIcons.event, color: colors.primary, size: 20),
      ),
      title: Text(
        event.title.resolve(locale),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(roomName),
      onTap: onTap,
    );
  }
}
