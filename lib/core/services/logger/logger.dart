import 'package:logger/logger.dart';

/// Creamos una instancia global siguiendo la documentación de pub.dev.
/// Añadimos instrucciones con 'PrettyPrinter' según nos convengan.
class AppLogger {
  static final Logger _logger = Logger(
    //filter: Environment.isDebug ? DevelopmentFilter() : ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0, // No ensucia la consola con el stacktrace
      errorMethodCount: 5, // Si hay un error, sí queremos ver qué pasó
      lineLength: 50, // Líneas más cortas, más legibles
    ),
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
