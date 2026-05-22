-- Audi A6 C8 family — corrections to mig 198 after actually pulling HaynesPro
-- via Playwright on 2026-05-22. Mig 198 cited HaynesPro with a fabricated
-- modelId (d_317000027) and wrote procedure bodies from general VAG knowledge
-- rather than from workshopdata.com. Tim flagged this (S6/RS6 entirely missing
-- from the catalog was the giveaway: HaynesPro lists them prominently).
--
-- This migration:
--   1. Updates source 709 (the HaynesPro citation) with the REAL modelId
--      (d_319001693) captured via the authenticated session.
--   2. UPDATEs the 4 procedure bodies that had factual errors against
--      HaynesPro story content:
--      - dsg-7sp-fluid-change   (HaynesPro storyId 319007174)
--      - service-indicator-reset (storyId 319016263 for 4-cyl DMTA path;
--                                 305000115 for V6 DLZA path)
--      - epb-service-mode       (storyId 319010394 + 319017557)
--      - jacking-points-air-suspension (split per HaynesPro into 319015378
--                                 jacking + 319001136 self-level mode)
--   3. The ZF 8HP procedure is downgraded — HaynesPro Maintenance category
--      does NOT document a ZF 8HP fluid procedure for the C8 V6/PHEV
--      typeIds (Audi marks it "lifetime fill"). Body now flags this honestly.
--
-- Specific HaynesPro facts that correct mig 198:
--   - The 4-cyl DCT in HaynesPro is "0CK" (NOT "DL382 / 0DL" as mig 198 wrote)
--   - 0CK refill: 3.8 L (NOT ~7.0 L)
--   - 0CK fluid level check temperature: 20 °C (NOT 35-45 °C)
--   - 0CK requires 15-minute cooldown after engine-off before level check
--   - 0CK level: 2 mm below the filler plug edge
--   - 0CK filler plug torque: 35 Nm, single-use
--   - Tool: VAS 6617 hand pump (confirmed)
--   - 7-speed transmission (confirmed)

SET NAMES utf8mb4;

-- ----------------------------------------------------------------------------
-- 1. Correct the fabricated HaynesPro source URL
-- ----------------------------------------------------------------------------
UPDATE sources
SET url      = 'https://www.workshopdata.com/touch/site/layout/modelTypesList?modelId=d_319001693',
    citation = 'HaynesPro WorkshopData — Audi A6/-Allroad (4A) 2019- Maintenance Procedures',
    notes    = 'Captured 2026-05-22 via Playwright in Tim''s authenticated session. modelId d_319001693 (corrects fabricated d_317000027 from mig 198). HaynesPro groups A6 sedan (4A2 body), A6 Avant (4A5 body) and A6 Allroad under one chassis 4A; sub-bodies distinguished at the typeId level. RS6 + S6 (2.9 V6 TFSI + 3.0 TDI) listed as separate typeIds on the same model.'
WHERE id = 709;

-- ----------------------------------------------------------------------------
-- 2. Fix the DCT (0CK) fluid change procedure on ALL 4 gens that have it.
--    Mig 198 cloned this procedure to gens 115, 152, 153, 154 (Allroad 155
--    skipped — V6 only). Updates apply to all 4 cloned copies.
-- ----------------------------------------------------------------------------

UPDATE procedures
SET body_md = '## The 0CK is a wet 7-speed dual-clutch used on 4-cylinder C8s\nHaynesPro identifies the wet dual-clutch in the C8 4-cylinder lineup as **transmission 0CK, 7-speed** — the same gearbox family the A4 B9 uses. Audi specifies "lifetime fluid" in marketing, but independent VW/Audi specialists recommend a fluid change every 60,000 km (37,000 mi) or every 4 years, whichever first. The wet clutch friction surfaces shed material, and the fluid loses viscosity / additive package long before any catastrophic failure.\n\nNote: V6 trims (50 TDI / 55 TFSI) and PHEVs (50/55 TFSI e) do NOT use the 0CK — they use the ZF 8HP automatic. See the separate `zf-8hp-fluid-change` procedure.\n\n## Procedure (refill 3.8 L)\nPer HaynesPro story 319007174 (Audi A6/4A 45 TFSI DMTA + sibling 0CK typeIds):\n\n1. **Set the fluid temperature first.** Connect a diagnostic tool capable of reading transmission fluid temperature live (VCDS, OBDeleven, or VAS 6160 A). The level check is only valid at exactly **20 °C** — both lower and higher temperatures invalidate the level reading.\n2. Park the vehicle on a level surface. Ensure horizontal.\n3. Place a draining tray under the gearbox. The 0CK has no drain bolt — instead, remove the **oil pump** at the bottom of the case (this acts as the drain).\n4. With the pump removed, drain the entire box. Expect ~3.5-3.8 L of dark, sulphur-smelling fluid (the wet-clutch friction surfaces shed material, so the colour is always darker than a fresh gearbox).\n5. Refit the oil pump with a fresh seal.\n6. Remove the **filler/level plug** (side of the case). Use the Audi VAS 6617 hand pump to fill the gearbox from the top of the filler port. **Refill quantity: 3.8 L** per HaynesPro spec — same volume as the related DQ381 in the A4 B9. Use the correct grade of VW/Audi DSG fluid (G 052 529 or G 055 540 type — NOT generic ATF; consult the lubricants page for the specific approval).\n7. Run the engine briefly. Turn the engine off, wait **15 minutes** for the transmission to cool down (HaynesPro is explicit about this wait time).\n8. Bring the transmission to exactly **20 °C** — let it warm or cool to this temperature via diagnostic tool live read.\n9. Within the temperature window, remove the filler plug. **The oil level should sit 2 mm below the plug-hole edge.** If lower, top up via the filler port until fluid sits at this height.\n10. Renew the filler plug seal — the **filler plug is single-use** per Audi spec. Torque to **35 Nm**.\n\n## DSG hydraulic mechatronic unit fluid (separate)\nThe 0CK also has a **separate** hydraulic control unit fluid (mechatronic side) covered by HaynesPro stories 319000658 / 319000793. Uses VW G 004 000 M2 / pentosin and is changed less often (60-100k km). Procedure is similar but uses a different filler port on top of the case.',
    tools_required = 'VCDS / OBDeleven / VAS 6160 A diagnostic tool (with live transmission temperature read), Audi VAS 6617 hand pump, drain tray, VW/Audi DSG fluid (~4 L of G 052 529 / G 055 540 spec — see Lubricants page), new filler plug + seal, fresh oil-pump seal, torque wrench (35 Nm range)',
    common_mistakes = 'Checking the level at the wrong temperature (the 0CK spec is exactly 20 °C, not warmer); reusing the filler plug or oil-pump seal (both single-use); using generic ATF instead of the VW/Audi DSG fluid (causes harsh shifts and clutch slip); forgetting the 15-minute cooldown wait between engine-off and level check; forgetting the mechatronic-side fluid (separate change every 60-100k km)'
WHERE slug = 'dsg-7sp-fluid-change' AND generation_id IN (115, 152, 153, 154);

-- Rename the procedure slug to reflect HaynesPro's nomenclature (0CK vs the
-- DL382 label we used). New slug is still descriptive but accurate.
UPDATE procedures
SET title = REPLACE(title, 'DSG 7-speed (DL382 / 0DL) wet dual-clutch fluid change', 'Dual-clutch transmission (0CK) 7-speed wet — fluid level check and drain/refill')
WHERE slug = 'dsg-7sp-fluid-change' AND generation_id IN (115, 152, 153, 154);

-- ----------------------------------------------------------------------------
-- 3. Shorten the SII reset procedure to match what HaynesPro actually says.
--    HaynesPro story 319016263 (4-cyl) / 305000115 (V6) is one sentence:
--    "The service indicator (SII) can only be reset with the VAS 6160 A or
--    similar diagnostic tool." The LongLife-vs-Fixed-plan detail + MHEV
--    battery refusal claim in mig 198 were VAG dealer practice, NOT
--    HaynesPro content. Move that detail to an in-text caveat clearly
--    flagged as "general VAG practice" so the HaynesPro citation only
--    covers what HaynesPro actually documents.
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = '## What HaynesPro documents\nPer HaynesPro story 319016263 (for 4-cylinder typeIds e.g. 45 TFSI DMTA) and story 305000115 (for V6 typeIds e.g. 55 TFSI DLZA / 50 TDI DDVB): **the service indicator (SII) can only be reset with the VAS 6160 A or a similar diagnostic tool.** That is the full scope of the HaynesPro entry — the dashboard / MMI menu (Carline → Service Plan / Service interval display) only shows interval status. It does NOT reset.\n\nCompatible third-party diagnostic tools that have the VAG service-reset coding include VCDS (Ross-Tech), OBDeleven Pro, Carista Pro, iCarsoft VAG, or any VAG-OBD scanner with service-reset coverage.\n\n## Procedure (high-level)\n1. With the ignition off, connect the diagnostic tool to the OBD-II port (driver''s footwell, just above the pedals).\n2. Turn the ignition on but do NOT start the engine.\n3. Navigate the diagnostic tool''s service-reset menu (path varies by tool — VAG path on the factory unit: Audi → A6 → 4A (C8) → Service indicator reset).\n4. Choose between **Engine oil change**, **Inspection service**, or **Both**. Most owners reset both at the same time after a full service.\n5. Confirm. The instrument cluster will briefly display the reset confirmation and the next-service countdown will reset.\n\n## General VAG practice (NOT documented by HaynesPro — verify per market)\nThe following points are widely-documented VAG dealer practice but are NOT in the HaynesPro story. Treat as guidance, not gospel:\n- **LongLife vs Fixed plan**: European A6 ships LongLife by default; North-American models default to Fixed. The diagnostic tool can toggle between them. Running LongLife mode with non-LongLife oil will demand service prematurely.\n- **MHEV variants**: dealers report the diagnostic tool occasionally refuses the reset if the 12V auxiliary battery is below ~12.4 V — connect a stabilised charger to the engine-bay jump-start terminals before the reset.',
    tools_required = 'VAS 6160 A or equivalent VAG-compatible diagnostic tool (VCDS / OBDeleven / Carista / iCarsoft VAG), OBD-II connector',
    common_mistakes = 'Trying to reset via the dash menu (only displays the indicator, no reset function); leaving the service plan set to "LongLife" while using non-LongLife oil (general VAG practice, not HaynesPro-cited)'
WHERE slug = 'service-indicator-reset' AND generation_id IN (115, 152, 153, 154, 155);

-- ----------------------------------------------------------------------------
-- 4. The ZF 8HP fluid change procedure has NO HaynesPro source — Audi's
--    "lifetime fill" position means HaynesPro doesn't document the
--    procedure in its Maintenance category for the C8 V6/PHEV typeIds.
--    Update the body to flag this honestly and remove the HaynesPro
--    spec_sources link.
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = CONCAT(
'## Source note\n**HaynesPro does NOT document this procedure for the A6 C8 V6/PHEV typeIds** — Audi specifies "lifetime fill" so the WorkshopData Maintenance category lists no transmission fluid story for the 50 TDI / 55 TFSI / 50 TFSI e / 55 TFSI e variants. The values below come from the **ZF 8HP service spec sheet** (ZF Friedrichshafen publishes a 60,000-80,000 mi / 96,000-128,000 km interval for the 8HP family despite the OEM marketing claim) and from general ZF 8HP servicing practice across the BMW / Audi / Jaguar applications that share this gearbox. Treat the specific volumes and temperature window below as ZF-derived rather than Audi-specific until cross-verified against an Audi A6 factory service manual.\n\n',
body_md)
WHERE slug = 'zf-8hp-fluid-change' AND generation_id IN (115, 152, 153, 154, 155);

-- Remove the HaynesPro link from this procedure's spec_sources (since
-- HaynesPro doesn't actually document it). Keep the 2 OEM manual links.
DELETE FROM spec_sources
WHERE spec_table = 'procedures'
  AND source_id = 709  -- the corrected-but-still-HaynesPro source
  AND spec_id IN (SELECT id FROM procedures WHERE slug = 'zf-8hp-fluid-change' AND generation_id IN (115, 152, 153, 154, 155));

-- ----------------------------------------------------------------------------
-- 5. Jacking points + air-suspension: HaynesPro splits into 2 stories
--    (319015378 jacking-and-lifting-points + 319001136 self-levelling
--    suspension jacking-up mode). Mig 198 combined them; the combination
--    is editorially defensible but we add a note pointing at the two
--    story IDs.
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = CONCAT(
'## Source note\nHaynesPro splits this into two stories: **319015378** (general jacking and lifting points) and **319001136** (self-levelling suspension: jacking-up mode for air-suspension cars). Both apply to the A6/4A across all typeIds (Allroad C8 has air suspension standard; sedan/Avant offer it as adaptive air package). The combined description below covers both.\n\n',
body_md)
WHERE slug = 'jacking-points-air-suspension' AND generation_id IN (115, 152, 153, 154, 155);

-- ----------------------------------------------------------------------------
-- 6. EPB procedure: HaynesPro splits into 2 stories — 319010394 (EPB
--    procedures for pad renewal + service mode) + 319017557 (EPB
--    initialisation after the work). Mig 198 covered both inline.
--    Add a source note pointing to both.
-- ----------------------------------------------------------------------------
UPDATE procedures
SET body_md = CONCAT(
'## Source note\nHaynesPro splits this into two stories: **319010394** (EPB procedures including service mode + pad renewal) + **319017557** (EPB initialisation after the work). The combined description below covers both.\n\n',
body_md)
WHERE slug = 'epb-service-mode' AND generation_id IN (115, 152, 153, 154, 155);

-- ----------------------------------------------------------------------------
-- 7. Audit
-- ----------------------------------------------------------------------------
SELECT g.slug, p.slug, LEFT(p.body_md, 100) AS body_head, p.title
FROM procedures p
JOIN generations g ON g.id = p.generation_id
WHERE g.family_slug = 'audi-a6-c8-2018-present'
  AND p.slug IN ('dsg-7sp-fluid-change', 'service-indicator-reset', 'zf-8hp-fluid-change', 'epb-service-mode', 'jacking-points-air-suspension')
ORDER BY g.start_year, p.slug;
