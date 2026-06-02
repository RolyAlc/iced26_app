/// Tipos de evento definidos en el contrato de datos (pipeline v3.2).
/// Ante un valor desconocido se usa [unknown] — nunca lanza excepción.
enum EventType {
  registration,
  instructions,
  workshop,
  sessions,
  keynote,
  keynoteSpeaker,
  paper,
  poster,
  symposium,
  icedTalks,
  doctoralColloquium,
  collaborativeSpace,
  break_,
  welcome,
  opening,
  closing,
  gala,
  presidents,
  internationalPanel,
  unknown;

  static EventType fromString(String? value) => switch (value) {
    'registration' => registration,
    'instructions' => instructions,
    'workshop' => workshop,
    'sessions' => sessions,
    'keynote' => keynote,
    'keynote_speaker' => keynoteSpeaker,
    'paper' => paper,
    'poster' => poster,
    'symposium' => symposium,
    'iced_talks' => icedTalks,
    'doctoral_colloquium' => doctoralColloquium,
    'collaborative_space' => collaborativeSpace,
    'break' => break_,
    'welcome' => welcome,
    'opening' => opening,
    'closing' => closing,
    'gala' => gala,
    'presidents' => presidents,
    'international_panel' => internationalPanel,
    _ => unknown,
  };

  bool get isPresentation => switch (this) {
    paper ||
    poster ||
    icedTalks ||
    doctoralColloquium ||
    keynoteSpeaker ||
    workshop ||
    symposium ||
    internationalPanel => true,
    _ => false,
  };

  /// Valor original del JSON/DB. Usar al escribir en Drift o serializar.
  String get jsonValue => switch (this) {
    break_ => 'break',
    internationalPanel => 'international_panel',
    keynoteSpeaker => 'keynote_speaker',
    icedTalks => 'iced_talks',
    doctoralColloquium => 'doctoral_colloquium',
    collaborativeSpace => 'collaborative_space',
    unknown => '',
    _ => name,
  };

  /// Label legible para mostrar en UI.
  String get label => switch (this) {
    registration => 'Registration',
    instructions => 'Instructions',
    workshop => 'Workshop',
    sessions => 'Sessions',
    keynote => 'Keynote',
    keynoteSpeaker => 'Keynote Speaker',
    paper => 'Paper',
    poster => 'Poster',
    symposium => 'Symposium',
    icedTalks => 'ICED Talks',
    doctoralColloquium => 'Doctoral Colloquium',
    collaborativeSpace => 'Collaborative Space',
    break_ => 'Break',
    welcome => 'Welcome',
    opening => 'Opening',
    closing => 'Closing',
    gala => 'Gala',
    presidents => 'Presidents',
    internationalPanel => 'International Panel',
    unknown => '',
  };
}
