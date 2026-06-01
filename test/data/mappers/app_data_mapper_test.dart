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
}
