import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/state/recently_viewed_people_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/widgets/person_result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';

/// Sección que muestra los ponentes vistos recientemente.
class RecentlyViewedPeopleSection extends ConsumerWidget {
  const RecentlyViewedPeopleSection({super.key, required this.personIds});

  final List<String> personIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // .value devuelve null mientras el provider está cargando o tiene error.
    // ?? {} es seguro: si aún no hay datos simplemente no se muestra nada.
    final peopleIndex = ref.watch(allPeopleIndexProvider).value ?? {};

    // Resolvemos IDs → People, descartando los que no existan en el índice.
    final people = <Person>[
      for (final id in personIds)
        if (peopleIndex[id] != null) peopleIndex[id]!,
    ];

    if (people.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        const SectionLabel(
          label: AppStrings.searchRecentlyViewedPeopleTitle,
          icon: AppIcons.person,
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final person in people)
          PersonResultTile(
            key: ValueKey(person.id),
            person: person,
            // Mueve el ponente al tope del historial al volver a visitarlo.
            onTap: () {
              ref.read(recentlyViewedPeopleProvider.notifier).add(person.id);
            },
          ),
      ],
    );
  }
}
