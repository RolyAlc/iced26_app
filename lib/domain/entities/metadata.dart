/// Entidad que representa los metadatos de la aplicación
class Metadata {
  Metadata({
    required this.eventId,
    required this.version,
    required this.generatedAt,
  });
  final String eventId;
  final String version;
  final String generatedAt;
}
