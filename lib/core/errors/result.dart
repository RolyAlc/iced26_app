/// Implementación del patrón Result.
sealed class Result<T> {
  const Result();
}

/// [Success] representa un resultado exitoso.
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// [Failure] representa un resultado fallido.
class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}
