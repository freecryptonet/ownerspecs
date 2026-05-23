# Chassis-level HaynesPro crawler

**One input (chassis modelId) → all typeIds harvested → one JSON.**

This is the tool that closes the loop: when adding a new vehicle to
the catalog, you run the crawler against the chassis modelId once and
get every engine variant's lubricants + coolant + brake fluid +
adjustment data in one shot. No per-engine snippet runs, no missing
fields.

## Usage

1. Open Playwright at `https://www.workshopdata.com/touch/site/layout/makesOverview`
   (or any other workshopdata.com page — the session cookie must be live).
2. Find the chassis modelId via Cars → Make → Model. Note the
   `data-model-id` attribute, e.g. `d_319001449` for Audi Q5 FY.
3. Run the crawler via `browser_evaluate`:

   ```js
   async () => {
     const modelId = 'd_319001449';
     const t0 = Date.now();
     const tlRes = await fetch(`/touch/site/layout/modelTypesList?modelId=${modelId}`, { credentials: 'include' });
     const tlDoc = new DOMParser().parseFromString(await tlRes.text(), 'text/html');
     const allRows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]'));
     const types = [];
     for (const r of allRows) {
       const cells = Array.from(r.querySelectorAll('td')).map(td => td.textContent.trim().replace(/\s+/g, ' '));
       const meta = { typeId: r.getAttribute('data-typeid'), type: cells[0], engine_code: cells[1], cc: cells[2] ? parseInt(cells[2], 10) : null, kw: cells[3] ? parseInt(cells[3], 10) : null, years: cells[4] };
       await new Promise(s => setTimeout(s, 1200));
       // ... lubricants fetch + parse (see crawl_chassis.js full body) ...
       types.push({ ...meta, oil, coolant, brake_fluid, ac_refrigerant });
     }
     return { chassis: { modelId, label: tlDoc.querySelector('h1,h2,h3')?.textContent?.trim() }, types, duration_ms: Date.now() - t0 };
   }
   ```

   (full body in `crawl_chassis.js`)

4. Save the returned JSON to
   `scrapers/output/haynespro-crawl-{chassis-slug}.json`.

## Performance

- 30 typeIds = ~47 seconds end-to-end (Q5 FY benchmark on 2026-05-23)
- 1.5 seconds per typeId average (1.2s throttle + ~200ms parse)
- Polite throttle prevents abuse-detection from the upstream service

## Output shape

```json
{
  "chassis": { "modelId": "d_319001449", "label": "Q5 (FY)", "engines_count": 30, "fetched_at": "..." },
  "types": [
    {
      "typeId": "t_319005453",
      "type": "30 TDI",
      "engine_code": "DEUB",
      "cc": 1968, "kw": 100,
      "years": "2017 - 2018",
      "oil": { "visc": "0W-30", "spec": "VW 507 00", "sump_l": 4.7, "drain_nm": 30 },
      "coolant": { "spec": "TL-VW 774L (G12EVO)", "capacity_l": 8 }
    },
    // ... 29 more engines ...
  ],
  "duration_ms": 46917
}
```

## What you discover with a single chassis crawl

When run against Q5 FY (d_319001449) on 2026-05-23, the crawler
surfaced:
- All 30 engine variants across 9 years (2016 - present)
- VW spec progression visible: 502 → 504 → 507 → 508 → 509 as Audi
  rolled forward the LongLife specs
- Mid-generation capacity shifts: 2017-2018 DEUB sump 4.7 L → 2019+
  DEZB sump 5.5 L (engine refresh increased oil volume)
- Cooling system capacity bracket: 4-cyl 8.0 L → 4-cyl MHEV 10.0 L →
  V6 TDI MHEV 15.0 L (CVMD only)
- Several engines NOT YET in the catalog: DMSA (40 TFSI 2022+), DTPA
  (40 eTDI), DPUA/DPVA/DGKB (45 TFSI MHEV variants), DLGA+EBCA /
  DRYA+EBCA (PHEV combo codes), etc.

## Scaling to all chassis

To harvest all of HaynesPro's catalog:

1. Walk `makesOverview` → list all makes (~80)
2. Per make → `modelOverview?makeId=...` → list all model groups
3. Per group → `modelTypes?modelGroupId=...` → list all chassis modelIds
4. Per chassis → run crawl_chassis (this script)

Total scope is roughly 3,000–10,000 chassis. At ~30s per chassis with
polite throttle, full mirror = 25–80 hours of Playwright work.
Practical approach: prioritize by catalog ingest queue (only crawl what
we're about to add) and run weekly diffs to pick up new model years
HaynesPro publishes.

## Idempotency

Since each crawl is a snapshot, re-running on the same chassis simply
overwrites the JSON. Useful for picking up new typeIds HaynesPro adds
(e.g. when Audi releases a new engine code mid-cycle).

## Maintenance-procedures crawl (deferred)

This crawler intentionally skips the `/modelDetailMaintenance` page
because procedure links are client-side rendered post-load, which means
`fetch()` would return an empty list. Capturing procedure inventory
remains a per-vehicle workflow (see `harvest_vehicle.md`) where you
navigate the page in Playwright and wait for hydration. For most
moat-fill work, lubricants + adjustmentData covers the bulk of catalog
ingest; procedures can be added as a separate pass per gen.
