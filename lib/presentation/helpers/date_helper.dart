/// Utilidades para el manejo y formateo de fechas en la capa de presentación.
class DateHelper {
  /// Formatea una fecha en formato ISO (o similar) a un formato legible corto (ej: "Apr 27").
  /// Si la fecha no es válida, devuelve el string original.
  static String formatShortDate(String date) {
    final dt = DateTime.tryParse(date);
    if (dt == null) {
      return date;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[dt.month - 1]} ${dt.day}';
  }
}
