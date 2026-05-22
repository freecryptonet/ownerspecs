-- F30 completion: OEM-verified bulbs + tire pressures per OE size for both
-- pre-LCI (2012-2015) and LCI (2015-2018) gens. Plus OEM source citations
-- for the gen-wide spec rows that already existed but had no OEM-tier
-- citation linked.
--
-- Scope per the "collect all data before next gen" workflow + Tim's
-- 2026-05-22 ask to fully complete F30 before moving to G20.
--
-- Bulb data extracted from:
--   - BMW US 2015 3 Series Sedan Owner's Manual (Part no. 01 40 2 960 440 -
--     II/15) — pre-LCI lineup with the more comprehensive halogen list
--     (10 replaceable positions before LCI moved most rear lighting to LED).
--   - BMW US 2018 3 Series Sedan Owner's Manual (Part no. 01402984107 -
--     X/17) — LCI lineup with reduced replaceable count (5 positions; tail-
--     gate + mirror turn signals went LED). Cross-verified vs MY2016 +
--     MY2017 manuals.
--
-- Tire pressure data extracted from the per-tire-size tables in both
-- pre-LCI 2015 and LCI 2018 manuals. The mig 163 attempt to land per-size
-- pressures used a non-existent `notes` column and INSERT IGNORE'd; this
-- migration retries with the correct column set.
--
-- Out-of-scope domains for F30 (not covered by OEM manuals): fuse circuit
-- layout (the manuals reference a card stored in the fuse box itself, not
-- printed), battery group / CCA (dealer service domain), specific service-
-- interval mileages (BMW uses Condition Based Service so intervals are
-- computed from on-board sensors not printed in the manual).

SET NAMES utf8mb4;

SET @gen_pre := (SELECT id FROM generations WHERE slug = '3-series-f30-sedan-2012-2015');
SET @gen_lci := (SELECT id FROM generations WHERE slug = '3-series-f30-lci-sedan-2015-2018');

SET @s_2015 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2015-owners-manual-51260');
SET @s_2016 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-sedan-2016-owners-manual-80762');
SET @s_2017 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2017-owners-manual-76567');
SET @s_2018 := (SELECT id FROM sources WHERE url = 'https://ownersmanuals2.com/bmw-auto/3-series-2018-owners-manual-76585');

-- ----------------------------------------------------------------------------
-- 1. Tire pressures per OE size — pre-LCI 2015 manual values
-- ----------------------------------------------------------------------------
-- Use INSERT (not IGNORE) — there's no uniqueness constraint, just data
-- integrity via the existing gen-wide rows from migrations 162 / split.
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_pre, 'front', 'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC'),
  (@gen_pre, 'rear',  'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC'),
  (@gen_pre, 'front', 'normal',   32.0, 220, '225/45 R18 91 V RSC'),
  (@gen_pre, 'rear',  'normal',   35.0, 240, '225/45 R18 91 V RSC'),
  (@gen_pre, 'front', 'normal',   35.0, 240, '225/40 R19 89 Y RSC'),
  (@gen_pre, 'rear',  'normal',   38.0, 260, '255/35 R19 92 Y RSC'),
  (@gen_pre, 'front', 'normal',   36.0, 250, '225/35 R20 90 Y XL RSC'),
  (@gen_pre, 'rear',  'normal',   44.0, 300, '255/30 R20 92 Y XL RSC'),
  (@gen_pre, 'spare', 'normal',   60.0, 420, 'T 135/80 R17 102 M');

-- LCI tire pressures (largely same OE sizes as pre-LCI, with the 18-inch
-- staggered 225/45+255/40 set new for LCI)
INSERT INTO tire_pressures (generation_id, position, load_condition, psi, kpa, tire_size) VALUES
  (@gen_lci, 'front', 'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC'),
  (@gen_lci, 'rear',  'normal',   32.0, 220, '225/50 R17 94 V M+S A/S RSC'),
  (@gen_lci, 'front', 'normal',   32.0, 220, '225/45 R18 91 V M+S A/S RSC'),
  (@gen_lci, 'rear',  'normal',   32.0, 220, '225/45 R18 91 V M+S A/S RSC'),
  (@gen_lci, 'front', 'normal',   32.0, 220, '225/45 R18 91 Y RSC (staggered front)'),
  (@gen_lci, 'rear',  'normal',   35.0, 240, '255/40 R18 95 Y RSC (staggered rear)'),
  (@gen_lci, 'front', 'normal',   32.0, 220, '225/40 R19 89 Y RSC'),
  (@gen_lci, 'rear',  'normal',   38.0, 260, '255/35 R19 92 Y RSC'),
  (@gen_lci, 'front', 'normal',   36.0, 250, '225/35 R20 90 Y XL RSC'),
  (@gen_lci, 'rear',  'normal',   44.0, 300, '255/30 R20 92 Y XL RSC');

-- ----------------------------------------------------------------------------
-- 2. Source citations for the new tire_pressures rows
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_2015 FROM tire_pressures
  WHERE generation_id = @gen_pre AND tire_size IS NOT NULL AND tire_size LIKE '%RSC%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_2015 FROM tire_pressures
  WHERE generation_id = @gen_pre AND tire_size LIKE 'T 135%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_2018 FROM tire_pressures
  WHERE generation_id = @gen_lci AND tire_size IS NOT NULL AND tire_size LIKE '%RSC%';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'tire_pressures', id, @s_2017 FROM tire_pressures
  WHERE generation_id = @gen_lci AND tire_size IS NOT NULL AND tire_size LIKE '%RSC%';

-- ----------------------------------------------------------------------------
-- 3. Bulb specs — pre-LCI 2015 manual (10 positions; halogen-heavy)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_pre, 'low_beam',                 'H7',     2, 0),
  (@gen_pre, 'high_beam',                'H7',     2, 0),
  (@gen_pre, 'turn_signal_front',        'PY21W',  2, 0),
  (@gen_pre, 'parking_light_front',      'H6W',    2, 0),
  (@gen_pre, 'daytime_running_light',    'PW24W',  2, 0),
  (@gen_pre, 'fog_lamp_front',           'H8',     2, 0),
  (@gen_pre, 'turn_signal_rear',         'PY21W',  2, 0),
  (@gen_pre, 'brake_light_outer',        'H21W',   2, 0),
  (@gen_pre, 'brake_light_inner',        'H21W',   2, 0),
  (@gen_pre, 'reversing_light',          'PW16W',  2, 0);

-- ----------------------------------------------------------------------------
-- 4. Bulb specs — LCI 2018 manual (5 positions; rear lighting and mirror
--    turn signals are LED on LCI so no replaceable bulb code)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen_lci, 'low_beam',          'H7',    2, 0),
  (@gen_lci, 'high_beam',         'H7',    2, 0),
  (@gen_lci, 'turn_signal_front', 'PY21W', 2, 0),
  (@gen_lci, 'fog_lamp_front',    'H8',    2, 0),
  (@gen_lci, 'reversing_light',   'H21W',  2, 0),
  -- LED-only positions (replacement requires dealer assembly swap)
  (@gen_lci, 'tail_lamp_assembly',     'LED', 1, 1),
  (@gen_lci, 'mirror_turn_signal',     'LED', 2, 1),
  (@gen_lci, 'daytime_running_light',  'LED', 2, 1);

-- ----------------------------------------------------------------------------
-- 5. Source citations on bulbs (OEM manuals are the primary authority)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2015 FROM bulbs WHERE generation_id = @gen_pre;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2018 FROM bulbs WHERE generation_id = @gen_lci;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2017 FROM bulbs WHERE generation_id = @gen_lci;
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'bulbs', id, @s_2016 FROM bulbs WHERE generation_id = @gen_lci;
