import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir un valor dinámico en una instancia de 'I18nStr'.
class I18nMapper {
  /// Transforma un dynamic en un objeto 'I18nStr'
  static I18nStr fromRaw(dynamic value) {
    if (value is Map) {
      final Map<String, String> castedMap = value.map(
        (key, val) => MapEntry(key.toString(), val?.toString() ?? ''),
      );
      return I18nStr(castedMap);
    }

    if (value is String) {
      return I18nStr({'und': value});
    }

    return I18nStr({});
  }
}
