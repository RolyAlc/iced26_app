import 'package:flutter_test/flutter_test.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';

void main() {
  test(
    'mergeSchedule keeps static app data and injects root schedule payload',
    () {
      final base = AppData.empty();
      final merged = AppDataMapper.mergeSchedule(
        base: base,
        scheduleJson: {
          'events': [
            {
              'id': 'event-1',
              'title': 'Opening session',
              'type': 'session',
              'startDate': '2026-08-30T09:00:00.000Z',
              'endDate': '2026-08-30T10:00:00.000Z',
            },
          ],
          'sessionBlocks': [
            {'id': 'block-1', 'parentId': 'event-1'},
          ],
          'speakers': [
            {'id': 'speaker-1', 'name': 'Ada Lovelace'},
          ],
          'rooms': [
            {'id': 'room-1', 'name': 'Main hall'},
          ],
        },
      );

      expect(merged.metadata.eventId, base.metadata.eventId);
      expect(merged.collections.events, hasLength(1));
      expect(merged.collections.events.single.id, 'event-1');
      expect(merged.collections.sessionBlocks, hasLength(1));
      expect(merged.collections.people, hasLength(1));
      expect(merged.collections.rooms, hasLength(1));
    },
  );

  test(
    'mergeSchedule maps portal session block times onto scheduled talks',
    () {
      final merged = AppDataMapper.mergeSchedule(
        base: AppData.empty(),
        scheduleJson: {
          'events': [
            {
              'id': '82',
              'title': 'Poster session',
              'kind': 'poster session',
              'type': 'session',
              'start': '2026-06-24T16:15:00',
              'end': '2026-06-24T17:45:00',
              'isSession': true,
            },
            {
              'id': '398',
              'title': 'Quality and Impact of Peer Mentoring',
              'type': 'paper',
              'date': '2026-06-24',
              'start': '2026-06-24T00:00:00',
              'end': '2026-06-24T00:00:00',
              'duration': 0,
              'sessionId': '82',
            },
          ],
          'sessionBlocks': [
            {
              'id': '82',
              'date': '2026-06-24',
              'startTime': '2026-06-24T16:15:00',
              'endTime': '2026-06-24T17:45:00',
              'kind': 'poster session',
              'roomId': 'room-1',
            },
          ],
        },
      );

      final sessionBlock = merged.collections.sessionBlocks.single;
      final talk = merged.collections.events.firstWhere(
        (event) => event.id == '398',
      );

      expect(sessionBlock.parentId, '82');
      expect(sessionBlock.startDate, DateTime(2026, 6, 24, 16, 15));
      expect(sessionBlock.endDate, DateTime(2026, 6, 24, 17, 45));
      expect(talk.startDate, DateTime(2026, 6, 24, 16, 15));
      expect(talk.endDate, DateTime(2026, 6, 24, 17, 45));
      expect(talk.filterTime, '16:15–17:45');
      expect(talk.roomId, 'room-1');
    },
  );
}
