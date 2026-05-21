-- Maintenance schedule enrichment — adds time-based items missing from
-- existing service_intervals across the 8 PDF-sourced gens + expands the
-- thin Tesla Model S schedule (was 4 rows) with EV-specific items.
--
-- Each row cites both the OEM SM and the manufacturer aggregator (2-source
-- rule). INSERT IGNORE on (gen, service) is impossible because the schema
-- has no unique constraint there — so we DELETE-then-INSERT only the
-- specific service names this migration introduces.

SET NAMES utf8mb4;

-- =========================================================================
-- Wipe the service names we'll re-insert (idempotent re-run safety)
-- =========================================================================
DELETE FROM spec_sources WHERE spec_table='service_intervals' AND spec_id IN (
  SELECT id FROM (SELECT id FROM service_intervals
    WHERE service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel','hepa_filter','drive_unit_fluid_LR','drive_unit_fluid_RR','drive_unit_fluid_F','hv_battery_coolant','battery_12v_replace','brake_caliper_lubrication')
      AND generation_id IN (26, 38, 76, 100, 55, 94, 27, 122, 116)
  ) AS x);
DELETE FROM service_intervals
  WHERE service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel','hepa_filter','drive_unit_fluid_LR','drive_unit_fluid_RR','drive_unit_fluid_F','hv_battery_coolant','battery_12v_replace','brake_caliper_lubrication')
    AND generation_id IN (26, 38, 76, 100, 55, 94, 27, 122, 116);

-- =========================================================================
-- Common time-based items for the 8 OM-sourced ICE pickup/SUV/sedan gens
-- =========================================================================
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  -- F-150 P702 (gen 26)
  (26, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, 'Ford schedule: 12 months. Inspect for streaking/chatter; replace if needed before then.'),
  (26, 'drive_belt_inspection', NULL, NULL, NULL, NULL, 120, '10-year interval. Inspect serpentine + accessory drive belt for cracking, glazing, fraying.'),
  (26, 'battery_12v_inspect',    7500, 5000, 12000, 8000, 6, 'Inspect 12V battery state-of-charge at every oil change. Replace as needed.'),

  -- Silverado T1 (gen 38)
  (38, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, 'GM schedule: 12 months.'),
  (38, 'drive_belt_inspection', NULL, NULL, NULL, NULL, 120, '10-year interval per GM schedule. Inspect drive belt for cracking + tensioner play.'),
  (38, 'battery_12v_inspect',    7500, 5000, 12000, 8000, 6, NULL),
  (38, 'fuel_filter_diesel',    NULL, NULL, NULL, NULL, 24, '3.0L LM2 Duramax only — replace fuel filter per DIC or every 2 years, whichever first.'),

  -- Tahoe T1XX (gen 76)
  (76, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, NULL),
  (76, 'drive_belt_inspection', NULL, NULL, NULL, NULL, 120, '10-year interval.'),
  (76, 'battery_12v_inspect',    7500, 5000, 12000, 8000, 6, NULL),

  -- Escalade T1XX (gen 100)
  (100, 'wiper_blades',         NULL, NULL, NULL, NULL, 12, NULL),
  (100, 'drive_belt_inspection',NULL, NULL, NULL, NULL, 120, '10-year interval.'),
  (100, 'battery_12v_inspect',   7500, 5000, 12000, 8000, 6, NULL),

  -- Equinox L1U (gen 55)
  (55, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, NULL),
  (55, 'drive_belt_inspection', NULL, NULL, NULL, NULL, 120, '10-year interval. Inspect for fraying/cracking.'),
  (55, 'battery_12v_inspect',    7500, 5000, 12000, 8000, 6, NULL),
  (55, 'fuel_filter_diesel',    NULL, NULL, NULL, NULL, 24, '1.6L LH7 Duramax only — replace per DIC or 2 years.'),

  -- Ascent WM (gen 94)
  (94, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, NULL),
  (94, 'drive_belt_inspection', 60000, NULL, 100000, NULL, NULL, 'Subaru schedule: visually inspect serpentine drive belt at 60,000 mi.'),
  (94, 'battery_12v_inspect',    6000, NULL, 10000, NULL, 6, NULL),

  -- Altima L34 (gen 27)
  (27, 'wiper_blades',          NULL, NULL, NULL, NULL, 12, NULL),
  (27, 'drive_belt_inspection', 60000, NULL, 100000, NULL, NULL, 'Nissan: inspect at 60,000 mi.'),
  (27, 'battery_12v_inspect',    7500, NULL, 12000, NULL, 6, NULL),

  -- Charger LD (gen 122)
  (122, 'wiper_blades',         NULL, NULL, NULL, NULL, 12, NULL),
  (122, 'drive_belt_inspection',NULL, NULL, NULL, NULL, 120, 'Mopar: 10-year inspection.'),
  (122, 'battery_12v_inspect',   8000, NULL, 12800, NULL, 6, NULL);

-- =========================================================================
-- Tesla Model S (gen 116) — EV-specific maintenance items.
-- Tesla service schedule (Owner Manual + Tesla service portal):
--   - HEPA / Bioweapon Defense cabin filter: every 3 years (where equipped)
--   - HV battery coolant inspection: every 4 years
--   - Drive unit gear oil: lifetime fill, but service if contaminated
--   - 12V (LiFePO4 on Plaid; AGM on pre-2021 LR): inspect annually, replace as
--     needed (Plaid LiFePO4 is essentially maintenance-free)
--   - Brake caliper service / re-lubrication: every 12 months / 12,500 mi in
--     cold/salty climates
-- =========================================================================
INSERT INTO service_intervals (generation_id, service, miles_normal, miles_severe, km_normal, km_severe, months, notes) VALUES
  (116, 'hepa_filter',              NULL, NULL, NULL, NULL, 36, 'Tesla HEPA / Bioweapon Defense cabin filter — replace every 3 years on equipped variants (P100D + most Plaid trims). Separate from the standard cabin air filter.'),
  (116, 'hv_battery_coolant',       NULL, NULL, NULL, NULL, 48, 'HV battery + drive-unit Glysantin G48 coolant — Tesla inspects every 4 years. Replace if contaminated or after a major repair.'),
  (116, 'drive_unit_fluid_F',       NULL, NULL, NULL, NULL, NULL, 'Front drive unit gear oil — Tesla lists as lifetime fill, but service if motor noise or contamination. PN/spec varies by drive-unit revision (Mobil SHC 629 / Tesla KAF1 / Tesla ATF9 / EDF2).'),
  (116, 'drive_unit_fluid_RR',      NULL, NULL, NULL, NULL, NULL, 'Rear drive unit gear oil — lifetime fill (SK ATF 212-B on dual-motor; on RWD Standard Range the rear unit is the only drive unit).'),
  (116, 'battery_12v_replace',      NULL, NULL, NULL, NULL, 48, 'Low-voltage battery — AGM (pre-2021 LR) lasts ~3-4 yr; LiFePO4 (Plaid + late MY refresh) is essentially maintenance-free with 12+ yr design life. Replace when state-of-charge degrades.'),
  (116, 'brake_caliper_lubrication', 12500, NULL, 20000, NULL, 12, 'Brake caliper service — Tesla recommends annual / 12,500 mi caliper cleaning + lubrication in cold/salty climates (regen braking limits pad wear, so calipers can seize without normal stress).');

-- =========================================================================
-- Citations — pair each row with OEM SM + manufacturer aggregator
-- =========================================================================
-- F-150 P702 — 130 SM + 602 aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 130 FROM service_intervals WHERE generation_id=26 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 602 FROM service_intervals WHERE generation_id=26 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Silverado T1 — 207 SM + 610 GM
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 207 FROM service_intervals WHERE generation_id=38 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id=38 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel');

-- Tahoe T1XX — 466 OM + 610
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 466 FROM service_intervals WHERE generation_id=76 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id=76 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Escalade T1XX — 576 OM + 610
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 576 FROM service_intervals WHERE generation_id=100 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id=100 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Equinox L1U — 321 SM + 610
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 321 FROM service_intervals WHERE generation_id=55 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 610 FROM service_intervals WHERE generation_id=55 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect','fuel_filter_diesel');

-- Ascent WM — 555 SM + 608 Subaru aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 555 FROM service_intervals WHERE generation_id=94 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 608 FROM service_intervals WHERE generation_id=94 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Altima L34 — 143 SM + 620 Nissan
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 143 FROM service_intervals WHERE generation_id=27 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 620 FROM service_intervals WHERE generation_id=27 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Charger LD — 590 OM + 611 Stellantis
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 590 FROM service_intervals WHERE generation_id=122 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 611 FROM service_intervals WHERE generation_id=122 AND service IN ('wiper_blades','drive_belt_inspection','battery_12v_inspect');

-- Tesla Model S — 580 OM + 612 Tesla aggregator
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 580 FROM service_intervals WHERE generation_id=116 AND service IN ('hepa_filter','hv_battery_coolant','drive_unit_fluid_F','drive_unit_fluid_RR','battery_12v_replace','brake_caliper_lubrication');
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id)
  SELECT 'service_intervals', id, 612 FROM service_intervals WHERE generation_id=116 AND service IN ('hepa_filter','hv_battery_coolant','drive_unit_fluid_F','drive_unit_fluid_RR','battery_12v_replace','brake_caliper_lubrication');

-- =========================================================================
-- Verification
-- =========================================================================
SELECT 'Maintenance schedule enrichment complete' AS status,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id IN (26,38,76,100,55,94,27,122,116)) AS post_total_for_9_gens,
       (SELECT COUNT(*) FROM service_intervals WHERE generation_id = 116) AS tesla_rows;
