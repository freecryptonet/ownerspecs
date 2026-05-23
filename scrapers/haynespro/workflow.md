# HaynesPro full automation workflow

Three tools chain together to keep the catalog complete and current:

```
  ┌──────────────────────┐
  │ discover_brand.js    │  Walks one make → all model groups → all
  │ (Playwright in-page) │  chassis modelIds. Output: discovery JSON.
  └──────────────────────┘
             │
             ▼
  ┌──────────────────────┐
  │ crawl_chassis.js     │  For one chassis modelId → all typeIds →
  │ (Playwright in-page) │  oil/coolant/brake/AC. Output: crawl JSON.
  └──────────────────────┘
             │
             ▼
  ┌──────────────────────┐
  │ ingest_to_sql.ts     │  Crawl JSON + gen_id → SQL migration with
  │ (Node CLI)           │  engines + fluid_specs + spec_sources.
  └──────────────────────┘
             │
             ▼
  ┌──────────────────────┐
  │ diff_crawls.ts       │  Compare two crawl JSONs over time. Output:
  │ (Node CLI)           │  added/removed/changed typeIds report.
  └──────────────────────┘
```

## Scenario A — Adding a NEW vehicle to the catalog

1. **Find chassis modelId** via HaynesPro UI (Cars → Make → Model)
   or via the discovery JSON if you've crawled the brand already.

2. **Crawl** with Playwright `browser_evaluate` running `crawl_chassis.js`:

   ```
   browser_evaluate({ function: `async () => { ${crawl_chassis.js body}; return crawlChassis('d_319001449'); }` })
   ```

   Save the returned JSON to
   `scrapers/output/haynespro-crawl-{slug}.json`.

3. **Create the catalog generation row** manually via SQL (the
   existing nameplate-add workflow in `reference_nameplate_add_workflow.md`).
   Note the `gen_id` it gets assigned.

4. **Auto-generate the moat-fill migration**:

   ```
   npx tsx scrapers/haynespro/ingest_to_sql.ts \
     scrapers/output/haynespro-crawl-{slug}.json \
     --gen-id 82 \
     --slug q5-fy \
     --mig-number 211
   ```

   Outputs `db/migrations/211_ingest_haynespro_q5-fy.sql` with:
   - INSERT IGNORE for the HaynesPro source row
   - INSERT IGNORE for new engines (auto-inferred from typeId rows)
   - INSERT IGNORE for fluid_specs (engine_oil + coolant per engine)
   - INSERT IGNORE for spec_sources links

5. **Review + apply**: scp to VPS, `mariadb ownerspecs < ...`, rebuild,
   smoke test the topic pages.

Total time per new vehicle: ~3 minutes (30s crawl + 2 min review/apply).
Pre-automation this took 1-2 hours per gen with the per-engine HaynesPro
clicking pattern.

## Scenario B — Discovering brand coverage

Run discover_brand.js once per brand to get the complete tree of chassis
modelIds. Useful for:
- Knowing what HaynesPro has before adding a new vehicle (avoid
  duplicating chassis already covered)
- Comparing catalog coverage vs HaynesPro coverage to find missing
  gens to ingest
- Spotting brand-new model years (Audi A5 FU 2024+, Q3 FJ 2024+, Q6 GF
  2024+) that aren't in the catalog yet

```
browser_evaluate({ function: `async () => { ${discover_brand.js body}; return discoverBrand('m_120'); }` })
```

makeIds for reference (from initial walk):
- Audi `m_120` · BMW `m_130` · Mercedes-Benz `m_440` · VW `m_730`
- Toyota `m_710` · Honda `m_290` · Mazda `m_430` · Nissan `m_500`
- Ford `m_270` · GM brands · Hyundai `m_300` · Kia `m_350`
- Volvo `m_740` · Tesla `m_310000001` · Polestar `m_319000130`

Output: `scrapers/output/haynespro-discovery-{brand}.json` per make.

## Scenario C — Periodic diff (catch new HaynesPro releases)

1. Quarterly: re-crawl the chassis you care about (already-ingested
   ones in catalog). Save the fresh JSON alongside the old one with a
   date suffix.

2. Run diff:

   ```
   npx tsx scrapers/haynespro/diff_crawls.ts \
     scrapers/output/haynespro-crawl-q5-fy-2026-05-23.json \
     scrapers/output/haynespro-crawl-q5-fy-2026-09-01.json
   ```

3. Output: Markdown report at `scrapers/output/haynespro-diff-{modelId}-{date}.md`
   showing:
   - Added engines (new typeIds HaynesPro added — likely new MY)
   - Removed engines (rare, but happens when typeId gets retired)
   - Changed engines (capacity update / spec name change / new alt oil)

4. For each significant change → write a targeted correction migration
   or extend the catalog with new engines.

## What this doesn't (yet) automate

- **Generation creation**: still manual SQL to create `generations`
  rows with editorial intro + dims + slug + ordinal. The ingest_to_sql
  script assumes the gen exists.
- **Maintenance procedures**: chassis crawl skips
  `modelDetailMaintenance` because procedure links are
  hydrated client-side. Per-vehicle workflow (`harvest_vehicle.md`)
  still required for procedure body capture.
- **Trim → engine mapping**: ingest creates fluid_specs at the gen
  level scoped by `engine_id`, not by `trim_id`. If your gen has trim
  rows that need engine_id set, that's a separate manual step.
- **Adjustment data table values**: the chassis crawler only captures
  lubricants. Battery + brake + suspension data still needs per-typeId
  capture via the adjustment_data snippet in snippets.md §2.

## Maintenance

- HaynesPro DOM changes very rarely (the page layout has been stable
  through 2024-2026 per Tim's session). If a parser regression
  surfaces, the snippets are all in `snippets.md` for easy edit.
- The polite throttle is conservative (1200ms in-page-fetch); can be
  tuned per `--throttle-ms` if HaynesPro tolerates faster.
- Cookie expiry: if Playwright session times out, re-auth via the UI.
  No way to refresh cookie programmatically — that's why these tools
  run interactively from a Claude Code session, not as an unattended
  cron job.
