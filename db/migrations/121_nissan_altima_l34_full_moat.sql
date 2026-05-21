-- Nissan Altima (L34) gen 27, 2018-2022 — per-engine moat backfill.
-- Source: 2020 Nissan Altima Owner's Manual (PDF, hosted at
-- manuals.startmycar.com — origin Nissan USA). Saved at
-- scrapers/manuals/2020-nissan-altima-om.pdf, capacity table from Section 10
-- "Technical and consumer information" pp. 10-2 — 10-3.
--
-- HaynesPro does NOT catalogue the Altima L34 (US/CA/JP-only — their data
-- ends at the L33, 2012-2018). The OEM owner manual is the primary public
-- source; cross-verified with the newly-created Nissan factory oil spec
-- aggregator (source 620, created in migration 119).
--
-- Engines (2 in our DB):
--   40 PR25DD    — 2.5L NA 4-cyl petrol (Altima 2.5 base, ~188 Hp)
--   41 KR20DDET  — 2.0L VC-Turbo 4-cyl (Altima VC-T / SR / Platinum, 248 Hp).
--                  World-first Variable Compression Turbo engine, 8.0:1↔14.0:1
--                  variable. Shared with Infiniti QX50.

SET NAMES utf8mb4;

SET @gen        := 27;
SET @e_pr25dd   := 40;
SET @e_kr20ddet := 41;
SET @s_sm       := 143;   -- Nissan Altima (L34) Service Manual
SET @s_nissan   := (SELECT id FROM sources WHERE citation LIKE 'Nissan factory oil spec%' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','differential_front')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','differential_front');

-- =========================================================================
-- engine_oil — per engine. Distinct viscosity + spec on PR25DD vs KR20DDET.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'engine_oil', 5.1, 5.39, '0W-20', 'Genuine Nissan Motor Oil 0W-20 SN (or synthetic 0W-20 GF-5 SN)', 10000, 16000, 12,
   'PR25DD 2.5L NA 4-cyl. With-filter sump capacity 5.1 L (5-3/8 US qt) per 2020 Altima OM Section 10. Without-filter drain-and-refill: 4.8 L. Severe-duty (towing, dust, frequent short trips) halves the change interval to 5,000 mi.'),
  (@gen, @e_kr20ddet, 'engine_oil', 4.7, 4.97, '5W-30', 'Genuine Nissan Motor Oil Ester 5W-30 SN (or synthetic 5W-30 GF-5 SN)', 10000, 16000, 12,
   'KR20DDET 2.0L VC-Turbo 4-cyl (Variable Compression Turbo, 8.0:1↔14.0:1). With-filter sump capacity 4.7 L (5 US qt) per 2020 Altima OM. The VC-Turbo''s multi-link reciprocating mechanism is fluid-quality sensitive — Genuine Nissan Ester 5W-30 SN is strongly preferred over generic 5W-30. Substitute synthetic 5W-30 GF-5 SN only if Ester variant unavailable.');

-- =========================================================================
-- coolant — Nissan Long Life Antifreeze/Coolant (blue), per-engine
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_pr25dd, 'coolant', 8.3, 8.77, 'Pre-diluted Genuine Nissan Long Life Antifreeze/Coolant (blue, L255)',
   'PR25DD primary engine cooling loop — 8.3 L total per 2020 Altima OM (with reservoir). Nissan blue LLC is the OE OAT formulation; do NOT substitute with green silicate IAT. Initial change: 105,000 mi / 6 yr; subsequent every 60,000 mi / 4 yr.'),
  (@gen, @e_kr20ddet, 'coolant', 8.2, 8.66, 'Pre-diluted Genuine Nissan Long Life Antifreeze/Coolant (blue, L255)',
   'KR20DDET VC-Turbo primary cooling loop — 8.2 L total per 2020 Altima OM. Slightly smaller than the NA 2.5L due to absence of EGR cooler.');

-- =========================================================================
-- transmission_cvt — Nissan NS-3, gen-wide (both engines pair with Jatco CVT)
-- Capacity not published in the OM (service-only spec).
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transmission_cvt', NULL, NULL, 'Genuine Nissan CVT Fluid NS-3', 'Jatco CVT (US Altima L34) on both PR25DD and KR20DDET. Nissan NS-3 ONLY — substituting NS-2, generic ATF, or any non-Nissan CVT fluid will destroy the variator. Total capacity not in the OM; service-drain refill ~3.5 L based on platform-mate (Rogue T33 PR25DD CVT). Service interval ~60,000 mi normal, 30,000 mi severe (towing).');

-- =========================================================================
-- gen-wide: differential gear oil (rear, AWD-equipped trims) + brake + A/C
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', NULL, NULL, 'Genuine Nissan Differential Oil Hypoid Super GL-5 80W-90 (conventional non-synthetic)', 'Rear differential — AWD trims only (Altima L34 offers Intelligent AWD). 80W-90 GL-5 conventional gear oil. Capacity not in the OM; consult service manual.'),
  (@gen, NULL, 'brake_fluid', NULL, NULL, 'Genuine Nissan Super Heavy Duty Brake Fluid / DOT 3', 'Brake fluid — DOT 3 spec only per 2020 Altima OM. 2-year change interval per Nissan schedule.'),
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'HFO-1234yf (R-1234yf), Nissan A/C System Oil Type PAG VC100YF', 'A/C refrigerant — Altima L34 ships globally with R-1234yf. Charge value per under-hood label. Compressor oil PAG VC100YF (Nissan-spec PAG variant).');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','differential_rear','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nissan FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','differential_rear','brake_fluid','ac_refrigerant');

-- =========================================================================
-- sweep + qt backfill
-- =========================================================================
DELETE fs FROM fluid_specs fs
WHERE fs.generation_id = @gen
  AND fs.fluid_type IN ('engine_oil','coolant')
  AND fs.viscosity IS NULL AND fs.spec_standard IS NULL
  AND EXISTS (
    SELECT 1 FROM fluid_specs fr
    WHERE fr.generation_id = fs.generation_id
      AND fr.fluid_type   = fs.fluid_type
      AND fr.id != fs.id
      AND fr.spec_standard IS NOT NULL
  );

UPDATE fluid_specs SET capacity_qt = ROUND(capacity_l * 1.05669, 2)
 WHERE generation_id = @gen AND capacity_l IS NOT NULL AND capacity_qt IS NULL;

SELECT 'Nissan Altima L34 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids;
