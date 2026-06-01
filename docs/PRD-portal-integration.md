# PRD: Portal API Integration & Data Sync

## Problem Statement

The Flutter app (`iced26_app`) is currently 100% offline. It reads a bundled JSON asset (`assets/data/app_data.json`) and seeds a local Drift (SQLite) database on first launch. There is no mechanism to receive schedule updates from the portal after the app is installed. When the conference committee corrects a session time or adds a new talk, users with the app already installed have no way to get the updated data without waiting for a new app store release.

We need to connect the app to the portal API so it can:
1. Check on startup whether the portal has newer schedule data.
2. Download and persist the latest schedule when it has changed.
3. Continue working offline using the locally cached data.

## Solution

Add an HTTP client to the Flutter app that consumes two public portal endpoints:
- `GET /api/sync-status` — lightweight check (returns `last_updated` timestamp)
- `GET /api/schedule` — full schedule payload (~1.1MB)

The app loads its static/reference data (news, socials, zones, themes, conference metadata) from the existing bundled JSON asset. It then fetches the live schedule from the portal and **overwrites** the schedule-related collections in memory before seeding Drift. This hybrid approach avoids duplicating static data in the portal while keeping the sync lightweight.

The sync decision is based **only** on the `last_updated` timestamp (the app is single-conference; `event_id` is not used for sync logic). If the portal's timestamp is newer than the locally stored one, the app downloads the full schedule and re-seeds the database.

## User Stories

1. As an app user, I want the app to check for schedule updates on startup, so that I always see the latest conference program.
2. As an app user, I want the app to skip downloading data when nothing has changed, so that it launches quickly and saves bandwidth.
3. As an app user, I want the app to work offline after the first sync, so that I can browse the schedule without an internet connection.
4. As an app user, I want my favorites and saved presentations to be preserved across schedule updates, so that I don't lose my personal data.
5. As a developer, I want the app to use Dio as the HTTP client, so that we have a robust, well-supported networking library with interceptors and error handling.
6. As a developer, I want the sync logic to be isolated in a dedicated repository, so that the UI layer doesn't need to know about timestamps or HTTP status codes.
7. As a developer, I want the app to fall back to the bundled JSON if the portal is unreachable, so that the app never fails to launch.
8. As a developer, I want the app's data model to align with the portal's response structure, so that mapping logic is minimal and maintainable.
9. As a developer, I want the sync metadata (`last_updated`) stored in the existing `AppConfigs` Drift table, so that no schema migration is needed.
10. As an app user, I want schedule updates to be transparent (no manual action required), so that the app just stays current automatically.

## Implementation Decisions

### Modules to Build/Modify

1. **HTTP Client** — Add `dio` dependency. Create a lightweight wrapper/provider that configures base URL, timeouts, and JSON response handling. No auth token needed for public endpoints.

2. **Remote Data Source** — New implementation of `AppDataSource` contract:
   - `PortalDataSource` — fetches `/api/schedule` and returns raw JSON string.
   - Keeps `LocalJsonService` as the fallback for static data.

3. **Sync Repository** — Extend/refactor `ConfigRepositoryImpl`:
   - On `initializeDataIfNeeded()`:
     a. Load static data from `LocalJsonService` (news, socials, zones, themes, metadata, config).
     b. Call `GET /api/sync-status` via Dio.
     c. Compare remote `last_updated` with local value stored in `AppConfigs` table.
     d. If remote is newer (or no local value exists):
        - Fetch `/api/schedule` via `PortalDataSource`.
        - Overwrite schedule collections (`rooms`, `events`, `sessionBlocks`, `speakers`/`people`) in the `AppData` object loaded from the asset.
        - Pass the hybrid `AppData` to `ConferenceDataSeeder` for transactional reset + re-seed.
        - Store the new `last_updated` in `AppConfigs`.
     e. If remote is equal/older or unreachable:
        - Skip sync, keep existing local data.
        - If first launch and no local data, seed from bundled asset only (fallback).

4. **ConferenceDataSeeder** — Minimal changes:
   - Continue accepting a single `AppData` object.
   - The seeder itself does not need to know about the two sources; the composition happens in the repository before calling `seed()`.

5. **Mappers — Simplification**:
   - The portal returns `events` (mixed talks + sessions) and `speakers`.
   - The app's internal model is simplified to match: no separate `programSlots` vs `presentations` entities.
   - Update `EventMapper`, `PersonMapper`, and any entity-to-Drift conversion to align with the portal's shape.
   - Remove or merge mappers that are no longer needed due to the simplified model.

6. **Dependency Injection** — Update Riverpod providers:
   - Replace `LocalJsonService` with `PortalDataSource` (or a composite/fallback strategy) in the `ConfigRepository` provider.
   - Add Dio client provider.

### Data Flow

```
App Launch
  ├── Load static asset (JSON) → AppData (base)
  ├── GET /api/sync-status → last_updated
  │     ├── Remote > Local? → GET /api/schedule
  │     │                    ├── Merge schedule into AppData (hybrid)
  │     │                    ├── Seeder.reset() + seed(hybrid AppData)
  │     │                    └── Store new last_updated in AppConfigs
  │     └── Remote ≤ Local or error → Skip, use existing Drift data
  └── Continue to UI
```

### API Contracts (Consumed)

- `GET /api/sync-status` → `{ "last_updated": "2026-05-27T10:00:00Z" }`
- `GET /api/schedule` → `{ rooms: [...], events: [...], sessionBlocks: [...], speakers: [...] }`

### Error Handling

- **Network unreachable / timeout** → Fall back to existing local data. If first launch, fall back to bundled asset.
- **Sync-status returns 404 / null** → Treat as "no data on portal yet", fall back to bundled asset.
- **Schedule fetch fails after sync-status succeeded** → Log error, keep existing local data, retry on next launch.
- **Parse error** → Log and fall back to bundled asset (defensive).

## Testing Decisions

- **Sync Repository** — Unit test with mocked Dio and mocked Drift:
  - Portal has newer timestamp → full sync triggered.
  - Portal has same timestamp → sync skipped.
  - Portal unreachable → fallback to local.
  - First launch with no local data → seeds from asset.
- **Mappers** — Test portal JSON → domain entity mapping for each entity type (`Room`, `Event`, `SessionBlock`, `Person`).
- **HTTP Client** — Test timeout, base URL, JSON parsing. No need to test Dio itself.
- **Integration** — Optional: test end-to-end with a local Fastify instance running the portal.

Good tests exercise external behavior: "given the portal returns a newer timestamp, the repository fetches schedule and updates the database."

## Out of Scope

- Push notifications or background sync (only syncs on foreground startup).
- Partial/incremental updates (full payload download on every sync).
- Offline queue for user actions (favorites, notes) to sync back to portal.
- Multiple conference support (`event_id` comparison removed; app is single-conference).
- Changes to the portal backend (covered in separate PRD).
- UI changes (loading states, "last updated" labels, etc.) — can be added later.

## Further Notes

- The bundled JSON asset (`assets/data/app_data.json`) is retained as the fallback and source of static data (news, socials, zones, themes). It is NOT removed.
- The `event_id` field in the local JSON is parsed but not used for sync decisions. The app is scoped to a single conference edition.
- The `last_updated` timestamp is stored in the existing `AppConfigs` key-value table (key: `last_sync_at`, value: ISO 8601 string). No Drift schema migration is required.
- The Dio client should be configured with reasonable timeouts (~10s for sync-status, ~30s for full schedule) to handle slow mobile networks.
- The simplified data model (`events` as a single mixed list) must be reflected in the Drift schema and all downstream UI mappers. This is the largest refactor surface area.
