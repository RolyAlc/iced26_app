import 'package:iced26/core/errors/result.dart';

/// Contrato genérico para cualquier lista de IDs vistos recientemente.
abstract class RecentlyViewedRepository {
  /// Devuelve la lista de IDs, del más reciente al más antiguo.
  Future<Result<List<String>>> getAll();

  /// Añade [id] al tope de la lista, elimina duplicados y aplica el límite.
  /// Devuelve la lista actualizada para que el notifier no necesite releer disco.
  Future<Result<List<String>>> add(String id);

  /// Limpia todo el historial.
  Future<Result<void>> clearAll();
}
