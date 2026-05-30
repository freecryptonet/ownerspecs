-- mig 522 — widen Tesla catalog so the public Tesla.com OM PDFs attach.
--
-- Tesla publishes OMs directly on its OEM site at the deterministic path
--   https://www.tesla.com/ownersmanual/{slug}/{locale}/Owners_Manual.pdf
-- where slug = `model3`/`models`/`modelx`/`modely`/`cybertruck` for the
-- current generation, and `<startyear>_<endyear>_<model>` for legacy gens
-- (`2017_2023_model3`, `2012_2020_models`, `2015_2020_modelx`,
-- `2020_2024_modely`). Manufacturer-owned domain — `public_link=1`.
--
-- DB already has model-3 (2017-2023), model-s (2012-present, single span),
-- model-y (2020-2024). This adds:
--   * model-3 current gen (2024-present) — backfill chassis-tiebreaker can
--     then split the 2017-2023 PDF from the current one.
--   * model-y current gen (2025-present) — same split.
--   * model-s split: existing `model-s-sedan-2012-present` becomes the
--     legacy span (end_year=2020), plus a NEW current gen 2021-present
--     for the 2021 facelift ("Plaid"/Raven).
--   * model-x (both gens — not in DB at all)
--   * cybertruck (also missing entirely).
--
-- Codenames are the Tesla internal designations — kept as the actual
-- model-line codenames (e.g. Tesla calls the 2024 facelift Model 3
-- "Highland"; Model Y's 2025 refresh is "Juniper"). The backfill chassis
-- tiebreaker reads codename but Tesla OM URLs are mostly distinguished
-- by year, so this is just for our internal records.

SET NAMES utf8mb4;

SET @tesla := (SELECT id FROM makes WHERE slug='tesla');

-- 1. Missing models
INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@tesla, 'model-x',    'Model X'),
  (@tesla, 'cybertruck', 'Cybertruck');

SET @m_model_3 := (SELECT id FROM models WHERE make_id=@tesla AND slug='model-3');
SET @m_model_s := (SELECT id FROM models WHERE make_id=@tesla AND slug='model-s');
SET @m_model_x := (SELECT id FROM models WHERE make_id=@tesla AND slug='model-x');
SET @m_model_y := (SELECT id FROM models WHERE make_id=@tesla AND slug='model-y');
SET @m_cybertruck := (SELECT id FROM models WHERE make_id=@tesla AND slug='cybertruck');

-- 2. Cap the legacy Model S row so the new 2021-present gen owns the
--    current-OM URL slot. The existing slug stays (`model-s-sedan-2012-present`)
--    for historic-URL stability; only end_year moves.
UPDATE generations SET end_year = 2020 WHERE model_id=@m_model_s AND slug='model-s-sedan-2012-present';

-- 3. New gens
INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  -- Model 3 — current "Highland" facelift
  (@m_model_3,    'model-3-highland-sedan-2024-present', 'Highland', 'Tesla Model 3 (Highland)',  'Sedan', 2024, NULL, 'RWD', 1),
  -- Model S — current 2021+ refresh ("Plaid"/Raven era)
  (@m_model_s,    'model-s-plaid-sedan-2021-present',    'Raven',    'Tesla Model S (Raven)',     'Sedan', 2021, NULL, 'AWD', 1),
  -- Model X — both gens (not in DB at all)
  (@m_model_x,    'model-x-suv-2015-2020',               NULL,       'Tesla Model X',             'SUV',   2015, 2020, 'AWD', 1),
  (@m_model_x,    'model-x-plaid-suv-2021-present',      'Raven',    'Tesla Model X (Raven)',     'SUV',   2021, NULL, 'AWD', 1),
  -- Model Y — current "Juniper" refresh
  (@m_model_y,    'model-y-juniper-suv-2025-present',    'Juniper',  'Tesla Model Y (Juniper)',   'SUV',   2025, NULL, 'AWD', 1),
  -- Cybertruck
  (@m_cybertruck, 'cybertruck-pickup-2023-present',      NULL,       'Tesla Cybertruck',          'Pickup', 2023, NULL, 'AWD', 1);
