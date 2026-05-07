enum TextSizePreference {
  small(0.85),
  medium(1.0),
  large(1.15),
  xl(1.3);

  const TextSizePreference(this.scaleFactor);

  final double scaleFactor;

  String get label {
    return switch (this) {
      TextSizePreference.small => 'S',
      TextSizePreference.medium => 'M',
      TextSizePreference.large => 'L',
      TextSizePreference.xl => 'XL',
    };
  }
}
