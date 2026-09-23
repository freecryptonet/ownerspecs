# ownerspecs clean-start — LOCKED plan (2026-09-04)

**Status: LOCKED. Panel-unanimous (Gemini + OpenAI + Grok) after 6 rounds — clean ENDORSE from all three on round 6.**
This **reverses** the 2026-08-28 retirement/fold-in decision. ownerspecs is no longer "retired / STOP WORK"; it is an active, repositioned, clean-start project with a hard 6-month kill-switch. Supersedes `OWNERSPECS_FOLD_IN_PLAN_2026-08-28.md` (the merge was rejected by Tim — sites stay separate).

---

## 1. The thesis

**ownerspecs = market-specific, document-verified vehicle specs.**
The product is the spec *as it actually is in a given country/market*, every value traceable to a **primary document** (Certificate of Conformity / body-type plate / owner manual / factory workshop manual). It surfaces the **per-country deltas** that auto-data.net and ultimatespecs.com flatten into one generic number.

Why this is defensible (and a generic specs site is not): incumbents win on volume/age/links with commodity catalog data. We cannot beat that. We *can* own the niche where the registered vehicle genuinely differs by market — homologated tyre/wheel combos, kerb/max/towing masses, emissions class, engine availability, market/climate-scoped fluid grades — because Tim holds a large, growing stack of primary documents (one per real VIN) that capture exactly those deltas.

## 2. Strategy (round 4, unanimous)

- **Wedge (build first):** market-specific **towing/max masses + homologated tyre/wheel combinations**, per market, **NL first → then DE/BE**. High practical intent (inspection / import / towing-bar), poor incumbent coverage, CoC+plate give direct proof. **Second layer:** oil grade / service intervals from workshop manuals.
- **Page structure (thin-content guard):** ONE canonical model/type page with per-market overrides (tabs/badges). Dedicated market page **only when data substantially differs**; otherwise show "no market difference" and canonical to the model page. No clone pages.
- **Links / authority:** niche forums (import, trekhaak/towing clubs, RDW/TÜV threads, classic clubs), tyre dealers, independent garages; ship a **free "CoC / type-plate decode" tool** as embeddable linkbait.
- **Legal (the #1 underestimated risk):** facts-only extracts/tables, **no full-manual dumps, redact VINs**, license-check before scaling. Matches the cluster's existing facts-only (Feist) posture.
- **Kill-switch:** 3-month leading check = ≥1 wedge page-cluster on Google page 1 **and** rising wedge-query impressions → else stop early. 6-month gate = **≥100 organic clicks/day on wedge pages** → keep separate & scale; **<100 → fold into servicereset**.

## 3. Clean-start base (round 5)

- **A. DOMAIN — KEEP ownerspecs.com.** Domain age + GSC continuity, no toxic equity (footprint is tiny), a new domain is a pointless sandbox reset. (Renew it — do NOT let it lapse.)
- **B. OLD PAGES — 410 the ~15k thin scraped URLs.** No noindex (crawl-budget leak); no bulk-301-to-home (signal dilution); 1:1 redirect ONLY where a document-backed page exists. **Timing: only AFTER the NL wedge pages are live** (see build order) — never before, or Google sees an empty ghost-site instead of an upgrade.
- **C. CODE — keep the Next.js app, design system, extraction + HaynesPro/webdatabays pipelines.** The contamination is in the DATA, not the code.
- **D. DATA MODEL — document-first.** `documents` (type, country/market, provenance, VIN redacted) → `spec_facts`, each with **mandatory** `source_document_id` + `market_id` + vehicle link. **No orphan facts. No inferred facts.** Publish only document-backed facts; render blank / "not verified for this market" where none exists.

## 4. Day-1 schema invariants (expensive to change later — get right first)

1. **Immutable canonical vehicle identity + URL structure**, mapped to EU type-approval identity: **Make → Model → Generation → Type/Variant/Version (the e\*-approval TVV)**. A document must never attach to the wrong car; URLs must never churn. (Consistent with the existing `engines.slug` frozen-URL rule.)
2. **Provenance NOT NULL** — `source_document_id` + `market_id` required on every fact row.
3. **Facts VERSIONED** — immutable rows + effective date; never overwritten in place.
4. **Inference PROHIBITED at the model level** — a fact with no `source_document` cannot exist.

## 5. Build order

1. **Schema** with the §4 day-1 invariants.
2. **Manual extraction of the first ~50 NL vehicles by hand** — validate document coverage BEFORE automating the pipeline (don't code the extractor until the docs prove they're dense enough).
3. **First NL wedge page-cluster LIVE** (masses + tyre homologation).
4. **Decode tool** (CoC / type-plate → embeddable linkbait).
5. **THEN 410** the ~15k old scraped pages.

## 6. Execution notes (round-6 blind spots — bake in, not optional)

- **Alias/lookup layer (Gemini):** humans search commercial labels ("Golf 8 1.5 eTSI R-Line") and by registration/kenteken — almost never the formal TVV code. The rigorous TVV identity MUST have an explicit alias/mapping layer to trade names + a kenteken/registration lookup, or perfect data still fails on findability.
- **Conflict-resolution policy (OpenAI):** a fixed rule-set for when source documents conflict for the same market — which source wins, and what the user sees. Affects UX + trust.
- **QA sign-off gate (Grok):** define the operational burn-rate and **who signs off on fact-rows** as a hard human gate BEFORE any pipeline automation. Manual QA cost is real; staff it.

## 7. First concrete data (already in hand)

8 CoCs transcribed at `F:\projects\servicereset\temp\ESD-USB\COC\*.md` (Kia Rio YB, Kia Sportage NQ5, Hyundai Tucson TL, Hyundai i20 GB + BC3, Mazda CX-5 KF, Toyota Auris E180, Nissan Pulsar C13). Each already carries the wedge fields: masses (§13/16/18) + every homologated tyre/wheel combo (§35 + §52 remarks). Kia Rio = highest-value (was servicereset's top page). Plus a growing stack of body-plates + owner/workshop manuals.

## 8. Pointers

- ownerspecs ops: `F:\projects\ownerspecs\CLAUDE.md`; DB `mariadb ownerspecs` on VPS 72.62.154.119; manuals corpus + `scripts/manual_query.py`.
- Panel: `node F:\projects\kentekenfeiten\scripts\panel.mjs`.
- Superseded doc: `F:\projects\servicereset\OWNERSPECS_FOLD_IN_PLAN_2026-08-28.md`.
- Decision memory: `F--projects-ownerspecs/memory/project_clean_start_2026_09_04.md`.

---

## 9. AMENDMENT — two-lane wedge (LOCKED 2026-09-23, panel-unanimous)

The wedge is now **two lanes**, not CoC-only. Panel (Gemini+OpenAI+Grok) unanimously endorsed; Tim locked it 2026-09-23. Reason: pure CoC-first (~50 hand-collected cars) cannot realistically hit the 6-month ≥100 clicks/day gate.

- **RDW lane (breadth):** NL registration authority open data → per-VIN/per-type masses & towing for the WHOLE NL fleet, free, official. A legitimate PRIMARY source (registered value is legally leading for NL). `doc_type='rdw_open'`, `source_priority=90`. RDW has **no tyre data**, so it structurally cannot touch the tyre moat.
- **CoC lane (depth):** homologated tyre/wheel combos §35/§52 — the un-copyable layer nobody (not even RDW) publishes. `source_priority=100`.

**Guardrails (moat holds IFF all three):** tyres stay CoC-only · NO competitor-catalog scraping (Feist unchanged) · per-fact provenance labelled in UI ("RDW registered" vs "CoC §35/§52").

**Thin-content rule:** NEVER masses-only URLs. One canonical model/gen page = RDW masses + CoC tyres where present + visible "tyres: awaiting CoC" state; noindex true stubs.

**Day-1 mandatory (biggest risk = RDW pollution + wrong TA↔model joins):** validate every RDW fact against cohort min/median/max (kentekenfeiten `content\modellen\*.json`); out-of-range → `qa_state='flagged'` → human queue; render only `approved`. Join via curated `curatie\generatie-curatie.tsv`, never naive base-only.

**Conflict UX:** RDW vs CoC mass disagreement → keep BOTH (conflict_group), render both labelled; never silently pick one.

Full schema + rationale: `SCHEMA_DESIGN_2026-09-23.md`. Build assets: vindecoder `euTypeApproval.ts` (ported → `lib/euTypeApproval.ts`), kentekenfeiten `curatie\generatie-curatie.tsv` (2,600 base→generation mappings → identity seed).

---

## 10. Source strategy & sequencing (panel-reviewed 2026-09-23)

After a 3-lane source investigation (RDW open data · allcarmanuals FSM · OEM/dealer manual portals) the panel (Gemini+OpenAI+Grok) set the sequencing. **Majority ruling: RDW-first, narrow parallel with hand-CoC validation; defer everything else.**

- **BUILD NOW — RDW masses lane.** Per-VIN NL masses/towing on `m9d7-ebf2` (+`3huj-srit` axles, `byxc-wwua` tow-ball). CC0 → `public_link=1`. Sibling ETL (`kentekenfeiten/scripts/etl-modellen.mjs` + `scripts/lib/*.mjs`) is ~copy-paste; port it with the variant-disambiguation + outlier guards intact. Delivers breadth toward the ≥100-clicks/day gate without waiting for CoCs. Automating RDW does NOT break the "validate CoC by hand first" rule — that rule governs the CoC/tyre lane only.
- **PARALLEL — CoC by hand (Tim).** The ~50 hand-transcribed CoCs remain the gold validation canon for the tyre-homologation moat (§35/§52). RDW has NO tyre data (confirmed 3×), so tyres are CoC-only, forever.
- **DEFER — Stellantis eGuide + all OEM owner-manual ingest + new-generation watch.** Not until the RDW↔CoC join is stable and gate progress is shown. eGuide is the best market-delta manual source (direct-PDF, per-language `nl-NL`/`fr-BE`/`de-DE`) but it is "glamorous, not the moat," and its manuals map to fuzzy marketing model/year (not TVV) → join pollution risk.
- **OEM manuals = Layer-2 ENRICHMENT ONLY, never a 3rd acquisition lane.** Add engine/gearbox/interval specs ONLY onto cars that already carry CoC tyre data, framed as "service data for this homologated config" — never oil/intervals as the page hook (that's incumbent commodity data). §35/§52 tyres stays the wedge.
- **allcarmanuals** = niche NULL-filler for older chassis only; internal-only, never-name, `public_link=0`.

**Mass-conflict rule:** RDW wins the primary rendered mass (legally leading for NL registration/MRB); CoC §13 shown alongside as "factory homologation value" — the visible delta IS the brand promise. Never silently drop either (conflict_group keeps both). Manuals never source a mass.

## 11. AMENDMENT — GLOBAL DUAL-MOAT (LOCKED 2026-09-23, panel-unanimous flip)

**Supersedes the EU-only framing of §1–§10.** ownerspecs.com is a **.com (global)** domain; US traffic is Tier-1 (highest ad CPM) and must not be forfeited. An earlier panel round said "EU-pure, route US via vindecoder" — WRONG on two premises Tim caught: (a) .com ≠ .eu (global intent), (b) **vindecoder.site is a VIN-decoder, a different concept** — it cannot capture US specs-browsing traffic. Plus: **document-first ≠ EU-only** — US OEM owner manuals + FSM are primary documents we already crawl (Mopar/GM/Ford/Nissan/MB/Kia, 1000s of PDFs). Re-briefed panel = **unanimous flip to global dual-moat.**

**ownerspecs = ONE global document-first specs site, two document-families, built FULLY IN PARALLEL:**
- **Moat A — global/US owner-manual + FSM specs** (fluids, oil capacity, torques, bulbs, fuses, maintenance schedules, tyre pressures). Document-verified from OEM manuals. Serves Tier-1 US traffic. This revives ownerspecs' ORIGINAL thesis — but with the clean-start citation rigor the old (lore-based) version lacked.
- **Moat B — EU market-delta wedge** (RDW masses/towing + CoC tyre homologation §35/§52 + tow-ball §19). Unique per-country deltas; the EU differentiator.
- One promise: *"OEM-document-verified specs"* — every value cites a primary source (manual/FSM/CoC/RDW). Two clearly-labelled layers: Owner Manuals (global) + EU Homologation (per-country deltas).

**Why the global version ranks where the old one didn't (Q5):** the old generic version failed on **lore + surface-level "all specs" dumps** (~2 clicks/day). The fix — **publish ONLY values with a document citation; win on the DEPTH incumbents miss** (bulbs/fuses/torques/schedules/fluids) + per-value citations + structured data + E-E-A-T + long-tail friction queries. No generic hp/top-speed overviews.

**Hard publish-rule (guardrail against the generic-underperformer relapse + index bloat):** no primary-doc citation → no page. `noindex` unless a page has **≥3 unique document-verified datapoints**. Monthly audit of uncited/thin pages.

**US legal (Gemini blind-spot):** US OEMs (GM/Ford/Stellantis) enforce copyright on manuals/FSM far more aggressively than EU authorities on CoC/RDW → strictly normalized facts only, **NEVER verbatim text or OEM diagrams** (facts-only/Feist, but US-critical).

**US = depth + verification, not market-delta.** Light US deltas (oil viscosity, GVWR/towing, EPA vs WLTP, CARB) are seasoning, not the core.

**Gate metric REVISED (§2 kill-switch amended):** measure a **monetized** signal (US ad revenue / RPM proxy) alongside wedge clicks, over **~9 months** — an EU-clicks-only gate would strangle the Tier-1 opportunity.

---

## (§10 continued) BIGGEST RISK (panel-unanimous): variant disambiguation. One `typegoedkeuringsnummer` base spans platform-twins/rebadges → a naive join silently attaches wrong masses to the wrong model page and kills "verified" authority. Mitigation: reuse the sibling `assignCombosToCohorts()` disambiguation (merk + handelsbenaming + date window), strict join-QA, and track **% of RDW records without a CoC match** as the go/no-go health metric. Grok's second risk: spreading effort across 3 lanes → generic specs site → miss the gate on diluted differentiation → hence the defer-everything-but-RDW ruling.
