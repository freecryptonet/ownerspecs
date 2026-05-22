# ownerspecs.com — Claude operating notes

For strategy + design rationale, read `PLAN.md`. This file is for **operating** the project.

## What it is

Internationally-focused automotive specs site competing with auto-data.net and ultimatespecs.com. The moat is owner-manual / FSM data those incumbents don't publish (fluid capacities, torques, maintenance schedules, batteries, bulbs, fuses, procedures). Same audience as sister sites autodtcs.com + servicereset.net.

Sister cluster: vindecoder.site (US), autodtcs.com (intl), servicereset.net (intl), ownerspecs.com (intl), zonewijzer.nl (NL). Cross-link only where audience and content align.

## Where things live

| | Local | Production |
|---|---|---|
| Code | `F:\projects\ownerspecs\` | `/home/deploy/ownerspecs/` on VPS |
| SSH | n/a | `ssh -i ~/.ssh/autodtcs_key root@72.62.154.119` |
| Process | n/a | pm2 app **`os`** on port **3004** (under `deploy` user) |
| Web | n/a | nginx vhost `/etc/nginx/sites-available/ownerspecs.com` → proxy to 127.0.0.1:3004; Let's Encrypt cert auto-renews |
| DB | tunnel via `~/start-mariadb-tunnel.bat` (port 3306 → 127.0.0.1:3306 on VPS) | MariaDB schema `ownerspecs` on Hostinger Business plan box (same shared box autodtcs/servicereset use) |
| DB user (app) | n/a | `ownerspecs_app@127.0.0.1` / `@localhost` (password in `/home/deploy/ownerspecs/.env.local`) |
| GitHub | not yet pushed (gh CLI not installed locally) | target: `freecryptonet/ownerspecs` |
| Memory | `C:\Users\Z620\.claude\projects\F--projects-ownerspecs\memory\` | n/a |

## Stack

- **Next.js 16.2.6** + React 19 + TypeScript + App Router
- **mysql2** with connection pool (`lib/db.ts` — `query<T>()`, `queryOne<T>()`)
- **Inter + IBM Plex Mono** via `next/font/google` (no Tailwind — vanilla CSS with design tokens in `app/globals.css`)
- **@next/third-parties** for GA4 (env-gated)
- All page routes are server components; nothing client-side yet

## Design system rules (locked)

**Engineering Reference aesthetic** — Wikipedia + GitHub + auto-data, never magazine. If you're tempted to:

- Use a serif/editorial font → **stop.** Inter only, IBM Plex Mono for tabular numerics.
- Add italics, dropcaps, scores, "Pros / Cons", `§` section labels → **stop.** Those signal editorial/blog; we're reference.
- Add an atmospheric dark hero with overlay text → **stop.** Wikipedia-infobox: small photo + structured spec table.
- Hide data behind accordions → **stop.** Auto-data shows everything; we should too.
- Default to cards everywhere → **prefer tables.** Use 1 px borders, alt-row stripes, monospaced spec values. Cards only for the answer-card pattern on deep moat pages.

**Mandatory on every page:**
- Verification badge with source count + last-reviewed date
- Inline `[n]` citation superscripts on spec values (every number that was extracted from a source)
- Sources block at the bottom — only sources that are actually cited via `spec_sources` should appear

Reference mockups live in `mockups/` (HTML) — the production design system in `app/globals.css` is the same tokens + components. Reload mockups locally with `python -m http.server 8765` from that dir if you want to compare iterations.

## Common operations

**Deploy a code change:**
```bash
# from F:\projects\ownerspecs\
scp -i ~/.ssh/autodtcs_key <changed-file> root@72.62.154.119:/home/deploy/ownerspecs/<path>
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'chown -R deploy:deploy /home/deploy/ownerspecs && sudo -u deploy bash -c "cd /home/deploy/ownerspecs && npm run build && pm2 restart os"'
```

**Run a SQL migration:**
```bash
scp -i ~/.ssh/autodtcs_key db/migrations/NNN_name.sql root@72.62.154.119:/tmp/
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs < /tmp/NNN_name.sql'
```

**Inspect the DB:**
```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'mariadb ownerspecs -e "SHOW TABLES;"'
# or as the app user to verify grants:
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'cat /home/deploy/ownerspecs/.env.local'  # gets the password
```

**pm2 control:**
```bash
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy pm2 logs os --lines 50'
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'sudo -u deploy pm2 restart os'
```

**Local dev** (if pulling down the project to dev locally):
1. Open the MariaDB tunnel: `~/start-mariadb-tunnel.bat` (forwards 127.0.0.1:3306 to VPS)
2. Copy `.env.example` → `.env.local` and fill `DB_PASSWORD` (get it from `/home/deploy/ownerspecs/.env.local` on VPS)
3. `npm install && npm run dev`

## Deployment quirks (each cost 5–15 min before being captured)

- **`rm -rf .next` (not just `.next/cache`) before `npm run build`.** Cache-only clean intermittently fails with `ENOTEMPTY: rmdir '.next/server/app/<brand>'` on multi-brand rebuilds. Full clean is reliable. pm2 restart alone does NOT force regen — without it deploys look successful but SSG pages don't change.
- **`scp` only to `root@72.62.154.119`**, never `deploy@`. The `deploy` user has no `authorized_keys` for `autodtcs_key`. Then `ssh root@... 'sudo -u deploy install -m 644 /tmp/x /home/deploy/ownerspecs/path'` to land it as deploy.
- **No `db/migrations/` dir on VPS.** Migrations are scp'd to `/tmp/NNN.sql` and piped: `mariadb ownerspecs < /tmp/NNN.sql`. Don't try to `install` into a migrations dir — it doesn't exist on prod.
- **Files can drift VPS-only.** `app/globals.css` was only on VPS at one point. Before editing anything you suspect is VPS-only, `scp root@...:/home/deploy/ownerspecs/<path> <local-path>` first to seed local.
- **`generateStaticParams` snapshots at build time.** Adding a `generations` row doesn't render the page until the next `npm run build`. 404s right after a DB insert ≠ bug, just stale build.
- **Build failures cascade to 502s.** If `npm run build` exits non-zero, pm2 keeps serving stale `.next` but new gens 502. After every build, grep its full output for `error|Type error`, not just `tail -2`.
- **Bash `cmd | tail -N || fallback` swallows failures.** Pipe returns tail's (0) exit, so `||` never fires. Drop the pipe or use `if ! cmd; then ...; fi` for fallbacks.
- **Playwright tab indices aren't stable.** Always `browser_tabs list` before `select`. HaynesPro/workshopdata.com has been tab 1, 3, and 8 across sessions.

## Data conventions

- **Data grain rules locked in `STRUCTURE.md`.** Engine-scoped fluid types (`engine_oil`, `coolant`, `transmission_*`) MUST have `engine_id` on multi-engine gens; NULL rows on multi-engine gens get suppressed at render. Canonical migration template: `db/migrations/089_civic_x_sedan_full_moat.sql`.
- **Aggregator source IDs (use these for the 2nd-source citation — don't create duplicates):** 593=NHTSA vPIC · 603=BMW · 604=Mercedes · 605=Toyota/Lexus · 606=Honda · 607=Hyundai/Kia/Genesis · 608=Mazda/Subaru · 609=VW Group · 610=GM · 611=Stellantis/FCA · 613=Volvo. Each gen also has a primary OEM Service Manual source — `SELECT id, citation FROM sources WHERE is_public=1 AND citation LIKE '%<Model>%Service%'`.
- **URL pattern**: `/[brand]/[generation]` for the generation hub (e.g. `/honda/civic-sedan-x-2016-2021`); `/[brand]/[generation]/[topic]` for deep moat pages
- **Slugs**: generation slug includes model + body + ordinal + years (e.g. `civic-sedan-x-2016-2021`). Globally unique within brand.
- **market_id** on spec tables is nullable: `NULL` = global default, non-NULL = per-market override. When querying, fall back from market-specific → global.
- **Citations**: every spec row must trace to ≥1 source (≥2 preferred) via `spec_sources(spec_table, spec_id, source_id)`. The polymorphic join lets one source cite multiple spec tables.
- **Numbers**: store both metric and imperial where the OEM publishes both (e.g. `torque_nm` + `torque_ftlb`). Don't compute one from the other — capture what the manual says.
- **Provenance for images**: every row in `images` must have `source`, `license`, `attribution`, `original_url`, `download_date`. Render attribution in the page footer.

## Shared helpers (use these, don't reinline)

- `lib/seo.ts` — `pageMetadata({title, description, path, heroPath})` returns full Metadata (canonical + OG + Twitter + robots:max-image-preview:large). `breadcrumbsJsonLd`, `vehicleJsonLd`, `techArticleJsonLd` build JSON-LD payloads.
- `lib/labels.ts` — every DB enum → display-label map (fluid / torque / service / bulb / fuse / tire / part). Falls back to `humanize()`. When a migration adds a new enum value, add the label here in the same change.
- `lib/generation.ts` — `getGenerationBase(brand, gen)` + `getGenerationHero(genId)` + `getGenerationSources(genId)` + `getSourcesFor(genId, table)`. Topic-page `generateMetadata` should pass `heroPath: await getGenerationHero(base.gen.id)` so share images match the gen.

## Schema column widths that bite during seeding

`electrical_specs.battery_group` 24, `bulbs.bulb_code` 24, `tire_pressures.tire_size` 48, `generations.layout` 16, `generations.front_suspension` / `rear_suspension` 128, `generations.front_brakes` / `rear_brakes` 96. ERROR 1406 (22001) aborts the migration mid-way — anything inserted AFTER the failing row (often `service_intervals` + `tire_pressures`) will be missing on the post-build pages. Re-insert manually with shorter strings if it happens.

## Schema column names that get misnamed

- **`engines` table columns are easy to misname.** Actual: `code` (UNIQUE) · `display_name` (NOT NULL) · `displacement_cc` · `fuel` (not `fuel_type`) · `aspiration` · `valvetrain` · `cylinders` (not `valves_per_cyl`) · `bore_mm` · `stroke_mm` · `compression`. Always supply `display_name` on `INSERT IGNORE INTO engines`.
- **`generations.layout` is varchar(16) drivetrain, not engine layout.** Existing convention: `'RWD'` / `'AWD'` / `'FWD'`. Don't write `'Front engine, longitudinal'` — overflows + breaks the rendering convention.
- **Mixed `fluid_specs` multi-row INSERTs need consistent column counts.** Engine_oil rows usually supply `viscosity` + `drain_interval_mi` + `drain_interval_km`; coolant rows don't. If you bundle both in one VALUES clause, supply `NULL` placeholders for the missing columns on coolant rows — otherwise ERROR 1136 aborts the whole migration.

## Recurring data-quality patterns

- **Engine duplicate records on US pickups.** F-150 P702, Silverado T1, Tahoe T1XX, Escalade T1XX each have shadow engine rows (e.g. `engines.id=26` "EcoBoost" 2264cc vs `id=172` "3.5 EcoBoost" 3496cc — same engine, two rows). Trims reference short-code IDs; legacy fluid_specs reference full-name IDs. Dedupe `engines` table before per-engine backfill on these gens.
- **Per-row `source_count` must filter `s.is_public = 1`.** Internal cross-verification sources (auto_data, ultimatespecs, haynespro) are stored for audit but never rendered. Counting them inflates `[1][2]...[N]` citation badges. Subqueries on `fluid_specs` / `torque_specs` must `JOIN sources s ON s.id = ss.source_id WHERE s.is_public = 1` and `COUNT(DISTINCT ss.source_id)`.
- **Thin scraper-leftover fluid rows.** The scraper auto-creates `engine_oil` + `coolant` rows from auto-data's `fluid_hints` (capacity_l only, NULL viscosity / spec_standard / filter_part_no). Hand-seeded moat migrations add rich rows for the same fluid_type without deduping → 2 rows per `engine_oil` / `coolant`. After each new moat migration, sweep:
  ```sql
  DELETE fs FROM fluid_specs fs
  WHERE fs.fluid_type IN ('engine_oil','coolant')
    AND fs.viscosity IS NULL AND fs.spec_standard IS NULL
    AND EXISTS (SELECT 1 FROM fluid_specs fr WHERE fr.generation_id=fs.generation_id AND fr.fluid_type=fs.fluid_type AND fr.id != fs.id AND fr.spec_standard IS NOT NULL);
  ```
  oil-capacity page also `ORDER BY (viscosity IS NULL) ASC, (spec_standard IS NULL) ASC` to prefer rich rows for the answer card.
- **slug-year vs `start_year` invariant.** Slug-year wins for SEO canonical. If they diverge (auto-data picks an earlier EU year while the slug uses a US start year), `UPDATE generations SET start_year = <slug-year>` rather than changing the slug.

## Mobile

- Wide tables MUST be wrapped: `<div className="table-scroll">…<table>…</table></div>`. The 10-column trim performance table is the recurring offender.
- `@media (max-width: 720px)` hides `.nav-primary` + `.search-bar` in the site header (no hamburger yet). Don't try to un-hide — needs a proper hamburger build.
- Test mobile via Playwright `browser_resize 375 812` + a horizontal-overflow probe: `document.documentElement.scrollWidth > innerWidth`.

## Deploy after a code change (canonical incantation)

```bash
scp -i ~/.ssh/autodtcs_key <local-file> root@72.62.154.119:/tmp/<x>
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 \
  'sudo -u deploy install -m 644 /tmp/<x> /home/deploy/ownerspecs/<path>
   sudo -u deploy bash -c "cd /home/deploy/ownerspecs && set -a && source .env.local && set +a && npm run build 2>&1 | grep -E error\\|Compiled | tail -3 && pm2 restart os --update-env 2>&1 | tail -1"'
```

`--update-env` on `pm2 restart` picks up new `.env.local` values.

## Don'ts

- Never publish verbatim text from any owner manual or FSM. Facts only; procedures restated in our own words.
- Never embed image URLs from auto-data.net or ultimatespecs.com's CDN. Source images separately (OEM press / Wikimedia / Flickr CC).
- Never break the source-tracking invariant — if you add a spec value without inserting a `spec_sources` row, that spec won't carry a citation and the page won't show it in the sources block.
- Never use `git push --force`, `pm2 delete vd/vd-staging/zw/fc`, or any destructive op on the shared VPS without explicit confirmation. Other production sites live there.

## Backfilling per-engine moat data (multi-gen batching)

For backfilling multiple gens of the same manufacturer family, batch into ONE migration file (see mig 101 Korean, 102 Toyota+Ford, 103 European, 104 VW Group, 105 BMW+MB, 106 Lexus). One scp + one apply + one rebuild covers the whole batch. Each gen subsection sets `@gen`, `@e_*` engine IDs, and `@s_sm` source IDs locally so they don't leak. Cut from ~30 min/gen to ~8 min/gen.

## Adding a new generation (the per-nameplate workflow)

Full recipe in memory: `reference_nameplate_add_workflow.md`. Short form:

1. Find auto-data + ultimatespecs gen-index URLs (WebSearch / WebFetch).
2. `npx tsx scrapers/batch.ts --auto-data-gen <url> --ultimatespecs-gen <url> --limit 6` on the VPS as deploy.
   - If ultimatespecs has no index for the exact gen, pass any sibling — batch.ts auto-falls-back to auto-data-only.
3. Patch gen metadata: set codename (e.g. `G20`, `P702`, `BT`), clean up slug (`<model>-<codename>-<body>-<years>`), rename OEM source citation to `'<Brand> <Model> (<Codename>) Service Manual'`.
4. Hero image: `python scrapers/images/wikimedia.py search <Brand> <Model> <Codename>` → download a 1280px CC BY-SA thumb to `public/images/<brand>/<gen-slug>/hero.jpg`. Standard widths only (220/320/640/800/1024/1280/1920/2560) — others 400.
5. Write `db/migrations/NNN_seed_<model>_<codename>_moat.sql` populating fluid_specs / torque_specs / electrical_specs / bulbs / fuses / parts / service_intervals / tire_pressures + an IGNORE-INSERT into `images`. Cite the public OEM-manual source via `INSERT IGNORE INTO spec_sources` per table.
6. scp the hero + the migration to the VPS, run the migration, `npm run build && pm2 restart os`. **Rebuild is required** — `generateStaticParams` snapshots gens at build time.
7. Smoke-test the 6 routes (`/`, `/oil-capacity`, `/maintenance-schedule`, `/torque`, `/electrical`, `/tires`) for HTTP 200.

## Where the moat data should come from (priority order)

Real sources beat lore. See `feedback_data_sources_hierarchy.md`.

1. **HaynesPro WorkshopData** — Tim has it pre-logged-in. Switch via `mcp__playwright__browser_tabs select 1`. Six-step nav walk-through in `docs/sources-haynespro.md`.
2. **OEM owner manuals via ownersmanuals2.com / ManualsLib** — immutable PDFs published by the manufacturer. Download via Playwright fetch + base64 + Python decode pattern. Cite at least one per gen; for long-running gens cite 2-3 years apart to catch mid-cycle spec migrations (BMW LC-18 coolant MY2023, VW 508.00 LL IV FE 2019).
3. **OEM Factory Service Manuals** — BMW TIS, VW erWin, GM Service Information, Toyota TIS. Gold standard for torques/alignments/calibrations where accessible.
4. **startmycar.com/{brand}/{model}/info/fusebox/{year}/{gencode}** — clean HTML fuse tables, generation-aware. Best for fuses.
5. **General automotive knowledge** — last resort, only for well-known constants (DOT 3 vs DOT 4, lug-nut JIS standards). Never for OE part numbers, with-filter capacities, or chassis-specific fuse layouts.

Why this matters: the whole moat is data the incumbents miss. If the moat tables are filled from training-data lore, we have plausible numbers but no real differentiation — and we'd be wrong on chassis-specific values (caliper carrier bolt torque varies wildly between chassis even within one maker).

## Source citations: link-gating policy (mig 194)

`sources.public_link` (tinyint(1), default 0) controls whether the Sources block renders the citation as a clickable link or as text-only. Set deliberately at source-row creation time.

- **`public_link = 1`**: rendered as `<a href="..." rel="nofollow noopener noreferrer" target="_blank">`. Use only for manufacturer-owned domains (bmw.com/owner-info, audi.com/owner-resources, owners.honda.com, mazdausa.com, etc.), NHTSA / vPIC, EPA / fueleconomy.gov, SAE.
- **`public_link = 0`** (default): rendered as text-only `<cite>{citation}</cite>`. **All** HaynesPro / ownersmanuals2 / ManualsLib / auto-data.net / ultimatespecs.com / startmycar / Wikipedia rows get this. URL stays in DB for internal audit, never exposed in rendered HTML.

Why: (1) stop SEO link-equity leakage to top-3 competitors (auto-data / ultimatespecs / startmycar), (2) avoid copyright invitations from paid datasets like HaynesPro — a live link to `workshopdata.com/.../storyId=N` is the easiest argument for "you republished our content" in a DMCA notice. Restated procedures per Feist v. Rural are defensible; an explicit source link weakens that posture.

When adding a new source row in a migration, decide `public_link` deliberately. Default to 0 unless you have a specific reason it should be 1.

## Aggregators are research aids, NOT citation sources

**Auto-data.net and ultimatespecs.com are NOT primary sources.** Use them to discover trim lineups, dimensions, and HaynesPro typeIds — then find the same fact on HaynesPro or an OEM manual and cite **that**. Three reasons aggregators fail the citation bar:

1. **Cache poisoning** — direct numeric URLs (e.g. `/en/bmw-5-series-sedan-g60-29388`) regularly serve content for an unrelated vehicle. An audit click on the cited URL months later may show different content.
2. **Second-hand data** — aggregators scrape OEM material and other aggregators with no verification step.
3. **No version pinning** — unlike PDFs or HaynesPro story IDs, aggregator pages mutate. We have no way to anchor what we saw at citation time.

**Tertiary fallback for marketing numbers:** 0-100 km/h, top speed (electronically limited), WLTP / EPA range claims rarely appear in workshop manuals. For these specific facts citing auto-data is acceptable provided the source `notes` field says explicitly *"marketing number — secondary aggregator, no workshop-grade source available."* Honest audit trail.

**Existing rows that cite auto-data:** ~hundreds. Don't bulk-backfill. When touching a gen for any reason, replace auto-data citations on that gen's spec rows with HaynesPro + OEM manual citations. New gens MUST default to HaynesPro + OEM manual as the citation pair.

## Known scraper/page bug patterns (do not regress)

These were each discovered in production and fixed. Future Claude — read these before touching the related code.

| Where | Bug | Fix |
|---|---|---|
| `app/[brand]/[generation]/[trim]/page.tsx` trim render | Trim page showed BOTH `transmission_mt` and `transmission_cvt` rows for a 6MT trim because filter was on engine_id only and the same engine pairs with both transmissions across sibling trims. | Trim query joins `transmissions` to get `tr.type`; render filters `transmission_*` rows where suffix mismatches `trim.transmission.type` (MT/AT/CVT/DCT/eCVT). Don't regress. |
| `lib/citations.ts` `buildCitationIndex` | Sources block included sources tied to spec rows the page didn't actually render — Sources block out of sync with `[N]` footnotes. | Function takes `renderedRows: {table,id}[]` — callers MUST pass post-suppression row IDs. Empty list = empty Sources block (correct). |
| `lib/generation.ts:108` `getGenerationSources` | Mixed-table IN list cross-pollinated sources — a Civic fluid_spec id=8 matched as a BMW source if BMW also had any spec with id=8 in any table. | Use per-table compound checks `(spec_table = ? AND spec_id IN (SELECT id FROM <table> WHERE generation_id = ?))`. |
| `app/[brand]/[generation]/page.tsx` (was) | The gen hub had its own copy of the buggy IN-list source query. | Removed duplicate; calls the shared helper. |
| `app/[brand]/[generation]/oil-capacity/page.tsx` (was) | Hardcoded `engineLabel: Record<string, string>` map with demo Civic data (`"1.5 T (L15B7) — Sport · EX-T · Touring"`) leaked onto every gen because fallthrough never reached `engine_display`. | Replaced with a `rowLabel(o)` builder. Falls back to `"All engines · generation-wide"` when no trim is associated. |
| `app/[brand]/[generation]/page.tsx` (was) + 5 topic pages | Each page had its OWN `Record<string, string>` for fluid/torque/service/bulb/etc. labels. (a) Civic demo data `"Engine oil (1.5T)"` leaked again. (b) Newer DB enum values (`transmission_at`, `transfer_case`, `front_differential`, `drl`, `frunk`, `cargo_bed`, `loaded`) fell through to ugly raw strings. | **Consolidated to single `lib/labels.ts`** as source of truth. Every helper falls back to `humanize()` (`"front_differential"` → `"Front differential"`) so missing entries degrade gracefully instead of looking broken. All 6 pages import from there. **Rule: when adding a new fluid/torque/service/etc. enum value in a migration, add the label to `lib/labels.ts` in the same change.** |
| Topic pages | Citation badge hardcoded `<sup>[1][2]</sup>`. | Generate from `sources.length`. |
| `scrapers/insert.ts` codename extractor | Caught `(245 Hp)`, `(190 Hp)` etc. as chassis codes and forked one Golf VIII into 5 gens. | Restrict to `/^[A-Z]{1,5}\d{0,4}[A-Z]?$/` plus a `(model, body_type, display_name)` dedupe fallback when codename is NULL. |
| `scrapers/insert.ts` body_type | "SUV / TT", "Sedan, Fastback", "Station wagon (estate)" slugified to ugly `-suv-tt-`, `-sedan-fastback-`, `-station-wagon-estate-` and forked gens. | Strip parentheticals, then split on `/` or `,`, take the leading token. |
| `app/globals.css .tabs-inner` | `overflow-x: auto` rendered a thin cosmetic scrollbar on desktop. | Add `scrollbar-width: none` + `::-webkit-scrollbar { display: none }`. |
| `db/migrations/*_seed_*.sql` | `tire_size varchar(48)` and `battery_group varchar(24)` overflow on long descriptors. | Trim to fit. |
| Older migrations | `capacity_qt` left NULL when `capacity_l` was populated. | Backfill: `UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2) WHERE capacity_l IS NOT NULL AND capacity_qt IS NULL`. |

## Family umbrella layer (`family_slug` / `family_label`)

Gens sharing a chassis platform (sedan + LCI + Touring + M-variant + BEV sibling) are grouped via `generations.family_slug` (varchar 96, indexed). The `/family/[slug]` route renders a side-by-side comparison. Per-gen pages auto-show a "Related on same chassis" pill bar + family breadcrumb. Set `family_slug` + `family_label` when inserting any new gen on an existing platform.

Naming: `<brand>-<model-line>-<base-chassis-code>-<years>` (e.g. `bmw-5-series-g30-2017-2024`, `audi-a4-b9-2015-2025`).

## Cloning a gen from a sibling (Touring/LCI/M-variant)

When cloning gen-wide spec data from a sibling gen via content-matching JOINs into `spec_sources`, **use `INSERT IGNORE`**. Multiple sibling rows can match the same new row on `(fluid_type, engine_id, capacity_l, viscosity)` and cause duplicate-key violations on `uk_spec_sources`. Same applies to bulbs/torques/tires JOINs. Always `UPDATE procedures SET title = REPLACE(...)` immediately after the procedure clone — skipping it leaves stale codename labels (G30→G60 contamination lesson, fixed in mig 181).

## Pending

See the project memory file `ownerspecs-project.md` for the live pending list (Phase 2+ items: per-topic sub-pages, scraping pipeline, brand/model index pages, image ingestion, GA4 + GSC verification, GitHub remote push).
