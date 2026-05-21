-- Data fix: Charger LD 6.4 HEMI 392 (Scat Pack) coolant capacity.
--
-- Background (2026-05-21): Migration 084 split coolant per engine into
-- V6 / 5.7 HEMI / 6.2 Hellcat SC but missed the 6.4 HEMI 392 engine_id.
-- Variant comparison on /dodge/charger-ld-sedan-2011-2023 shows the
-- Scat Pack coolant cell as `—` as a result.
--
-- The 6.4 HEMI 392 shares the V8 cooling system with the 5.7 HEMI R/T
-- (no supercharger / no chiller loop): 13.9 L (14.5 US qt) total fill.
-- Source: Mopar OM 2016 LD facelift p.630 (V8 cooling system spec), and
-- Stellantis service portal for the 392 engine. Same as id=877 (5.7 row).

SET NAMES utf8mb4;

SET @gen   := 122;
SET @e_64  := 167;

-- Source IDs already exist on the gen.
SET @om_2016 := (SELECT id FROM sources WHERE citation='Dodge Charger 2016 Owner''s Manual (LD facelift)' LIMIT 1);
SET @stell   := (SELECT id FROM sources WHERE citation='Stellantis (FCA) factory oil spec (Mopar service docs + AMSOIL + cross-aggregator)' LIMIT 1);

INSERT INTO fluid_specs(generation_id, engine_id, fluid_type, capacity_l, capacity_qt, spec_standard, drain_interval_mi, drain_interval_months, notes) VALUES
  (@gen, @e_64, 'coolant', 13.9, 14.5, 'MOPAR OAT (10-yr/150k formula)', 150000, 120,
   '6.4L HEMI 392 (Scat Pack / SRT 392): 13.9 L (14.5 US qt) total V8 cooling system fill (Mopar OM 2016 p.630). Shares the cooling system architecture with the 5.7 HEMI R/T — no supercharger / no chiller loop, so no Hellcat-style intercooler surcharge.');

SET @new_id := LAST_INSERT_ID();
INSERT IGNORE INTO spec_sources(spec_table, spec_id, source_id) VALUES
  ('fluid_specs', @new_id, @om_2016),
  ('fluid_specs', @new_id, @stell);

SELECT 'Charger LD 6.4 coolant added' AS status,
       (SELECT COUNT(*) FROM fluid_specs WHERE generation_id=@gen AND fluid_type='coolant') AS coolant_rows;
