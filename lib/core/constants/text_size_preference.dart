enum TextSizePreference {
  small(0.85),
  medium(1.0),
  large(1.15),
  xl(1.3);

  const TextSizePreference(this.scaleFactor);

  final double scaleFactor;

  // Etiqueta corta para usos compactos (chips, badges).
  String get label {
    return switch (this) {
      TextSizePreference.small => 'S',
      TextSizePreference.medium => 'M',
      TextSizePreference.large => 'L',
      TextSizePreference.xl => 'XL',
    };
  }

  // Nombre completo para el picker y subtítulos.
  String get displayName {
    return switch (this) {
      TextSizePreference.small => 'Small',
      TextSizePreference.medium => 'Medium',
      TextSizePreference.large => 'Large',
      TextSizePreference.xl => 'Extra Large',
    };
  }
}
