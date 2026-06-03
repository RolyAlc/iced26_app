import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Enriquece eventos con datos heredados de sus [SessionBlock] cuando el evento
/// no tiene horario propio (placeholder 00:00–00:00).
abstract final class EventEnricher {
  static List<Event> inheritSessionBlockTimes(
    List<Event> events,
    List<SessionBlock> sessionBlocks,
  ) {
    if (events.isEmpty || sessionBlocks.isEmpty) return events;

    final blocksById = {for (final block in sessionBlocks) block.id: block};

    return events.map((event) {
      final sessionId = event.sessionId;
      if (sessionId == null) return event;

      final block = blocksById[sessionId];
      if (block == null) return event;

      final needsTime = _needsSessionBlockTime(event);
      final resolvedRoomId = event.roomId ?? block.roomId;

      if (!needsTime) {
        return resolvedRoomId != event.roomId
            ? event.copyWith(roomId: resolvedRoomId)
            : event;
      }

      final inheritedStart = block.startDate;
      final inheritedEnd = block.endDate;
      final computedDuration = inheritedStart != null && inheritedEnd != null
          ? inheritedEnd.difference(inheritedStart).inMinutes
          : null;

      return event.copyWith(
        startDate: inheritedStart,
        endDate: inheritedEnd,
        roomId: resolvedRoomId,
        durationMin: computedDuration ?? event.durationMin,
      );
    }).toList();
  }

  static bool _needsSessionBlockTime(Event event) {
    final start = event.startDate;
    final end = event.endDate;
    if (start == null || end == null) return true;
    return start.hour == 0 &&
        start.minute == 0 &&
        end.hour == 0 &&
        end.minute == 0;
  }
}
