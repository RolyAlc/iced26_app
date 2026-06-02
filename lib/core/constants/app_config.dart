/// Constantes de edición del congreso.
abstract final class AppConfig {
  // Identificador corto — usado como título de la app Flutter.
  static const String title = 'ICED26';
  // Nombre de display — usado en textos visibles al usuario.
  static const String edition = 'ICED 26';
  static const String location = 'Salamanca, Spain';
  static const String welcomeLabel = 'Welcome to ICED26';
  static const String websiteUrl = 'https://iced26.es';
  static const String websiteLabel = 'iced26.es';
  static const String portalApiBaseUrl = String.fromEnvironment(
    'PORTAL_API_BASE_URL',
    defaultValue: 'https://iced26-app-portal-production.up.railway.app/api',
  );
  // Idioma por defecto del congreso — usado para resolver textos i18n en viewmodels.
  static const String defaultLocale = 'en';

  // Rango de fechas navegables — coincide con el período del congreso.
  static final DateTime firstDay = DateTime(2025);
  static final DateTime lastDay = DateTime(2027, 12, 31);
}
