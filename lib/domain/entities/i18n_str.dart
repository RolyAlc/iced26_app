/// Entidad para manejar textos internacionales
class I18nStr {
  final Map<String, String> values;

  I18nStr(this.values);

  /// Método para obtener el texto según el idioma
  String resolve(String locale) {
    if (values.isEmpty) {
      return '';
    }

    // Intentamos el idioma solicitado, luego inglés, luego el primero disponible
    final String? requestedValue = values[locale];
    final String? fallbackEnglish = values['en'];

    return requestedValue ?? fallbackEnglish ?? values.values.first;
  }
}
