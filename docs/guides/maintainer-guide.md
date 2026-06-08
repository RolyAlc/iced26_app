---
version: 1.0.0
status: activo
last_updated: 2026-06-08
icon: lucide/wrench
tags:
  - mantenimiento
  - upv
  - nueva-edicion
  - datos
audience: administración
---

# Guía de mantenimiento: UPV

Esta guía está dirigida a la persona encargada de mantener la aplicación en futuras ediciones del congreso.

Se contemplan dos situaciones:

- **Solo actualización de datos**: cambio del programa sin modificar el código.
- **Recompilación y publicación**: cuando hay cambios en el código o actualización de Flutter.

## 1. Requisitos previos

Antes de realizar cualquier cambio, asegúrate de disponer de:

- Flutter SDK instalado (`^3.11.4`) y añadido a la variable de entorno `PATH`
- Acceso al repositorio del proyecto
- Archivo `android/key.properties` con las claves de firma
- Acceso a Google Play Console para publicar en Android
- Mac con Xcode instalado si se va a publicar en iOS

Comprueba que el entorno está correctamente configurado:

```bash
flutter doctor
```

Todos los elementos necesarios deben aparecer en verde.

## 2. Actualizar únicamente los datos del programa

Este es el caso más habitual: cambia el programa, pero no el código.

### 2.1. Pasos

1. Descargar el archivo `app_data.json` desde el repositorio externo de datos.

2. Comprobar que el archivo JSON es válido en [jsonlint.com](https://jsonlint.com) u otra herramienta similar.

3. Sustituir el archivo en el proyecto:

   ```bash
   assets/data/app_data.json
   ```

4. Instalar dependencias y generar el código necesario:

   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

5. Probar la aplicación en un dispositivo o emulador antes de publicarla:

   ```bash
   flutter run --uninstall-first
   ```

   > El parámetro `--uninstall-first` fuerza a la aplicación a cargar el JSON desde cero, como si fuera una instalación nueva.

6. Si todo funciona correctamente, continuar con la sección 4 para generar la versión de producción.

## 3. Retoques de código

Si, además de los datos, se han realizado cambios en el código:

1. Instalar dependencias:

    ```bash
    flutter pub get
    ```

2. Regenerar el código automático si se han modificado modelos o proveedores:

    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

3. Comprobar que no hay errores:

    ```bash
    dart analyze .
    ```

4. Probar la aplicación en un dispositivo:

    ```bash
    flutter run
    ```

> Si aparecen errores difíciles de identificar, limpiar el proyecto y volver a probar:
>
> ```bash
> flutter clean && flutter pub get && flutter run --uninstall-first
> ```

## 4. Generar la versión de producción

Antes de compilar, incrementa el número de versión en `android/app/build.gradle`:

```gradle
versionCode <número anterior + 1>
versionName "x.y.z"
```

> `versionCode` debe ser siempre mayor que el publicado en Google Play. En caso contrario, la subida será rechazada.

### 4.1. Android

```bash
flutter build appbundle --release
# Resultado: build/app/outputs/bundle/release/app-release.aab
```

### 4.2. iOS (requiere Mac con Xcode)

```bash
flutter build ipa --release
# Resultado: build/ios/ipa/iced26.ipa
```

> Ambos comandos requieren el archivo `android/key.properties` correctamente configurado. Ver [Identidad de la aplicación](app_identity.md).

## 5. Publicación en Google Play

1. Accede a [Google Play Console](https://play.google.com/console).
2. Selecciona la aplicación ICED26.
3. Entra en **Producción → Crear nueva versión**.
4. Sube el archivo `.aab` generado en el paso anterior.
5. Añade las notas de la versión (cambios realizados).
6. Envía la versión para revisión.

> El proceso completo con capturas y lista de comprobación está en [Publicación en tiendas](publish_stores.md).

```md id="zq71ab"
## 6. Qué datos controla la UPV y qué controla el código

| Elemento                      | Quién lo gestiona | Cómo                                          |
| ----------------------------- | ----------------- | --------------------------------------------- |
| Programa (sesiones, ponentes) | UPV               | Archivo `app_data.json`                       |
| Noticias y avisos             | UPV               | Archivo `app_data.json`                       |
| Textos de la interfaz         | Equipo técnico    | Archivos `lib/l10n/app_es.arb` / `app_en.arb` |
| Colores, tipografía, iconos   | Equipo técnico    | `lib/presentation/app/theme/`                 |
| Lógica de la aplicación       | Equipo técnico    | `lib/`                                        |
| Publicación en tiendas        | Ambos             | Google Play Console / App Store Connect       |

## 7. Resolución de problemas

**El JSON no carga o la aplicación aparece vacía**
Comprueba que el archivo `assets/data/app_data.json` existe y contiene un JSON válido. Revisa que está declarado en `pubspec.yaml` dentro de `assets`. Vuelve a instalar la aplicación con `flutter run --uninstall-first`.

**El proceso de compilación falla por un problema de firma**
Comprueba que el archivo `android/key.properties` existe y apunta al archivo de firma correcto. Este archivo no está en el repositorio por motivos de seguridad: debe solicitarse al equipo técnico.

**`dart run build_runner` falla por conflictos**
Ejecuta el comando con el parámetro `--delete-conflicting-outputs`. Si el problema continúa, limpia el proyecto con `flutter clean` y vuelve a intentarlo.

**Google Play rechaza el archivo `.aab`**
Comprueba que `versionCode` es superior al de la versión publicada. Verifica también que la firma de la aplicación es correcta.

**La aplicación se cierra al iniciar tras actualizar el JSON**
El archivo JSON contiene un error de formato o falta algún campo obligatorio. Valídalo en [jsonlint.com](https://jsonlint.com) y compáralo con el [contrato de datos](../generated/contract.md).

## 8. Contacto técnico

Para dudas sobre el código, la arquitectura o el proceso de publicación, contacta con el equipo de desarrollo original del proyecto.
```
