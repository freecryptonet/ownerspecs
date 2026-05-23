-- mig 236 — Nissan catalog scaffolding for Juke F16, Ariya FE0, X-Trail T33, Qashqai J12.
-- Adds 4 models + 4 generations. Spec data follows in subsequent migrations
-- (extracted from the owner manuals in manual_inventory).
--
-- Codename mapping (from Nissan's manual filename codes):
--   Juke F16     — OM filename code 0F16 (ICE) / HF16 (Hybrid). Single chassis.
--   Ariya FE0    — OM filename code 0FE0. BEV only.
--   X-Trail T33  — OM filename code HJ12 (hybrid e-Power variants we have PDFs for).
--   Qashqai J12  — OM filename code HT33 (hybrid e-Power variants we have PDFs for).

SET NAMES utf8mb4;

SET @make_nissan := (SELECT id FROM makes WHERE slug = 'nissan');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@make_nissan, 'juke', 'Juke'),
  (@make_nissan, 'ariya', 'Ariya'),
  (@make_nissan, 'x-trail', 'X-Trail'),
  (@make_nissan, 'qashqai', 'Qashqai');

-- Generations
SET @m_juke    := (SELECT id FROM models WHERE make_id = @make_nissan AND slug = 'juke');
SET @m_ariya   := (SELECT id FROM models WHERE make_id = @make_nissan AND slug = 'ariya');
SET @m_xtrail  := (SELECT id FROM models WHERE make_id = @make_nissan AND slug = 'x-trail');
SET @m_qashqai := (SELECT id FROM models WHERE make_id = @make_nissan AND slug = 'qashqai');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout)
VALUES
  (@m_juke,    'juke-f16-suv-2019-present',      'F16', 'Juke (F16, 2nd gen) 2019-',      'SUV',      2019, NULL, 'FWD'),
  (@m_ariya,   'ariya-fe0-suv-2022-present',     'FE0', 'Ariya (FE0) 2022-',              'SUV',      2022, NULL, 'AWD'),
  (@m_xtrail,  'x-trail-t33-suv-2022-present',   'T33', 'X-Trail (T33, 4th gen) 2022-',   'SUV',      2022, NULL, 'AWD'),
  (@m_qashqai, 'qashqai-j12-suv-2021-present',   'J12', 'Qashqai (J12, 3rd gen) 2021-',   'SUV',      2021, NULL, 'FWD');

-- Audit
SELECT g.id, mk.slug AS make, m.slug AS model, g.slug, g.codename, g.start_year, g.end_year
FROM generations g
JOIN models m ON m.id = g.model_id
JOIN makes mk ON mk.id = m.make_id
WHERE mk.slug = 'nissan'
ORDER BY m.slug, g.start_year;
