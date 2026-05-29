import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/widgets/result_tile.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';

/// Sección que muestra los eventos vistos recientemente.
class RecentlyViewedSection extends ConsumerWidget {
  const RecentlyViewedSection({
    super.key,
    required this.eventIds,
    required this.onEventTap,
  });

  final List<String> eventIds;
  final ValueChanged<Event> onEventTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // .value devuelve null mientras el provider está cargando o tiene error.
    // ?? {} es seguro: si aún no hay datos simplemente no se muestra nada.
    final eventsIndex = ref.watch(allEventsIndexProvider).value ?? {};

    // Resolvemos IDs → Events, descartando los que no existan en el índice.
    final events = <Event>[
      for (final id in eventIds)
        if (eventsIndex[id] != null) eventsIndex[id]!,
    ];

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        SectionLabel(
          label: l10n.searchRecentlyViewedTitle,
          icon: AppIcons.history,
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final event in events)
          ResultTile(
            key: ValueKey(event.id),
            event: event,
            onTap: () {
              onEventTap(event);
            },
          ),
      ],
    );
  }
}
