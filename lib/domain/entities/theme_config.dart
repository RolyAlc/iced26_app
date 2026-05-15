/// Entidad que representa la configuración de tema de la aplicación
class ThemeConfig {
  ThemeConfig({
    required this.colors,
    required this.typography,
    required this.logo,
  });
  final Map<String, String> colors;
  final Map<String, dynamic> typography;
  final Map<String, dynamic> logo;
}
