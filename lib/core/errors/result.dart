/// Implementación del patrón Result.
sealed class Result<T> {
  const Result();
}

/// [Success] representa un resultado exitoso.
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// [Failure] representa un resultado fallido.
class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
