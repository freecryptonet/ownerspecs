-- mig 354 — Phase 1 owner-manual backfill: dimensions + OEM source rows
-- for 4 Nissan gens + Mercedes A-Class W177. First use of Tim's
-- 94 newly-indexed OEM manuals (mig 352 / scan_manuals.ts session).
--
-- Source pattern: one source row per primary OEM manual, linked via
-- sources.manual_inventory_id to the immutable PDF (sha256 + edition_code
-- + page_count). public_link=0 because the exact PDF URL on
-- nl.eowners.nissan.eu / mercedes-benz.nl is unstable per edition.
--
-- Per gen this mig:
--   1. Ensures a sources row exists, linked to manual_inventory
--   2. Backfills NULL dimensions on generations (length/width/height/
--      wheelbase/track) + fuel_tank_l from the manual
--   3. Cites all existing fluid_specs rows on the gen to the manual source
--      via spec_sources (INSERT IGNORE — uk dedupes if already linked)
--
-- Dimensions sourced from latest model-year EU manual per gen, cross-
-- verified against Nissan / Mercedes published spec sheets.

SET NAMES utf8mb4;

START TRANSACTION;

-- ---------------------------------------------------------------------------
-- 1. Ensure sources rows exist + linked to manual_inventory
-- ---------------------------------------------------------------------------

-- Juke F16: source 746 already exists (created earlier session). Wire FK.
UPDATE sources s
JOIN manual_inventory mi ON mi.file_path = 'manuals/om24nl-0f16e1eur.pdf'
SET s.manual_inventory_id = mi.id
WHERE s.id = 746 AND s.manual_inventory_id IS NULL;

-- Ariya FE0 — new source, MY2024 latest
INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual', "Nissan Ariya (FE0) Owner's Manual — MY2024 (OM24NL-0FE0E4EUR)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/om24nl-0fe0e4eur.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_ariya = (SELECT id FROM sources WHERE manual_inventory_id =
       (SELECT id FROM manual_inventory WHERE file_path='manuals/om24nl-0fe0e4eur.pdf'));

-- Qashqai J12 — new source. Use 0J12 (non-hybrid) as it has the broader content.
INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual', "Nissan Qashqai (J12) Owner's Manual — MY2024 (OM24NL-0J12E1EUR)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/om24nl-0j12e1eur.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_qashqai = (SELECT id FROM sources WHERE manual_inventory_id =
       (SELECT id FROM manual_inventory WHERE file_path='manuals/om24nl-0j12e1eur.pdf'));

-- X-Trail T33 — new source. Use HT33 e-Power (most common EU spec).
INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual', "Nissan X-Trail e-Power (T33) Owner's Manual — MY2024 (OM24NL-HT33E1EUR)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/om24nl-ht33e1eur.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_xtrail = (SELECT id FROM sources WHERE manual_inventory_id =
       (SELECT id FROM manual_inventory WHERE file_path='manuals/om24nl-ht33e1eur.pdf'));

-- Mercedes A-Class W177 — new source, MY2024 MBUX
INSERT INTO sources (type, citation, manual_inventory_id, public_link, retrieved_at, is_public)
SELECT 'owner_manual', "Mercedes-Benz A-Class Limousine (V177) Owner's Manual — MY2024 (NL, MBUX)",
       mi.id, 0, NOW(), 1
FROM manual_inventory mi
WHERE mi.file_path = 'manuals/mercedes-a-klasse-limousine-2024-oktober-v177-mbux-handleiding-2.pdf'
  AND NOT EXISTS (SELECT 1 FROM sources WHERE manual_inventory_id = mi.id);
SET @s_aclass = (SELECT id FROM sources WHERE manual_inventory_id =
       (SELECT id FROM manual_inventory WHERE file_path='manuals/mercedes-a-klasse-limousine-2024-oktober-v177-mbux-handleiding-2.pdf'));

-- Juke source id locked for reuse
SET @s_juke = 746;

-- ---------------------------------------------------------------------------
-- 2. Backfill dimensions on generations (only update where currently NULL
--    to avoid overwriting any prior hand-curated values)
-- ---------------------------------------------------------------------------

-- Juke F16 (id 162) — from OM24NL-0F16E1EUR
UPDATE generations SET
  length_mm     = COALESCE(length_mm, 4210),
  width_mm      = COALESCE(width_mm, 1800),
  height_mm     = COALESCE(height_mm, 1577),
  wheelbase_mm  = COALESCE(wheelbase_mm, 2636),
  front_track_mm = COALESCE(front_track_mm, 1560),
  rear_track_mm = COALESCE(rear_track_mm, 1552),
  fuel_tank_l   = COALESCE(fuel_tank_l, 46.0)
WHERE id = 162;

-- Ariya FE0 (id 163) — BEV, no fuel tank. Dimensions from OM24NL-0FE0E4EUR.
UPDATE generations SET
  length_mm     = COALESCE(length_mm, 4595),
  width_mm      = COALESCE(width_mm, 1850),
  height_mm     = COALESCE(height_mm, 1660),
  wheelbase_mm  = COALESCE(wheelbase_mm, 2775),
  front_track_mm = COALESCE(front_track_mm, 1610),
  rear_track_mm = COALESCE(rear_track_mm, 1605)
WHERE id = 163;

-- Qashqai J12 (id 165) — from OM24NL-0J12E1EUR (18"/19" alloys baseline)
UPDATE generations SET
  length_mm     = COALESCE(length_mm, 4425),
  width_mm      = COALESCE(width_mm, 1835),
  height_mm     = COALESCE(height_mm, 1625),
  wheelbase_mm  = COALESCE(wheelbase_mm, 2665),
  front_track_mm = COALESCE(front_track_mm, 1580),
  rear_track_mm = COALESCE(rear_track_mm, 1580),
  fuel_tank_l   = COALESCE(fuel_tank_l, 55.0)
WHERE id = 165;

-- X-Trail T33 (id 164) — from OM24NL-HT33E1EUR
UPDATE generations SET
  length_mm     = COALESCE(length_mm, 4680),
  width_mm      = COALESCE(width_mm, 1840),
  height_mm     = COALESCE(height_mm, 1725),
  wheelbase_mm  = COALESCE(wheelbase_mm, 2705),
  front_track_mm = COALESCE(front_track_mm, 1585),
  rear_track_mm = COALESCE(rear_track_mm, 1590),
  fuel_tank_l   = COALESCE(fuel_tank_l, 55.0)
WHERE id = 164;

-- Mercedes A-Class W177 Saloon (V177, id 315) — sedan body. Per MB 2024 NL handleiding.
UPDATE generations SET
  length_mm     = COALESCE(length_mm, 4549),
  width_mm      = COALESCE(width_mm, 1796),
  height_mm     = COALESCE(height_mm, 1419),
  wheelbase_mm  = COALESCE(wheelbase_mm, 2729),
  front_track_mm = COALESCE(front_track_mm, 1567),
  rear_track_mm = COALESCE(rear_track_mm, 1551),
  fuel_tank_l   = COALESCE(fuel_tank_l, 43.0)
WHERE id = 315;

-- ---------------------------------------------------------------------------
-- 3. Cite every existing fluid_specs row on each gen to the manual source.
--    INSERT IGNORE — uk(spec_table, spec_id, source_id) silently dedupes
--    if already linked.
-- ---------------------------------------------------------------------------

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_juke FROM fluid_specs WHERE generation_id = 162;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_ariya FROM fluid_specs WHERE generation_id = 163 AND @s_ariya IS NOT NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_qashqai FROM fluid_specs WHERE generation_id = 165 AND @s_qashqai IS NOT NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_xtrail FROM fluid_specs WHERE generation_id = 164 AND @s_xtrail IS NOT NULL;

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'fluid_specs', id, @s_aclass FROM fluid_specs WHERE generation_id = 315 AND @s_aclass IS NOT NULL;

-- For A-Class W177 also cite torque + service_intervals + electrical to the manual
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'torque_specs', id, @s_aclass FROM torque_specs WHERE generation_id = 315 AND @s_aclass IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'service_intervals', id, @s_aclass FROM service_intervals WHERE generation_id = 315 AND @s_aclass IS NOT NULL;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @s_aclass FROM electrical_specs WHERE generation_id = 315 AND @s_aclass IS NOT NULL;

-- POST-CHECK
SELECT 'gen dimensions filled' k, COUNT(*) n FROM generations
  WHERE id IN (162,163,164,165,315) AND length_mm IS NOT NULL
UNION ALL
SELECT 'sources linked to manual_inventory', COUNT(*) FROM sources WHERE id IN (@s_juke, @s_ariya, @s_qashqai, @s_xtrail, @s_aclass)
UNION ALL
SELECT 'new spec_sources rows added', ROW_COUNT();

COMMIT;
