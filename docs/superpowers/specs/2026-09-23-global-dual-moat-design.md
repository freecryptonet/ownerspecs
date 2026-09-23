# ownerspecs.com — Global dual-moat document-first specs site (design)

**Status:** Approved 2026-09-23 (Tim + panel-unanimous). Amends `CLEAN_START_PLAN_2026-09-04.md` (EU-only → global). Feeds the implementation plan (writing-plans next).

## 1. Thesis

ownerspecs.com is **one global, document-first vehicle-specs site** competing with auto-data.net / ultimatespecs.com. One promise: **every published spec value cites a primary document.** Two document-families ("moats"), built **fully in parallel**:

- **Moat A — global/US owner-manual + FSM specs** (fluids, oil capacity, torque specs, bulbs, fuses, maintenance schedules, tyre pressures). Sourced from OEM owner manuals + factory service manuals. Serves **Tier-1 US traffic** (highest ad CPM). This revives ownerspecs' original thesis — the deep owner-manual data incumbents omit — now under the clean-start's citation rigor the old lore-based version lacked.
- **Moat B — EU market-delta wedge** (RDW masses/towing + CoC tyre homologation §35/§52 + tow-ball load §19). Per-country deltas that aggregators flatten. The unique, un-copyable EU differentiator.

Why a .com, why global: US owners search specs ("2019 Civic oil capacity", "F-150 lug-nut torque") in Tier-1-CPM volumes. ownerspecs.com is a global domain and a specs-browsing site; the sister site vindecoder.site is a **VIN decoder** (a different concept) and cannot serve this traffic. US OEM owner manuals are primary documents we already crawl — so US specs can be document-verified without a CoC.

## 2. Publish discipline — why this ranks where the old version didn't

The earlier generic version underperformed (~2 clicks/day) on **lore data + surface-level "all specs" dumps**. The fixes are load-bearing:

- **Hard publish-rule: no primary-document citation → no page.** `noindex` unless a page carries **≥3 unique document-verified datapoints**. Monthly audit of uncited / thin pages.
- **Win on depth, not breadth:** bulbs, fuses, torque specs, maintenance schedules, fluid specs — the long-tail friction queries incumbents miss — with visible per-value citations, structured data (JSON-LD), and E-E-A-T. **No** generic hp/top-speed overview pages.
- **US legal (critical):** US OEMs (GM/Ford/Stellantis) enforce copyright on manuals/FSM far more aggressively than EU authorities on CoC/RDW. Publish **strictly normalized facts only — never verbatim text or OEM diagrams** (facts-only / Feist posture, US-critical).

## 3. Data model — mig 579 supports both moats already

The document-first schema (`db/migrations/579_document_first_schema.sql`, panel-reviewed, gap-checked, GO) needs **no redesign** for dual-moat:

- **`documents`** is the provenance root for every source (`doc_type` ∈ coc | type_plate | owner_manual | workshop_manual | fsm | refrigerant_label | component_photo | rdw_open | …). An owner manual and a CoC are both documents.
- **Moat A facts** = `spec_facts` rows (fluid/torque/electrical/service `fact_type`s, already seeded) with `source_document_id` → the OEM manual/FSM document. `qa_state`, `valid_from/to`, per-value citation all apply.
- **Moat B facts** = the typed wedge tables `tyre_homologations` + `mass_homologations` (+ RDW mass facts), sourced to CoC / `rdw_open` documents.
- Identity: `vehicle_types` (TVV: full-approval + variant + version) for EU; makes/models/generations for global routing. `source_priority` arbitrates conflicts.

So the clean-start's "wipe contaminated data" step becomes **"repopulate via document-first"**: Moat A from OEM manuals, Moat B from RDW/CoC. Both enforce `source_document_id NOT NULL` (no inferred facts).

## 3a. Architecture integration (panel-validated against the built app, 2026-09-23)

The document-first model retrofits onto the existing Next.js app with **no new URL tiers**:

- **Grain (hybrid):** `trims` stays trade-name / powertrain **scaffolding** (the hub "Pick your trim" table + Tier-3 URLs); `vehicle_types` (TVV) is the **document-verified data grain**. Link via **`trims.vehicle_type_id` (nullable FK)** — added to mig 579. RDW mass facts match a trim cluster on `baseName|hp|engine_code`; the range surfaces in the hub column + detail on `/towing`. Do NOT demote `trims` (breaks the catalog).
- **Render homes (no new top-level routes):** RDW masses/towing/axle-load/kogeldruk → enhance the existing **`/towing`** topic; CoC tyre-homologation §35/§52 → a homologation section on the existing **`/tires`** topic. Moat-tiles stay Tier-2.
- **Market deltas:** no per-market pages — render NL/DE/BE as market-scoped rows or an "NL/DE/BE" column on `/towing`+`/tires`, default NL with others collapsed; the existing market pills act as filters.
- **Citations:** extend `buildCitationIndex`'s allow-list (currently 13 legacy tables) to include `documents` + `spec_facts` + `tyre_homologations` + `mass_homologations`, so every dual-moat value emits its `[n]` + sources entry.
- **"No citation → no page" enforcement = the existing render-gate/`notFound` pattern** (a page renders only with ≥3 cited datapoints), **NOT a parallel `noindex`.** (Corrects the earlier round — the site uses render-gate everywhere; only `/search` uses noindex, so a noindex rule would be inconsistent.)
- **Auto-data `trims`:** keep, but label explicitly as **"catalog (indicative, uncited)"**; `VerifyBadge` + `[n]` are reserved for document-sourced facts. E-E-A-T via separation, not via gaps.
- **SSG build impact (blind spot):** aggregating tens of thousands of TVVs at build time via `spec_facts` will slow SSG → **materialize cluster aggregates (mass ranges) in MySQL** ahead of the build.
- **Publish CI checks:** block publish/deploy unless the 40 kg mass-span veto passes AND the `trim ↔ vehicle_type` cluster map is 1:1 AND the page has ≥3 cited datapoints.
- **Editorial / provenance workflow (blind spot):** a document authoring/curation path (add a document, link facts, record provenance) is still unspecified — required before scaling CoC + OEM-manual ingest.

## 4. Data sources & pipelines

### Moat A — OEM manuals / FSM (global, incl. US)
- Existing crawlers (manufacturer-owned → `public_link=1`): Mopar (694 PDFs), GM (1,379), Ford US, Nissan/Infiniti US, Mercedes US, Mazda CA, Kia CA, Genesis CA, Hyundai NL+UK, Mitsubishi NL. EU direct-PDF: **Stellantis eGuide** (per-language), Toyota EU. HTML-only per-gen (Playwright): Audi, VW-Group, Renault.
- Pipeline: crawler downloads PDFs → convert on demand → extract facts → `spec_facts` with citation. Aggregator fallbacks (allcarmanuals, ManualsLib) = internal-only, `public_link=0`, never named, older-chassis NULL-fill only.

### Moat B — EU market-delta (RDW + CoC)
- **RDW open data (CC0, `public_link=1`):** per-VIN masses/towing (`m9d7-ebf2`), per-axle load+track (`xhyb-w7xt`), tow-ball + dims (`byxc-wwua`), motorcode (`4by9-ammk`), transmission (`7rjk-eycs`). Prototype validated (`scripts/rdw_masses_prototype.py`): exact CoC match on Kia Rio (5/5 masses + both axles); per-TVV modal + agreement pollution guard; clustering to marketed trims with a **40 kg mass-span veto**. RDW lacks tyres AND tow-ball for M1 → both CoC-only.
- **CoC ingest — CONTINUOUS pipeline (Tim shares new CoCs regularly).** Design for a steady stream, not a one-off batch: drop CoC (transcription or scan) → parse (per-brand §52 dialects) → `documents` + `document_fields` (raw capture) → `vehicle_types` + wedge facts. Each new CoC also serves as a gold cross-check point for the RDW lane.

## 5. Research / validation plan (data quality first, both moats)

A reusable data-quality harness, triangulating **4 signals** (CoC-gold · external reality anchors · cross-source · internal stats — because internal consistency alone missed the RDW body-field error):

- **Moat B / RDW:** per-field trust scorecard on a **~12-15 representative cross-section** (multiple brands × segments × fuels × bodies + one import-heavy model + the CoC cars). Output: publish / corroborate / reject per field. (Known: `inrichting` body field is unreliable — 99% of Golf mis-coded "stationwagen"; use `handelsbenaming` instead.)
- **Moat A / US OEM manuals:** validate the extraction pipeline — does the extracted oil capacity / torque actually match the source PDF? (An OM citation is a claim, not proof.)
- **Government-source landscape:** national (NL RDW, DE KBA, BE) + EU-level + **US federal** (NHTSA vPIC / GVWR, EPA fuel economy) — per source: fields, reliability, openness/licence — for cross-validation, gap-filling, and market expansion (DE/BE).

## 6. Build sequencing & gate

- **Fully parallel** from day one: Moat A (top US/global models via OEM manuals) + Moat B (NL wedge via RDW/CoC).
- **Schema:** apply mig 579 once Tim's next CoC batch lands (final gap-check first).
- **Gate (revised from the EU-clicks-only kill-switch):** a **monetized** signal — US ad revenue / RPM proxy **alongside** wedge clicks — measured over **~9 months**. An EU-clicks-only gate would strangle the Tier-1 opportunity.
- **Working method:** spar with the multi-model panel continuously at every meaningful decision ([[feedback_spar_with_panel_continuously]]).

## 7. Risks & guardrails

| Risk | Guardrail |
|---|---|
| Relapse to the generic underperformer / index bloat | No citation → no page; `noindex` unless ≥3 cited datapoints; monthly thin-page audit |
| US OEM copyright enforcement (DMCA) | Normalized facts only; never verbatim text or OEM diagrams |
| RDW data pollution / wrong TVV joins (masses on wrong car) | Modal + agreement (n≥10, ≥0.80); variant disambiguation via curated mapping; track % RDW-without-CoC-match |
| Silent wrong-merge in clustering | 40 kg mass-span veto → range or per-TVV, never one misleading number |
| Spreading thin across two moats | One coherent promise + shared schema; depth-first publishing; parallel but disciplined |
| Data-quality assumed, not measured | The §5 validation harness runs before trusting any field at scale |

## 8. Open items / dependencies

- Apply mig 579 (blocked on final CoC gap-check — awaiting Tim's next batch; more arriving regularly).
- Bootstrap identity from the kentekenfeiten curatie seed + port `euTypeApproval.ts` (done) once schema applied.
- Instrument the monetized gate metric (ad RPM + wedge clicks).
- Legal check on US OEM manual usage posture before scaling Moat A.
- Decompose into implementation plans (writing-plans): (1) data-quality harness + gov-source landscape [written]; (2) RDW lane productionization + clustering + **materialized cluster aggregates**; (3) CoC continuous-ingest pipeline + **document editorial/provenance workflow**; (4) Moat A OEM-manual extraction; (5) render layer — extend `buildCitationIndex`, `trims.vehicle_type_id` mapping, enhance `/towing`+`/tires`, market-delta columns, **render-gate enforcement (not noindex)**, publish CI checks (40 kg veto + 1:1 cluster map + ≥3 cited).
