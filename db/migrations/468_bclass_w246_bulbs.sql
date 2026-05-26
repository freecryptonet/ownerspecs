-- mig 468: Mercedes-Benz B-Class (W246) gen 317 — fill the bulbs lane.
-- Base halogen variant, cross-checked across three independent sources
-- (AUTODOC fitment + a Mercedes bulb chart + the OM headlight list, which agree).
-- Reverse-light bulb omitted: sources conflicted (P21W vs W16W).
--
-- Headlights are H7 on the halogen variant; bi-xenon trims use D1S/D3S — captured
-- in the source note (bulbs has no per-row notes column).
--
-- Sources:
--   958  Mercedes-Benz Owner's Manual (public anchor — lists exterior lamps).
--   NEW  Exterior bulb fitment reference, cross-checked (is_public=0, flagged).

SET @gen := 317;

INSERT INTO sources (type, citation, public_link, retrieved_at, is_public, notes)
VALUES ('reference',
        'Exterior bulb fitment reference',
        0, NOW(), 0,
        'Aggregated reference, NOT OEM documentation. Base halogen-headlamp variant, cross-checked across three independent fitment sources. Bi-xenon trims use D1S/D3S low/high beam instead of H7; high-mount stop lamp is factory LED.');
SET @src_bulb := LAST_INSERT_ID();

INSERT INTO bulbs (generation_id, position, bulb_code, quantity, led_from_factory) VALUES
  (@gen, 'headlight_low',  'H7',     2, 0),
  (@gen, 'headlight_high', 'H7',     2, 0),
  (@gen, 'fog_front',      'H11',    2, 0),
  (@gen, 'turn_front',     'PY21W',  2, 0),
  (@gen, 'turn_rear',      'PY21W',  2, 0),
  (@gen, 'brake_tail',     'P21/5W', 2, 0),
  (@gen, 'side_marker',    'W5W',    2, 0),
  (@gen, 'license_plate',  'W5W',    2, 0);

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'bulbs', b.id, s.id
  FROM bulbs b
  CROSS JOIN (SELECT 958 AS id UNION SELECT @src_bulb) s
 WHERE b.generation_id = @gen;
