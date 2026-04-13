import 'package:iced26/domain/entities/metadata.dart';

/// Mapper para convertir el JSON de los metadatos en una instancia de 'Metadata'.
/// Devuelve un objeto 'Metadata' con los campos correctamente parseados.
class MetadataMapper {
  static Metadata fromMap(Map<String, dynamic> json) {
    // Extraemos con valores por defecto para evitar nulos
    final String eventId = json['event_id']?.toString() ?? '';
    final String version = json['version']?.toString() ?? '';
    final String generatedAt = json['generated_at']?.toString() ?? '';

    return Metadata(
      eventId: eventId,
      version: version,
      generatedAt: generatedAt,
    );
  }
}
