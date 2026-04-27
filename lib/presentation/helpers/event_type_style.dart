import 'package:flutter/material.dart';
import 'package:iced26/domain/entities/event_type.dart';

/// Estilo visual de un tipo de evento.
class EventTypeStyle {
  final IconData icon;
  final Color color;
  const EventTypeStyle(this.icon, this.color);
}

/// Resuelve el estilo visual de un [EventType].
EventTypeStyle resolveTypeStyle(BuildContext context, EventType type) {
  final cs = Theme.of(context).colorScheme;
  return switch (type) {
    EventType.keynote => EventTypeStyle(Icons.mic, cs.primary),
    EventType.workshop => EventTypeStyle(Icons.build, cs.secondary),
    EventType.sessions => EventTypeStyle(Icons.forum, cs.tertiary),
    EventType.break_ => EventTypeStyle(Icons.local_cafe, cs.outline),
    EventType.opening => EventTypeStyle(Icons.celebration, cs.primary),
    EventType.closing => EventTypeStyle(Icons.flag, cs.primary),
    EventType.gala => EventTypeStyle(Icons.wine_bar, cs.tertiary),
    EventType.welcome => EventTypeStyle(Icons.waving_hand, cs.tertiary),
    EventType.registration => EventTypeStyle(Icons.how_to_reg, cs.secondary),
    EventType.instructions => EventTypeStyle(Icons.info_outline, cs.secondary),
    EventType.internationalPanel => EventTypeStyle(Icons.language, cs.tertiary),
    EventType.presidents => EventTypeStyle(Icons.workspace_premium, cs.primary),
    EventType.unknown => EventTypeStyle(Icons.event, cs.secondary),
  };
}
