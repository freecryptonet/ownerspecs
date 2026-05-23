-- mig 216 — Owner-manual PDF inventory.
-- Tracks which manual editions/revisions we have on local disk, so a
-- citation can reference the EXACT edition that backs a spec value.
-- This addresses mid-cycle manual revisions (BMW LC-87 → LC-18 1/1/2019,
-- VW 508.00 LL IV FE 2019, Honda Type 2 BLUE rev) where the same MY can
-- carry corrected spec values between revisions.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS manual_inventory (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  file_path VARCHAR(512) NOT NULL,
  sha256 CHAR(64) NOT NULL,
  manual_type ENUM('owner','service','workshop','parts','quickref','other') NOT NULL DEFAULT 'owner',
  brand VARCHAR(64),
  model VARCHAR(96),
  model_year_start SMALLINT UNSIGNED,
  model_year_end SMALLINT UNSIGNED,
  edition_code VARCHAR(96),
  edition_label VARCHAR(96),
  publication_date DATE,
  language CHAR(5) DEFAULT 'en-US',
  region CHAR(8),
  page_count SMALLINT UNSIGNED,
  title_text VARCHAR(255),
  extracted_at DATETIME NOT NULL,
  notes TEXT,
  UNIQUE KEY uk_sha256 (sha256),
  KEY idx_brand_model (brand, model),
  KEY idx_edition (edition_code),
  KEY idx_my (model_year_start, model_year_end)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE sources
  ADD COLUMN manual_inventory_id INT UNSIGNED NULL AFTER url,
  ADD KEY idx_sources_manual_inventory (manual_inventory_id);

ALTER TABLE spec_sources
  ADD COLUMN page_number SMALLINT UNSIGNED NULL;

-- Audit
SHOW CREATE TABLE manual_inventory\G
