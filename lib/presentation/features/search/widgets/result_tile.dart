import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/widgets/search_highlight_text.dart';

/// Tile que muestra un resultado de la búsqueda.
class ResultTile extends ConsumerWidget {
  const ResultTile({super.key, required this.event, required this.onTap});
  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final roomsIndex = ref.watch(allRoomsIndexProvider).value ?? {};
    final roomName =
        roomsIndex[event.roomId]?.name.resolve(locale) ?? l10n.searchNoRoom;
    final query = ref.watch(searchProvider.select((s) => s.query));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer.withValues(alpha: 0.2),
        child: Icon(AppIcons.event, color: colors.primary, size: 20),
      ),
      title: SearchHighlightText(
        text: event.title.resolve(locale),
        query: query,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(roomName),
      onTap: onTap,
    );
  }
}
