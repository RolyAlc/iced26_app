import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/domain/entities/metadata.dart';

/// Mapper para [Metadata]
abstract final class MetadataMapper {
  /// Crea un [Metadata] a partir de un mapa
  static Metadata fromMap(Map<String, dynamic> json) {
    return Metadata(
      eventId: json.getString('event_id'),
      version: json.getString('version'),
      generatedAt: json.getString('generated_at'),
    );
  }
}
