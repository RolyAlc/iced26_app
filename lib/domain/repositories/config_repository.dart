import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/conference_config.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Contrato para la configuración global y el estado del sistema.
abstract class ConfigRepository {
  /// Inicializa los datos si es necesario.
  ///
  /// Devuelve `true` si se sincronizó una nueva edición, `false` si no hubo cambios.
  Future<Result<bool>> initializeDataIfNeeded();

  /// Obtiene la configuración del tema.
  Future<Result<ThemeConfig?>> getThemeConfig();

  /// Obtiene los metadatos escalares de la edición del congreso.
  Future<Result<ConferenceConfig?>> getConferenceConfig();
}
