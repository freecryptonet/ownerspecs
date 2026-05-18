# Scrapers

Stage A of the data acquisition pipeline. See `PLAN.md` for the strategy and
`CLAUDE.md` for the legal/operational rules — facts only, never verbatim
text/images/page structure, ≥2 sources per spec via `spec_sources`.

## What's here

| File | Purpose |
|---|---|
| `lib.ts` | Polite HTTP with rate limit + retry/backoff; number parsing utilities |
| `auto-data.ts` | Parser for one auto-data.net trim page |
| `cli.ts` | Run a single URL → write JSON to `output/` for inspection |
| `output/` | Hand-inspectable JSON dumps (git-ignored) |

## How to run

From the project root (works on either Windows local or VPS):

```bash
npm install --no-save tsx cheerio   # one-time
npx tsx scrapers/cli.ts auto-data 'https://www.auto-data.net/en/bmw-3-series-g20-330i-258hp-46420'
# → scrapers/output/auto-data-bmw-3-series-g20-330i-258hp-46420.json
```

## Rate-limit posture

`SCRAPER_MIN_DELAY_MS` defaults to **4000** ms — ~15 requests/minute per host
maximum. Bump higher if you're running long batches. **Never** lower below 1000
ms; both auto-data.net and ultimatespecs.com have explicit ToS forbidding
crawling, and politeness is the only mitigation we have.

`SCRAPER_USER_AGENT` honestly identifies us:
```
ownerspecs-bot/0.1 (+https://ownerspecs.com — research crawler · contact timgvk@gmail.com)
```
Do not change to mimic a browser. If they 403/429 us, we want to know.

## Verified extraction (2026-05-18)

Test target: BMW 3 Series Sedan (G20) 330i Steptronic, auto-data.net.

**31 of 35 fields populated correctly** on first end-to-end run:
- identity: brand, model, generation, trim_modification, body, doors, seats, years ✓
- engine: code, displacement, cylinders, bore, stroke, compression, aspiration, fuel, layout ✓
- performance: hp, torque, 0-100, top speed, fuel urban + combined, CO2, emission ✓
- dimensions: length, width, height, wheelbase, front track ✓
- weight: kerb, max, fuel tank, trunk, trailer unbraked ✓
- drivetrain: drive wheel, transmission, suspensions, brakes, tire, rim ✓
- fluid hints: engine oil capacity (5.25 L), coolant (9.8 L) ✓

Known gaps to address in v2 of the parser:
- `engine.kw` (auto-data shows kW alongside Hp in the Power cell — separate regex needed)
- `engine.valvetrain` (not always present on EU spec sheets)
- `weight.trailer_braked_kg` (their label `Permitted trailer load with brakes (12%)`
  has a parenthetical that our normalize collapses; needs an additional key variant)
- `dimensions.rear_track_mm` (sparse on auto-data — they often only publish front track)
- `engine.engine_oil_spec` is login-gated on auto-data — we correctly skip the
  lock-icon placeholder; this field will come from HaynesPro / OEM manuals instead

## Next steps (incremental)

1. ✅ auto-data.net trim parser — 89% field-extraction on one real target
2. ✅ CLI for one-shot scrapes with output to JSON
3. ⏳ ultimatespecs.com parser (similar structure, parallel implementation)
4. ⏳ Reconciliation: take auto-data + ultimatespecs outputs for the same trim,
   compare every numeric field, flag any disagreement >5%, write a merged
   record with both sources tracked
5. ⏳ DB insertion: take a reconciled record, find or create
   make/model/generation/engine/transmission, insert the trim, write
   `spec_sources` rows for every populated field
6. ⏳ Brand-index discovery: given a make slug, walk the brand→model→generation
   page tree to find trim URLs
7. ⏳ Batch orchestrator: scrape top-N nameplates, write a manifest with success/
   failure counts and disagreement flags

## What this scraper does NOT do (and never will)

- Embed image URLs from auto-data.net's CDN (we source images separately — see
  PLAN.md "Image sourcing")
- Copy editorial blurbs, "Q&A" text, or marketing copy
- Mimic a browser User-Agent or otherwise misrepresent who's calling
- Run without a delay
- Persist their HTML or page structure verbatim — we parse facts and discard
  the rest
