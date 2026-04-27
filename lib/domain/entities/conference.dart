import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa la información de la conferencia
class Conference {
  final I18nStr name;
  final List<I18nStr> conferenceThemes;

  Conference({required this.name, required this.conferenceThemes});
}
