/// Estados lógicos de un evento basados en su tiempo de ejecución.
enum EventStatus {
  live, // El evento está ocurriendo ahora mismo.
  next, // El evento ocurrirá en el futuro.
  ended, // El evento ya ha finalizado.
}
