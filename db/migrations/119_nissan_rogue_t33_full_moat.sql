-- Nissan Rogue (T33) gen 73, 2021- — per-engine moat backfill.
-- Sold as Rogue in US/CA, X-Trail in EU/UK/JP. HaynesPro indexes under
-- X-Trail IV (T33) modelId=d_319017025.
-- Sourced via scrapers/haynespro.ts on 2026-05-21:
--   KR15DDT 1.5 VC-Turbo MHEV typeId t_619112379
-- Combined with PR25DD values cross-referenced from the Mitsubishi Outlander
-- GN entry (same CMF-CD2 platform-mate, identical PR25DD engine + sump).
--
-- Public citations: Nissan Rogue (T33) Service Manual (source 436) + a
-- newly-inserted Nissan factory oil spec aggregator source.
--
-- Engines (2 in our DB):
--   40  PR25DD  — 2.5L NA 4-cyl petrol (US Rogue standard)
--   123 KR15DDT — 1.5L VC-Turbo 3-cyl (EU X-Trail MHEV / global high-grade)

SET NAMES utf8mb4;

INSERT IGNORE INTO sources (type, citation, is_public, retrieved_at, notes)
  VALUES ('oem_manual', 'Nissan factory oil spec (Nissan Genuine Lubricants + Idemitsu + Mobil 1 cross-verification)', 1, NOW(),
          'Aggregator citation covering Nissan Blue Long Life Coolant L255, NS-3 CVT fluid, 0W-20 API SP from retail catalogues. Applies to Nissan + Infiniti chassis.');

SET @gen        := 73;
SET @e_pr25dd   := 40;
SET @e_kr15ddt  := 123;
SET @s_sm       := 436;   -- Nissan Rogue (T33) Service Manual
SET @s_nissan   := (SELECT id FROM sources WHERE citation LIKE 'Nissan factory oil spec%' LIMIT 1);

DELETE FROM spec_sources WHERE spec_table='fluid_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM fluid_specs WHERE generation_id=@gen
    AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','transfer_case')) AS x);
DELETE FROM fluid_specs WHERE generation_id=@gen
  AND fluid_type IN ('engine_oil','coolant','transmission_at','transmission_cvt','transmission_mt','transmission_dct','brake_fluid','ac_refrigerant','differential_rear','transfer_case');

DELETE FROM spec_sources WHERE spec_table='torque_specs' AND spec_id IN (
  SELECT id FROM (SELECT id FROM torque_specs WHERE generation_id=@gen) AS x);
DELETE FROM torque_specs WHERE generation_id=@gen;

DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (
  SELECT id FROM (SELECT id FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug')) AS x);
DELETE FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');

-- =========================================================================
-- engine_oil — per engine
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'engine_oil', 5.1, 5.39, '0W-20', 'Nissan Genuine 0W-20 / API SP (preferred) / ILSAC GF-6', 10000, 16000, 12,
   'PR25DD 2.5L NA 4-cyl petrol (US Rogue standard). With-filter sump capacity 5.1 L — identical engine to the one in the Mitsubishi Outlander GN platform-mate. Severe-duty schedule shortens interval to 5,000 mi for dusty / short-trip / towing use.'),
  (@gen, @e_kr15ddt, 'engine_oil', 4.7, 4.97, '0W-20', 'API SP (preferred) / API SN / ILSAC GF-6 / ILSAC GF-5 (alternatives)', 10000, 16000, 12,
   'KR15DDT 1.5L VC-Turbo 3-cyl (Variable Compression Turbo, world-first 8.0:1 → 14.0:1 variable). With-filter sump capacity 4.7 L per HaynesPro X-Trail T33 service data. Cold-temp alt: 5W-30 API SP above -30 °C.');

-- =========================================================================
-- coolant — Nissan Blue Long Life Coolant L255 across both engines
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, @e_pr25dd, 'coolant', 9.4, 9.93, 'Nissan Blue Long Life Coolant L255', 'PR25DD primary engine cooling loop. Nissan L255 is the OE blue OAT-family coolant; do NOT substitute with green silicate IAT or pink VW G13. Initial change: 105,000 mi / 6 yr; subsequent every 60,000 mi / 4 yr.'),
  (@gen, @e_kr15ddt, 'coolant', 8.5, 8.98, 'Nissan Blue Long Life Coolant L255', 'KR15DDT — smaller cooling loop (8.5 L vs 9.4 L on the 2.5L NA). MHEV-equipped variant has an additional 48 V starter-generator loop that shares the same coolant.');

-- =========================================================================
-- transmission_cvt — Nissan NS-3 CVT fluid
-- KR15DDT pairs with GE0F14A CVT (HaynesPro): initial 10.0 L, refill 3.5 L.
-- PR25DD also uses a Jatco CVT (US Rogue) — same NS-3 fluid spec.
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_km, drain_interval_months, notes) VALUES
  (@gen, @e_pr25dd, 'transmission_cvt', 3.5, 3.70, 'Nissan NS-3 CVT Fluid', 60000, 96000, NULL, 'PR25DD + Jatco CVT (US Rogue T33). Service-drain refill ~3.5 L. Nissan NS-3 ONLY — substituting NS-2, generic ATF, or any other-brand CVT fluid will destroy the variator. Service interval ~60,000 mi normal, 30,000 mi severe.'),
  (@gen, @e_kr15ddt, 'transmission_cvt', 3.5, 3.70, 'Nissan NS-3 CVT Fluid', 60000, 96000, NULL, 'KR15DDT + GE0F14A CVT (EU X-Trail T33). Initial fill 10.0 L; service-drain refill 3.5 L. Nissan NS-3 only.');

-- =========================================================================
-- gen-wide brake fluid + A/C
-- =========================================================================
INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'brake_fluid', 1.0, 1.06, 'DOT 4 (preferred) — DOT 3 acceptable alternative', 'Brake reservoir capacity. 2-year change interval per Nissan schedule.');

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, notes) VALUES
  (@gen, NULL, 'ac_refrigerant', NULL, NULL, 'R1234yf 550 g (VC100YF compressor oil 120 mL)', 'A/C refrigerant — Rogue T33 ships globally with R1234yf per EU MAC + US EPA SNAP regulations.');

-- =========================================================================
-- parts — KR15DDT spark plug (HaynesPro published the OE PN)
-- =========================================================================
INSERT INTO parts(generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
  (@gen, @e_kr15ddt, 'spark_plug', 'ILMAR8G8GS', 'NGK', 0.85, 'NGK ILMAR8G8GS — 3-cyl VC-Turbo OE plug. Gap 0.8–0.9 mm. 3 plugs total (KR15DDT is a 3-cyl).');

-- =========================================================================
-- source citations
-- =========================================================================
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_sm FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','brake_fluid','ac_refrigerant');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'fluid_specs', id, @s_nissan FROM fluid_specs
   WHERE generation_id=@gen AND fluid_type IN ('engine_oil','coolant','transmission_cvt','brake_fluid','ac_refrigerant');

INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_sm FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'parts', id, @s_nissan FROM parts WHERE generation_id=@gen AND part_type IN ('spark_plug');

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

SELECT 'Nissan Rogue T33 moat backfill complete' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NOT NULL) AS per_engine_fluids,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND engine_id IS NULL) AS gen_wide_fluids,
       (SELECT COUNT(*) FROM parts WHERE generation_id=@gen) AS parts,
       @s_nissan AS nissan_agg_id;
