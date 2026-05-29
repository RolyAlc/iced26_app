import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir un valor dinámico en una instancia de 'I18nStr'.
class I18nMapper {
  /// Transforma un dynamic en un objeto 'I18nStr'
  static I18nStr fromRaw(dynamic value) {
    if (value is Map) {
      final Map<String, String> result = {};

      for (var entry in value.entries) {
        final String key = entry.key.toString();
        final String val = entry.value?.toString() ?? '';

        result[key] = val;
      }

      return I18nStr(result);
    }

    if (value is String) {
      return I18nStr({'und': value});
    }

    return I18nStr({});
  }
}
