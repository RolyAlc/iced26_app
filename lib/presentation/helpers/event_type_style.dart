import 'package:flutter/material.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

// TODO: Mirar return switch

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
    EventType.keynote => EventTypeStyle(AppIcons.mic, cs.primary),
    EventType.workshop => EventTypeStyle(AppIcons.workshop, cs.secondary),
    EventType.sessions => EventTypeStyle(AppIcons.sessions, cs.tertiary),
    EventType.break_ => EventTypeStyle(AppIcons.coffee, cs.outline),
    EventType.opening => EventTypeStyle(AppIcons.celebration, cs.primary),
    EventType.closing => EventTypeStyle(AppIcons.flag, cs.primary),
    EventType.gala => EventTypeStyle(AppIcons.wineBar, cs.tertiary),
    EventType.welcome => EventTypeStyle(AppIcons.wavingHand, cs.tertiary),
    EventType.registration => EventTypeStyle(
      AppIcons.registration,
      cs.secondary,
    ),
    EventType.instructions => EventTypeStyle(AppIcons.info, cs.secondary),
    EventType.internationalPanel => EventTypeStyle(
      AppIcons.language,
      cs.tertiary,
    ),
    EventType.presidents => EventTypeStyle(
      AppIcons.workspacePremium,
      cs.primary,
    ),
    EventType.unknown => EventTypeStyle(AppIcons.event, cs.secondary),
  };
}
