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
            role: s['role']?.toString(),
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
}
