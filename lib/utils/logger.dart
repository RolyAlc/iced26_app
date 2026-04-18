import 'package:logger/logger.dart';

/// Creamos una instancia global siguiendo la documentación de pub.dev.
/// Añadimos instrucciones con 'PrettyPrinter' según nos convengan.
final logger = Logger(
  //filter: Environment.isDebug ? DevelopmentFilter() : ProductionFilter(),
  printer: PrettyPrinter(
    methodCount: 0, // No ensucia la consola con el stacktrace
    errorMethodCount: 5, // Si hay un error, sí queremos ver qué pasó
    lineLength: 50, // Líneas más cortas, más legibles
    colors: true, // Colores para identificar niveles
    printEmojis: true, // Emojis visuales
  ),
);
