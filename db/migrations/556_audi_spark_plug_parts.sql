-- mig 556 — OE spark-plug part numbers for Audi petrol engines (engine pages "OE part numbers").
-- Browser HaynesPro Adjustment Data ("Spark plugs — make and type"). Facts only.
-- Spark-plug PN is family-shared (like oil), so one PN per engine family, applied per (gen, engine).
-- Petrol only (diesels use glow plugs). PN availability is patchy in HaynesPro — these are the
-- families where make/type is published; others (A1 EA111/EA888/EA113, A8 4H petrol) not listed -> backfill.
-- Sources: 815 (A1 8X), 817 (Q2 GA), 810 (A8 4E).

SET NAMES utf8mb4;

INSERT INTO parts (generation_id, engine_id, part_type, part_number, source_brand, gap_mm, notes) VALUES
 -- EA211 TFSI (1.0/1.4/1.5) — VW/Audi 04E 905 612
 (350,2160,'spark_plug','04E 905 612','VW/Audi',NULL,'1.0 TFSI (EA211).'),
 (350,2161,'spark_plug','04E 905 612','VW/Audi',NULL,'1.0 TFSI (EA211).'),
 (350,2158,'spark_plug','04E 905 612','VW/Audi',NULL,'1.4 TFSI (EA211).'),
 (350,2159,'spark_plug','04E 905 612','VW/Audi',NULL,'1.4 TFSI (EA211).'),
 (350,2078,'spark_plug','04E 905 612','VW/Audi',NULL,'1.4 TFSI (EA211, CPTA).'),
 (354,2141,'spark_plug','04E 905 612','VW/Audi',NULL,'1.5 TFSI (EA211 evo).'),
 -- A8 4E V6 FSI (2.8/3.0/3.2) — NGK 101 905 621
 (351,1648,'spark_plug','101 905 621','NGK',NULL,'2.8 FSI (V6). NGK, VW/Audi PN 101 905 621.'),
 (351,1649,'spark_plug','101 905 621','NGK',NULL,'3.0 V6 petrol. NGK, VW/Audi PN 101 905 621.'),
 (351,1653,'spark_plug','101 905 621','NGK',NULL,'3.2 FSI (V6). NGK, VW/Audi PN 101 905 621.'),
 -- A8 4E V8 petrol (3.7/4.2) — NGK BKR-6 EQUA (Bosch FGR 7KQEO), gap 0.9-1.1 mm
 (351,1654,'spark_plug','BKR-6 EQUA','NGK',1.00,'3.7 V8. Bosch FGR 7KQEO equivalent. Gap 0.9-1.1 mm.'),
 (351,1656,'spark_plug','BKR-6 EQUA','NGK',1.00,'4.2 V8. Bosch FGR 7KQEO equivalent. Gap 0.9-1.1 mm.'),
 (351,1657,'spark_plug','BKR-6 EQUA','NGK',1.00,'4.2 V8 (FSI). Bosch FGR 7KQEO equivalent. Gap 0.9-1.1 mm.'),
 -- A8 4E W12 — VW/Audi 101 905 600 A (NGK PZFR6J11), gap 1.0-1.1 mm
 (351,2120,'spark_plug','101 905 600 A','VW/Audi',1.05,'6.0 W12. NGK PZFR6J11 equivalent. Gap 1.0-1.1 mm.');

INSERT INTO spec_sources (spec_table, spec_id, source_id)
SELECT 'parts', p.id, CASE p.generation_id WHEN 350 THEN 815 WHEN 354 THEN 817 WHEN 351 THEN 810 END
FROM parts p
WHERE p.part_type='spark_plug' AND p.generation_id IN (350,351,354)
  AND NOT EXISTS (SELECT 1 FROM spec_sources ss WHERE ss.spec_table='parts' AND ss.spec_id=p.id
                  AND ss.source_id = CASE p.generation_id WHEN 350 THEN 815 WHEN 354 THEN 817 WHEN 351 THEN 810 END);
