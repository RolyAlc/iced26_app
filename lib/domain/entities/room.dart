import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una sala de la conferencia
class Room {
  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.zoneId,
    required this.sessionStyle,
  });

  final String id;
  final I18nStr name;
  final int? capacity;
  final String? zoneId;
  final String? sessionStyle;
}
