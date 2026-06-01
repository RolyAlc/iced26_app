---
version: 1.1.0
status: activo
last_updated: 2026-05-25
icon: lucide/palette
tags:
  - arquitectura
  - design-system
  - tokens
audience: tecnico
---

# Sistema de diseño

Diseño de la aplicación. Todos los valores siguen una rejilla de **8px** (con subdivisión de 4px). El fichero fuente de verdad es `lib/core/constants/design_tokens.dart`.

## 1. Espaciados: `AppSpacing`

| Token | Valor | Uso típico                                   |
| ----- | ----- | -------------------------------------------- |
| `xxs` | 2px   | Separaciones mínimas (bordes, gaps internos) |
| `xs`  | 4px   | Micro-ajustes, separación icono-texto        |
| `s`   | 8px   | Padding interno en elementos pequeños        |
| `sm`  | 12px  | Chips y etiquetas                            |
| `m`   | 16px  | Padding de página, separación estándar       |
| `l`   | 24px  | Separación entre secciones                   |
| `xl`  | 32px  | Márgenes en layouts complejos                |

## 2. Radios: `AppRadius`

| Token       | Valor | Aplicación                                 |
| ----------- | ----- | ------------------------------------------ |
| `s`         | 12px  | Inputs, mini-cards, widgets de detalle     |
| `m`         | 20px  | Tarjetas principales (Featured, News)      |
| `container` | 28px  | Cards y bottom sheets (M3 Spec)            |
| `l`         | 32px  | Elementos flotantes (SearchBar, NavBar)    |
| `full`      | 100px | Formas totalmente redondeadas (pills, FAB) |

## 3. Animaciones: `AppDuration`

| Token      | Valor | Contexto                                |
| ---------- | ----- | --------------------------------------- |
| `fast`     | 200ms | Ripples, snackbars, micro-interacciones |
| `medium`   | 300ms | Expansiones, cambios de estado          |
| `entrance` | 600ms | Transiciones de pantalla completa       |

## 4. Layout: `AppLayout`

| Token                           | Valor | Propósito                                                   |
| ------------------------------- | ----- | ----------------------------------------------------------- |
| `pageHeaderFallbackHeight`      | 142px | Altura base del header expandido                            |
| `searchBarHeaderFallbackHeight` | 70px  | Altura del header colapsado                                 |
| `navBarHeight`                  | 72px  | Altura de la barra de navegación inferior                   |
| `navBarBottomClearance`         | 4px   | Gap entre la navBar y la barra de gestos del sistema        |
| `navBarClearanceFallback`       | 120px | Margen inferior para no tapar contenido (72 + 24 + 4 + 20)  |
| `maxContentWidth`               | 750px | Ancho máximo del área de contenido (centrado en tablet/web) |

> `AppLayout.horizontalPadding(context)` es una función adaptativa: devuelve `s` en pantallas < 360px, `m` en < 600px y `l` en el resto.

## 5. Elevación: `AppElevation`

M3 usa color tonal para jerarquía visual; la sombra se reserva solo para elementos flotantes.

| Token  | Valor | Uso                                     |
| ------ | ----- | --------------------------------------- |
| `none` | 0     | Estilo M3 flat (por defecto)            |
| `low`  | 2     | Elementos que se superponen ligeramente |

## 6. Tipografía complementaria

`AppTextSize` y `AppTextStyle` complementan `theme.textTheme` para casos puntuales.

| Clase          | Token                | Valor | Uso                                                               |
| -------------- | -------------------- | ----- | ----------------------------------------------------------------- |
| `AppTextSize`  | `chip`               | 12px  | Chips y badges (fuera del `textTheme`)                            |
| `AppTextStyle` | `labelLetterSpacing` | 0.8   | Labels de sección en mayúsculas (`labelSmall`/`labelMedium` bold) |

## 7. Opacidades: `AppOpacity`

| Token         | Valor | Uso                                               |
| ------------- | ----- | ------------------------------------------------- |
| `placeholder` | 0.75  | Contenido pendiente de carga (shimmer, skeletons) |

## 8. Colores fijos: `AppOverlayColors`

Colores que no siguen el tema. Se usan sobre imágenes o superficies donde el contraste está garantizado por el contexto visual.

| Token                    | Valor       | Uso                                                |
| ------------------------ | ----------- | -------------------------------------------------- |
| `heroGradientStart`      | `#00000000` | Inicio del gradiente hero (transparente)           |
| `heroGradientEnd`        | `#DD000000` | Final del gradiente hero (negro 87%)               |
| `heroText`               | `#FFFFFFFF` | Texto principal sobre imagen                       |
| `heroTextSecondary`      | `#B3FFFFFF` | Texto secundario sobre imagen (blanco 70%)         |
| `cardTextSecondary`      | `#CCFFFFFF` | Texto sobre cards con imagen (blanco 80%)          |
| `speakerCardGradientEnd` | `#CC000000` | Gradiente de speaker cards (negro 80%)             |
| `timeBadgeBackground`    | `#66000000` | Fondo del badge de tiempo sobre imagen (negro 40%) |
| `barrierScrim`           | `#8A000000` | Scrim de bottom sheets y modales (negro 54%)       |
| `shadowBase`             | `#FF000000` | Base para sombras con opacidad dinámica            |

## 9. Colores de categoría: `AppCategoryColors`

Colores fijos por tipo de evento del congreso.

| Token      | Color      | Tipo de evento |
| ---------- | ---------- | -------------- |
| `workshop` | Amber 800  | Workshop       |
| `paper`    | Blue 700   | Paper          |
| `poster`   | Green 700  | Poster         |
| `talks`    | Red 700    | Talk           |
| `symposia` | Purple 700 | Symposia       |
| `fallback` | Teal 700   | Resto          |

## 10. Colores de notas: `AppNoteColors`

Paleta de etiquetas de ánimo (`MoodTag`) en el diario. Fijos — no siguen el `ColorScheme`.

| `NoteColor` | Color      | Etiqueta |
| ----------- | ---------- | -------- |
| `focus`     | Blue 500   | Focus    |
| `success`   | Green 500  | Success  |
| `idea`      | Amber 600  | Idea     |
| `mood`      | Purple 500 | Mood     |

> `AppNoteColors.colorOf(color)` y `AppNoteColors.labelOf(color)` son los métodos de acceso. `labelOf(null)` devuelve `'None'`.
