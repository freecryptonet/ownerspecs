-- mig 362: BMW X7 (G07) + (G07 LCI) dimensions + fuel tank from OEM Owner's Manual
-- Source: BMW X7 (G07) 2019 Owner's Manual (Part no. 01402720901 — II/19) Technical data section
-- Manual cached at /home/deploy/ownerspecs/manuals/BMW_X7_G07_2019_OwnersManual.pdf (downloaded 2026-05-25)
-- Indexing into manual_inventory deferred (scan script needs dotenv on VPS).

-- Insert manual_inventory + source rows for the X7 G07 OEM manual
INSERT INTO manual_inventory
  (file_path, sha256, manual_type, brand, model, model_year_start, model_year_end,
   edition_code, edition_label, publication_date, language, region, page_count, title_text, extracted_at, notes)
VALUES
  ('manuals/BMW_X7_G07_2019_OwnersManual.pdf',
   'b6ca2b6b2dd097172cbcc5e9ac402ee4b545623ba35195541903745d15fade5e',
   'owner', 'BMW', 'X7', 2019, 2019,
   '01402720901', 'II/19', '2019-02-01', 'en-US', 'US', NULL,
   'BMW X7 Owner''s Manual', NOW(),
   'BMW X7 G07 / G07 LCI Owner''s Manual; covers xDrive40i and xDrive50i. Acquired via community forum mirror; manual is a US BMW publication.');

SET @mi_x7 := LAST_INSERT_ID();

INSERT INTO sources
  (type, citation, url, manual_inventory_id, is_public, public_link, retrieved_at, notes)
VALUES
  ('oem_manual',
   'BMW X7 (G07) Owner''s Manual (II/19, US)',
   NULL, @mi_x7, 1, 0, NOW(),
   'OEM Owner''s Manual; US edition. Used for dimensions, weights, towing, fuel-tank capacity. CBS-based service intervals not in this document.');

SET @s_x7_om := LAST_INSERT_ID();

-- Backfill dimensions + fuel tank on X7 G07 + G07 LCI
UPDATE generations SET
    length_mm    = 5165,
    width_mm     = 2000,
    height_mm    = 1805,
    wheelbase_mm = 3105,
    fuel_tank_l  = 83.0
  WHERE id IN (241, 242);

-- Cite the manual on each of the two generation rows
INSERT IGNORE INTO spec_sources (spec_table, spec_id, source_id) VALUES
  ('generations', 241, @s_x7_om),
  ('generations', 242, @s_x7_om);
