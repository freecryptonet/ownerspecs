-- mig 467: Mercedes-Benz B-Class (W246) gen 317 — fill the empty parts lane with
-- wiper-blade fitment (cross-checked across multiple aftermarket catalogues; the
-- 650/475 mm front + 250 mm rear set is the dominant W246 fitment).
--
-- Sources:
--   958  Mercedes-Benz Owner's Manual (public anchor — OM lists wiper fitment).
--   NEW  Service-parts fitment reference, cross-checked aftermarket catalogues
--        (is_public=0, flagged provenance).

SET @gen := 317;

INSERT INTO sources (type, citation, public_link, retrieved_at, is_public, notes)
VALUES ('reference',
        'Service-parts fitment reference',
        0, NOW(), 0,
        'Aggregated reference, NOT OEM documentation. Wiper-blade sizes cross-checked across multiple independent aftermarket fitment catalogues.');
SET @src_parts := LAST_INSERT_ID();

INSERT INTO parts (generation_id, part_type, part_number, size, notes) VALUES
  (@gen, 'wiper_blade', '650 mm', '650 mm', 'Front · driver side'),
  (@gen, 'wiper_blade', '475 mm', '475 mm', 'Front · passenger side'),
  (@gen, 'wiper_blade', '250 mm', '250 mm', 'Rear');

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p.id, s.id
  FROM parts p
  CROSS JOIN (SELECT 958 AS id UNION SELECT @src_parts) s
 WHERE p.generation_id = @gen AND p.part_type = 'wiper_blade';
