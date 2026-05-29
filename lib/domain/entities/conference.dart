import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa la información de la conferencia.
class Conference {
  Conference({required this.name, required this.conferenceThemes});

  final I18nStr name;
  final List<ConferenceTheme> conferenceThemes;
}
