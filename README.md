---
version: 1.1.1
status: activo
last_updated: 2026-05-26
tags: [README, presentation]
---

# ICED26 — Aplicación para el congreso ICED26

Aplicación móvil para el congreso **ICED26** (International Conference on Engineering Design 2026), desarrollada en Flutter.

Funciona sin conexión: todos los datos están empaquetados en la app.

## 1. ¿Qué puede hacer el usuario?

| Pantalla        | Descripción                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| **Home**        | Ponentes destacados, noticias, actividades sociales y temáticas del congreso |
| **Schedule**    | Programa completo por día, filtros por tipo de sesión                        |
| **My Schedule** | Sesiones y presentaciones marcadas como favoritas                            |
| **Search**      | Búsqueda de eventos y ponentes con filtros avanzados                         |
| **Diary**       | Notas personales con calendario y etiquetas de estado de ánimo               |
| **Settings**    | Tamaño de texto, tema visual (claro/oscuro/sistema)                          |

## 2. Stack tecnológico

| Qué                         | Con qué                               |
| --------------------------- | ------------------------------------- |
| **Framework**               | Flutter 3 y Dart 3                    |
| **Estado**                  | Riverpod 3 (con generación de código) |
| **Base de datos local**     | Drift (SQLite)                        |
| **Datos de la conferencia** | JSON empaquetado en assets            |
| **Persistencia de usuario** | Drift + SharedPreferences             |
| **Documentación**           | Zensical (`zensical serve`)           |

## 3. Requisitos previos

- **Flutter SDK** `^3.11.4` (incluye Dart — no es necesario instalarlo por separado)
- Android Studio o Xcode (según plataforma destino)

## 4. Cómo arrancar

```bash
# 1. Clonar el repositorio
git clone <url-del-repo>
cd iced26

# 2. Instalar dependencias
flutter pub get

# 3. Generar código automático (Riverpod + Drift)
dart run build_runner build --delete-conflicting-outputs

# 4. Arrancar la app
flutter run
```

> Los ficheros `*.g.dart` son generados automáticamente. No los edites a mano.

## 5. Estructura del proyecto

```bash
lib/
  core/          > constantes, tokens de diseño, errores, extensiones
  data/          > implementaciones de repositorios, mappers, fuentes de datos
  domain/        > entidades, contratos de repositorios, casos de uso
  di/            > proveedores Riverpod (inyección de dependencias)
  presentation/  > UI: vistas, viewmodels, widgets compartidos

assets/
  data/          > app_data.json (datos del congreso)
  brand/         > logo e imágenes de marca
  speakers/      > fotos de ponentes

docs/            > documentación del proyecto (ver zensical.toml)
tools/           > scripts de utilidad (smell_checker, generador de estructura)
```

## 6. Documentación

```bash
# Ver la documentación en el navegador
zensical serve
```

O consulta directamente los ficheros en `docs/`.

## 7. Scripts útiles

```bash
# formatear y analizar
dart format . && dart analyze .
```
