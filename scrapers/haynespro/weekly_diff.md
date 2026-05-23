# Weekly HaynesPro diff runbook

**Purpose:** catch new HaynesPro model-year additions, capacity changes,
and spec updates BEFORE they surface as customer-facing errors. Runs
weekly on Monday morning.

**Why not unattended cron:** HaynesPro requires Tim's authenticated
session in Playwright. The scheduled remote agent can't carry that
cookie. So the weekly task is a SCHEDULED REMINDER + RUNBOOK that Tim
processes in a Claude Code session with Playwright active.

## Pre-flight

1. Open Playwright at `https://www.workshopdata.com/touch/site/layout/makesOverview`.
2. Verify session is authenticated (Cars/Trucks nav visible, no login
   prompt). If expired, log in via the UI.

## Run for each chassis in registry

Read `scrapers/haynespro/chassis_registry.json` → `chassis[]`. For each
entry:

1. **Run crawl** with Playwright `browser_evaluate`. The snippet below
   captures FOUR fluid types per typeId (oil + coolant + brake + transmission)
   in one pass — this is the canonical parser as of 2026-05-23. Older
   versions only captured oil + coolant; do NOT downgrade to those.

   ```js
   async () => {
     const modelId = '{from registry}';
     function parseLubricantsAll(text) {
       const country = text.indexOf('Filter by country');
       const after = country >= 0 ? text.slice(country) : text;
       function findSection(label) {
         const re = new RegExp(`\\n\\s+${label.replace(/[()]/g, '\\$&')}(?:[,\\s][^\\n]*)?\\n`, 'g');
         const m = re.exec(after);
         return m ? m.index + m[0].indexOf(label) : -1;
       }
       const oilStart = findSection('Engine oil');
       const coolStart = findSection('Cooling system');
       const oilBlock = oilStart >= 0 ? after.slice(oilStart, coolStart > 0 ? coolStart : oilStart + 5000) : '';
       const oilVisc = oilBlock.match(/SAE\s+(\d+W-\d+)/);
       const oilSpec = oilBlock.match(/(?:VW|BMW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA|JASO|Nissan|Hyundai|Kia)[^\n]+/);
       const oilSump = oilBlock.match(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/);
       const oilDrain = oilBlock.match(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/);
       const brakeStart = findSection('Brake system');
       const coolBlock = coolStart >= 0 ? after.slice(coolStart, brakeStart > 0 ? brakeStart : coolStart + 3000) : '';
       const coolSpec = coolBlock.match(/Coolant\s*\n+\s*([^\n]+)/);
       const coolCap = coolBlock.match(/Cooling system\s+([\d.]+)\s*\(l\)/);
       const transTypes = [
         { label: 'Manual transmission', code: 'transmission_mt' },
         { label: 'Automatic transmission', code: 'transmission_at' },
         { label: 'Dual-clutch transmission', code: 'transmission_dct' },
         { label: 'Continuously variable transmission', code: 'transmission_cvt' },
         { label: 'CVT', code: 'transmission_cvt' },  // Toyota hybrid eCVT (e.g. 'CVT, P710')
         { label: 'eCVT', code: 'transmission_cvt' },
         { label: 'Hybrid transmission', code: 'transmission_cvt' },
       ];
       const wheelsStart = findSection('Wheels and tyres');
       const acStart = findSection('Air conditioning');
       let firstTransIdx = Infinity, firstTrans = null;
       for (const tt of transTypes) {
         const idx = findSection(tt.label);
         if (idx > brakeStart && idx < firstTransIdx) { firstTransIdx = idx; firstTrans = tt; }
       }
       let transmission = null;
       if (firstTrans) {
         const endIdx = Math.min(
           wheelsStart > firstTransIdx ? wheelsStart : Infinity,
           acStart > firstTransIdx ? acStart : Infinity,
           firstTransIdx + 4000
         );
         const tblock = after.slice(firstTransIdx, endIdx);
         const tspec = tblock.match(/(?:Gear oil|ATF|CVT fluid|Transmission fluid)(?:\s*\([^)]*\))?\s*\n+\s*([A-Z0-9][^\n]{2,80})/);
         const trefill = tblock.match(/(?:Gearbox refill|Initial filling|Refill capacity|Capacity, refill|Total fill)\s+([\d.]+)\s*\(l\)/);
         transmission = { type: firstTrans.code, label: firstTrans.label, spec: tspec ? tspec[1].trim() : null, capacity_l: trefill ? parseFloat(trefill[1]) : null };
       }
       const brakeEnd = firstTransIdx < Infinity ? firstTransIdx : (wheelsStart > 0 ? wheelsStart : (brakeStart >= 0 ? brakeStart + 3000 : -1));
       const brakeBlock = brakeStart >= 0 ? after.slice(brakeStart, brakeEnd) : '';
       const bSpec = brakeBlock.match(/Brake fluid(?:\s*\([^)]*\))?\s*\n+\s*([A-Z][^\n]{2,80})/);
       const bAlt = brakeBlock.match(/Alternative lubricant specification\)\s*\n+\s*([A-Z][^\n]{2,80})/);
       const brakeCaps = [...brakeBlock.matchAll(/Brake system[^0-9\n]*?([\d.]+)\s*\(l\)/g)].map(m => parseFloat(m[1]));
       const brakeCap = brakeCaps.length ? Math.min(...brakeCaps) : null;
       return {
         oil: { visc: oilVisc ? oilVisc[1] : null, spec: oilSpec ? oilSpec[0].trim() : null, sump_l: oilSump ? parseFloat(oilSump[1]) : null, drain_nm: oilDrain ? parseInt(oilDrain[1], 10) : null },
         coolant: { spec: coolSpec ? coolSpec[1].trim() : null, capacity_l: coolCap ? parseFloat(coolCap[1]) : null },
         brake_fluid: { spec: bSpec ? bSpec[1].trim() : null, spec_alt: bAlt ? bAlt[1].trim() : null, capacity_l: brakeCap },
         transmission,
       };
     }
     const t0 = Date.now();
     const tlRes = await fetch(`/touch/site/layout/modelTypesList?modelId=${modelId}`, { credentials: 'include' });
     const tlDoc = new DOMParser().parseFromString(await tlRes.text(), 'text/html');
     const chassisLabel = tlDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
     const rows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]'));
     const types = [];
     for (const r of rows) {
       const cells = Array.from(r.querySelectorAll('td')).map(td => td.textContent.trim().replace(/\s+/g, ' '));
       const meta = { typeId: r.getAttribute('data-typeid'), type: cells[0], engine_code: cells[1], cc: cells[2] ? parseInt(cells[2], 10) : null, kw: cells[3] ? parseInt(cells[3], 10) : null, years: cells[4] };
       try {
         await new Promise(s => setTimeout(s, 1000));
         const lubRes = await fetch(`/touch/site/layout/lubricants?typeId=${meta.typeId}&groupId=QUICKGUIDES&altView=true`, { credentials: 'include' });
         const lubDoc = new DOMParser().parseFromString(await lubRes.text(), 'text/html');
         types.push({ ...meta, ...parseLubricantsAll(lubDoc.body?.innerText ?? '') });
       } catch (e) { types.push({ ...meta, error: e.message }); }
     }
     return { chassis: { modelId, label: chassisLabel, engines_count: rows.length, fetched_at: new Date().toISOString() }, types, duration_ms: Date.now() - t0 };
   }
   ```

2. **Save dated** to `scrapers/output/haynespro-crawl-{slug}-{YYYY-MM-DD}.json`.

3. **Diff vs previous** (if `last_crawl` in registry is non-null):

   ```
   npx tsx scrapers/haynespro/diff_crawls.ts \
     scrapers/output/{last_crawl} \
     scrapers/output/haynespro-crawl-{slug}-{YYYY-MM-DD}.json
   ```

4. **Update registry**: set `last_crawl` and `last_crawl_at` to the new
   file/date.

## Aggregate weekly report

After processing all chassis, concatenate the individual diff reports
into one weekly summary:

```
scrapers/output/haynespro-weekly-diff-{YYYY-MM-DD}.md
```

Sections:
- **Per-chassis change summary** (counts of added/removed/changed)
- **New engine codes discovered** — likely new catalog ingest opportunity
- **Spec/capacity changes** — needs targeted correction migration
- **Failed chassis** — log network/auth issues to investigate

## Action items from the report

For each `## Added engines` entry → consider ingesting via
`scrapers/haynespro/ingest_to_sql.ts` once you decide which catalog gen
the new engine belongs to.

For each `## Changed engines` entry → write a focused correction
migration (UPDATE fluid_specs WHERE engine_code = ?) matching the
pattern of mig 209/210.

For each `## Removed engines` entry → investigate before any change
(HaynesPro removals are rare and worth understanding).

## Total time per weekly run

- 11 chassis currently in registry × ~30s per crawl = ~6 minutes Playwright
- Per-chassis diff = ~1s each
- Aggregate report = manual triage, ~10-30 minutes depending on changes

**Total: ~15-40 minutes per week** to keep the catalog fully synced
with HaynesPro upstream.

## Scaling

When the catalog grows past ~50 chassis, the weekly run becomes
~30 minutes Playwright + 1-2 hours triage. At that point, consider:
- Splitting into per-brand weekly runs (Mondays Audi, Tuesdays BMW…)
- Sampling: re-crawl only chassis that have current-MY production
- Auto-applying "safe" corrections (e.g. capacity adjustments < 0.3 L)
  without manual review

## Registry maintenance

When ingesting a new catalog gen via the `ingest_to_sql.ts` workflow,
add the chassis to `chassis_registry.json` if not already there. This
ensures the weekly diff covers the new gen automatically.
