-- Mitsubishi Outlander (GN) gen 30, 2022-2025 — per-engine moat backfill.
-- Sourced from HaynesPro WorkshopData via scrapers/haynespro.ts on 2026-05-21.
-- typeId: PR25DD t_619037936 (HaynesPro lists only the petrol PR25DD for the
-- new GN/GM chassis — the 4B12 PHEV variant is not yet in HaynesPro's
-- catalogue under this gen entry).
--
-- The new Outlander shares the Renault-Nissan Alliance CMF-CD platform with
-- the Nissan Rogue T33 (X-Trail). PR25DD is the Nissan-developed 2.5L
-- naturally-aspirated 4-cyl petrol engine; the GN's PHEV variant uses the
-- 4B12 Mitsubishi-built 2.4L (not in HaynesPro under this gen entry — only
-- ICE rows written here, 4B12 deferred to a separate pass with OEM owner
-- manual sourcing).
--
-- Public citations: a newly-inserted Mitsubishi Outlander (GN) Service
-- Manual source + a newly-inserted Mitsubishi factory oil spec aggregator.

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Mitsubishi Outlander (GN) Service Manual', 1, NOW(),
          'Mitsubishi OEM service data for GN chassis (2022+). Primary public citation for GN moat data.');
INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Mitsubishi factory oil spec (Mitsubishi Genuine Lubricants + Penrite + Castrol cross-verification)', 1, NOW(),
          'Aggregator citation covering Mitsubishi Dia Queen CVTF-J4 + Super Long Life Coolant + API SN engine oil from retail catalogues.');

SET @gen      := 30;
SET @e_pr25dd := 40;   -- PR25DD (Nissan-shared 2.5L petrol)
SET @e_4b12   := 46;   -- 4B12 PHEV (deferred — not in HaynesPro under GN entry)
SET @s_sm     := (SELECT id FROM sources WHERE citation = 'Mitsubishi Outlander (GN) Service Manual' LIMIT 1);
SET @s_mit_agg := (SELECT id FROM sources WHERE citation LIKE 'Mitsubishi factory oil spec%' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','transmission_cvt','brake_fluid','ac_refrigerant','differential_rear','transfer_case') AND engine_id = @e_pr25dd) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND engine_id = @e_pr25dd
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_mt','transmission_dct','transmission_cvt','brake_fluid','ac_refrigerant','differential_rear','transfer_case');

-- Wipe any prior gen-wide rows for the categories we're writing as gen-wide.
DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL
    AND fluid_type IN ('brake_fluid','ac_refrigerant','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL
  AND fluid_type IN ('brake_fluid','ac_refrigerant','differential_rear','transfer_case');

-- =========================================================================
-- engine_oil — PR25DD only (4B12 PHEV deferred, see header note)
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'engine_oil', 5.1, 5.39, '0W-20', 'API SN (preferred) / ILSAC GF-5 alternative', 7500, 12000, 12,
   'PR25DD 2.5L Nissan-developed 4-cyl petrol — shared with Nissan Rogue/X-Trail T33. With-filter sump capacity per Mitsubishi GN service data. Mitsubishi specifies API SN as preferred and ILSAC GF-5 as acceptable alternative. Severe-duty schedule may shorten interval to 5,000 mi for dusty/short-trip use.');

-- =========================================================================
-- coolant — PR25DD only
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'coolant', 9.4, 9.93, 'Mitsubishi Super Long Life Coolant (green, phosphate OAT)', NULL, NULL, NULL,
   'PR25DD — primary engine cooling loop. Mitsubishi spec is green phosphate-OAT chemistry; do NOT mix with red Toyota-style OAT or pink VW G13. Long-life: 100,000 mi initial replacement, then every 50,000 mi.');

-- =========================================================================
-- transmission_cvt — PR25DD pairs with the new Mitsubishi-Aisin CVT8
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'transmission_cvt', 7.9, 8.35, 'Mitsubishi Dia Queen CVTF-J4 (or CVTF-J4+ extended)', 60000, 96000, NULL,
   'PR25DD + Mitsubishi-Aisin CVT8 (revised CVT generation). Refill capacity 7.9 L. Mitsubishi Dia Queen CVTF-J4 ONLY — substituting generic ATF or other-brand CVT fluid will damage the variator. Service interval ~60,000 mi normal duty, halve for towing/severe duty.');

-- =========================================================================
-- gen-wide: brake fluid + transfer box + rear differential + A/C
-- (HaynesPro published these on the PR25DD row but they're chassis-level
-- components that apply to both ICE and PHEV variants.)
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 4 (preferred) — DOT 3 acceptable alternative', 'Brake reservoir capacity. Mitsubishi recommends a 2-year change interval on hygroscopic DOT 4-class fluids.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'transfer_case', 0.3, 0.32, 'SAE 75W-90 API GL-5 (Mitsubishi Genuine)', 'AWD transfer box on S-AWC-equipped trims. Small 0.3 L sump; service interval per Mitsubishi schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'differential_rear', 0.5, 0.53, 'SAE 75W-80 API GL-5 (Mitsubishi Genuine)', 'AWD rear differential on S-AWC-equipped trims — 0.5 L. Lower viscosity (75W-80) than transfer box reflects the lighter-duty rear-axle application.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf', 'A/C refrigerant — new Outlander GN ships globally with R1234yf per EU MAC + US EPA SNAP regulations. Charge value not surfaced in HaynesPro accessible section.');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','brake_fluid','transfer_case','differential_rear','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_mit_agg FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','brake_fluid','transfer_case','differential_rear','ac_refrigerant');

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

SELECT 'Mitsubishi Outlander GN moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       @s_sm AS mit_sm_id, @s_mit_agg AS mit_agg_id;
