-- mig 482: remove the "Mopar full-flow" oil-filter rows (ids 865, 870). The
-- part_number held a description ("Mopar full-flow"), not an OE number, and the
-- rows were gen-wide (engine_id NULL) on the Charger LX / 300 LX gens which mix
-- V6 (EER/EGG) and V8 (ESF/EZB) engines that use DIFFERENT oil filters — so a
-- single gen-wide filter is wrong regardless. Removing the placeholder; a real
-- per-engine Mopar PN can be added later with proper sourcing.
DELETE FROM spec_sources WHERE spec_table='parts' AND spec_id IN (865,870);
DELETE FROM parts WHERE id IN (865,870) AND part_number='Mopar full-flow';
