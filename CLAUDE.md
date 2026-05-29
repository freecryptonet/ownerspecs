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

- **`rm -rf .next` (not just `.next/cache`) before `npm run build`.** Cache-only clean intermittently fails with `ENOTEMPTY: rmdir '.next/server/app/<brand>'` on multi-brand rebuilds. pm2 restart alone does NOT force regen — without it deploys look successful but SSG pages don't change.
- **Every `rm -rf .next && npm run build` makes the LIVE site return 500s for the whole ~4-min build window** — the running pm2 process loses its `.next` the instant `rm -rf` fires and only recovers at the closing `pm2 restart`. Mid-build 500s are normal; don't panic or start a second build. Verify 200 only AFTER the build completes.
- **Batching many gens: apply ALL their migrations to the DB first, then run ONE build.** The build renders from DB state (not git), so a single rebuild covers every gen applied since the last build. One build per gen wastes ~4 min each.
- **Code edits render from the VPS filesystem, NOT local/git.** A migration + rebuild does NOT pick up local `.tsx`/`.ts` edits — `scp` every changed code file to the VPS *before* `npm run build`. Easy to miss when a change is "mostly a migration" with one render tweak (cost a build cycle this session).
- **`app/[brand]/[generation]/page.tsx` splits `getGenerationData()` (load+compute) from `Page()` (render).** A new derived value (e.g. `genIsEV`) must be added to the loader's `return {…}` AND the `Page()` destructure, or the build fails `Cannot find name`.
- **NEVER run two rebuilds concurrently.** Each does `rm -rf .next && npm run build`; if two overlap they race on `.next`, the `rm` fails with `ENOTEMPTY` mid-delete (leaving `.next` half-removed), `&&` aborts the chain so pm2 never restarts, and pm2 ends up `errored` → **whole-site 502** (mig 403/404 incident, 2026-05-25). If you background a rebuild, wait for its completion notification before starting another. Recovery from a corrupted `.next` / errored pm2: ensure no `next build` process is running (`ps aux | grep 'next build'`), then ONE sequential `rm -rf .next && npm run build && pm2 restart os`. The "full clean is reliable" claim only holds when no other build is touching `.next`.
- **Run `npx tsc --noEmit` BEFORE `rm -rf .next && npm run build` when you've edited any .ts/.tsx.** The destructive clean + a failed type-check leaves the live site serving NO static pages (down) until a clean build completes — caught this the hard way. Gotcha that triggered it: a type guard like `isChassisCode(x)` applied to a value already typed `string` narrows the *else*-branch to `never` (`Property 'split' does not exist on type 'never'`) — use `.filter(guard)` rather than an `if (guard(x))` gate that then reuses `x`.
- **`scp` only to `root@72.62.154.119`**, never `deploy@`. The `deploy` user has no `authorized_keys` for `autodtcs_key`. Then `ssh root@... 'sudo -u deploy install -m 644 /tmp/x /home/deploy/ownerspecs/path'` to land it as deploy.
- **`scp` takes multiple sources but only ONE destination.** Copying two files to two different remote paths in one `scp` call fails (`scp: remote mkdir ".../x": Failure` — it treats the last arg as a dir). Use a separate `scp` per file.
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
- **Two-level catalog:** `/[brand]` = model list, `/[brand]/[model]` = that model's gens (both dense `spec-table`s). `/[brand]/[model]` is resolved INSIDE the `[generation]` route (model slug `a4` vs gen slug `a4-b9-sedan-2015-2018` never collide; a literal `[model]` dir WOULD collide with `[generation]`). The gen route's `generateStaticParams` emits both gen AND model slugs; model pages render via `components/ModelView`.
- **Catalog-only gens are allowed (render-gate, not creation-gate; 2026-05-27).** The gen hub suppresses moat tabs+tiles with no data and topic pages `notFound()` when empty, so a gen with only catalog data (trims/dims/engines) renders clean — no dead links, no "0" badges (verify badge shows "Catalogue data · owner-manual data in progress" at 0 sources). Don't block creating a gen on a full moat; backfill the moat later from free public OEM sources. (Supersedes the old "no thin gens" hard rule — now a render-gate; see memory `feedback_gen_completion_checklist`.)
- **Engine-vs-engine comparison**: `/compare/engines/[pair]` (e.g. `m15a-vs-m16a`). Pairs are curated in `lib/engineCompare.ts` `ENGINE_PAIRS` — add one `[slugA, slugB]` line (both must be existing `engines.slug`); reciprocal "Compare with…" links auto-render on `/engines/[code]` and the pair is added to the sitemap. Kept curated (not auto-generated) to avoid flooding the index with low-value pairs.
- **Slugs**: generation slug includes model + body + ordinal + years (e.g. `civic-sedan-x-2016-2021`). Globally unique within brand.
- **market_id** on spec tables is nullable: `NULL` = global default, non-NULL = per-market override. When querying, fall back from market-specific → global.
- **Citations**: every spec row must trace to ≥1 source (≥2 preferred) via `spec_sources(spec_table, spec_id, source_id)`. The polymorphic join lets one source cite multiple spec tables.
- **Numbers**: store both metric and imperial where the OEM publishes both (e.g. `torque_nm` + `torque_ftlb`). Don't compute one from the other — capture what the manual says.
- **Provenance for images**: every row in `images` must have `source`, `license`, `attribution`, `original_url`, `download_date`. Render attribution in the page footer.
- **Trims are catalog data, NOT citation-gated.** `trims` performance/dimension columns (hp, torque_nm, 0-100, top speed, fuel, CO2) come from auto-data.net per-variant pages (the source the scraper uses) and carry no `spec_sources`. This is the one place auto-data is the accepted source — unlike moat specs (fluids/torques/etc.), which need HaynesPro/OEM. Use the lower bound of auto-data's published fuel/CO2 range, consistently.
- **`engines.fuel` is normalized lowercase** (`petrol`/`diesel`/`electric`/`hybrid`; mig 480 folded `Petrol`/`gasoline`→`petrol`). Any fuel check must still be case-insensitive AND treat `gasoline` as petrol (legacy rows / scraper drift). Fuel-aware suppression (no spark plugs on diesel/EV, no glow on petrol, no combustion on EV) lives on the trim + gen `/torque` pages.
- **Specs are engine-specific** (Tim's rule). Engine oil, coolant, compression, spark plug → correct only the matching engine's row, and only from a source that covers THAT engine. Drivetrain fluids (ATF, transfer case, front/rear diff) are shared across a model's variants (same gearbox/AWD) → gen-wide is fine.
- **A `spec_sources` link to an OM is a CLAIM, not proof.** Rows can cite an owner's manual yet hold lore values (CX-90 had wrong oil/coolant/compression/bulbs/intervals while citing the OM, migs 483-484). When correctness matters, pull the actual PDF and verify (pypdf — see [[reference_manual_inventory_system]] for the VPS extraction recipe). Likely systemic on pre-2026-05 gens.
- **EV trim hp = headline PEAK power, not HaynesPro's continuous rating.** Full BEV data model (mig 494 schema, render rules, citation policy, sourcing) → [[reference_ev_data_model]]. Consult before adding/editing any BEV trim.

## Shared helpers (use these, don't reinline)

- `lib/seo.ts` — `pageMetadata({title, description, path, heroPath})` returns full Metadata (canonical + OG + Twitter + robots:max-image-preview:large). `breadcrumbsJsonLd`, `vehicleJsonLd`, `techArticleJsonLd` build JSON-LD payloads.
- `lib/labels.ts` — every DB enum → display-label map (fluid / torque / service / bulb / fuse / tire / part). Falls back to `humanize()`. When a migration adds a new enum value, add the label here in the same change.
- `lib/generation.ts` — `getGenerationBase(brand, gen)` + `getGenerationHero(genId)` + `getGenerationSources(genId)` + `getSourcesFor(genId, table)`. Topic-page `generateMetadata` should pass `heroPath: await getGenerationHero(base.gen.id)` so share images match the gen.

## Schema column widths that bite during seeding

`electrical_specs.battery_group` 24, `bulbs.bulb_code` 24, `tire_pressures.tire_size` 48, `generations.layout` 16, `generations.front_suspension` / `rear_suspension` 128, `generations.front_brakes` / `rear_brakes` 96. ERROR 1406 (22001) aborts the migration mid-way — anything inserted AFTER the failing row (often `service_intervals` + `tire_pressures`) will be missing on the post-build pages. Re-insert manually with shorter strings if it happens.

`parts.part_number` is **NOT NULL** (ERROR 1048 aborts mid-migration). For parts identified by size rather than an OE number (wiper blades), put the size string in `part_number` (e.g. `'650/400 mm'`).

## Schema column names that get misnamed

- **`engines` table columns are easy to misname.** Actual: `code` (UNIQUE) · `slug` (UNIQUE, the URL key — see below) · `display_name` (NOT NULL) · `displacement_cc` · `fuel` (not `fuel_type`) · `aspiration` · `valvetrain` · `cylinders` (not `valves_per_cyl`) · `bore_mm` · `stroke_mm` · `compression`. Always supply `display_name` on `INSERT IGNORE INTO engines`.
- **`engines.slug` is the frozen `/engines/[slug]` URL key — NEVER recompute the URL from `code` (mig 389).** The route, the engine index, the gen-hub "Available engines" / "Engines" rows, and `sitemap.ts` all read `engines.slug` directly. Editing `code`/`display_name` for accuracy must NOT change the URL — that was the 404 bug (changing `5.7 HEMI`→`EZB/EZH 5.7 HEMI` orphaned `/engines/57-hemi`). A `BEFORE INSERT` trigger auto-derives `slug` from `code` when not supplied, so plain `INSERT IGNORE INTO engines` is safe; the slug is frozen thereafter. If you ever need a clean slug for a code with punctuation (sales-code prefixes, slashes), set `slug` explicitly in the INSERT. Don't reintroduce a `slugFromCode(code)` helper in any page/link.
- **Before relabeling `engines.code`, collision-check the target (code is UNIQUE).** If the clean code already exists, the decorated row is a SHADOW DUPLICATE → MERGE (repoint trims+fluid_specs+torque_specs+service_intervals+parts onto the survivor, delete shadow, then sweep same-(gen,engine,type) fluid dups), don't rename. EV motors (Tesla/BMW i/Lightning) have no public OEM code — descriptive name is correct; Hyundai EVs do (Kona=EM16). Full audit + open structural issue in memory `reference_engine_code_audit_2026_05.md`.
- **To deliberately change a frozen slug:** update `engines.slug` in a migration AND add a 301 to `ENGINE_SLUG_REDIRECTS` in `next.config.ts` (old→new). Internal links + sitemap read `engines.slug` so they follow on rebuild; the redirect saves any crawled/linked old URL. mig 481 realigned 27 codes (`61-srt8`→`esf` etc.). Still never auto-recompute slug from code in the render layer (mig 389).
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

## Adding a new generation / backfilling moat data

Full recipe (batch ingest → patch metadata → hero image → moat migration → rebuild → smoke), the scraper operational gotchas (tsx-not-on-VPS, ultimatespecs-404-crash, codename exact-match for trim attachment, RS Q3 ↔ RSQ3 normalisation gap, current `isChassisCode` regex), AND the multi-gen batching patterns (idempotent inserts, compact UNION inserts across sibling gens, verifying `SET @src LIKE` resolved, what's safe to reuse engine-to-engine) → [[reference_nameplate_add_workflow]].

**Always-load reminder:** rebuild is REQUIRED after any gen insert — `generateStaticParams` snapshots at build time.

## Manual PDF extraction & US OM gaps

**Fast path — manual_query.py (mig 515, 2026-05-28):** PDFs are pre-converted to markdown with `<!--PAGE n-->` markers, with a `section_map` JSON per manual (`fluids`/`torques`/`maintenance`/`fuses`/`bulbs`/`tire_pressures`/`specifications` → page ranges). Use this for ALL manual lookups; the old per-query pypdf flow is the fallback only.

**Local-canonical architecture (2026-05-28).** PDFs are LOCAL ONLY (`F:\projects\ownerspecs\manuals\*.pdf` — ~5GB and growing). The VPS holds only the `.md` files and the DB. Reasoning: PDFs are cold storage we never serve; the markdown is what makes queries fast. Centralizing PDFs on a 96GB shared VPS would crowd vindecoder/freecrypto/build artifacts once we add Hyundai/Audi/Mopar US portals.

```bash
# QUERY (run on VPS — DB local, no tunnel)
ssh -i ~/.ssh/autodtcs_key root@72.62.154.119 'cd /home/deploy/ownerspecs && set -a && source .env.local && set +a && ./.venv-manuals/bin/python scripts/manual_query.py <cmd>'

manual_query.py list bmw
manual_query.py list --brand suzuki --year 2018
manual_query.py show BMW_X7_G07_2019_OwnersManual fluids
manual_query.py show 109 torques                 # by inventory id
manual_query.py grep "5W-30|0W-20" --topic fluids
manual_query.py grep "ft-lb" --brand chrysler --topic torques
```

**Convert ON DEMAND, not in bulk (decided 2026-05-29).** Bulk-converting every PDF a portal crawler downloads is wasteful — corpus-wide grep is only useful for ~10% of queries, the rest are "I know which manual I want, what does it say about X?". Pre-converting 600+ Mopar PDFs ate ~5h of CPU and produced .md for chassis we don't even have gens for. The standing rule: **the crawler downloads PDFs into `manuals/`; the conversion + index step happens only when a gen-fill task actually needs that manual.**

Per-gen on-demand workflow:
```
# 1. Tunnel up
~/start-mariadb-tunnel.bat                              # NB: that script points port 3306 at the OLD shared Hostinger box.
                                                         # For ownerspecs use the manual SSH:
ssh -i ~/.ssh/autodtcs_key -L 3307:127.0.0.1:3306 -N root@72.62.154.119 &

# 2. Convert just the one PDF we need
F:\projects\ownerspecs\.venv-manuals\Scripts\python.exe scripts\convert_manuals.py --only mopar_jeep_wrangler_2024.pdf

# 3. Index it
F:\projects\ownerspecs\.venv-manuals\Scripts\python.exe scripts\detect_sections.py --only mopar_jeep_wrangler_2024.md --write-db

# 4. Sync that one .md to VPS
scp -i ~/.ssh/autodtcs_key manuals/mopar_jeep_wrangler_2024.md root@72.62.154.119:/home/deploy/ownerspecs/manuals/
```

A bulk convert is still defensible when we want corpus-grep over a specific area (e.g. "every Stellantis OM that mentions PHEV torque values") — in that case run `convert_manuals.py --workers 2 --skip-large 1000 --limit 50` in batches that don't burn the CPU all day, then full-corpus sync + `detect_sections.py --write-db`. `--limit N` was added 2026-05-29 specifically for batched runs.

**Portal crawlers** auto-discover manufacturer-owned PDFs and store them on F:\. Pattern: fetch index → regex `.pdf` links → download into `manuals/`, skip existing. Existing crawlers (do NOT re-run unless OEM publishes new PDFs):
- `scripts/crawl_mitsubishi_nl.py` (84 PDFs, MY1998-2026)
- `scripts/crawl_hyundai_nl.py` (70 PDFs, 22 model variants, MY2014-2025)
- `scripts/crawl_mopar_us.py` (694 PDFs, 6.1 GB, 6 brands MY2005-2027 — uses the public APIM key from api.mopar.com/vehicleKit, skips Akamai-walled sitemap)

To add a brand: copy whichever crawler structurally matches the target portal (Mitsubishi/Hyundai = static HTML index; Mopar = JSON API). Swap index URL + filename pattern + normalize_filename prefix.

- Legacy VPS PDF extraction recipe (pypdf, `/tmp/pdfx.py` modes, mopar OM era differences) → [[reference_manual_inventory_system]]. Still useful when section_map missed a section or for the FSM (chrysler-300c, 9528p, skipped by `--skip-large`).
- Tyre PSI + 12V battery group/CCA are the two specs US OMs (and HaynesPro) systematically omit; legitimate fill path (aggregator with `public_link=0` + "NOT OEM" note) → [[reference_us_om_gaps]].

## Where the moat data should come from (priority order)

Real sources beat lore. See `feedback_data_sources_hierarchy.md`.

1. **HaynesPro WorkshopData** — Tim has it pre-logged-in. Switch via `mcp__playwright__browser_tabs select 1`. Six-step nav walk-through in `docs/sources-haynespro.md`.
2. **OEM owner manuals via ownersmanuals2.com / ManualsLib** — immutable PDFs published by the manufacturer. Download via Playwright fetch + base64 + Python decode pattern. Cite at least one per gen; for long-running gens cite 2-3 years apart to catch mid-cycle spec migrations (BMW LC-18 coolant MY2023, VW 508.00 LL IV FE 2019).
3. **OEM Factory Service Manuals** — BMW TIS, VW erWin, GM Service Information, Toyota TIS. Gold standard for torques/alignments/calibrations where accessible.
4. **startmycar.com/{brand}/{model}/info/fusebox/{year}/{gencode}** — clean HTML fuse tables, generation-aware. Best for fuses.
5. **General automotive knowledge** — last resort, only for well-known constants (DOT 3 vs DOT 4, lug-nut JIS standards). Never for OE part numbers, with-filter capacities, or chassis-specific fuse layouts.

Why this matters: the whole moat is data the incumbents miss. If the moat tables are filled from training-data lore, we have plausible numbers but no real differentiation — and we'd be wrong on chassis-specific values (caliper carrier bolt torque varies wildly between chassis even within one maker).

## Source citations: link-gating policy (mig 194)

`sources.public_link` (tinyint(1), default 0): `1` = rendered as `<a>`, `0` = rendered as text-only `<cite>`. Set deliberately at source-row creation. **`public_link = 1` only for manufacturer-owned domains + NHTSA/vPIC + EPA/fueleconomy + SAE.** Everything else (HaynesPro / ownersmanuals2 / ManualsLib / auto-data / ultimatespecs / startmycar / Wikipedia / 3rd-party FSM hosts) = 0.

Full eligibility table + rationale (stops SEO leakage to competitors + reduces paid-vendor copyright exposure) → [[reference_source_link_gating]].

## Vendor/sibling-brand leaks: scrub EVERY rendered text column

- The never-name-vendor rule covers all rendered text, not just `sources.citation`: also `sources.notes`, `*_specs.notes`, `parts.notes`, `generations.family_label`, `procedures.body_md`. The leak usually hides in the *justification* for a flagged value ("…HaynesPro has no Challenger…").
- Post-push smoke grep must include rebadge-donor / sibling brands too, not only the paid-vendor list (e.g. `tonale` for the Hornet): `curl -s <url> | grep -ioE 'haynespro|workshopdata|auto-data|ultimatespecs|<sibling>'`. Source notes/citation are SSG → a scrub needs a rebuild to take effect.

## Aggregators are research aids, NOT citation sources

**Auto-data.net and ultimatespecs.com are NOT primary sources.** Use them to discover trim lineups, dimensions, and HaynesPro typeIds — then find the same fact on HaynesPro or an OEM manual and cite **that**. Three reasons aggregators fail the citation bar:

1. **Cache poisoning** — direct numeric URLs (e.g. `/en/bmw-5-series-sedan-g60-29388`) regularly serve content for an unrelated vehicle. An audit click on the cited URL months later may show different content.
2. **Second-hand data** — aggregators scrape OEM material and other aggregators with no verification step.
3. **No version pinning** — unlike PDFs or HaynesPro story IDs, aggregator pages mutate. We have no way to anchor what we saw at citation time.

**Tertiary fallback for marketing numbers:** 0-100 km/h, top speed (electronically limited), WLTP / EPA range claims rarely appear in workshop manuals. For these specific facts citing auto-data is acceptable provided the source `notes` field says explicitly *"marketing number — secondary aggregator, no workshop-grade source available."* Honest audit trail.

**Existing rows that cite auto-data:** ~hundreds. Don't bulk-backfill. When touching a gen for any reason, replace auto-data citations on that gen's spec rows with HaynesPro + OEM manual citations. New gens MUST default to HaynesPro + OEM manual as the citation pair.

## Known scraper/page bug patterns (do not regress)

Catalog of fixed-in-prod bugs covering trim transmission filter, citation index sync, source attribution scope (per-table compound check), `lib/labels.ts` as single source of truth, scraper codename + body_type rules, CSS table layout traps, per-engine query scoping, and the `{0 && jsx}` numeric-0 render trap → **[[reference_known_bug_patterns]]**.

**Read this file BEFORE editing:** any `app/[brand]/[generation]/**` page · `lib/citations.ts` · `lib/generation.ts` · `lib/labels.ts` · `scrapers/insert.ts` · `app/globals.css` table/tab styles · any new `_seed_` migration with tire_pressures/electrical_specs · anywhere you're rendering a numeric DB value with `{x && ...}`.

## Family umbrella + cloning a sibling gen

`generations.family_slug` / `family_label` groups platform-mates for `/family/[slug]` + related-on-chassis pill bar. Set both when adding a sibling gen. Cloning gen-wide specs from a sibling uses `INSERT IGNORE` (multi-match → duplicate-key on `uk_spec_sources`) and you MUST `UPDATE procedures SET title = REPLACE(...)` immediately after the procedure clone (G30→G60 contamination lesson, mig 181). Full naming convention + clone-vs-verify table → [[reference_family_and_sibling_cloning]].

## Pending

See the project memory file `ownerspecs-project.md` for the live pending list (Phase 2+ items: per-topic sub-pages, scraping pipeline, brand/model index pages, image ingestion, GA4 + GSC verification, GitHub remote push).
