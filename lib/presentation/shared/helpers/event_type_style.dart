import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/models/icon_color_style.dart';

/// Extension para obtener el estilo de un tipo de evento.
extension EventTypeX on EventType {
  IconColorStyle style(ColorScheme cs) {
    return switch (this) {
      EventType.keynote => IconColorStyle(AppIcons.mic, cs.primary),
      EventType.keynoteSpeaker => IconColorStyle(AppIcons.mic, cs.primary),
      EventType.workshop => IconColorStyle(AppIcons.workshop, cs.secondary),
      EventType.sessions => IconColorStyle(AppIcons.sessions, cs.tertiary),
      EventType.paper => IconColorStyle(AppIcons.article, cs.primary),
      EventType.poster => IconColorStyle(AppIcons.slideshow, cs.secondary),
      EventType.symposium => IconColorStyle(AppIcons.forum, cs.tertiary),
      EventType.icedTalks => IconColorStyle(
        AppIcons.recordVoiceOver,
        cs.primary,
      ),
      EventType.doctoralColloquium => IconColorStyle(
        AppIcons.workspacePremium,
        cs.secondary,
      ),
      EventType.collaborativeSpace => IconColorStyle(
        AppIcons.collections,
        cs.tertiary,
      ),
      EventType.break_ => IconColorStyle(AppIcons.coffee, cs.outline),
      EventType.opening => IconColorStyle(AppIcons.celebration, cs.primary),
      EventType.closing => IconColorStyle(AppIcons.flag, cs.primary),
      EventType.gala => IconColorStyle(AppIcons.wineBar, cs.tertiary),
      EventType.welcome => IconColorStyle(AppIcons.wavingHand, cs.tertiary),
      EventType.registration => IconColorStyle(
        AppIcons.registration,
        cs.secondary,
      ),
      EventType.instructions => IconColorStyle(AppIcons.info, cs.secondary),
      EventType.internationalPanel => IconColorStyle(
        AppIcons.language,
        cs.tertiary,
      ),
      EventType.presidents => IconColorStyle(
        AppIcons.workspacePremium,
        cs.primary,
      ),
      EventType.unknown => IconColorStyle(AppIcons.event, cs.secondary),
    };
  }
}
