# HaynesPro oil-spec harvest workflow

Companion to `scrapers/haynespro/compare_oil.ts`. Produces per-engine
JSON files that the comparator consumes.

## Why this is interactive (not unattended)

HaynesPro requires authentication. Tim's session lives in a Playwright
browser tab; standalone `node fetch()` won't carry the cookie. The
harvest step is driven from a Claude Code conversation that talks to
the running Playwright instance through the MCP tools.

## Per-engine harvest steps

For each `engine_code` in `scrapers/haynespro/typeids.json`:

1. Pick the first typeId in the list.
2. Navigate Playwright to:
   `https://www.workshopdata.com/touch/site/layout/lubricants?typeId={typeId}&groupId=QUICKGUIDES&altView=true`
3. Use `browser_evaluate` with the snippet below to extract a normalized
   JSON shape:

   ```js
   () => {
     const text = document.body.innerText;
     const country = text.indexOf('Filter by country');
     const after = country >= 0 ? text.slice(country) : text;
     // Engine oil section — preferred + alternatives + sump capacity + drain torque
     const engineOilStart = after.indexOf('Engine oil');
     const engineOilEnd = after.indexOf('Cooling system', engineOilStart);
     const engineOilBlock = after.slice(engineOilStart, engineOilEnd > 0 ? engineOilEnd : engineOilStart + 4000);

     const visc = engineOilBlock.match(/SAE\s+(\d+W-\d+)/);
     // First "Preferred" or "Alternative" lubricant — preferred listed first
     const lines = engineOilBlock.split(/\n+/).map(s => s.trim()).filter(Boolean);
     let preferred = null;
     let alternatives = [];
     let current = null;
     for (let i = 0; i < lines.length; i++) {
       const m = lines[i].match(/Engine oil \((Preferred|Alternative) lubricant specification\)/);
       if (m) {
         if (current) {
           if (current.kind === 'Preferred') preferred = { viscosity: current.viscosity, spec: current.spec };
           else alternatives.push({ viscosity: current.viscosity, spec: current.spec });
         }
         current = { kind: m[1], viscosity: null, spec: null };
         continue;
       }
       if (current) {
         const v = lines[i].match(/^SAE\s+(\d+W-\d+)/);
         if (v) current.viscosity = v[1];
         else if (/^(BMW|VW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru)/.test(lines[i]) && !current.spec) {
           current.spec = lines[i].replace(/All temperatures$/, '').trim();
         }
       }
     }
     if (current) {
       if (current.kind === 'Preferred') preferred = { viscosity: current.viscosity, spec: current.spec };
       else alternatives.push({ viscosity: current.viscosity, spec: current.spec });
     }
     const sump = engineOilBlock.match(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/);
     const drain = engineOilBlock.match(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/);
     return {
       url: location.href,
       fetched_at: new Date().toISOString(),
       preferred,
       alternatives,
       sump_l: sump ? parseFloat(sump[1]) : null,
       drain_nm: drain ? parseInt(drain[1], 10) : null,
     };
   }
   ```

4. Save the returned JSON to
   `scrapers/output/haynespro-oil-{engine_code}.json` with the harness
   `Write` tool, adding `engine_code` and `typeId` fields:

   ```json
   {
     "engine_code": "B48B20B",
     "typeId": "t_619015365",
     "fetched_at": "...",
     "preferred": { "viscosity": "0W-20", "spec": "BMW Longlife-17 FE+" },
     "alternatives": [ ... ],
     "sump_l": 5.25,
     "drain_nm": 25
   }
   ```

5. Polite throttle: 4 seconds between requests to workshopdata.com per
   the convention in `scrapers/lib.ts`.

## After all engines harvested

Run the comparator:

```
npx tsx scrapers/haynespro/compare_oil.ts
```

Output lands at `scrapers/output/oil-audit-{YYYY-MM-DD}.md` — Markdown
report grouped by engine_code with status per DB row (OK / WRONG-VISC /
WRONG-CAP / WRONG-SPEC). Use the report to write the correction migration.

## Re-running

After applying a correction migration, re-run the comparator (no need
to re-harvest unless HaynesPro source data changed). The report should
flip status to OK for the corrected rows.

## Adding new engines

Append to `typeids.json` → `engines[]` with the engine_code, modelId,
chassis label, and at least one typeId. The comparator will pick them
up automatically on the next run.
