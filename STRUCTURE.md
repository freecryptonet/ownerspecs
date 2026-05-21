# ownerspecs.com — site structure & data grain (decision doc)

**Status:** Locked 2026-05-21 (Tim + Claude). All page rebuilds and future data imports follow this doc. Supersedes any per-spec presentation choices made in the first 86 migrations.

## Why this document exists

Through migrations 001–086 we built spec tables (`fluid_specs`, `torque_specs`, `parts`, etc.) keyed at `generation_id` with optional `trim_id`. The gen overview page rendered one row per `(gen, fluid_type)`. **This was wrong.** Many specs vary per engine inside a single generation — a Charger LD has four engine-specific oil capacities and two viscosities; a single number is wrong for ~75% of visitors.

Rendering the wrong number with confidence is an E-E-A-T problem. Google's Helpful Content / People-First guidance specifically penalizes content that gives confident answers to questions it does not actually know. Before importing any more content, we are locking the URL hierarchy, the data grain, and the source-citation pattern.

## Competitor structural baseline (audited 2026-05-21)

Five competitors analyzed: auto-data.net, ultimatespecs.com, carfolio.com, cars-data.com, automobile-catalog.com. Reference vehicle: Dodge Charger LD (4 engines: 3.6 Pentastar V6, 5.7 HEMI V8, 6.4 392, 6.2 Hellcat SC).

| Pattern | Used by | Notes |
|---|---|---|
| Per-engine-variant as leaf URL | auto-data, ultimatespecs, automobile-catalog | most common |
| Flat trim URL, no gen tier | carfolio | thinnest; no fluids at all |
| `/{brand-model}/{spec-topic}` comparison URL | cars-data | best long-tail SEO shape |
| Free oil capacity | auto-data, ultimatespecs | only two have it |
| Free oil viscosity | (none consistently) | auto-data paywalls it; ultimatespecs sometimes shows |
| Per-row source citations | **none** | uncontested moat |
| Maintenance schedules, torque, oil filter PN, spark plug PN, tire pressure values, bulb PN, fuse box | **none** | uncontested moat (PLAN.md 8-tile list confirmed) |

**Conclusion:** the cleanest pattern is **per-engine-variant deep pages + topic-comparison URLs + a richer gen overview**, plus per-row sources. We already have all three URL tiers in our app routes — the work is rebuilding the page contents and locking the data grain.

## The three URL tiers (locked)

### Tier 1 — Generation URL
`/[brand]/[gen]` — e.g. `/dodge/charger-ld-sedan-2011-2023`

**Role:** Overview + horizontal comparison.

**Renders:**
- Gen-wide identity: years, body type, codename, markets, plant, predecessor/successor.
- Gen-wide dimensions: length / width / height / wheelbase, drag coefficient, fuel tank capacity.
- **Variant comparison table** (no competitor has this): one column per engine/trim, rows = HP, torque, 0–100, top speed, curb weight, oil capacity, oil viscosity, coolant capacity, transmission, drive. Footnoted sources per row.
- Trim grid (clickable into Tier 3).
- Topic-page grid (clickable into Tier 2).
- Hero image.

**JSON-LD:** `Vehicle` (generation-level), `BreadcrumbList`.

### Tier 2 — Topic URL
`/[brand]/[gen]/[topic]` — e.g. `/dodge/charger-ld-sedan-2011-2023/oil-capacity`

**Role:** Spec comparison across engines for one topic.

**Renders:** one row per engine, columns = the spec fields for that topic (capacity, viscosity, spec_standard, filter PN, drain interval, severe-duty interval, sources).

Topics:
- `oil-capacity`, `coolant`, `brake-fluid`, `transmission-fluid`, `differential-fluid`, `ac-refrigerant`, `power-steering-fluid` (Tier 2 fluid topics)
- `torque-specs`, `spark-plugs`, `oil-filter`, `air-filter`, `cabin-filter` (engine-scoped parts/torque)
- `tire-pressure`, `bulbs`, `fuses`, `maintenance-schedule` (gen-wide or trim-scoped)

**JSON-LD:** `Dataset` + `Table`, `BreadcrumbList`.

### Tier 3 — Trim URL (the "your car" landing)
`/[brand]/[gen]/[trim]` — e.g. `/dodge/charger-ld-sedan-2011-2023/rt-5-7-hemi`

**Role:** Engine-scoped deep page. Single answer per spec, no comparison.

**Renders:**
- Trim identity, performance, engine block, weight & towing, wheels & tires.
- **Fluid block** filtered to `(engine_id = trim.engine_id) OR (engine_id IS NULL)` — i.e. this engine's specifics + truly gen-wide fluids.
- Torque block filtered same way.
- Parts block filtered same way (oil filter PN, spark plug PN, air filter PN, cabin filter PN).
- Tire pressures (matched to trim's tire size where applicable).
- Service interval table.
- Sibling trims tile grid.
- Topic-page links (cross-link to Tier 2).

**JSON-LD:** `Car` + `EngineSpecification` + `QuantitativeValue` (ultimatespecs' pattern, the strongest schema among competitors).

## Data grain — strict rules

A spec row stores `engine_id` to scope to a specific engine and/or `trim_id` to scope to a specific trim. `NULL` means "applies to all" at that scope.

### fluid_specs

| fluid_type | engine_id | trim_id | rule |
|---|---|---|---|
| `engine_oil` | **required** | NULL | always per engine |
| `coolant` | **required** | NULL | usually per engine (system size varies) |
| `transmission_at` / `transmission_mt` / `transmission_dct` / `transmission_cvt` | **required** | NULL | transmission tied to engine choice |
| `brake_fluid` | NULL | NULL | gen-wide unless proven otherwise |
| `ac_refrigerant` | NULL | NULL | gen-wide unless proven otherwise |
| `washer_fluid` | NULL | NULL | always gen-wide |
| `power_steering_fluid` | NULL | NULL | gen-wide unless EPS-vs-hydraulic split |
| `differential_front` / `differential_rear` | NULL or engine_id | trim_id if AWD-only trim | depends on drivetrain split |
| `transfer_case` | NULL | trim_id if AWD-only trim | only present on AWD/4WD trims |

Rule of thumb: **if we cannot prove a value is identical across all engines in the gen, we MUST split per engine. If we do not yet know, we leave the row out and mark the gen incomplete rather than guess.**

### torque_specs (after migration 087)

| fastener | engine_id | trim_id |
|---|---|---|
| `spark_plug`, `oil_drain`, `valve_cover`, `intake_manifold`, `head_bolt` | **required** | NULL |
| `lug_nut` | NULL | trim_id if wheel size differs |
| `caliper_bolt` | NULL | trim_id if brake package differs |

### parts (after migration 087)

| part_type | engine_id | trim_id |
|---|---|---|
| `spark_plug`, `air_filter`, `oil_filter`, `pcv_valve` | **required** | NULL |
| `cabin_filter` | NULL | NULL (usually gen-wide) |
| `wiper_front`, `wiper_rear`, `drive_belt` | NULL | trim_id if engine-dependent |

### tire_pressures, bulbs, fuses, service_intervals

Mostly gen-wide. Trim-scoped only when trim's tire size or option package changes the value. Engine-scoped only when severe-duty schedule differs (diesel vs gas).

## Source citation pattern

Every spec row must have ≥2 sources (preferably 3) per `feedback_ownerspecs_two_source_rule.md`. We escalate the visibility:

- Today: sources block at bottom of page, no per-row attribution.
- **New:** each spec row renders `[1][2]` superscript footnotes pointing into the sources block. Sources block becomes a numbered list. Per-row attribution is recorded in `spec_sources(spec_table, spec_id, source_id)` (already exists).

This is the single biggest E-E-A-T differentiator. No competitor does it. It's also what we want — it makes the two-source rule visible to the visitor instead of buried in the DB.

## Migration roadmap

| # | What | Status |
|---|---|---|
| 083 | `fluid_specs.engine_id` | done |
| 084 | Charger LD per-engine split (proof of concept) | done |
| 085 | per-engine batch A (9 gens) | done |
| 086 | per-engine batch B (15 gens) | done |
| **087** | **`torque_specs.engine_id` + `parts.engine_id`** | **pending** |
| 088+ | per-engine torque + parts backfill, gen by gen | pending |

## Page rebuild order

1. STRUCTURE.md (this doc) — DONE
2. Migration 087 — schema
3. Tier 1 rebuild — gen page as comparison table
4. Tier 2 rebuild — topic pages as comparison tables
5. Tier 3 rebuild — trim page as engine-scoped deep page
6. Per-row source citations UI
7. Schema markup pass (Car/EngineSpecification on trim, Dataset on topic, Vehicle on gen)
8. Regression check on Charger LD (4-engine canary)
9. **Then and only then** resume content import — into the new shape

## Import freeze

Effective 2026-05-21, no new INSERTs into `fluid_specs`, `torque_specs`, `parts` until step 8 above completes. Identity-level imports (`makes`, `models`, `generations`, `trims`, `engines`, `transmissions`, `images`, `sources` rows themselves) remain allowed because their grain is correct.

## Out of scope (future work)

- Multi-language (English only for now; matches all competitors' US/EN baseline).
- Per-market spec rows (we have `market_id` columns — defer using them until US gens are deep).
- User accounts / favorites / comparison cart — defer until traffic justifies it.
- AMP / mobile-specific URLs — Next.js responsive is the answer.
