---
version: 1.1.0
status: activo
last_updated: 2026-05-25
icon: lucide/rocket
tags:
  - onboarding
  - setup
  - beginner
audience: principiante
---

# Guía de inicio rápido

> Para quien llega nuevo al proyecto. No se asume experiencia previa en Flutter.

## 1. ¿Qué es esta app?

**ICED26** es la aplicación del congreso de ingeniería de diseño **ICED 2026**.

Muestra el **programa**, los **ponentes**, **noticias** y permite al asistente llevar su propio horario personalizado y un **diario de notas**.

**Funciona completamente sin internet.** No hay servidor. Todos los datos del congreso vienen dentro de la propia aplicación en un fichero JSON.

## 2. Requisitos

Antes de arrancar es necesario tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.11.4`
- Un editor: [VS Code](https://code.visualstudio.com/) con la extensión Flutter, o Android Studio
- Un dispositivo o emulador Android / iOS

Para verificar que Flutter está correctamente instalado:

```bash
flutter doctor
```

> Todos los elementos deben aparecer en verde (o con advertencias menores).

## 3. Primeros pasos

Se muestran los comandos básicos para arrancar la app por primera vez.

```bash
# 1. Clonar el repositorio
git clone <url-del-repo>
cd iced26

# 2. Instalar dependencias
flutter pub get

# 3. Generar código automático
#    Necesario la primera vez y cada vez que se modifiquen modelos o providers
dart run build_runner build --delete-conflicting-outputs

# 4. Arrancar la app
flutter run
```

> **¿Qué son los ficheros `.g.dart`?**
>
> Son ficheros generados automáticamente por `riverpod_generator` y `drift_dev`.
>
> El paso 3 los crea. **No se deben editar a mano** — se sobreescriben en cada build.

## 4. Estructura del proyecto

```bash
lib/
├── core/           > constantes globales, tokens de diseño, extensiones, errores
├── data/           > implementaciones concretas: mappers, repositorios, BD, JSON
├── domain/         > el núcleo del negocio: entidades, contratos, casos de uso
├── di/             > inyección de dependencias con Riverpod
└── presentation/   > todo lo que ve el usuario: vistas, viewmodels, widgets

assets/
├── data/           > app_data.json (datos del congreso)
├── brand/          > logo y recursos de marca
└── speakers/       > fotos de ponentes

docs/               > esta documentación
tools/              > scripts de utilidad (smell_checker, generador de estructura)
```

> **La regla de oro de las capas:** las capas superiores pueden usar las inferiores, nunca al revés. `domain` no sabe que existe SQLite. `presentation` no sabe que existe un repositorio concreto.

## 5. ¿Por dónde sigo?

| Quiero entender...                           | Documento                                               |
| -------------------------------------------- | ------------------------------------------------------- |
| Cómo se organizan las capas del proyecto     | [Arquitectura y capas](../architecture/layers.md)       |
| Cómo llegan los datos del JSON a la pantalla | [Flujo de datos](../architecture/data_flow.md)          |
| Cómo funciona Riverpod en este proyecto      | [Inyección de dependencias](../architecture/di.md)      |
| Las convenciones de código del equipo        | [Convenciones](conventions.md)                          |
| Los comandos del día a día                   | [Comandos útiles](commands.md)                          |
| Las decisiones de arquitectura tomadas       | [ADRs](../architecture/adr/0001_usar_pattern_result.md) |
| Los tokens visuales del design system        | [Sistema de diseño](../architecture/design_system.md)   |
| El contrato oficial del JSON                 | [Contrato técnico](../generated/contract.md)            |
| Cómo publicar la app en las tiendas          | [Publicación en tiendas](publish_stores.md)             |
