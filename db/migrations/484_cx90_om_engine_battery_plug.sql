-- mig 484: CX-90 (KK) — more OM corrections from the engine/electrical spec pages
-- (2024 US OM, source 566, pages 695-697). Same lore-not-verified pattern.
SET @gen := 95;
SET @om := 566;

-- 1) Compression ratio: OM p695 says 12.0:1 for the e-SKYACTIV-G 3.3T; DB had 11.0.
--    (Intrinsic to the engine; engine 160 is used only by this gen.)
UPDATE engines SET compression = 12.0 WHERE id = 160 AND compression = 11.0;

-- 2) Battery: OM p697 says 75D23L / 80D26L (JIS), 12V-65Ah. DB had a European
--    "H6 AGM, 80 Ah" — wrong format for a JIS-battery car. Correct group + Ah.
--    (CCA not stated in the OM; existing 760 left but flagged as unverified.)
UPDATE electrical_specs
   SET battery_group = '80D26L / 75D23L (JIS)', ah = 65
 WHERE generation_id = @gen AND battery_group = 'H6 AGM';

-- 3) Spark plug: OM p697 says Mazda Genuine H301-18-110 / H302-18-110 for the
--    e-SKYACTIV-G. DB had PE5R-18-110 (that is the CX-5's plug). Correct the PN
--    and scope it to the 3.3T petrol (engine 160) — engine-specific.
UPDATE parts
   SET part_number = 'H301-18-110 / H302-18-110', source_brand = 'Mazda Genuine', engine_id = 160
 WHERE generation_id = @gen AND part_type = 'spark_plug' AND part_number = 'PE5R-18-110';

INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @om FROM parts WHERE generation_id=@gen AND part_type='spark_plug';
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'electrical_specs', id, @om FROM electrical_specs WHERE generation_id=@gen;
