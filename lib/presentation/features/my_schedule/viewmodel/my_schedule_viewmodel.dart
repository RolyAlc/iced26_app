import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/models/my_schedule_display_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_schedule_viewmodel.g.dart';

/// Transforma la lista plana de [myScheduleItemsProvider] en grupos por día,
/// insertando una [MyScheduleDayHeader] con el conteo antes de cada grupo.
@riverpod
Future<List<MyScheduleDisplayItem>> myScheduleGrouped(Ref ref) async {
  final items = await ref.watch(myScheduleItemsProvider.future);

  final Map<DateTime, List<MyScheduleItem>> byDay = {};
  final List<MyScheduleItem> unscheduled = [];

  for (final item in items) {
    final t = item.sortTime;
    if (t == null) {
      unscheduled.add(item);
    } else {
      byDay.putIfAbsent(DateTime(t.year, t.month, t.day), () => []).add(item);
    }
  }

  return [
    for (final entry in byDay.entries) ...[
      MyScheduleDayHeader(date: entry.key, count: entry.value.length),
      ...entry.value.map(MyScheduleRow.new),
    ],
    if (unscheduled.isNotEmpty) ...[
      MyScheduleDayHeader(date: null, count: unscheduled.length),
      ...unscheduled.map(MyScheduleRow.new),
    ],
  ];
}
