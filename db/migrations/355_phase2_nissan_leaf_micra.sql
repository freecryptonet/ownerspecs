-- mig 355 — Phase 2 catalog expansion: add Nissan Leaf ZE1 (2018-2024)
-- and Nissan Micra K14 (2017-2024) as new generations, with engine
-- entries + dimensions + primary fluids from their NL owner manuals.
--
-- Sources (linked via sources.manual_inventory_id):
--   Leaf:  OM23NL-0ZE1E0EUR  (manuals/om23nl-0ze1e0eur.pdf)
--   Micra: OM21NL-0K14E0EUR  (manuals/om21nl-0k14e0eur.pdf)
--
-- Engines added (5 new):
--   HR09DET — 0.9L IGT turbo 3-cyl (Micra)
--   BR10DE  — 1.0L NA 3-cyl (Micra, early base)
--   HR10DET — 1.0L turbo 3-cyl (Micra)
--   K9K     — 1.5 dCi diesel 4-cyl (Micra; Renault-developed)
--   EM57    — Leaf permanent-magnet synchronous motor (single-speed)
-- HR10DDT already in engines (id 867).
--
-- Dimensions cross-verified against Nissan EU spec sheets. Where the
-- manual reports "Totale breedte" with no excl-mirrors qualifier (Micra),
-- the body width 1743 mm is used to match the Nissan published spec
-- (1935 mm is the with-mirrors measurement per Nissan EU brochure).

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- 1. Models (leaf, micra)
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO models (make_id, slug, name, is_active)
SELECT 13, 'leaf',  'Leaf',  1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=13 AND slug='leaf');

INSERT IGNORE INTO models (make_id, slug, name, is_active)
SELECT 13, 'micra', 'Micra', 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM models WHERE make_id=13 AND slug='micra');

SET @m_leaf  = (SELECT id FROM models WHERE make_id=13 AND slug='leaf');
SET @m_micra = (SELECT id FROM models WHERE make_id=13 AND slug='micra');

-- ---------------------------------------------------------------------------
-- 2. Engines (5 new)
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO engines (code, display_name, displacement_cc, fuel, aspiration, cylinders) VALUES
  ('HR09DET', 'Nissan 0.9 IG-T (HR09DET) 3-cyl turbo',  898,  'gasoline', 'turbocharged',        3),
  ('BR10DE',  'Nissan 1.0 (BR10DE) 3-cyl NA',           999,  'gasoline', 'naturally aspirated', 3),
  ('HR10DET', 'Nissan 1.0 IG-T (HR10DET) 3-cyl turbo',  999,  'gasoline', 'turbocharged',        3),
  ('K9K',     'Nissan/Renault 1.5 dCi (K9K) 4-cyl',     1461, 'diesel',   'turbocharged',        4),
  ('EM57',    'Nissan EM57 permanent-magnet synchronous motor (Leaf ZE1)', NULL, 'electric', NULL, NULL);

SET @e_hr09det = (SELECT id FROM engines WHERE code='HR09DET');
SET @e_br10de  = (SELECT id FROM engines WHERE code='BR10DE');
SET @e_hr10det = (SELECT id FROM engines WHERE code='HR10DET');
SET @e_hr10ddt = (SELECT id FROM engines WHERE code='HR10DDT');
SET @e_k9k     = (SELECT id FROM engines WHERE code='K9K');
SET @e_em57    = (SELECT id FROM engines WHERE code='EM57');

-- ---------------------------------------------------------------------------
-- 3. Generations
-- ---------------------------------------------------------------------------

-- Leaf ZE1 (2018-2024) hatchback, BEV. No fuel tank.
INSERT IGNORE INTO generations
  (model_id, slug, ordinal, codename, display_name, body_type,
   start_year, end_year, layout,
   length_mm, width_mm, height_mm, wheelbase_mm, front_track_mm, rear_track_mm,
   fuel_tank_l, is_active)
VALUES
  (@m_leaf, 'leaf-ze1-hatchback-2018-2024', 2, 'ZE1', 'Leaf (ZE1, 2nd gen)', 'Hatchback',
   2018, 2024, 'FWD',
   4479, 1790, 1535, 2700, 1540, 1555,
   NULL, 1);

SET @g_leaf = (SELECT id FROM generations WHERE slug='leaf-ze1-hatchback-2018-2024');

-- Micra K14 (2017-2024 EU) hatchback, multiple engines (gas turbo + NA + diesel).
INSERT IGNORE INTO generations
  (model_id, slug, ordinal, codename, display_name, body_type,
   start_year, end_year, layout,
   length_mm, width_mm, height_mm, wheelbase_mm, front_track_mm, rear_track_mm,
   fuel_tank_l, is_active)
VALUES
  (@m_micra, 'micra-k14-hatchback-2017-2024', 5, 'K14', 'Micra (K14, 5th gen)', 'Hatchback',
   2017, 2024, 'FWD',
   3999, 1743, 1455, 2525, 1510, 1520,
   41.0, 1);

SET @g_micra = (SELECT id FROM generations WHERE slug='micra-k14-hatchback-2017-2024');

-- ---------------------------------------------------------------------------
-- 4. Source rows linked to manual_inventory
-- ---------------------------------------------------------------------------

INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual',
       "Nissan Leaf (ZE1) Owner's Manual — MY2023 (OM23NL-0ZE1E0EUR)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/om23nl-0ze1e0eur.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_leaf = (SELECT id FROM sources WHERE manual_inventory_id =
               (SELECT id FROM manual_inventory WHERE file_path='manuals/om23nl-0ze1e0eur.pdf'));

INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual',
       "Nissan Micra (K14) Owner's Manual — MY2021 (OM21NL-0K14E0EUR)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/om21nl-0k14e0eur.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_micra = (SELECT id FROM sources WHERE manual_inventory_id =
               (SELECT id FROM manual_inventory WHERE file_path='manuals/om21nl-0k14e0eur.pdf'));

-- ---------------------------------------------------------------------------
-- 5. Fluids per gen (data from manual section "Inhoudsmaten en aanbevolen vloeistoffen")
-- ---------------------------------------------------------------------------

-- Leaf ZE1: BEV with reduction gear, brake fluid, A/C refrigerant. No engine oil, no coolant.
-- The "coolant" in a BEV is the HV battery coolant — handled separately.
INSERT IGNORE INTO fluid_specs
  (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  (@g_leaf, NULL,     'brake_fluid',    NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 4 equivalent', NULL),
  (@g_leaf, NULL,     'ac_refrigerant', NULL, NULL, NULL, 'HFO-1234yf (R-1234yf), 530±30 g; A/C oil NISSAN A/C System Oil Type ND-12 130 cc', NULL);

-- Micra K14: per-engine oil capacities (with filter) + gen-wide brake/coolant/transmission
-- Engine oil capacities from manual (with filter) — using ACEA C5 SAE 5W-30 / 0W-20 per current EU spec
INSERT IGNORE INTO fluid_specs
  (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, notes)
VALUES
  -- Note: Micra K14 OM21 page 287 gives "Zonder vervanging oliefilter 4.7L" gen-wide.
  -- Per-engine WITH-FILTER capacities: HR10DDT manual says 4.1L, others not explicit in this
  -- section — leave NULL where unknown.
  (@g_micra, @e_hr09det, 'engine_oil',     NULL, NULL, '5W-30',  'ACEA C4 5W-30 (NISSAN Genuine; HR09DET — Renault-developed turbo)', NULL),
  (@g_micra, @e_br10de,  'engine_oil',     NULL, NULL, '0W-20',  'ACEA C5 0W-20 (NISSAN Motor Oil Synthetic Technology — BR10DE 1.0 NA)', NULL),
  (@g_micra, @e_hr10det, 'engine_oil',     NULL, NULL, '5W-30',  'ACEA C4 5W-30 (NISSAN Genuine; HR10DET turbo)', NULL),
  (@g_micra, @e_hr10ddt, 'engine_oil',     4.1,  4.33, '0W-20',  'ACEA C5 0W-20 (NISSAN Motor Oil Synthetic Technology — HR10DDT turbo)', NULL),
  (@g_micra, @e_k9k,     'engine_oil',     NULL, NULL, '5W-30',  'ACEA C4 5W-30 (Renault-developed K9K 1.5 dCi diesel)', NULL),
  -- Per-engine coolant capacities (NISSAN L255N spec, capacity per page 291)
  (@g_micra, @e_hr09det, 'coolant', 5.9,  6.23, NULL, 'NISSAN Genuine Engine Coolant L255N', NULL),
  (@g_micra, @e_br10de,  'coolant', 5.8,  6.13, NULL, 'NISSAN Genuine Engine Coolant L255N', NULL),
  (@g_micra, @e_hr10det, 'coolant', 6.2,  6.55, NULL, 'NISSAN Genuine Engine Coolant L255N', NULL),
  (@g_micra, @e_hr10ddt, 'coolant', 6.65, 7.03, NULL, 'NISSAN Genuine Engine Coolant L255N', NULL),
  (@g_micra, @e_k9k,     'coolant', 6.3,  6.66, NULL, 'NISSAN Genuine Engine Coolant L255N', NULL),
  -- Transmissions (gen-wide, both MTs + CVT)
  (@g_micra, NULL, 'transmission_mt',  2.3,  2.43, '75W', 'NISSAN MT-XZ Gear Oil NFX 75W (5MT variant)', NULL),
  (@g_micra, NULL, 'transmission_mt',  1.4,  1.48, '75W', 'NISSAN MT-XZ Gear Oil NFX 75W (6MT variant)', NULL),
  (@g_micra, NULL, 'transmission_cvt', 6.9,  7.29, NULL, 'NISSAN CVT Fluid NS-3 (do not substitute)', NULL),
  (@g_micra, NULL, 'brake_fluid',      NULL, NULL, NULL, 'NISSAN Brake Fluid or DOT 4+ Class 6 equivalent', NULL),
  (@g_micra, NULL, 'ac_refrigerant',   NULL, NULL, NULL, 'HFO-1234yf (R-1234yf), 450±35 g; A/C oil YR20 90 cc', NULL);

-- ---------------------------------------------------------------------------
-- 6. Cite all new fluid rows + gen-level data to the manual sources
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_leaf  FROM fluid_specs WHERE generation_id = @g_leaf;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_micra FROM fluid_specs WHERE generation_id = @g_micra;

-- POST-CHECK
SELECT 'new models'     k, COUNT(*) n FROM models WHERE make_id=13 AND slug IN ('leaf','micra')
UNION ALL SELECT 'new gens',    COUNT(*) FROM generations WHERE slug IN ('leaf-ze1-hatchback-2018-2024','micra-k14-hatchback-2017-2024')
UNION ALL SELECT 'new engines', COUNT(*) FROM engines WHERE code IN ('HR09DET','BR10DE','HR10DET','K9K','EM57')
UNION ALL SELECT 'leaf fluids', COUNT(*) FROM fluid_specs WHERE generation_id = @g_leaf
UNION ALL SELECT 'micra fluids', COUNT(*) FROM fluid_specs WHERE generation_id = @g_micra
UNION ALL SELECT 'spec_sources cites', COUNT(*) FROM spec_sources WHERE source_id IN (@s_leaf, @s_micra);

COMMIT;
