---
version: 1.0.0
status: activo
last_updated: 2026-05-26
icon: lucide/square-terminal
tags: [comandos]
---

<!-- TOOD: Añadir script para que el dev siguiente no tenga que recordarselo -->

# Comandos utiles

## 1. Iniciar la app

```bash
# Para descargar las dependencias
flutter pub get

# Para iniciar la app
flutter run

# Para iniciar la app, desinstalando primero la app
flutter run --uninstall-first

# Para limpiar el proyecto (opcional)
flutter clean

# Para generar los iconos de la app.
# Se debe de asegurar que el pubspec.yaml tenga
# la configuración correcta y el logo en assets.
flutter pub run flutter_launcher_icons
```

## 2. Formatear mediante dart

```bash
# Formatear code by dart
dart format .
# Analizar code by dart
dart analyze .
# Generar drift code
dart run build_runner build --delete-conflicting-outputs
# Comando junto
dart format . && dart analyze .
```

## 3. Activar la documenación

```bash
# La documentación esta hecha en Zensical
# Para mayor información consultar a su pagina web oficial
# Flujo
# Eliminar entorno (en caso de q lo precise)
uv rm -f .venv

# Crear entorno
uv venv

# Instalar dependencias
uv sync

# Iniciar la documenación
zensical serve
```

## 4. Comandos recomendados de desarrollo

```bash
# Hot Reload
r
# Hot Restart
R
```

## 5. Flujo recomendablde trabajo

### 5.1. Desarrollo normal

```bash
flutter pub get
dart run build_runner watch --delete-conflicting-outputs
flutter run
```

### 5.2. Antes de subir cambios

```bash
dart format .
dart analyze .
```

### 5.3. Si algo falla de forma extraña

```bash
flutter clean
flutter pub get
flutter run --uninstall-first
# En todo caso, se recomienda borrar la aplicación del dispositivo físico.
```