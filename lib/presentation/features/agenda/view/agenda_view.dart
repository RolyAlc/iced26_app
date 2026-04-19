import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/agenda_viewmodel.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/models/agenda_state.dart';

/// Pantalla principal de la agenda, que muestra los eventos organizados por días.
class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  /// Construye la vista de la agenda.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaStateAsync = ref.watch(agendaViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule'), centerTitle: true),
      body: AppAsyncValueWidget(
        asyncValue: agendaStateAsync,
        data: (state) => _AgendaList(sections: state.sections),
      ),
    );
  }
}

/// Lista de eventos organizada por días.
class _AgendaList extends StatelessWidget {
  final List<AgendaDaySection> sections;

  const _AgendaList({required this.sections});

  /// Construye la lista de eventos.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return _DaySection(section: section);
      },
    );
  }
}

/// Sección de un día en la agenda.
class _DaySection extends StatelessWidget {
  final AgendaDaySection section;

  const _DaySection({required this.section});

  /// Construye una sección del día.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...section.events.map((event) => _EventCard(event: event)),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Tarjeta de evento.
class _EventCard extends StatelessWidget {
  final dynamic event; // [:: Futuro] Usar EventUIModel

  const _EventCard({required this.event});

  /// Construye una tarjeta de evento.
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
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
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(event.filterTime ?? 'No time'),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navegar a detalle
        },
      ),
    );
  }
}
