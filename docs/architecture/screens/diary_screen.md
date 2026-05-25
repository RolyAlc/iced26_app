---
version: 1.0.0
status: activo
last_updated: 2026-05-25
icon: lucide/notebook-pen
tags: [pantalla, diary, calendario, notas]
audience: tecnico
---

# Pantalla Diary

Diario personal del asistente al congreso. Combina un calendario con notas de texto y eventos del programa en una sola vista.

## 1. Estructura general

```mermaid
graph TD
    DV["DiaryView\nConsumerWidget"]
    ERR["AppEmptyState\nerror"]
    STK["Stack"]
    AP["AppPage"]
    DH["DiaryHeader"]
    DB["DiaryBody\nConsumerStatefulWidget"]
    FAB["DiaryFab"]

    DV -->|"hasError"| ERR
    DV -->|"ok"| STK
    STK --> AP
    STK --> FAB
    AP --> DH
    AP --> DB
```

> `DiaryBody` gestiona el estado local de animación (`_slideDirection`) y los gestos de swipe horizontal.

## 2. Providers

| Provider                        | Tipo                                     | Qué expone                             |
| ------------------------------- | ---------------------------------------- | -------------------------------------- |
| `diaryNotesProvider`            | `AsyncValue<List<DiaryNote>>`            | Todas las notas del usuario (stream)   |
| `diaryConferenceEventsProvider` | `AsyncValue<Map<DateTime, List<Event>>>` | Eventos del congreso indexados por día |
| `selectedDiaryDateProvider`     | `DateTime`                               | Día seleccionado en el calendario      |
| `diaryFocusedMonthProvider`     | `DateTime`                               | Mes visible en el calendario           |
| `diaryCalendarFormatProvider`   | `CalendarFormat`                         | Formato semana / mes                   |

> Los cinco providers viven en `diary_viewmodel.dart`.

## 3. DiaryBody — composición

```mermaid
graph TD
    DB["DiaryBody"]
    CAL["AppCard + DiaryCalendar\n(TableCalendar)"]
    GES["GestureDetector\nonHorizontalDragEnd"]
    ANI["AnimatedSwitcher\nslide + fade"]
    DAY["DiaryDayContent\nkey: ValueKey(selectedDate)"]

    DB --> CAL
    DB --> GES
    GES --> ANI
    ANI --> DAY
```

> El `AnimatedSwitcher` usa un `SlideTransition` cuya dirección (`_slideDirection`) se calcula comparando el día nuevo con el actual antes de actualizar el estado.

## 4. DiaryDayContent

Muestra las notas y los eventos del día seleccionado en dos listas separadas.

- **Notas** — `DiaryNoteCard` con acciones de edición y borrado.
- **Eventos** — `DiaryEventTile` (solo lectura, vincula al programa del congreso).
- Si no hay nada para ese día se muestra un estado vacío inline.

## 5. Editor de notas (sheet)

`DiaryFab` abre `DiaryNoteEditorSheet` como bottom sheet. El sheet admite creación y edición.

Campos: título · contenido · etiqueta de ánimo (`MoodTag`) · color de fondo.

Las acciones de guardado y borrado van directamente a `saveDiaryNoteUseCaseProvider` y `deleteDiaryNoteUseCaseProvider`.

## 6. Flujo de navegación

```mermaid
flowchart LR
    A[DiaryFab.onPressed] --> B["DiaryNoteEditorSheet (AppBottomSheet)"]
    B --> C[guardar → saveDiaryNoteUseCase]
    C --> D[diaryNotesProvider se invalida]
    D --> E[UI reactiva]

    B --> F[borrar → deleteDiaryNoteUseCase]
    F --> D

```
