-- mig 403: scrub vendor/sibling names from source citations + notes (rendered columns).
-- migs 400/401/402 leaked "HaynesPro" (in notes 896/897) and "Alfa Romeo Tonale" (citation
-- 898) into rendered output, violating the never-name-vendor rule. Replace with neutral text.

UPDATE sources SET notes =
  'Battery group/CCA, cold tyre placard pressures, and general HEMI service torques. NOT OEM documentation: the factory owner manual defers these to the door-jamb placard or does not print them, so they are compiled from third-party battery-fitment and tire-pressure references. Provenance flagged for audit.'
  WHERE id = 896;

UPDATE sources SET notes =
  'Battery group/CCA, cold tyre placard pressures, and generic service torques. NOT OEM documentation: the factory owner manual defers these to the door-jamb placard or does not print them, so they are compiled from third-party battery-fitment and tire-pressure references. Provenance flagged for audit.'
  WHERE id = 897;

UPDATE sources SET
  citation = 'Dodge Hornet workshop service specifications (shared platform)',
  notes = 'Workshop-grade service data for the shared platform underpinning the Hornet (cold tyre pressures + sizes, alternator torque, 1.3L spark-plug gap). Vendor-neutral per house policy.'
  WHERE id = 898;
