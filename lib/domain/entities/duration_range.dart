enum DurationRange {
  short, // ≤ 30 min
  medium, // 31–90 min
  long; // > 90 min

  bool matches(int minutes) {
    return switch (this) {
      DurationRange.short => minutes <= 30,
      DurationRange.medium => minutes > 30 && minutes <= 90,
      DurationRange.long => minutes > 90,
    };
  }

  static DurationRange fromMinutes(int minutes) {
    if (minutes <= 30) return DurationRange.short;
    if (minutes <= 90) return DurationRange.medium;
    return DurationRange.long;
  }
}
