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

1. **Run crawl** with Playwright `browser_evaluate`:

   ```js
   async () => {
     const modelId = '{from registry}';
     const t0 = Date.now();
     const tlRes = await fetch(`/touch/site/layout/modelTypesList?modelId=${modelId}`, { credentials: 'include' });
     const tlDoc = new DOMParser().parseFromString(await tlRes.text(), 'text/html');
     const chassisLabel = tlDoc.querySelector('h1, h2, h3')?.textContent?.trim().replace(/\s+/g, ' ') ?? null;
     const allRows = Array.from(tlDoc.querySelectorAll('tr[data-typeid]'));
     const types = [];
     for (const r of allRows) {
       const cells = Array.from(r.querySelectorAll('td')).map(td => td.textContent.trim().replace(/\s+/g, ' '));
       const meta = { typeId: r.getAttribute('data-typeid'), type: cells[0], engine_code: cells[1], cc: cells[2] ? parseInt(cells[2], 10) : null, kw: cells[3] ? parseInt(cells[3], 10) : null, years: cells[4] };
       await new Promise(s => setTimeout(s, 1200));
       try {
         const lubRes = await fetch(`/touch/site/layout/lubricants?typeId=${meta.typeId}&groupId=QUICKGUIDES&altView=true`, { credentials: 'include' });
         const lubDoc = new DOMParser().parseFromString(await lubRes.text(), 'text/html');
         const lubText = lubDoc.body?.innerText ?? '';
         const country = lubText.indexOf('Filter by country');
         const after = country >= 0 ? lubText.slice(country) : lubText;
         const oilStart = after.indexOf('Engine oil');
         const oilEnd = after.indexOf('Cooling system', oilStart);
         const oilBlock = after.slice(oilStart, oilEnd > 0 ? oilEnd : oilStart + 5000);
         const v = oilBlock.match(/SAE\s+(\d+W-\d+)/);
         const s = oilBlock.match(/(?:VW|BMW|MB|Mopar|Toyota|Honda|API|ACEA|GM|Mazda|Ford|Volvo|Audi|Subaru|FCA)[^\n]+/);
         const sump = oilBlock.match(/Engine sump,?\s*including filter\s+([\d.]+)\s*\(l\)/);
         const drain = oilBlock.match(/Engine oil drain plug[^.]*?(\d+)\s*\(Nm\)/);
         const coolBlock = after.slice(after.indexOf('Cooling system'), after.indexOf('Brake system', after.indexOf('Cooling system')));
         const coolSpec = coolBlock.match(/Coolant\s*\n+\s*([^\n]+)/)?.[1] ?? null;
         const coolCap = coolBlock.match(/Cooling system\s+([\d.]+)\s*\(l\)/);
         types.push({ ...meta, oil: { visc: v?.[1] ?? null, spec: s?.[0]?.trim() ?? null, sump_l: sump ? parseFloat(sump[1]) : null, drain_nm: drain ? parseInt(drain[1], 10) : null }, coolant: { spec: coolSpec, capacity_l: coolCap ? parseFloat(coolCap[1]) : null } });
       } catch (e) { types.push({ ...meta, error: e.message }); }
     }
     return { chassis: { modelId, label: chassisLabel, engines_count: allRows.length, fetched_at: new Date().toISOString() }, types, duration_ms: Date.now() - t0 };
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
