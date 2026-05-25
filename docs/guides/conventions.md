---
version: 1.0.0
status: activo
last_updated: 2026-05-25
icon: lucide/book-open-check
tags: [convenciones, codigo, estilo, dart, flutter]
audience: tecnico
---

# Convenciones de código

Reglas obligatorias en todo el proyecto. Su objetivo es que el código sea legible y coherente para cualquier persona del equipo, independientemente de su nivel.

---

## 1. Cuerpos de método siempre con llaves

No se usa la sintaxis de expression body (`=>`) en métodos ni getters. Siempre se usa el cuerpo completo con llaves y `return` explícito.

```dart
// Correcto
String get label {
  return _label.toUpperCase();
}

Widget build(BuildContext context) {
  return Text(label);
}

// Incorrecto
String get label => _label.toUpperCase();
Widget build(BuildContext context) => Text(label);
```

> La forma larga es más fácil de leer para quien llega al código por primera vez y facilita añadir lógica sin refactorizar.

---

## 2. Constantes privadas con prefijo `_k`

Las constantes locales de un fichero o clase se nombran con el prefijo `_k` (de *k*onstant, convención de Google). Esto las distingue visualmente de variables y parámetros.

```dart
// Correcto
const _kCardHeight = 80.0;
const _kAnimationDuration = Duration(milliseconds: 300);
const _kPadding = EdgeInsets.all(16);

// Incorrecto
const cardHeight = 80.0;
const double animDuration = 300;
```

---

## 3. Listas con `for` collection literal

En lugar de `.map().toList()` o `.where().toList()`, se usa `for` y `if` dentro de collection literals. Es más directo y no requiere importar nada.

```dart
// Correcto
final widgets = [
  for (final item in items) ItemWidget(item),
];

final visibles = [
  for (final item in items)
    if (item.isVisible) ItemWidget(item),
];

// Incorrecto
final widgets = items.map((item) => ItemWidget(item)).toList();
final visibles = items.where((item) => item.isVisible).map((item) => ItemWidget(item)).toList();
```

---

## 4. Comentarios solo explican el POR QUÉ

Un comentario nunca debe describir lo que hace el código (el código ya lo dice). Solo se añade cuando el motivo de una decisión no es obvio: restricciones del framework, workarounds, invariantes no evidentes.

```dart
// Correcto
ref.onDispose(db.close);
// Drift requiere cerrar explícitamente la conexión; sin esto, los tests de
// integración dejan ficheros de BD huérfanos en disco.

// Incorrecto
ref.onDispose(db.close); // cierra la base de datos
```

```dart
// Correcto
const _kActionButtonMinSize = 36.0;
// Intencionalmente por debajo del mínimo táctil M3 (48dp): la lista de
// sesiones es densa y el espacio es limitado — decisión de diseño aceptada.

// Incorrecto
const _kActionButtonMinSize = 36.0; // tamaño mínimo del botón de acción
```

---

## 5. Strings de UI en `AppStrings`

Ningún literal de texto visible para el usuario se escribe directamente en los widgets. Todos van a `lib/core/constants/app_strings.dart`.

```dart
// Correcto
Text(AppStrings.save)
Text(AppStrings.themeLight)

// Incorrecto
Text('Save')
Text('Light')
```

> Centralizar los strings facilita la búsqueda, los cambios de redacción y una futura internacionalización.

---

## 6. Patrón Result para errores

Los repositorios y casos de uso no lanzan excepciones. Devuelven `Result<T>`, que puede ser `Success(data)` o `Failure(message)`. Esto hace los errores explícitos en el tipo de retorno.

```dart
// Devolver un resultado
Future<Result<List<Event>>> getAllEvents() async {
  try {
    final rows = await _db.select(_db.events).get();
    return Success(rows.map(EventMapper.fromRow).toList());
  } catch (e) {
    return Failure(e.toString());
  }
}

// Consumir un resultado
final result = await useCase.execute();

return switch (result) {
  Success(data: final d) => HomeState.loaded(d),
  Failure(message: final m) => HomeState.error(m),
};
```

---

## 7. `dispose()` en `StatefulWidget` con `ChangeNotifier`

Cualquier `StatefulWidget` que cree un objeto que extienda `ChangeNotifier` (como `ExpansibleController`, `TextEditingController`, `AnimationController`) debe liberarlo en `dispose()`.

```dart
// Correcto
class _MyWidgetState extends State<MyWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose(); // evita memory leak
    super.dispose();
  }
}
```

> Sin `dispose()`, cada instancia del widget que sale del árbol deja un listener colgado — memory leak real y acumulativo.

---

## 8. Nomenclatura de ficheros y clases

Dart tiene convenciones estrictas que el proyecto respeta:

| Elemento | Convención | Ejemplo |
|---|---|---|
| Ficheros | `snake_case` | `home_view.dart`, `app_data_mapper.dart` |
| Clases y enums | `PascalCase` | `HomeView`, `AppDataMapper`, `EventStatus` |
| Miembros privados | prefijo `_` | `_controller`, `_isLoading` |
| Constantes locales | prefijo `_k` | `_kCardHeight`, `_kPadding` |
| Providers Riverpod | `camelCase` + sufijo `Provider` (generado) | `scheduleRepositoryProvider` |

## 9. Patrón `_buildXxx()` en `State`

Cuando `build()` supera las 20-25 líneas, se extrae lógica a métodos privados `Widget _buildXxx()` dentro de la misma clase `State`. Esto mantiene `build()` declarativo y legible sin crear widgets separados innecesariamente.

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
      _buildSaveButton(),
    ],
  );
}

Widget _buildHeader() {
  return Text(AppStrings.title, style: theme.titleLarge);
}
```

> Se usa `_buildXxx` cuando el fragmento es privado y específico de esa pantalla. Si el widget se reutiliza en otro sitio, se extrae a un fichero propio en `widgets/`.

## Resumen rápido

| Regla | Si | No |
|---|---|---|
| Cuerpo de métodos | `{ return x; }` | `=> x` |
| Constantes locales | `_kNombre` | `nombre`, `NOMBRE` |
| Listas | `[for (final x in list) ...]` | `.map().toList()` |
| Comentarios | explicar el POR QUÉ | describir el QUÉ |
| Strings UI | `AppStrings.clave` | `'texto literal'` |
| Errores | `Result<T>` | `throw Exception(...)` |
| Controladores | `dispose()` obligatorio | sin liberar |
