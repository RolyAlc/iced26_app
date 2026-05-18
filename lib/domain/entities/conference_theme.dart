import 'package:iced26/domain/entities/i18n_str.dart';

const _kWordsPerMinute = 200;

/// Un tema de la conferencia con su descripción y lista de tópicos.
class ConferenceTheme {
  ConferenceTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.topicsInclude,
  });

  final String id;
  final I18nStr name;
  final I18nStr description;
  final List<I18nStr> topicsInclude;

  /// Minutos estimados de lectura basados en descripción + tópicos (~200 wpm).
  int estimatedReadMinutes(String locale) {
    final descWords = description.resolve(locale).trim().split(RegExp(r'\s+'));
    final topicWords = topicsInclude
        .expand((t) => t.resolve(locale).trim().split(RegExp(r'\s+')))
        .toList();

    final totalWords = descWords.length + topicWords.length;
    final minutes = (totalWords + _kWordsPerMinute - 1) ~/ _kWordsPerMinute;

    // Mínimo 1 min (textos muy cortos). Máximo 99 para que el chip no desborde.
    return minutes.clamp(1, 99);
  }
}
