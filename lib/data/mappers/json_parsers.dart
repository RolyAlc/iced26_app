import 'dart:convert';

import 'package:iced26/domain/entities/speaker_entry.dart';

/// Parsers de JSON
abstract final class JsonParsers {
  /// Parsea una lista de [SpeakerEntry] a partir de un [String] que contiene un JSON.
  static List<SpeakerEntry> parseSpeakers(String? json) {
    if (json == null) {
      return const [];
    }
    return (jsonDecode(json) as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(
          (s) => SpeakerEntry(
            personId: s['personId']?.toString() ?? '',
            isPresenter: s['isPresenter'] as bool?,
          ),
        )
        .where((s) => s.personId.isNotEmpty)
        .toList();
  }

  /// Parsea una lista de [String] a partir de un [String] que contiene un JSON.
  static List<String> parseStringList(String? json) {
    if (json == null) {
      return const [];
    }
    return (jsonDecode(json) as List<dynamic>).cast<String>();
  }

  /// Parsea una lista de [SpeakerEntry] a partir de un valor raw del JSON.
  static List<SpeakerEntry> rawSpeakers(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(
          (s) => SpeakerEntry(
            personId: s['personId']?.toString() ?? s['id']?.toString() ?? '',
            isPresenter: s['isPresenter'] as bool?,
          ),
        )
        .where((s) => s.personId.isNotEmpty)
        .toList();
  }

  /// Parsea una lista de [String] a partir de un valor raw del JSON.
  static List<String> rawStringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).toList();
  }

  /// Parsea una fecha ISO 8601 a [DateTime] local.
  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  /// Formatea una hora como HH:mm.
  static String formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formatea un rango horario como "HH:mm–HH:mm". Retorna solo el inicio si [end] es null.
  static String? formatFilterTime(DateTime? start, DateTime? end) {
    if (start == null) return null;
    final startLabel = formatTime(start);
    if (end == null) return startLabel;
    return '$startLabel–${formatTime(end)}';
  }
}
