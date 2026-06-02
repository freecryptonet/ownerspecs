-- mig 557 — backfill spark-plug PNs for A1 8X petrol engines HaynesPro didn't list (EA111/EA888).
-- Source: spark-plug manufacturer application data cross-referenced across >=2 agreeing listings
-- (Tim's own-research-if-cross-checked rule). Vendor-neutral source row, public_link=0, is_public=0
-- (research cross-reference, not an OEM/primary publication).
-- WRITTEN (clean >=2-source agreement):
--   2157 DAJB 1.8 TFSI (EA888 gen3) -> 06K 905 601 (NGK 94833)
--   2079 CAXA/CNVA 1.4 TFSI turbo (EA111) -> 101 905 626 (NGK PZFR6R)
--   2162 CBZA 1.2 TSI (EA111) -> NGK IZFR6P-7
-- SKIPPED (sources conflict / conflate EA111<->EA211<->EA888, could not meet >=2-agreeing bar):
--   2077 CAVG/CTHG 1.4 twincharged (EA111); 2076 CDLH 2.0 TFSI (EA113). Leave for a cleaner source.

SET NAMES utf8mb4;

INSERT INTO sources (type, citation, public_link, is_public, retrieved_at, notes) VALUES
 ('reference','Spark-plug manufacturer application data (cross-referenced)',0,0,NOW(),
  'OE spark-plug part numbers cross-referenced from spark-plug manufacturer application catalogues and multiple parts listings; >=2 agreeing sources required per value. Research cross-reference, not an OEM publication.');
SET @src_sp := LAST_INSERT_ID();

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
 (350,2157,'spark_plug','06K 905 601','VW/Audi',NULL,'1.8 TFSI (EA888 gen3). NGK 94833 (DILKAR6A) equivalent.'),
 (350,2079,'spark_plug','101 905 626','VW/Audi',NULL,'1.4 TFSI turbo (EA111, CAXA/CNVA). NGK PZFR6R equivalent.'),
 (350,2162,'spark_plug','IZFR6P-7','NGK',NULL,'1.2 TSI (EA111, CBZA).');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', id, @src_sp FROM parts
WHERE part_type='spark_plug' AND generation_id=350 AND engine_id IN (2157,2079,2162)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='parts' AND ss.spec_id=parts.id AND ss.source_id=@src_sp);
