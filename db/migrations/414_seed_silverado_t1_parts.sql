-- mig 414: seed parts for Chevrolet Silverado 1500 (T1, gen 38) → completes the gen (8/8 moat tables).
-- Source: GM owner's-manual "Maintenance Replacement Parts" table (Silverado 1500 MY2023 OM, p.424).
-- V8 trims only are in our catalog (5.3L L82/L84, 6.2L L87) — values shown apply to those.
-- ACDelco = GM's OEM parts brand (fine to name; not a data vendor). GM part numbers in notes.
-- Engine air filter: not given a replacement PN in this OM's table (deferred) → omitted, not guessed.

INSERT INTO sources (type, citation, is_public, public_link, retrieved_at)
VALUES ('oem_manual', 'Chevrolet Silverado 1500 (T1) Owner''s Manual', 1, 0, NOW());
SET @src := LAST_INSERT_ID();

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, size, notes) VALUES
  (38, NULL, 'oil_filter',    'PF63',     'ACDelco', NULL, NULL,      'GM 12707246; 5.3L (L82/L84) & 6.2L (L87) V8'),
  (38, NULL, 'cabin_filter',  'CF185',    'ACDelco', NULL, NULL,      'GM 13508023'),
  (38, NULL, 'spark_plug',    '41-114',   'ACDelco', NULL, NULL,      'GM 12622441; 5.3L & 6.2L V8'),
  (38, NULL, 'wiper_front_d', '84578275', 'GM',      NULL, '21.7 in', 'Driver side (55 cm)'),
  (38, NULL, 'wiper_front_p', '84578275', 'GM',      NULL, '21.7 in', 'Passenger side (55 cm)');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
  SELECT 'parts', id, @src FROM parts WHERE generation_id = 38;
