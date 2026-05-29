import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una zona de la conferencia
class Zone {
  Zone({
    required this.id,
    required this.name,
    required this.lang,
    required this.description,
  });
  final String id;
  final I18nStr name;
  final String? lang;
  final I18nStr description;
}
