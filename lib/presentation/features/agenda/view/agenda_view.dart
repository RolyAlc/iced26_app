import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/agenda_viewmodel.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_page.dart';
import 'package:iced26/presentation/widgets/app_section.dart';

/// Pantalla principal de la agenda, que muestra los eventos organizados por días.
class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaStateAsync = ref.watch(agendaViewModelProvider);

    return AppAsyncValueWidget(
      asyncValue: agendaStateAsync,
      data: (state) => AppPage(
        header: Text(
          'Schedule',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        headerHeight: 60,
        children: state.sections
            .map(
              (section) => AppSection(
                title: section.title,
                child: Column(
                  children: section.events
                      .map((event) => _EventCard(event: event))
                      .toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Tarjeta de evento.
class _EventCard extends StatelessWidget {
  final dynamic event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: () {
          // TODO: Navegar al detalle del evento
        },
        borderRadius: 16,
        bordered: true,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            event.title.resolve(locale),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event.filterTime ?? 'No time',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
        ),
      ),
    );
  }
}
