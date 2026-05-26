-- 489: split the combined "ERB / ERC / ERG" 3.6 Pentastar (engine 138)
--
-- ERB = original Pentastar (2011-~2017), 5.9 qt / 5.6 L oil capacity.
-- ERC = "Pentastar Upgrade" (2016+): revised heads/cams, cooled features, and a
--       reduced 5.0 qt / 4.7 L oil capacity; 0W-20.
-- ERG = eTorque (48V mild-hybrid) Pentastar; 0W-20; adds battery/inverter coolant.
-- Dedicated ERC (id 59) and ERG (id 58) rows already existed (used by Wrangler JL);
-- 138 was a redundant combined row. Classifier = OIL CAPACITY (the Upgrade's
-- definitive 5.9->5.0 qt change), cross-checked with year + eTorque trim naming.
--
--   STAY ERB (138 relabeled): Challenger LC, Avenger JS, Journey JC, GC WK2,
--     Durango WD, Charger LD  (all 5.6 L).
--   -> ERC (59): Pacifica RU, Gladiator JT, GC WL (4.7 L, non-eTorque) + JL shared.
--   -> ERG (58): RAM 1500 DT Pentastar (eTorque) + JL eTorque coolant loops.
-- Moving engine_id on existing rows preserves their spec_sources automatically.
-- URL: 138 slug erb-erc-erg -> erb; next.config.ts adds 301 erb-erc-erg->erb and
-- repoints the legacy "pentastar"->erb.

-- 1) Relabel rows for clarity
UPDATE engines SET code='ERB', slug='erb',
  display_name='Chrysler 3.6L Pentastar V6 (ERB, 2011-2017)'
WHERE id=138 AND code='ERB / ERC / ERG';
UPDATE engines SET display_name='Chrysler 3.6L Pentastar V6 (ERC, Upgrade, 2016+)' WHERE id=59 AND code='ERC';
UPDATE engines SET display_name='Chrysler 3.6L Pentastar V6 (ERG, eTorque mild-hybrid)' WHERE id=58 AND code='ERG';

-- 2) Duplicate the Wrangler JL shared oil + coolant onto ERG (58) so the eTorque
--    JL trim renders them (the non-eTorque JL keeps them via ERC below).
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes)
SELECT 37, 58, 'engine_oil', 4.73, 5.00, '0W-20', 'API SP / Chrysler MS-6395; SAE 0W-20', '68191349AC', NULL, 8000, 12,
       '3.6L Pentastar V6 eTorque: 4.73 L (5 qt) with filter, SAE 0W-20 (MS-6395).'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM fluid_specs WHERE generation_id=37 AND engine_id=58 AND fluid_type='engine_oil') z);
INSERT INTO fluid_specs (generation_id, engine_id, fluid_type, capacity_l, capacity_qt, viscosity, spec_standard, filter_part_no, drain_interval_km, drain_interval_mi, drain_interval_months, notes)
SELECT 37, 58, 'coolant', 10.60, 11.20, NULL, 'Mopar OAT 10yr/150k (FCA MS.90032)', NULL, 240000, 150000, 120,
       '3.6L Pentastar V6 engine cooling system: 10.6 L (11.2 qt).'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM (SELECT id FROM fluid_specs WHERE generation_id=37 AND engine_id=58 AND fluid_type='coolant') z);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', nf.id, s.sid
FROM fluid_specs nf
JOIN (SELECT 202 sid UNION SELECT 599 UNION SELECT 611 UNION SELECT 864) s
WHERE nf.generation_id=37 AND nf.engine_id=58 AND nf.fluid_type IN ('engine_oil','coolant');

-- 3) Move trims to ERC / ERG
UPDATE trims SET engine_id=59 WHERE generation_id IN (86,334) AND engine_id=138;  -- Pacifica, Gladiator -> ERC
UPDATE trims SET engine_id=58 WHERE generation_id=43 AND engine_id=138;            -- RAM 1500 DT Pentastar (eTorque) -> ERG

-- 4) Move fluid_specs to ERC (59)
UPDATE fluid_specs SET engine_id=59 WHERE id IN (666,668,8435,8436);  -- Pacifica
UPDATE fluid_specs SET engine_id=59 WHERE id IN (8507,8509);          -- Gladiator
UPDATE fluid_specs SET engine_id=59 WHERE id IN (931,520,8453);       -- GC WL (was stranded on 138)
UPDATE fluid_specs SET engine_id=59 WHERE id IN (885,196);            -- JL shared oil + coolant
-- ... and to ERG (58)
UPDATE fluid_specs SET engine_id=58 WHERE id IN (883,273,8444);       -- RAM Pentastar oil/coolant/inverter
UPDATE fluid_specs SET engine_id=58 WHERE id IN (8464,8463);          -- JL eTorque battery + inverter coolant

-- 5) Move parts to ERC (59)
UPDATE parts SET engine_id=59 WHERE id=889;                           -- Gladiator
