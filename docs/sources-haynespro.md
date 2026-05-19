# HaynesPro WorkshopData — navigation reference

Reference for future Claude sessions driving Tim's pre-authed Playwright tab on `workshopdata.com`. Switch with `mcp__playwright__browser_tabs select 1` (NOT startmycar.com). Auth already handled. Legal posture: facts only, never verbatim text, never diagrams.

## 1. What it is

HaynesPro WorkshopData Car Edition (Infopro Digital, ex-Haynes). OEM-aggregated technical data for ~70 makes / 48,000+ models. Audience: indie shops, dealer techs, mobile diagnosticians. Sold rebadged by LKQ, Workshop Software, Thinktool, Mecainfo, balticdiag — same DB. `/touch/` is the tablet UI; `acc.haynespro.com` is the sales site.

## 2. URL pattern (BMW 3 Series G20 330i example)

Base: `https://www.workshopdata.com/touch/site/layout/`

1. `makesOverview` — make grid (BMW tile).
2. After picking BMW the URL advances through `site/layout/<step>` paths with IDs in the query string (`makeId`, `modelId`, `typeId`, `engineCode`). Step names rotate — observe live, don't hard-code.
3. Model list → **3-Series (G20/G21) Saloon/Touring** (saloon and touring are separate models).
4. Type/engine → **330i** by engine code **B48B20 / B48B20M1** (indexed by engine code, not trim).
5. Year band → e.g. `03/2019 → …`.
6. Vehicle dashboard with category tabs (§3).

Shortcut: the VIN box on `makesOverview` skips steps 2-5. Use it whenever the VIN is known.

## 3. Data categories (per vehicle)

| Section | Content | Format |
|---|---|---|
| Identification | engine code, KBA, build dates, body | HTML table |
| Maintenance | service interval schedule, mileage/time matrix | table + drawings |
| Adjustment data | torques, valve clearances, idle, firing order, cap pressures | HTML table |
| Lubricants & fluids | engine/trans/brake/coolant/AC: type, viscosity, capacity, spec | HTML table |
| Repair times | OEM labour times | HTML table |
| Repair manuals | step-by-step incl. service-reset / EPB / oil-life / SAS | HTML + drawings |
| Technical drawings | component locations, belt routing, fuse box, bulb chart | SVG/PNG image |
| Electrical (VESA) | wiring diagrams, pin-outs, ground points | clickable SVG, JS |
| Fault codes (SmartCASE) | EOBD + OEM DTCs, known-fix cases | HTML table |
| Recalls / TSBs | manufacturer campaigns | HTML table |
| Tyres & wheels | sizes, pressures, torque | HTML table |
| Air-conditioning | refrigerant type + charge | HTML table |
| Adjustment / alignment | toe, camber, caster | HTML table |

Categorisation is **highly consistent** across makes. Coverage depth varies (mainstream EU deepest; Korean/JDM thinner pre-2010). Some entries (e.g. Fiat 500, Audi A4 B9) carry a "diagnostic tool required" flag — verify an owner-method exists before committing.

## 4. HTML structure / scrapability

Spec pages are server-rendered HTML with classic `<table>` markup (the touch UI is a thin client over server pages). Maintenance, lubricants, torques, adjustment data extract cleanly via Cheerio/Playwright `page.content()` — no JS execution needed for the data tables.

Exceptions needing a real browser render:
- **VESA wiring diagrams** — interactive SVG, JS-wired hotspots; read DOM after click for pin/wire colour, never the image.
- **Technical drawings** — PNG/SVG images. Out of scope.
- Some adjustment-data sub-views lazy-load on tab click.

Playwright is already required for auth, so `waitForSelector('table')` and parse.

## 5. Make / model nomenclature

- **Make**: marketing brand ("BMW", "Mercedes-Benz").
- **Model**: family + chassis code ("3-Series (G20/G21) Saloon", "Golf VIII"). Body styles split. Long-running nameplates get **multiple HaynesPro entries per generation** (E90, F30, G20 are distinct models).
- **Type/variant**: keyed off **engine code**, not trim. "330i" is inferred from B48B20; M340i is a separate type entry.

Map our `make/model/generation` to HaynesPro by chassis code + engine code, never trim name. Cache the resolved `(makeId, modelId, typeId)` in DB.

## 6. Fallbacks when HaynesPro is blocked / thin / missing

1. **OEM technical portals** — BMW TIS/AIR, VW erWin, Toyota TIS, Honda Service Express, Ford Motorcraft, GM ACDelco TDS, Hyundai HMA-TIS. Paid (~$20-50/day) but authoritative; owner's manuals usually free.
2. **manualslib.com** — free OEM owner's-manual PDFs and many service manuals. Best free fallback for capacities and schedules.
3. **ALLDATA / Mitchell1 / Identifix** — paid pro DBs, near-equivalent to HaynesPro. Not scrapeable; spot-check verification only.
4. **startmycar.com** — free, community-curated procedures. Variable quality; good for service-reset steps when HaynesPro is gated.
5. **Bentley Publishers** (paid; BMW/VW/Audi/Porsche/MINI deep), **Chilton DIY** (paid, US), brand forums (bimmerfest, civicx, audizine) — forums for sanity-checking torques and surfacing TSBs; never quote verbatim.

Honour the ≥2-source rule from `PLAN.md`: pair HaynesPro with an OEM PDF or manualslib copy before writing a moat fact into `spec_sources`.
