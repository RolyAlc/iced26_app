# ADR 001: Uso del Patrón Result Híbrido

## 1. Estatus

- [x] Aceptado
  - :: 19/04/2026
- [x] Implementado
  - :: 19/04/2026

## 2. Contexto

Necesitamos una forma consistente de manejar errores que cumpla los siguientes requisitos:

- **Desacoplamiento**: La lógica de negocio (Domain) y datos (Data) no deben depender de frameworks de UI o estado (como Riverpod).
- **Explicitud**: Los errores no deben ser "sorpresas" (excepciones no capturadas), sino parte del contrato de las funciones.
- **Ergonomía en Flutter**: El manejo de errores en la UI debe ser sencillo y aprovechar las herramientas nativas del ecosistema (como `AsyncValue`).

## 3. Decisión

Se implementará un **Patrón Result Híbrido**.

- **Capas de Data y Domain**: Se utiliza una clase sellada (`sealed class Result<T>`) con dos estados: `Success` (con datos) y `Failure` (con un mensaje de error). Esto asegura que los UseCases y Repositorios tengan contratos claros.
- **Capa de Presentation**: Los ViewModels (Providers) son los encargados de "traducir" el `Result` al estado de la UI.
  - Se transformará el `Result` a un flujo de datos que Riverpod expone como `AsyncValue`.
  - En caso de `Failure`, se lanzará una excepción dentro del Provider para que Riverpod lo capture y lo gestione mediante el estado `.error`.

## 4. Consecuencias

### 4.1. Positivas

- **Contratos fuertes**: Al mirar un método, se sabe inmediatamente que puede fallar sin tener que leer toda la implementación.
- **Seguridad en compilación**: Gracias a las `sealed classes`, el compilador obliga a manejar tanto el éxito como el error en los ViewModels.
- **Testeos simplificados**: Es extremadamente fácil mockear errores en los tests de los UseCases sin lidiar con excepciones complejas.
- **UI limpia**: La UI sigue usando el estándar `.when(data, error, loading)` de Riverpod, sin saber que debajo existe un patrón `Result`.

### 4.2. Negativas

- **Boilerplate**: Requiere una pequeña cantidad de código extra en los Repositorios y UseCases para envolver los resultados.
- **Curva de aprendizaje**: Los desarrolladores nuevos deben entender que los errores se devuelven, no solo se lanzan.

## 5. Ejemplo de uso

### 5.1. Repositorio/UseCase

En el repositorio se envuelve el código que puede lanzar excepciones con un bloque `try-catch`.
Dentro del `try`, si la operación es exitosa, se envuelve el resultado en un objeto `Success`.
En el `catch`, se atrapa cualquier excepción y se envuelve en un objeto `Failure` con un mensaje descriptivo.

```dart
Future<Result<List<Event>>> execute() async {
  try {
    final data = await repo.getData();
    return Success(data);
  } catch (e) {
    return Failure('Error al cargar eventos: $e');
  }
}
```

### 5.2. ViewModel (Traducción)

El ViewModel recibe el `Result` del UseCase y lo convierte en un `AsyncValue` para que la UI pueda consumirlo.  

```dart
final result = await useCase.execute();
return switch (result) {
  Success(data: final data) => data,
  Failure(message: final msg) => throw msg, // Riverpod lo convierte a AsyncError
};
```
