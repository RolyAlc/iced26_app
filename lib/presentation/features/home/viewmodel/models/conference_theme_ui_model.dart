/// Modelo de presentación de un tema de la conferencia.
///
/// Todos los strings están pre-resueltos al locale por defecto.
/// [readMinutes] se calcula una sola vez en el viewmodel.
class ConferenceThemeUIModel {
  const ConferenceThemeUIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.topics,
    required this.readMinutes,
  });

  final String id;
  final String name;
  final String description;
  // Lista de tópicos ya filtrada (sin entradas vacías).
  final List<String> topics;
  // Tiempo estimado de lectura en minutos (mínimo 1, máximo 99).
  final int readMinutes;
}
