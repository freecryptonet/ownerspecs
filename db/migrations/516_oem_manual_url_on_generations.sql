-- mig 516 — add OEM manual download fields to generations.
--
-- Lets the gen hub page render a "Download Owner's Manual" card with a
-- direct link to the manufacturer's PDF. The actual PDF stays on the OEM
-- domain (public_link=1 sources per mig 194), so we host nothing and carry
-- zero copyright exposure — we're surfacing a citation, not republishing.
--
-- SEO play: target the high-intent "<year> <model> owner's manual" query
-- on the gen page that already ranks for spec queries. See feedback memory
-- (this session, 2026-05-30) for the reasoning.
--
-- All columns NULL by default. The page template renders the card only
-- when oem_manual_url IS NOT NULL, so partial rollout is safe.

SET NAMES utf8mb4;

ALTER TABLE generations
  ADD COLUMN oem_manual_url           VARCHAR(512)      NULL AFTER successor_id,
  ADD COLUMN oem_manual_pdf_size_mb   DECIMAL(5,1)      NULL AFTER oem_manual_url,
  ADD COLUMN oem_manual_year_referenced SMALLINT UNSIGNED NULL AFTER oem_manual_pdf_size_mb,
  ADD COLUMN oem_manual_source_id     INT UNSIGNED      NULL AFTER oem_manual_year_referenced,
  ADD COLUMN oem_manual_verified_at   DATE              NULL AFTER oem_manual_source_id,
  ADD KEY idx_oem_manual_source (oem_manual_source_id);
