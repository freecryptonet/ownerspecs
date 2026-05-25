-- 454: Remove the S63 M-engine (396, S63B44T4) contamination from the regular (non-M) X5/X6.
-- The S63 is an M-division-only engine; the regular X5/X6 use N63 (50i), B58 (40i) or S68 (M60i),
-- and their M counterparts are SEPARATE gens (X5M F85/F95, X6M F86/F96). After the mig-453 split
-- these regular gens were left showing "S63B44T4 ... M TwinPower Turbo" as an engine — pure
-- contamination. Each already carries its correct N63/B58/diesel rows; drop only the S63 rows.
-- (Broader scraper leakage on these gens — e.g. 3-series engine rows on the X5 F15 — is a
--  separate, larger issue documented in memory reference_bmw_m_i_engine_contamination.)

DELETE ss FROM spec_sources ss
  JOIN fluid_specs f ON ss.spec_table='fluid_specs' AND ss.spec_id=f.id
  WHERE f.engine_id=396 AND f.generation_id IN (168,48,235,238,237);
DELETE FROM fluid_specs WHERE engine_id=396 AND generation_id IN (168,48,235,238,237);
