import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/search/widgets/search_highlight_text.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/shared/widgets/speaker_detail_sheet.dart';

/// Tile de ponente en los resultados de búsqueda — abre su ficha al tocar.
class PersonResultTile extends ConsumerWidget {
  const PersonResultTile({super.key, required this.person, this.onTap});

  final Person person;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final name = person.name.resolve(locale);
    final presentations = ref.watch(
      presentationsByPersonIdProvider.select((v) => v.value?[person.id] ?? []),
    );
    final query = ref.watch(searchProvider.select((s) => s.query));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: SpeakerAvatar(person: person, name: name),
      title: SearchHighlightText(
        text: name,
        query: query,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: person.institution != null
          ? Text(
              person.institution!,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            )
          : null,
      trailing: presentations.isNotEmpty
          ? Text(
              l10n.searchTalkCount(presentations.length),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      onTap: () {
        onTap?.call();
        showSpeakerDetail(context, person, presentations);
      },
    );
  }
}
