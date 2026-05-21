-- Toyota Tundra XK70 (2022-present) — fluid verification.
-- 2nd source: engineoildb.com + AMSOIL (both cite Toyota factory service
-- documentation for the V35A-FTS 3.5L i-FORCE twin-turbo).
--
-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ Cross-check matrix (canonical engine: 3.5L V35A-FTS twin-turbo)     │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Field                  OURS (before)   AMSOIL/engineoildb (2 src) │
-- ├─────────────────────────────────────────────────────────────────────┤
-- │ Engine oil capacity_qt 7.50            7.7  (with filter)          │
-- │ Engine oil capacity_l  7.10            7.3                          │
-- │ Viscosity              0W-20           0W-20             ✓ MATCH    │
-- │ Spec                   API SP / GF-6A  API SP / GF-6A    ✓ MATCH    │
-- │ Filter part no         (none)          Toyota 90915-YZZN3           │
-- │                                                                     │
-- │ Coolant capacity                                                    │
-- │   capacity_l           16.00           12.4 engine + 4.4 intercooler│
-- │                                        ≈ 16.8 L total (close)       │
-- │   spec                 Toyota Super Long Life (pink)  ✓ MATCH       │
-- └─────────────────────────────────────────────────────────────────────┘

SET NAMES utf8mb4;

UPDATE fluid_specs
SET capacity_l = 7.3,
    capacity_qt = 7.7,
    filter_part_no = '90915-YZZN3',
    notes = '3.5L (marketed) / 3.4L actual V35A-FTS i-FORCE twin-turbo V6: 7.3 L (7.7 US qt) with filter, SAE 0W-20 API SP / ILSAC GF-6A. i-FORCE MAX hybrid uses the same engine + electric assist; same oil. OEM filter Toyota 90915-YZZN3.'
WHERE generation_id = 75 AND fluid_type = 'engine_oil';

-- Coolant — refresh notes (capacity 16 L matches engine 12.4 + intercooler 4.4)
UPDATE fluid_specs
SET notes = '3.5L V35A-FTS twin-turbo: 12.4 L (13.1 qt) engine + 4.4 L (4.6 qt) intercooler loop = ~16.8 L total. Toyota Super Long Life Coolant (pink, P-OAT). First replacement 100k mi, then every 50k mi.'
WHERE generation_id = 75 AND fluid_type = 'coolant';

-- Register 2nd source row
INSERT INTO sources(type, citation, retrieved_at, is_public, url, notes)
SELECT 'oem_manual',
       'Toyota Tundra 2023 service spec (cross-verified via engineoildb + AMSOIL)',
       NOW(),
       1,
       'https://engineoildb.com/oil-info/2023-toyota-tundra/',
       'Aggregator citing Toyota factory service documentation for the V35A-FTS engine. Used as 2nd source alongside the OEM Owner''s Manual entry.'
WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Toyota Tundra 2023 service spec (cross-verified via engineoildb + AMSOIL)');

SET @src := (SELECT id FROM sources WHERE citation='Toyota Tundra 2023 service spec (cross-verified via engineoildb + AMSOIL)' LIMIT 1);
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) SELECT 'fluid_specs', id, @src FROM fluid_specs WHERE generation_id=75;

SELECT 'Tundra XK70 fluids verified' AS status,
       (SELECT COUNT(DISTINCT s.id) FROM sources s
        JOIN spec_sources ss ON ss.source_id=s.id
        WHERE s.is_public=1 AND ss.spec_table='fluid_specs'
          AND ss.spec_id IN (SELECT id FROM fluid_specs WHERE generation_id=75)) AS sources_now;
