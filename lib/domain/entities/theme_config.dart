/// Entidad que representa la configuración de tema de la aplicación
class ThemeConfig {
  final Map<String, String> colors;
  final Map<String, dynamic> typography;
  final Map<String, dynamic> logo;

  ThemeConfig({
    required this.colors,
    required this.typography,
    required this.logo,
  });
}
