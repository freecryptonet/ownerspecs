# ownerspecs.com — competitive plan

## Thesis

auto-data.net (~3.6M visits/mo) and ultimatespecs.com (~2.6M visits/mo) publish the same
data shape: engine, performance, dimensions — sourced from marketing spec sheets. Pure
database aesthetic, no hero imagery on trim pages, no editorial voice, no diff-highlighted
comparisons. **Owner manuals contain an order of magnitude more practical data than
either site publishes** — and that data has higher purchase intent (a person searching
"2018 Honda Civic transmission fluid" is about to buy ATF).

ownerspecs.com is the fifth site in the automotive cluster:
- vindecoder.site — VIN decode, recalls (NHTSA)
- autodtcs.com — DTC codes
- servicereset.net — reset/calibration procedures
- freecrypto.net — unrelated, shared VPS
- **ownerspecs.com (new)** — owner-manual-derived spec + maintenance data

**Strategy:** monetization deferred. Year 1 is content depth + design quality + SEO authority.
Bigger and stronger than the incumbents on every page that matters.

## Decisions locked

| Decision | Choice | Why |
|---|---|---|
| Domain | **ownerspecs.com** | Tested ~35 candidates. Available, .com, ~$10/yr at Hostinger. Telegraphs the owner-manual differentiator. Distinct from incumbents' "carspecs/autospecs" naming. |
| Hosting | **Hostinger VPS** (72.62.154.119, KVM 2) | Same VPS as vindecoder.site + freecrypto.net. Next.js apps in this cluster live on the VPS, not Business plan (Passenger spawn-storm 503s drove the migration). Business plan hosts WordPress only (autodtcs + servicereset). |
| Database | Shared MariaDB on Hostinger | Same SSH tunnel `~/start-mariadb-tunnel.bat` (port 3306). Dedicated schema `ownerspecs`. |
| Stack | Next.js 16 | Same as vindecoder.site. Auto-growing sitemap from DB. |
| Market | **International, 1990–present** | Global model lineups. Matches autodtcs.com / servicereset.net audience. Top ~300 global nameplates (US + EU + JDM + AU). |
| Monetization | **Deferred** | No ads, no affiliates in v1. Decide once organic traffic shows traction. |

## What the incumbents already own (match parity, don't compete)

Brand → Model → Generation → Engine segmentation. Both cover: engine (cc, hp, Nm,
bore/stroke, compression, valvetrain, injection, aspiration), performance (0-100, top
speed, fuel consumption u/eu/c, CO2, Euro standard), dimensions (L/W/H, wheelbase,
track, Cd, turning circle), weights (kerb, max, trailer braked/unbraked), capacities
(fuel, trunk), drivetrain (drive wheels, gearbox, suspension, brakes, tires, rims).

We match this on the generation hub page so spec-sheet surface area is parity, then
internal-link out to the data they don't have.

## Where we win — the full owner-manual catalogue

Not five page types. Roughly **forty per generation**, grouped:

**Fluids & lubricants** (10)
- Engine oil capacity + viscosity grade + spec (API/ILSAC/ACEA)
- Transmission fluid type + capacity (auto/manual/CVT/DCT)
- Coolant chemistry (OAT/HOAT/IAT, Toyota SLLC, VW G13, Honda Type 2) + capacity
- Brake fluid grade (DOT 3/4/5.1/LV)
- Power steering fluid
- Differential fluid (front/rear, GL rating)
- Transfer case fluid
- A/C refrigerant type + charge weight + PAG oil spec
- Washer fluid capacity
- Recommended fuel octane

**Maintenance schedule** (flagship page type — incumbents don't publish this at all)
- Full by-mileage table for normal + severe duty
- Time-based intervals (brake fluid every 3 yrs, etc.)
- Visual timeline of upcoming services
- Cost estimate per service (later — affiliate hook)

**Electrical** (5)
- Battery group size + CCA + Ah
- Alternator amperage
- Bulb manifest (full interior + exterior with H/9005/194/7440 codes)
- Fuse box layout — under-hood + interior, position × amp × circuit (table not scanned image)
- Relay locations

**Torque specs** (table per generation)
- Wheel lug nuts, spark plugs, oil drain plug, hub nut, caliper bolts, suspension bolts

**Parts & consumables**
- Spark plug PN + gap + heat range + torque
- Oil filter PN
- Air filter PN
- Cabin filter PN
- Wiper blade sizes (front + rear, by trim)
- Drive belt routing + PN
- Key fob battery type
- All bulb PNs

**Tires & wheels**
- Door-jamb placard pressures (F/R/spare, loaded vs unloaded)
- Original equipment tire spec (size + load + speed rating)
- Rim size + offset + bolt pattern
- Tire chain compatibility (some trims forbid them)

**Procedures (text restatement, not verbatim)**
- Oil-life reset, TPMS relearn, throttle body adapt, steering angle reset
- Electronic parking brake service mode
- Window auto-up/down reset, sunroof reset, seat memory programming
- Bluetooth pairing, key fob programming
- Jump-start procedure (with battery location for trunk-battery cars)
- Towing/flat-tow mode entry
- Off-road mode (4WD/AWD specifics)
- Battery disconnect/connect order
- Jack points + spare tire access

**Reference**
- Towing capacity by trim + receiver class
- Payload by trim
- Roof rack max load
- Trailer wiring config (4-pin/7-pin)
- VIN structure
- OBD-II port location (some cars hide it)
- Dashboard warning light legend

(Service reset procedures with overlap to servicereset.net are cross-linked, not duplicated.
Recall data cross-links to vindecoder.site. DTC explanations cross-link to autodtcs.com.)

## URL architecture

Generation-scoped, not year-scoped — owner manuals are published per generation, and this
avoids the duplicate-content trap dealer SEO pages fall into.

```
/2016-2021-honda-civic/                                ← generation hub
/2016-2021-honda-civic/oil-capacity
/2016-2021-honda-civic/transmission-fluid
/2016-2021-honda-civic/coolant
/2016-2021-honda-civic/brake-fluid
/2016-2021-honda-civic/battery
/2016-2021-honda-civic/spark-plugs
/2016-2021-honda-civic/bulbs
/2016-2021-honda-civic/fuses
/2016-2021-honda-civic/lug-nut-torque
/2016-2021-honda-civic/maintenance-schedule
/2016-2021-honda-civic/tire-pressure
/2016-2021-honda-civic/towing-capacity
/2016-2021-honda-civic/oil-reset
/2016-2021-honda-civic/tpms-reset
/2016-2021-honda-civic/jump-start
/2016-2021-honda-civic/compare/2016-2021-toyota-corolla
/oil-capacity/all-2018-sedans                          ← cross-make pivot (incumbents can't)
/maintenance-schedule/all-cvt-vehicles
```

The cross-make pivots — "every car needing 0W-20", "all Group H6 batteries", "all CVTs by
fluid change interval" — are Feist-safe, structurally impossible for incumbents to produce
from their data model, and rank with no direct competition.

## Design system — premium editorial-tech, not database

The single biggest visual gap on auto-data.net and ultimatespecs.com: **no hero image on
trim pages**. They're all-tables-no-pictures. Closing that gap alone separates us
visually. Then we layer the editorial moves parkers.co.uk and carwow.co.uk use.

**Trim page layout**
1. **Full-width 16:9 hero** — official OEM 3/4-front press shot, ~1200×675. Overlay: model name (editorial serif), generation badge, year range chip, body-type chip, star/score badge.
2. **Editorial intro** — 2-3 sentences below H1, auto-generated from spec percentiles ("Economical 1.5T sedan, top-quartile fuel economy in its class, average power").
3. **Key-specs strip** — 6 tile cards above the fold: 0–60, top speed, power, combined MPG, range/CO2, base price. Each tile has a tiny percentile bar showing position vs class ("204 hp — top 25% midsize sedans").
4. **Maintenance snapshot card** — flagship widget incumbents lack: oil-change interval + capacity + viscosity, next 3 services with mileage, badge "Severe / Normal duty?" toggle.
5. **Accordion spec groups** — Engine, Performance, Dimensions, Drivetrain, Safety, Equipment. First two open by default. 2-column label/value, zebra stripes, monospaced tabular numerals.
6. **Pros / Cons twin lists** — derived from spec percentiles vs class (parkers pattern).
7. **Related-trims rail** — 4-up cards with scores.
8. **Compare-with-rival** row.
9. **Owner-manual data section** — 8-tile grid linking to the deep pages (oil, transmission, coolant, battery, bulbs, fuses, torque specs, maintenance schedule). This is the moat surface.
10. **Cluster cross-links** — match audience focus (see Cross-link matrix below).

**Compare page**
- Sticky bottom compare bar (max 3 cars) — carwow pattern.
- Diff-highlight every row: best value green, worst muted, delta chips ("+15 hp", "-1.2 s").
- ultimatespecs' compare tool is exhaustive but has zero diff highlighting; trivial to leapfrog.

**Navigation**
- Mega-menu: Brand / Body Type / Fuel Type / Price.
- Persistent search bar in header: VIN, license plate, natural language ("2018 Camry oil").
- Brand grid is secondary, not primary nav.

**Palette + typography**
- Background: warm off-white `#FAFAF7`
- Ink: deep `#0E1116`
- Accent: oxblood `#7A2E2E` OR electric blue `#1B4DE3` (pick one — A/B in v1)
- Editorial serif for H1/H2: Source Serif Pro, GT Super, or Tiempos
- Precise sans for body: Inter or Söhne
- All numeric values use the tabular-numerals variant
- Generous whitespace; 8-px grid

**Imagery rule**
- One canonical 3/4-front hero per generation (trim variants share the headline-trim photo with caption "shown: XLE; LE differs in wheels/grille")
- Gallery of 8–12 per generation when available: 3/4-rear, side profile, dash, rear seats, boot, wheel detail, instrument cluster, infotainment
- Consistent neutral studio backdrop where possible

**Mobile**
- Spec accordions stack single-column
- Key-specs strip becomes a horizontal snap-scroll card carousel (no horizontal table scroll, which both incumbents force)
- Hero compresses to 4:5

**Patterns to borrow from startmycar.com**
startmycar.com is a community Q&A site (not a competitor — different category), but two patterns of theirs are worth lifting: the clean make-logo grid for discovery, and the multi-region selector at the footer for handling international visitors gracefully. Even though we're US-first, a footer market selector that signals "this data is for US-market vehicles" sets clear expectations.

## Car image sourcing

Both incumbents serve unwatermarked uncredited images from their own CDNs — auto-data.net
openly admits the on-site set exceeds what they'll license out via their paid Image API.
OEMs don't sue specs aggregators because the traffic benefits them. We follow the same
practical playbook but with better paper trail.

| Segment | Primary source | Fallback |
|---|---|---|
| 2010–present top-200 nameplates | OEM press rooms (Toyota Newsroom, Stellantis Media, BMW PressClub, Ford, GM, VW, Honda, Hyundai, Tesla) with "Photo: {OEM}" credit on every page | Wikimedia Commons CC-BY-SA |
| 2000–2009 | Wikimedia Commons | Flickr CC-BY |
| 1990–1999 | Flickr CC + Wikimedia Commons | Clean placeholder, no stolen photo |
| Trim variants | Headline-trim photo + caption | Color swatch UI (palette names aren't copyrightable) |
| Hero/lifestyle | Unsplash, Pexels | OEM brand assets |

Every image row stores `source`, `license`, `attribution_text`, `original_url`, `download_date`.
Attribution renders in page footer. AI-generated renders are **out** — trademarked grilles/badges
remain trademarked regardless of generation method (Andersen v. Stability AI unresolved
through Sept 2026).

## Data acquisition pipeline

Two-stage. **Scrape competitors first for catalog parity, then fill the moat from owner
manuals + FSM.** This is much faster than starting from PDFs alone.

### Stage A — competitor scrape (catalog parity)

Headless-browser scrape (Playwright) of auto-data.net + ultimatespecs.com to populate
the spec-sheet base layer: brand → model → generation → engine, plus engine/performance/
dimension/drivetrain fields both already publish. Both have ~3M monthly visits and no
rate-limited public API outside auto-data's paid offering.

- **Legal posture:** Feist v. Rural (499 U.S. 340, 1991) — raw facts (engine cc, hp, 0-100, wheelbase) aren't copyrightable. Their selection/arrangement may have thin compilation protection, so we never republish their table organization wholesale or copy verbatim editorial blurbs.
- **ToS exposure:** both sites' terms forbid scraping. We mitigate by (a) low request rates with polite delays, (b) cross-referencing ≥2 sources per spec (auto-data + ultimatespecs → 80%+ agreement is our confidence threshold), (c) never embedding their image CDN URLs, (d) storing `source` + `retrieved_at` on every spec row in case we need to redact later.
- **What we don't take:** images (we source separately — see Image sourcing below), editorial copy, page structure, internal-link organization.

### Stage B — owner-manual + FSM gap fill (the moat)

Once the catalog skeleton exists, populate the 40-page-type owner-manual layer per generation:

1. **HaynesPro / workshopdata.com** via Tim's existing pre-logged-in Playwright tab (`mcp__playwright__browser_tabs select 1`) — extract facts only, never verbatim text, never diagrams. Same constraint as servicereset.net.
2. **OEM open PDFs** — BMW, VW, Audi have public libraries. Cleanest source.
3. **OEM portals with VIN/login walls** — Honda, Toyota, Ford, GM, Hyundai, Subaru, Stellantis. Pull what's accessible; older years often leak.
4. **Internet Archive** for pre-2005 legacy.
5. **Single ALLDATA DIY seat** ($30–60/yr per vehicle) for cross-verification on top-50 nameplates. Never republished.
6. **NOT manualslib / carmanualsonline** — ToS bans scraping; PDFs still OEM-copyrighted.

**Extraction for PDFs:** pdfplumber (text layer) → Claude Sonnet 4.6 PDF API with structured JSON schema → schema validation → MariaDB → human spot-check on 5% sample. Cost ~$0.30 per manual via batch API. Top 2,000 manuals (~95% of US-market demand) ≈ $600–1,200 total.

### Source reconciliation

Every spec row has ≥2 sources (e.g. auto-data + ultimatespecs for catalog facts; HaynesPro + OEM manual for moat facts). The `spec_sources` join table records every citation. When sources disagree by >5%, flag for human review. This is the structural advantage over both incumbents — they single-source and propagate errors silently.

### Coverage targets

- **Phase 1 (scrape only):** top ~300 global nameplates × all generations 1990–present ≈ 5,000 generation-rows + 18,000 trim-rows (auto-data and ultimatespecs are both EU/global-leaning so the scrape gives global coverage natively). Catalog parity with both incumbents inside ~2–3 weeks of scraping.
- **Phase 2 (moat fill — top 80 globally):** owner-manual data for top-80 nameplates (mix of US, EU, JDM volume sellers) ≈ 1,500 generation-rows = ~80% of maintenance-data search demand.
- **Phase 3 (moat fill — top 300):** ~5,000 rows = 95% of demand.
- **Phase 4:** pre-1990 long-tail from Internet Archive.

## Cross-link matrix

ownerspecs.com is **international-focused** like autodtcs.com and servicereset.net.
Cross-linking pattern:

| From → To | When | Pattern |
|---|---|---|
| ownerspecs ↔ **autodtcs.com** (intl) | DTC mentioned anywhere (e.g. EVAP reset references P0440-series) | Inline contextual link to the DTC explainer — natural pair, same audience |
| ownerspecs ↔ **servicereset.net** (intl) | Reset/calibration procedure on the page | "Full step-by-step reset guide at servicereset.net" — natural pair, same audience |
| ownerspecs → **vindecoder.site** (US) | Page is about a US-market model and recall/VIN lookup adds value | "US owners — check recall history at vindecoder.site" — qualify the audience, don't push US tools to EU visitors |
| vindecoder → **ownerspecs** | Spec/maintenance context on any model page | "See full maintenance schedule at ownerspecs.com" — fine because ownerspecs covers US models too as part of global catalogue |
| ownerspecs → **startmycar.com** (external) | When community discussion is the right next step | Cite as community Q&A pointer, not data source |
| **zonewijzer.nl** (NL) → ownerspecs | When a Dutch driver might need fluid/maintenance data | Optional; relevant only on automotive context pages |

Max 2 cross-links per page. Always inline + contextual, never footer-bombed. The autodtcs ↔ servicereset ↔ ownerspecs triangle is the natural internal-link cluster — three sites sharing one international audience.

## Legal posture

Feist v. Rural (499 U.S. 340, 1991): facts aren't copyrightable. Safe: numbers, part
numbers, fluid grades, procedures restated in our own words. Not safe: verbatim text,
scanned fuse-box / wiring / exploded-view diagrams, wholesale copy of any one source's
table organization or editorial blurbs.

**Mitigations baked into the pipeline:**
- ≥2 sources per spec, recorded in `spec_sources` join table
- Auto-data and ultimatespecs treated as fact sources only — never their images, never their text, never their page structure
- HaynesPro / OEM manuals: facts only, no verbatim, no diagrams
- Low scrape rates with polite delays and rotating user-agents; we don't claim to be a browser we're not
- If a takedown notice ever arrives for any source, the spec rows are flagged in DB and we can redact without losing other-sourced data

## Database schema (sketch)

International focus means many specs differ by market — Toyota RAV4 US-market vs EU-market
have different engine options, fluid grades, recommended oil viscosities, and tire spec.
Handle this with a `market` column on the spec tables; default rows are global, with
per-market overrides where they exist.

```
makes              (id, name, country_of_origin)
models             (id, make_id, name)
generations        (id, model_id, start_year, end_year, body_type, codename)
markets            (id, code, name)  -- e.g. US, EU, UK, JDM, AU, RoW
generation_markets (generation_id, market_id, local_name, start_year, end_year)  -- when same gen sells under different name/years
trims              (id, generation_id, market_id, name, engine_id, transmission_id)
engines            (id, displacement_cc, hp, torque_nm, fuel, aspiration, valvetrain)
transmissions      (id, type, gears, name)

-- Owner-manual data (the moat). market_id is nullable: null = global default, non-null = per-market override.
fluid_specs        (id, generation_id, trim_id, market_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard)
electrical_specs   (id, generation_id, trim_id, market_id, battery_group, cca, ah, alternator_amps)
torque_specs       (id, generation_id, trim_id, market_id, fastener, torque_nm, torque_ftlb)
bulbs              (id, generation_id, market_id, position, bulb_code, quantity)
fuses              (id, generation_id, market_id, location, position, amperage, circuit_name)
parts              (id, generation_id, trim_id, market_id, part_type, part_number, source_brand)
service_intervals  (id, generation_id, trim_id, market_id, service, km_normal, km_severe, miles_normal, miles_severe, months)
tire_pressures     (id, generation_id, trim_id, market_id, position, kpa, psi, load_condition)
procedures         (id, generation_id, market_id, procedure_type, slug, body_md)

-- Provenance
sources            (id, type, citation, url, retrieved_at)
spec_sources       (id, spec_table, spec_id, source_id)
images             (id, generation_id, trim_id, url, source, license, attribution, original_url, download_date)
```

## Phased roadmap

**Phase 0 — foundation (week 1)**
- Register ownerspecs.com via Hostinger
- DNS + SSL on the VPS (Caddy or Nginx, same setup as vindecoder.site)
- Next.js 16 scaffold, deploy "coming soon" hero to start crawl
- pm2 app on VPS, port allocated
- MariaDB schema `ownerspecs` + migration
- GA4 + Search Console verification

**Phase 1 — catalog scrape (weeks 2–3)**
- Build the Playwright scraper for auto-data.net + ultimatespecs.com
- Schema in MariaDB: makes, models, generations, trims, engines, transmissions
- Source-reconciliation logic (≥2 sources per spec, disagreement flagging)
- Populate top-200 US nameplates × all generations 1990–present (~3,500 generation-rows, ~12,000 trim-rows)
- This puts us at catalog parity with both incumbents

**Phase 2 — design system (weeks 4–5)**
- Page templates: generation hub, fluid page, electrical page, torque page, maintenance schedule, procedure, compare
- Component library: hero, key-specs strip, accordion group, pros/cons, compare bar, related rail, owner-manual 8-tile grid
- Typography + palette locked (oxblood vs electric blue accent decided)
- Mobile-first responsive pass
- Image ingestion pipeline (OEM press rooms + Wikimedia + Flickr CC) with provenance tracking

**Phase 3 — moat fill (weeks 6–12)**
- PDF extraction pipeline (pdfplumber + Claude Sonnet 4.6 PDF API)
- Process top-50 nameplates' owner manuals → ~1,200 generation-rows with full owner-manual data (80% of maintenance-data search demand)
- HaynesPro Playwright extraction for the same set
- Source reconciliation across auto-data + ultimatespecs + HaynesPro + OEM manual

**Phase 4 — scale + authority (months 4–6)**
- Top-200 nameplate moat coverage (~3,500 rows, 95% of demand)
- Cross-make pivot pages ("/oil-capacity/all-2018-sedans", "/maintenance-schedule/all-cvt-vehicles")
- Cluster cross-links live (per the Cross-link matrix)
- Editorial layer expansion
- Then revisit monetization

## Open follow-ups
- Standalone repo `freecryptonet/ownerspecs` vs subdir of vindecoder-site — recommend standalone for clean deploy boundary
- A/B accent color: oxblood vs electric blue
- Decide whether to render fuses as a structured table only, or invest in an in-house SVG fuse-box illustration (defensible IP, but expensive to produce per generation)
