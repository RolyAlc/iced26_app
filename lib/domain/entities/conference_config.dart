/// Metadatos escalares de la edición del congreso.
///
/// Análogo a [ThemeConfig]: contiene solo la configuración de la edición
/// (nombre, lema, lugar, fechas, web) sin las colecciones de temas.
class ConferenceConfig {
  const ConferenceConfig({
    required this.name,
    required this.tagline,
    required this.location,
    required this.dates,
    required this.websiteUrl,
    required this.defaultLocale,
  });

  final String name;
  final String tagline;
  final String location;
  final String dates;
  final String websiteUrl;
  final String defaultLocale;

  String get websiteLabel => websiteUrl.replaceFirst(RegExp(r'https?://'), '');
}
