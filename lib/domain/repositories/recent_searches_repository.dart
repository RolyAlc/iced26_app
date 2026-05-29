import 'package:iced26/core/errors/result.dart';

/// Contrato para la gestión de búsquedas recientes.
abstract class RecentSearchesRepository {
  /// Obtiene la lista de búsquedas recientes.
  Future<Result<List<String>>> getRecentSearches();

  /// Añade una búsqueda a la lista, gestionando duplicados y límites.
  Future<Result<void>> addSearch(String query);

  /// Elimina una búsqueda específica.
  Future<Result<void>> removeSearch(String query);

  /// Limpia todo el historial.
  Future<Result<void>> clearAll();
}
