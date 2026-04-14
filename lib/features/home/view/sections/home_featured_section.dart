import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/event.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({super.key, required this.events});

  final List<Event> events;

  @override
  Widget build(BuildContext context) {
    // Mostramos el título de sección y el carrusel horizontal.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Today’s event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "see all",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: events.isEmpty ? 1 : events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final event = events.isEmpty ? null : events[index];
              return _FeaturedCard(event: event);
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.event});

  final Event? event;

  @override
  Widget build(BuildContext context) {
    final title = event?.title.resolve('en') ?? 'Evento destacado';
    final time = event == null
        ? '09:00 - 12:00'
        : '${event?.filterTime ?? '09:00'}';

    // Creamos una tarjeta con gradiente oscuro/dorado.
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const RadialGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF6D5A3C)],
          radius: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Location: Classroom 1.A - Iglesia',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          const Text(
            'Duration: 3h',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
