import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Pantalla principal de la agenda, que muestra los eventos organizados por días.
class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key, required this.appData});

  final AppData appData;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final daySections = _buildDaySections(locale);

    return Scaffold(
      appBar: AppBar(title: Text(appData.conference.name.resolve(locale))),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: daySections.length,
        itemBuilder: (context, index) =>
            _DaySection(section: daySections[index]),
      ),
    );
  }

  List<_DaySectionData> _buildDaySections(String locale) {
    final events = [...appData.collections.events];
    events.sort((a, b) {
      final aTime = a.startDate ?? DateTime(1900);
      final bTime = b.startDate ?? DateTime(1900);
      return aTime.compareTo(bTime);
    });

    final zones = {for (final zone in appData.collections.zones) zone.id: zone};

    if (appData.collections.days.isNotEmpty) {
      return appData.collections.days.map((day) {
        final dayEvents = events.where((event) {
          if (event.startDate == null) return false;
          if (event.startDate != null && day.date.isNotEmpty) {
            return event.startDate!.toIso8601String().startsWith(day.date);
          }
          return false;
        }).toList();

        return _DaySectionData(
          title: day.title.resolve(locale),
          date: day.date,
          events: dayEvents,
          zones: zones,
        );
      }).toList();
    }

    final grouped = <String, List<Event>>{};
    for (final event in events) {
      final startDate = event.startDate;
      final key = startDate == null ? 'Sin fecha' : _formatDate(startDate);
      grouped.putIfAbsent(key, () => []).add(event);
    }

    return grouped.entries
        .map(
          (entry) => _DaySectionData(
            title: entry.key,
            date: entry.key,
            events: entry.value,
            zones: zones,
          ),
        )
        .toList();
  }
}

class _DaySectionData {
  _DaySectionData({
    required this.title,
    required this.date,
    required this.events,
    required this.zones,
  });

  final String title;
  final String date;
  final List<Event> events;
  final Map<String, Zone> zones;
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.section});

  final _DaySectionData section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            section.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...section.events.map((event) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              /* title: Text(event.title.resolve(locale)),
              subtitle: Text(_eventSubtitle(event, zoneName)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SessionDetailScreen(
                    appData:
                        (context.findAncestorWidgetOfExactType<AgendaScreen>()!)
                            .appData,
                    event: event,
                  ),
                ),
              ), */
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
