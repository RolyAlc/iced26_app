import 'package:iced26/domain/entities/i18n_str.dart';

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
}
