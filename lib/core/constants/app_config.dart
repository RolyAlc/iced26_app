/// Constantes de edición del congreso.
/// Cambiar de edición = modificar solo este fichero.
abstract final class AppConfig {
  static const String edition = 'ICED26';
  static const String title = 'ICED26';
  static const String welcomeLabel = 'Welcome to ICED26';
  static const String websiteUrl = 'https://iced26.es';
  static const String websiteLabel = 'iced26.es';

  // Rango de fechas navegables — coincide con el período del congreso.
  static final DateTime firstDay = DateTime(2025, 1, 1);
  static final DateTime lastDay = DateTime(2027, 12, 31);
}
