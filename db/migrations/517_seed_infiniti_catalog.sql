-- mig 517 — seed Infiniti catalog (make + 16 models + 24 gens).
--
-- Why now: we have 98 Infiniti OEM PDFs sitting on disk from the
-- nissanusa.com sister portal (infinitiusa.com), but no Infiniti rows
-- in the DB so backfill_oem_manual_urls.py matches zero of them.
--
-- This is catalog-only seed (no fluids/torques/maintenance yet). Per
-- the 2026-05-27 render-gate downgrade [[feedback_gen_completion_checklist]],
-- catalog-only gens are allowed: the gen hub suppresses empty moat
-- tabs+tiles and topic pages notFound(). Verification badge will show
-- "Catalogue data · owner-manual data in progress" at 0 sources.
--
-- Year ranges are taken from the PDF corpus we already have on disk.
-- Chassis codenames are the manufacturer-recognised codes (V36, Y51,
-- Y62, V37, L50, L51, J55, S51, H15) — accurate for the year span.
-- Where Infiniti renamed a nameplate mid-life (G→Q40 sedan, FX→QX70,
-- M→Q70, JX→QX60, QX56→QX80, EX→QX50), each badged name gets its own
-- gen rather than predecessor/successor links — keeps the OM-URL
-- backfill 1:1 with what's on disk.

SET NAMES utf8mb4;

INSERT IGNORE INTO makes (slug, name, country_of_origin) VALUES ('infiniti', 'Infiniti', 'JP');
SET @inf := (SELECT id FROM makes WHERE slug = 'infiniti');

INSERT IGNORE INTO models (make_id, slug, name) VALUES
  (@inf, 'ex',   'EX'),
  (@inf, 'fx',   'FX'),
  (@inf, 'g',    'G'),
  (@inf, 'jx',   'JX'),
  (@inf, 'm',    'M'),
  (@inf, 'q40',  'Q40'),
  (@inf, 'q50',  'Q50'),
  (@inf, 'q60',  'Q60'),
  (@inf, 'q70',  'Q70'),
  (@inf, 'qx30', 'QX30'),
  (@inf, 'qx50', 'QX50'),
  (@inf, 'qx55', 'QX55'),
  (@inf, 'qx56', 'QX56'),
  (@inf, 'qx60', 'QX60'),
  (@inf, 'qx70', 'QX70'),
  (@inf, 'qx80', 'QX80');

SET @m_ex   := (SELECT id FROM models WHERE make_id=@inf AND slug='ex');
SET @m_fx   := (SELECT id FROM models WHERE make_id=@inf AND slug='fx');
SET @m_g    := (SELECT id FROM models WHERE make_id=@inf AND slug='g');
SET @m_jx   := (SELECT id FROM models WHERE make_id=@inf AND slug='jx');
SET @m_m    := (SELECT id FROM models WHERE make_id=@inf AND slug='m');
SET @m_q40  := (SELECT id FROM models WHERE make_id=@inf AND slug='q40');
SET @m_q50  := (SELECT id FROM models WHERE make_id=@inf AND slug='q50');
SET @m_q60  := (SELECT id FROM models WHERE make_id=@inf AND slug='q60');
SET @m_q70  := (SELECT id FROM models WHERE make_id=@inf AND slug='q70');
SET @m_qx30 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx30');
SET @m_qx50 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx50');
SET @m_qx55 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx55');
SET @m_qx56 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx56');
SET @m_qx60 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx60');
SET @m_qx70 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx70');
SET @m_qx80 := (SELECT id FROM models WHERE make_id=@inf AND slug='qx80');

INSERT IGNORE INTO generations
  (model_id, slug, codename, display_name, body_type, start_year, end_year, layout, is_active)
VALUES
  (@m_ex,   'ex37-v36-coupe-2007-2013',         'V36', 'Infiniti EX37 (V36)',          'coupe',       2007, 2013, 'RWD', 1),
  (@m_fx,   'fx-s51-suv-2008-2013',             'S51', 'Infiniti FX (S51)',            'suv',         2008, 2013, 'AWD', 1),
  (@m_g,    'g-sedan-v36-2006-2013',            'V36', 'Infiniti G Sedan (V36)',       'sedan',       2006, 2013, 'RWD', 1),
  (@m_g,    'g-coupe-v36-2007-2013',            'V36', 'Infiniti G Coupe (V36)',       'coupe',       2007, 2013, 'RWD', 1),
  (@m_g,    'g-convertible-v36-2009-2013',      'V36', 'Infiniti G Convertible (V36)', 'convertible', 2009, 2013, 'RWD', 1),
  (@m_jx,   'jx35-l50-suv-2013-2013',           'L50', 'Infiniti JX35 (L50)',          'suv',         2013, 2013, 'AWD', 1),
  (@m_m,    'm-y51-sedan-2011-2013',            'Y51', 'Infiniti M (Y51)',             'sedan',       2011, 2013, 'RWD', 1),
  (@m_m,    'm-hybrid-y51-sedan-2012-2013',     'Y51', 'Infiniti M Hybrid (Y51)',      'sedan',       2012, 2013, 'RWD', 1),
  (@m_q40,  'q40-v36-sedan-2015-2015',          'V36', 'Infiniti Q40 (V36)',           'sedan',       2015, 2015, 'RWD', 1),
  (@m_q50,  'q50-v37-sedan-2014-present',       'V37', 'Infiniti Q50 (V37)',           'sedan',       2014, NULL, 'RWD', 1),
  (@m_q50,  'q50-hybrid-v37-sedan-2014-2018',   'V37', 'Infiniti Q50 Hybrid (V37)',    'sedan',       2014, 2018, 'RWD', 1),
  (@m_q60,  'q60-v37-coupe-2017-2022',          'V37', 'Infiniti Q60 (V37)',           'coupe',       2017, 2022, 'RWD', 1),
  (@m_q60,  'q60-coupe-v36-2014-2015',          'V36', 'Infiniti Q60 Coupe (V36)',     'coupe',       2014, 2015, 'RWD', 1),
  (@m_q60,  'q60-convertible-v36-2014-2015',    'V36', 'Infiniti Q60 Convertible (V36)', 'convertible', 2014, 2015, 'RWD', 1),
  (@m_q70,  'q70-y51-sedan-2014-2019',          'Y51', 'Infiniti Q70 (Y51)',           'sedan',       2014, 2019, 'RWD', 1),
  (@m_q70,  'q70-hybrid-y51-sedan-2014-2018',   'Y51', 'Infiniti Q70 Hybrid (Y51)',    'sedan',       2014, 2018, 'RWD', 1),
  (@m_qx30, 'qx30-h15-suv-2017-2019',           'H15', 'Infiniti QX30 (H15)',          'suv',         2017, 2019, 'AWD', 1),
  (@m_qx50, 'qx50-p32r-suv-2014-2017',          'P32R','Infiniti QX50 I (P32R)',       'suv',         2014, 2017, 'RWD', 1),
  (@m_qx50, 'qx50-j55-suv-2019-present',        'J55', 'Infiniti QX50 II (J55)',       'suv',         2019, NULL, 'FWD', 1),
  (@m_qx55, 'qx55-j55-suv-2022-present',        'J55', 'Infiniti QX55 (J55)',          'suv',         2022, NULL, 'AWD', 1),
  (@m_qx56, 'qx56-y62-suv-2011-2013',           'Y62', 'Infiniti QX56 (Y62)',          'suv',         2011, 2013, 'AWD', 1),
  (@m_qx60, 'qx60-l50-suv-2014-2020',           'L50', 'Infiniti QX60 I (L50)',        'suv',         2014, 2020, 'FWD', 1),
  (@m_qx60, 'qx60-l51-suv-2022-present',        'L51', 'Infiniti QX60 II (L51)',       'suv',         2022, NULL, 'FWD', 1),
  (@m_qx60, 'qx60-hybrid-l50-suv-2014-2017',    'L50', 'Infiniti QX60 Hybrid (L50)',   'suv',         2014, 2017, 'FWD', 1),
  (@m_qx70, 'qx70-s51-suv-2014-2017',           'S51', 'Infiniti QX70 (S51)',          'suv',         2014, 2017, 'AWD', 1),
  (@m_qx80, 'qx80-y62-suv-2014-2024',           'Y62', 'Infiniti QX80 I (Y62)',        'suv',         2014, 2024, 'AWD', 1),
  (@m_qx80, 'qx80-y63-suv-2025-present',        'Y63', 'Infiniti QX80 II (Y63)',       'suv',         2025, NULL, 'AWD', 1);
