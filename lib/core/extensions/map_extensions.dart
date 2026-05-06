/// Extensiones para `Map<String, dynamic>`
extension MapX on Map<String, dynamic> {
  /// Obtiene un String de un mapa
  String getString(String key, [String fallback = '']) {
    return this[key]?.toString() ?? fallback;
  }

  /// Obtiene un String de un mapa
  String? getStringOrNull(String key) {
    return this[key]?.toString();
  }

  /// Obtiene un int de un mapa
  int? getInt(String key) {
    return (this[key] as num?)?.toInt();
  }

  /// Obtiene un mapa de un mapa
  Map<String, dynamic> getMap(String key) {
    final value = this[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const {};
  }

  /// Obtiene una lista de un mapa
  List getList(String key) {
    final value = this[key];
    return value is List ? value : const [];
  }
}
