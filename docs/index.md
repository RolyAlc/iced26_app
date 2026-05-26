---
version: 1.0.0
status: activo
last_updated: 2026-05-25
icon: lucide/rocket
tags: [inicio, navegacion, indice]
---

<!-- markdownlint-disable MD007 -->

# ICED26 — Documentación del proyecto

Bienvenido a la documentación técnica de **ICED26**. Esta documentación está pensada para que cualquier persona pueda orientarse rápidamente.

## 1. ¿Por dónde comienzo?

| Si eres...                    | Ve a...                                               |
| ----------------------------- | ----------------------------------------------------- |
| Nuevo en el proyecto          | [Guía de inicio rápido](guides/onboarding.md)         |
| Desarrollador con experiencia | [Arquitectura y capas](architecture/layers.md)        |
| Organizador del congreso      | [Qué hace cada pantalla](guides/features_overview.md) |

## 2. Secciones de la documentación

### 2.1. Guías

- [Inicio rápido](guides/onboarding.md) — cómo arrancar el proyecto desde cero
- [Comandos útiles](guides/commands.md) — referencia rápida de comandos del día a día
- [Glosario UX/UI](guides/ux_ui_glossary.md) — terminología visual del proyecto
- [Publicación en tiendas](guides/publish_stores.md) — Google Play Store y Apple App Store
- [Qué hace cada pantalla](guides/features_overview.md) — descripción no técnica de cada pantalla para el organizador del congreso

### 2.2. Arquitectura

- [Glosario](architecture/glossary.md) — definiciones centralizadas: `Result<T>`, `I18nStr`, `UseCase`, `Mapper`, `Entity` y más
- [Sistema de diseño](architecture/design_system.md) — tokens de espaciado, color, tipografía y animación
- **Pantallas documentadas:**
    - [Home](architecture/screens/home_screen.md)
    - [Detalle de presentación](architecture/screens/presentation_detail.md)
    - [Búsqueda](architecture/screens/search_screen.md)
    - [Lista de presentaciones](architecture/screens/slot_presentation_list.md)
    - [Diary](architecture/screens/diary_screen.md)
    - [Mi agenda](architecture/screens/my_schedule_screen.md)
    - [Ajustes](architecture/screens/settings_screen.md)

### 2.3. Decisiones técnicas (ADR)

Cada ADR explica el **por qué** de una decisión de arquitectura. Es la memoria del proyecto.

- [ADR-0001 — Patrón Result](architecture/adr/0001_usar_pattern_result.md)
- [ADR-0002 — Fuente de verdad de datos](architecture/adr/0002_fuente_verdad_datos.md)
- [ADR-0003 — Material 3](architecture/adr/0003_sistema_visual_material3.md)
- [ADR-0004 — Estructura de features](architecture/adr/0004_estructura_features.md)
- [ADR-0005 — Design tokens](architecture/adr/0005_design_tokens.md)
- [ADR-0006 — App icons](architecture/adr/0006_app_icons.md)
- [ADR-0007 — Migración de datos](architecture/adr/0007_migracion_datos_nueva_edicion.md)
- [ADR-0008 — SQLite3 Flutter libs](architecture/adr/0008_sqlite3_flutter_libs.md)

### 2.4. Contrato de datos

- [Contrato técnico (auto-generado)](generated/contract.md) — estructura oficial del JSON de la conferencia
