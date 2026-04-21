import 'package:flutter/material.dart';

/// Estilo de un tipo de evento.
class EventTypeStyle {
  final IconData icon;
  final Color color;
  const EventTypeStyle(this.icon, this.color);
}

/// Resuelve el estilo de un tipo de evento.
EventTypeStyle resolveTypeStyle(BuildContext context, String type) {
  final cs = Theme.of(context).colorScheme;
  return switch (type) {
    'keynote' => EventTypeStyle(Icons.mic, cs.primary),
    'workshop' => EventTypeStyle(Icons.build, cs.secondary),
    'sessions' => EventTypeStyle(Icons.forum, cs.tertiary),
    'break' => EventTypeStyle(Icons.local_cafe, cs.outline),
    'opening' => EventTypeStyle(Icons.celebration, cs.primary),
    'closing' => EventTypeStyle(Icons.flag, cs.primary),
    'gala' => EventTypeStyle(Icons.wine_bar, cs.tertiary),
    'welcome' => EventTypeStyle(Icons.waving_hand, cs.tertiary),
    'registration' => EventTypeStyle(Icons.how_to_reg, cs.secondary),
    'instructions' => EventTypeStyle(Icons.info_outline, cs.secondary),
    'international_panel' => EventTypeStyle(Icons.language, cs.tertiary),
    'presidents' => EventTypeStyle(Icons.workspace_premium, cs.primary),
    _ => EventTypeStyle(Icons.event, cs.secondary),
  };
}
