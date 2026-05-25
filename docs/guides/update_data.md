---
version: 1.1.0
status: activo
last_updated: 2026-05-25
icon: lucide/file-json
tags: [guia, datos, actualizacion, congreso]
audience: organizador
---

# Actualizar los datos del congreso

Esta guía explica cómo preparar la app para una nueva edición del congreso.

## 1. De dónde vienen los datos

La app no gestiona los datos directamente. Existe un **repositorio externo** que genera el fichero `app_data.json` con toda la información del congreso (programa, presentaciones, salas, temas, etc.).

La app solo lee ese fichero — no lo edita ni lo genera.

## 2. El fichero de datos

Una vez generado, el fichero debe colocarse en:

```bash
assets/data/app_data.json
```

La app lo lee al **primer arranque** y lo persiste en la base de datos local del dispositivo. Si el fichero cambia, los cambios se aplican la próxima vez que la app se instala desde cero o tras un borrado de datos.

> La estructura completa del fichero está documentada en [Contrato de datos](../generated/contract.md).

## 3. Qué ocurre con los datos del usuario

Al instalar la nueva edición, los datos personales del usuario se tratan de forma diferente según su tipo:

| Dato                         | Qué ocurre   | Por qué                                     |
| ---------------------------- | ------------ | ------------------------------------------- |
| **Notas del diario**         | Se conservan | Son personales y no dependen del programa   |
| **Favoritos (eventos)**      | Se eliminan  | Los IDs del programa anterior ya no existen |
| **Presentaciones guardadas** | Se eliminan  | Ídem                                        |

> La lógica de detección de nueva edición compara el campo `event_id` del JSON nuevo con el guardado. Si difieren, limpia favoritos y presentaciones. Ver [ADR-0007](../architecture/adr/0007_migracion_datos_nueva_edicion.md) para más detalles.

## 4. Pasos para publicar una nueva edición

1. Obtener el fichero `app_data.json` generado por el repositorio externo.
2. Reemplazar `assets/data/app_data.json` con el fichero nuevo.
3. Verificar que el JSON es válido (cualquier validador online sirve).
4. Recompilar la app.
