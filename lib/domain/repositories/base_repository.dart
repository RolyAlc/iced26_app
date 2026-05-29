import 'package:iced26/core/errors/result.dart';

/// Contrato base que todos los repositorios deben respetar.
/// Usa el tipo genérico [T] para la entidad que maneja.
abstract interface class BaseRepository<T> {
  /// Obtiene todos los elementos disponibles.
  Future<Result<List<T>>> getAll();

  /// Obtiene un elemento por su identificador único.
  Future<Result<T>> getById(String id);
}
