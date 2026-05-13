import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/shared/widgets/speaker_detail_sheet.dart';

/// Tile de ponente en los resultados de búsqueda — abre su ficha al tocar.
class PersonResultTile extends ConsumerWidget {
  const PersonResultTile({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final name = person.name.resolve(locale);
    final colors = Theme.of(context).colorScheme;
    final presentations =
        ref.watch(presentationsByPersonIdProvider).value?[person.id] ?? [];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: SpeakerAvatar(person: person, name: name),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: person.institution != null
          ? Text(
              person.institution!,
              style: TextStyle(color: colors.onSurfaceVariant),
            )
          : null,
      trailing: presentations.isNotEmpty
          ? Text(
              '${presentations.length} talk${presentations.length == 1 ? '' : 's'}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
            )
          : null,
      onTap: () {
        showSpeakerDetail(context, person, presentations);
      },
    );
  }
}
