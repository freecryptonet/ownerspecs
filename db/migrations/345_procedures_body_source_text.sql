-- mig 345 — add procedures.body_md_source_text for the raw HaynesPro
-- repairManuals fetch. NEVER rendered publicly (Feist v Rural concern); kept
-- as audit-text so a later restating pass (LLM-aided or manual) can produce
-- the public body_md.

ALTER TABLE procedures
  ADD COLUMN body_md_source_text MEDIUMTEXT NULL COMMENT 'Raw HaynesPro repairManuals body text. Internal audit only — NOT rendered. Restate into body_md before exposing publicly.'
  AFTER body_md;

-- Confirm
DESCRIBE procedures;
