-- Plan 2 RDW->schema writer — GENERATED SQL, DRY-RUN OUTPUT (NOT APPLIED).
-- Cohort: kia-rio-yb  where: merk='KIA' and starts_with(typegoedkeuringsnummer,'e11*2007/46*3777') and (upper(handelsbenaming) like '%RIO%') and datum_eerste_toelating>='20110101' and datum_eerste_toelating<'20180101' and voertuigsoort='Personenauto'
-- Generated: 2026-09-23 23:43:49  by scripts/rdw_ingest/write_cohort.py
-- Review before applying. Idempotent: safe to run more than once (see header docstring
-- for the one caveat — value CHANGES on rerun no-op instead of version-forwarding).

SET NAMES utf8mb4;

-- 0. markets: NL is absent from the current `markets` table (confirmed via read-only
--    SELECT — see report). Additive, keyed on the real UNIQUE constraint uk_markets_code.
INSERT INTO markets (code, name, is_active) VALUES ('NL', 'Netherlands', 1)
  ON DUPLICATE KEY UPDATE name = VALUES(name);
SET @market_nl = (SELECT id FROM markets WHERE code='NL');

-- 1. fact_types: additive vocab entry for the CoC-doc-verifiable running-order mass as a
--    scalar spec_facts fact (separate from its typed mass_homologations row — see the
--    write_cohort.py summary for why this duplication exists / open question for Tim).
INSERT INTO fact_types (code, category, default_unit, value_kind)
  VALUES ('mass_running_order', 'mass', 'kg', 'num')
  ON DUPLICATE KEY UPDATE category = VALUES(category);
SET @ft_mass_running_order = (SELECT id FROM fact_types WHERE code='mass_running_order');

-- 2. documents: ONE row for this ingest run (generation_id=456). No natural unique
--    key on `documents` (mig 579) -> idempotency via WHERE NOT EXISTS on a stable cohort
--    tag in `notes`.
INSERT INTO documents (doc_type, provenance_kind, generation_id, market_id, citation,
    public_link, license, retrieved_at, notes)
SELECT 'rdw_open', 'official_open_data', 456, @market_nl, 'RDW Open Data (CC0)',
    1, 'CC0', NOW(), 'cohort:kia-rio-yb | RDW m9d7-ebf2 pull 2026-09-23 23:43:49 | where=merk=''KIA'' and starts_with(typegoedkeuringsnummer,''e11*2007/46*3777'') and (upper(handelsbenaming) like ''%RIO%'') and datum_eerste_toelating>=''20110101'' and datum_eerste_toelating<''20180101'' and voertuigsoort=''Personenauto'''
WHERE NOT EXISTS (
  SELECT 1 FROM documents
  WHERE doc_type='rdw_open' AND generation_id=456 AND market_id=@market_nl
    AND notes LIKE 'cohort:kia-rio-yb%'
);
SET @doc_id = (SELECT id FROM documents
  WHERE doc_type='rdw_open' AND generation_id=456 AND market_id=@market_nl
    AND notes LIKE 'cohort:kia-rio-yb%' ORDER BY id DESC LIMIT 1);

-- 3. vehicle_types — one row per publishable TVV (total registrations >= 10). Idempotent via the real UNIQUE key uk_tvv.
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P21', 'M52AZ1', 'b5p21|m52az1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P21', 'M51BZ1', 'b5p21|m51bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P11', 'M61BZ1', 'b5p11|m61bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P31', 'M53BZ1', 'b5p31|m53bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '01', 'YB', 'B5P21', 'M51BZ1', 'b5p21|m51bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '01', 'YB', 'B5P31', 'M53BZ1', 'b5p31|m53bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P51', 'A41BZ1', 'b5p51|a41bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '00', 'YB', 'B5P41', 'M62BZ1', 'b5p41|m62bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '01', 'YB', 'B5P11', 'M61BZ1', 'b5p11|m61bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');
INSERT IGNORE INTO vehicle_types (generation_id, category, approval_base, approval_extension, tvv_type, tvv_variant, tvv_version, market_twin_key, approval_market_id, commercial_label) VALUES (
  456, 'M1', 'e11*2007/46*3777', '01', 'YB', 'B5P41', 'M62BZ1', 'b5p41|m62bz1',
  (SELECT id FROM markets WHERE code='UK'), 'RIO');

-- 4. mass_homologations — per publishable TVV, per mass_kind. Flagged mass facts
--    (n<10 or within-TVV agreement<0.8) are SKIPPED entirely, not written
--    pending (write-side gate, stricter than the render-side qa_state gate).
--    `conditions` carries the n/agreement audit trail as a stopgap (mig 579 has no
--    structured column for it yet — flagged as a migration-580 candidate).
--    Idempotent via WHERE NOT EXISTS keyed on (vehicle_type_id, market_id, mass_kind,
--    axle_index, valid_to IS NULL).
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1155, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1600, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1600, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2600, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1000, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=1382;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M52AZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1155, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1600, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1600, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2600, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1000, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=910;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1160, 'n=200;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1620, 'n=200;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1620, 'n=200;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2730, 'n=200;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1110, 'n=200;agreement=0.995', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=200;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1110, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1560, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1560, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2470, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 910, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=170;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1155, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1600, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1600, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2600, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1000, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=102;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P21' AND vt.tvv_version='M51BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1110, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1560, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1560, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2470, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 910, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=43;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P31' AND vt.tvv_version='M53BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1158, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1600, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1600, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2400, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 800, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=37;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P51' AND vt.tvv_version='A41BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1130, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1580, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1580, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2580, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1000, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=35;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='00' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1160, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1620, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1620, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2730, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1110, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=12;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P11' AND vt.tvv_version='M61BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'running_order', NULL, 1130, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='running_order' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_permissible', NULL, 1580, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_permissible' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_laden_technical', NULL, 1580, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_laden_technical' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_combination', NULL, 2580, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_combination' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_braked', NULL, 1000, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_braked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'tow_unbraked', NULL, 450, 'n=10;agreement=1.0', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='tow_unbraked' AND mh.axle_index IS NULL AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 1, 945, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=1 AND mh.valid_to IS NULL);
INSERT INTO mass_homologations (generation_id, vehicle_type_id, market_id, mass_kind, axle_index, value_kg, conditions, source_document_id, valid_from, qa_state)
SELECT 456, vt.id, @market_nl, 'max_axle', 2, 840, 'per-type TGK axle (xhyb-w7xt), deterministic', @doc_id, CURDATE(), 'pending'
FROM vehicle_types vt WHERE vt.approval_base='e11*2007/46*3777' AND vt.approval_extension='01' AND vt.tvv_variant='B5P41' AND vt.tvv_version='M62BZ1'
AND NOT EXISTS (SELECT 1 FROM mass_homologations mh WHERE mh.vehicle_type_id=vt.id AND mh.market_id=@market_nl AND mh.mass_kind='max_axle' AND mh.axle_index=2 AND mh.valid_to IS NULL);
