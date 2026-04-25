/// Tipos de evento definidos en el contrato de datos (pipeline v3.2).
/// Ante un valor desconocido se usa [unknown] — nunca lanza excepción.
enum EventType {
  registration,
  instructions,
  workshop,
  sessions,
  keynote,
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
    'break' => break_,
    'welcome' => welcome,
    'opening' => opening,
    'closing' => closing,
    'gala' => gala,
    'presidents' => presidents,
    'international_panel' => internationalPanel,
    _ => unknown,
  };

  /// Valor original del JSON/DB. Usar al escribir en Drift o serializar.
  String get jsonValue => switch (this) {
    break_ => 'break',
    internationalPanel => 'international_panel',
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
