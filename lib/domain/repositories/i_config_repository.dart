import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Contrato para la configuración global y el estado del sistema.
abstract class IConfigRepository {
  /// Inicializa los datos si es necesario.
  Future<Result<void>> initializeDataIfNeeded();

  /// Obtiene la configuración del tema.
  Future<Result<ThemeConfig?>> getThemeConfig();
}
