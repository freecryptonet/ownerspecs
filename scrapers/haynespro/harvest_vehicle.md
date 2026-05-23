# Full HaynesPro per-vehicle harvest workflow

For each vehicle (= typeId) you want to ingest, run these 3 snippets
in sequence and combine the output into one
`scrapers/output/haynespro-vehicle-{typeId}.json`.

This is the **single source of truth** when adding a new vehicle to
the catalog — it captures every HaynesPro field that maps to a catalog
moat table, so you don't miss data fields that you'd otherwise have to
hunt for individually.

## Pre-flight

1. Open the Playwright browser at `https://www.workshopdata.com/touch/site/layout/makesOverview`.
2. Verify the session is authenticated — the page should show the make
   list (Cars/Trucks nav visible). If you see a 404 or "log in" page,
   navigate via `/touch/site/layout/login` then `Cars` link.
3. Look up the chassis modelId via Cars → Make → Model. Drill into a
   specific typeId from `/touch/site/layout/modelTypesList?modelId={d}`.
4. Note the typeId from `data-typeid` attribute on the row.

## Step 1 — Lubricants

Navigate:
```
/touch/site/layout/lubricants?typeId={typeId}&groupId=QUICKGUIDES&altView=true
```

Run the **Lubricants snippet** from `snippets.md §1` via
`browser_evaluate`. Capture the returned `LubricantsBlock` JSON.

Polite throttle: wait 4 seconds before next request to workshopdata.com.

## Step 2 — Adjustment Data

Navigate:
```
/touch/site/layout/adjustmentData?typeId={typeId}&groupId=QUICKGUIDES&fromOverview=true
```

Run the **Adjustment Data snippet** from `snippets.md §2`. Capture
the returned `AdjustmentDataBlock` JSON.

## Step 3 — Maintenance procedures

Navigate:
```
/touch/site/layout/modelDetailMaintenance?typeId={typeId}&currentSubject=MAINTENANCE
```

Wait ~1.5 s for hydration (procedure links are client-side rendered).
Run the **Maintenance snippet** from `snippets.md §3`. Capture the
`MaintenanceProcedure[]` JSON.

## Combine and save

Build the unified `HaynesProVehicleHarvest` JSON (see `types.ts`) and
write to:

```
scrapers/output/haynespro-vehicle-{typeId}.json
```

Include `engine_code`, `typeId`, `modelId`, `vehicle_label`, `years`,
and `fetched_at` at the top level. The three section JSONs go under
`lubricants`, `adjustment_data`, `procedures`.

## Procedure body capture (per story)

The maintenance step gives you a procedure INVENTORY (titles + storyIds).
For procedures you want to import into the catalog `procedures` table,
each story body needs a separate visit:

```
/touch/site/layout/repairManuals?typeId={typeId}&currentSubject=MAINTENANCE&currentPage={group}&groupId={group}&storyId={storyId}
```

Then dump `document.body.innerText` of the main section. Save under:

```
scrapers/output/haynespro-stories/{storyId}.txt
```

The body text + the title from the inventory together populate the
`title`, `body_md` (after restating in our voice per Feist v. Rural),
`tools_required`, `common_mistakes` fields when writing a per-vehicle
moat-fill migration.

## Cite discipline

Per [[feedback-data-sources-hierarchy]], HaynesPro citations go in
`sources` with `is_public=0, public_link=0`. The cited URL must be the
real one captured during this harvest — never inferred from a pattern.
Use the `source_urls` block of the harvest JSON as the canonical URL.

## Reusability across siblings

When the SAME engine code shows up on a sibling typeId (e.g. DKMB on
both A6 sedan + Q5 e-tron), the lubricants spec is IDENTICAL per
HaynesPro convention. You only need ONE harvest per `engine_code`; the
adjustment_data/procedures may differ slightly per chassis.

For maximum efficiency:
- Harvest LUBRICANTS once per unique `engine_code` (smaller set).
- Harvest ADJUSTMENT_DATA + PROCEDURES once per typeId (larger set).
