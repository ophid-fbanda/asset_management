# Conventions

---

## Frontend Conventions

The frontend is built on a small set of **`*x` toolkit modules** under `frontend/src/api/`. They exist so that views read like intent, not plumbing. The golden rule:

> If a line of raw code can be expressed through `datax`, `objectx`, `colorx`, or `exportx`, use the toolkit. Don't hand-roll fetches, filters, resets, headers, or palettes in a component.

A typical view declares a few keys and computeds and is essentially done — caching, search, export, and theming are inherited.

### `datax` — Data & Caching (`frontend/src/api/datax.js`)

All HTTP and cache access goes through `datax`. Components must **never** touch `axios`/`httpx` or the `cachex` store directly.

Caching is keyed by string. The key is usually also the request URL, which keeps reads, writes, and fetches aligned (e.g. `assets/registrations/4`).

- **Reading** — `dataFromCache(key)` returns a `computed` of the cached value, so reads stay reactive. Pair it with a `computed` key when the key itself can change (e.g. per-station), then drive the fetch off that key with a `watch`.
- **Loading** — `dataFetchToCache(key)` fetches **only if the key isn't already cached** (load-once). `dataRefreshCache(key)` always re-fetches and overwrites.
- **Patching** — `dataPatchCache(patchKey, dataKey, idKey = 'entity_id')` re-fetches authoritative row(s) and upserts them into a cached list in place (replace-only; it never removes rows). Use it for surgical live updates; use `dataRefreshCache` when a server-side filter is the real source of truth.
- **Writing / clearing** — `dataToCache(key, value)`, `dataClearCache(key)` (omit the key to clear everything).
- **Sending** — `dataSend(url, data)` for JSON POST, `dataUpload(url, data)` for multipart.
- **Two-way binding** — `dataReadableWritable(key, fallback)` returns a writable `computed` you can drop straight into `v-model`, so independent components share state through one cache key. **Declare it once** in `setup`; never call it inline in a template.

**Auth & session** are also `datax` concerns: `dataAutoSignIn(url)` (silent re-auth on mount), `dataSignOut(url)`, and the profile helpers `dataToProfile` / `dataFromProfile` / `dataClearProfile` (backed by the opaque `PROFILE_KEY`). Every request runs through `observe()`, which **clears the profile on a 401/403** — the backend has already invalidated the session by then, so the frontend simply reacts and the user is nuked back to login rather than being shown what they can't do.

`dataUnique(prefix)` mints a profile-scoped `prefix-profileId-timestamp` id for client-generated keys.

### `objectx` — Object & Array Shaping (`frontend/src/api/objectx.js`)

Pure, side-effect-free helpers for the shapes views deal with constantly:

- **State resets** — `objectReset(obj, except)`, `objectResetSet(obj, k, v)` (mutually-exclusive state like `ui.busy`/`ui.error`/`ui.success`), `objectSet(obj, k, v)`.
- **Completeness** — `objectComplete(obj, except)` for a yes/no gate, `emptyObjectKey(obj, except)` for the first offending key. Same scan, two contracts.
- **Tables** — `objectHeaders(rows, except)` derives `{ field, header }` columns from the first row, hiding `id` and any `*_id`, so identifiers travel with the data but stay out of the table.
- **Search & filter** — `arraySearch(rows, keyword, exception)` is a case-insensitive full-text filter across row values (empty keyword returns the array unchanged). `arrayFilter(rows, key, values, except)` keeps rows whose `key` is in a list (cascading selects).
- **Lookups** — `objectLookup(rows, key, value, except)` (first matching row, pruned), `columnLookup(rows, column, value, returnColumn)` (resolve an id to a display value), `objectFirstId(rows)` (default a select to the first option).

### `colorx` — Palettes (`frontend/src/api/colorx.js`)

`colorPalette(key, fallback = 'secondary')` maps a status id to a PrimeVue severity. Status badges resolve their color from this single source rather than each view re-deciding severities.

### `exportx` — Exports (`frontend/src/api/exportx.js`)

`exportToExcel(rows, filename, sheetName)` and `exportToPDF(element, filename, layout, fmt)`. Feed `exportToExcel` whatever rows are currently on screen (e.g. the filtered list) so the export matches the view.

### Page State

Group state into up to three named reactives rather than scattering loose `ref`s:

- **`form`** — everything destined for the server (POST/PUT). Submitted by a function named **`submitForm`**.
- **`ui`** — anything that drives page state (`busy`, `error`, toggles, active section). Keep it cohesive, not a catch-all.
- **`context`** — page-specific context that isn't standard across pages. Used only where applicable.

### Declaration Order

Inside `<script setup>`:

1. Imports
2. Props (`defineProps`), if any
3. Emits (`defineEmits`), if any
4. Statics (constants, option lists, style objects)
5. State reactives (`form`, `ui`, `context`)
6. Computeds and functions (including `submitForm`)

### Comments

Keep comments minimal — code should be self-explanatory. Document **intent or non-obvious constraints**, not what the code already says. The toolkit modules themselves carry banner-style headers and a short "why" note per export; match that style when extending them.

---

## Database Conventions

These conventions keep SQL readable and consistent across queries.

### Table References

- Tables are referenced by their full name rather than aliases (e.g. `staff_profiles.staff_email`, not `sp.staff_email`).
- When a query references the same table more than once (self-joins or repeated joins), each occurrence keeps the full table name and is indexed rather than shortened — the first stays as the table name, and further occurrences append a number (e.g. `staff_profiles`, `staff_profiles2`).

```sql
SELECT staff_profiles.full_name, staff_profiles2.full_name
FROM staff_profiles
JOIN staff_profiles AS staff_profiles2 ON staff_profiles2.id = staff_profiles.manager_id
```

- Inside a `LATERAL` subquery, tables are aliased as `t1`, `t2`, … as the one exception.

### Query Identifiers

Every query exposes two identifiers: `entity_id` for the primary record being listed, and `event_id` for its related `event_register` entry. These give the frontend uniform keys for row actions and approvals, and because both end in `_id` they are naturally excluded from generated table headers.

---

## Backend Conventions

### Exchange DTOs

Exchange DTOs live under `exchange/` and are named `<Domain>Exchange` (parent) and `<Domain>ItemExchange` (child rows), e.g. `TransferExchange` / `TransferItemExchange`.

**Two binding strategies — choose based on the endpoint:**

| Strategy | When | Spring annotation | Frontend sender |
|---|---|---|---|
| `@ModelAttribute` (multipart) | Form has a file upload | `consumes = MULTIPART_FORM_DATA_VALUE` | `dataUpload` |
| `@RequestBody` (JSON) | No file upload | default | `dataSend` |

**All non-`String` frontend-bound fields must suppress the Lombok setter and provide a hand-written one that parses from `String`:**

```java
@Setter(AccessLevel.NONE)
@NotNull(message = "Station is required.")
Integer eventStationId;

public void setEventStationId(String v) {
    try { this.eventStationId = Integer.parseInt(v.trim()); }
    catch (Exception e) { this.eventStationId = null; }
}
```

This applies to both `@ModelAttribute` and `@RequestBody` DTOs — it prevents Lombok from generating a type-permissive setter and gives explicit control over how each field is parsed. Nested object lists (`List<ItemExchange>`) keep standard Lombok setters since they are deserialised by Jackson as arrays, not raw strings.

For `@ModelAttribute` DTOs, nested lists arrive stringified (`JSON.stringify` on the client) and must be parsed with `TypeConvertor`:

```java
@Setter(AccessLevel.NONE)
List<AssetExchange> assets;

public void setAssets(String value) {
    this.assets = TypeConvertor.instance().readJson(value, new TypeReference<List<AssetExchange>>() {});
}
```

**Server-side internals** are set programmatically after binding and keep standard Lombok setters:

- `eventId` (from `ExchangeBase`) — created via `base.createEventId()`.
- `eventAdminId` (from `ExchangeBase`) — copied from the session profile.
- Child-link fields (e.g. `assetTransferId`, `assetIssuanceId`) — stamped in the insert loop.
