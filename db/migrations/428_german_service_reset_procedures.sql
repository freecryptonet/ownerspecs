-- mig 428: German service-reset procedures for gens that had ZERO procedures.
-- BMW Condition Based Service reset / Audi service-interval reset / Mercedes ASSYST reset.
-- Reset method is tied to the HMI generation (iDrive / MMI-cluster / ASSYST), which is shared
-- brand-wide, so one canonical restated procedure per brand is accurate across its chassis
-- (this is NOT chassis-specific data like torques/capacities). Each row gets a gen-specific lead
-- line + two brand-level citations. Original wording (no vendor prose copied); vendor never named.

-- ---------- brand-level sources (text-only, vendor-neutral) ----------
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'owner_manual','BMW Owner''s Manual — Condition Based Service & reset',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='BMW Owner''s Manual — Condition Based Service & reset');
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'service_manual','BMW Service Information — maintenance & service-reset',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='BMW Service Information — maintenance & service-reset');
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'owner_manual','Audi Owner''s Manual — servicing & service interval',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Audi Owner''s Manual — servicing & service interval');
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'service_manual','Audi Service Information — maintenance & service-reset',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Audi Service Information — maintenance & service-reset');
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'owner_manual','Mercedes-Benz Owner''s Manual — ASSYST service system',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mercedes-Benz Owner''s Manual — ASSYST service system');
INSERT INTO sources (type,citation,is_public,public_link,retrieved_at)
  SELECT 'service_manual','Mercedes-Benz Service Information — maintenance & service-reset',1,0,NOW()
  WHERE NOT EXISTS (SELECT 1 FROM sources WHERE citation='Mercedes-Benz Service Information — maintenance & service-reset');

SET @bmw_om := (SELECT id FROM sources WHERE citation='BMW Owner''s Manual — Condition Based Service & reset');
SET @bmw_si := (SELECT id FROM sources WHERE citation='BMW Service Information — maintenance & service-reset');
SET @aud_om := (SELECT id FROM sources WHERE citation='Audi Owner''s Manual — servicing & service interval');
SET @aud_si := (SELECT id FROM sources WHERE citation='Audi Service Information — maintenance & service-reset');
SET @mb_om  := (SELECT id FROM sources WHERE citation='Mercedes-Benz Owner''s Manual — ASSYST service system');
SET @mb_si  := (SELECT id FROM sources WHERE citation='Mercedes-Benz Service Information — maintenance & service-reset');

-- ---------- target gens (zero procedures), captured before we insert ----------
CREATE TEMPORARY TABLE _tgt (gen INT PRIMARY KEY, brand VARCHAR(24));
INSERT INTO _tgt (gen,brand)
  SELECT g.id, mk.name
  FROM generations g JOIN models m ON m.id=g.model_id JOIN makes mk ON mk.id=m.make_id
  WHERE mk.name IN ('BMW','Audi','Mercedes-Benz') AND g.is_active=1
    AND g.id NOT IN (SELECT generation_id FROM procedures);

-- ===================== BMW — Condition Based Service reset =====================
INSERT INTO procedures (generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes)
SELECT g.id,'cbs_reset','cbs-reset',
  CONCAT('Condition Based Service (CBS) reset — ', m.name, ' (', COALESCE(g.codename,''), ')'),
  CONCAT('The ', m.name, ' (', COALESCE(g.codename,''),
') uses BMW Condition Based Service (CBS). Each maintenance item is tracked separately — brake fluid, front and rear brake pads, microfilter/cabin filter, the vehicle check, and on combustion models the engine oil (plus spark plugs and the statutory emissions/roadworthiness check where applicable). Every item has its own service counter, and the instrument cluster shows a *Service Required* message as a counter runs down. The car cannot tell that the work was carried out, so after a service the matching counter must be reset by hand.

**Reset using the iDrive / cluster menu (cars with a central display)**
1. Press Start/Stop once *without* touching the brake to switch the ignition on — do not start the engine.
2. Open the service list (iDrive: *Vehicle Status -> Service Required*; on cars without the menu, scroll to the item with the trip/BC button).
3. Select the item you serviced and confirm the prompt to restore its full interval. Repeat for each item replaced.

**Reset using the trip/BC button (no menu, or as a fallback)**
1. With the engine off, press and hold the trip-reset (BC) button, then switch the ignition on while keeping it held.
2. Hold until the serviced item and a reset symbol appear; release, then press briefly to confirm.
3. Move to the next item if more than one job was done.

Each counter is independent — resetting *Engine oil* does not reset *Brake fluid*. Confirm the cluster shows the restored interval before switching off.'),
  'In-car only — iDrive controller / cluster menu, or the trip-reset (BC) button. No diagnostic tooling needed for the in-car reset.',
  'Resetting a counter before the work is actually finished. Resetting the wrong item (e.g. Engine oil instead of Brake fluid). After a major service, forgetting that each CBS item has its own counter and leaving some un-reset. Expecting CBS to track aftermarket pads or fluids accurately.'
FROM _tgt t JOIN generations g ON g.id=t.gen JOIN models m ON m.id=g.model_id
WHERE t.brand='BMW';

-- ===================== Audi — service-interval reset =====================
INSERT INTO procedures (generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes)
SELECT g.id,'service_reminder_reset','service-interval-reset',
  CONCAT('Service interval reset — ', m.name, ' (', COALESCE(g.codename,''), ')'),
  CONCAT('The ', m.name, ' (', COALESCE(g.codename,''),
') stores its service schedule as either a fixed (time/distance) or flexible (LongLife) interval in the instrument cluster. When an interval is reached the driver display shows a spanner/service icon with the distance remaining or overdue. After a service the interval has to be reset manually.

**Reset via the cluster menu (driver information system / MMI-linked clusters)**
1. Switch the ignition on without starting the engine.
2. Open the cluster menu and go to *Servicing & checks* (or *Service*) using the steering-wheel buttons or the wiper-stalk menu control.
3. Select the service item (e.g. *Oil change service* or *Inspection*) and confirm *Reset now*.

**Reset via the button method (older clusters without a menu)**
1. With the ignition off, press and hold the trip-reset (0.0) button on the cluster.
2. Switch the ignition on while still holding — *Service* or *! Service* appears.
3. Release, then turn the clock/minute knob (or lift the right stalk) to clear the display and confirm.

On LongLife (flexible) servicing the reset also depends on correct service data being stored; if the wrong interval type is set, the next reminder can appear too early or too late.'),
  'In-car only — steering-wheel/cluster controls or the trip-reset button. No tools required for the standard interval reset.',
  'Resetting before the oil-change or inspection service is complete. Confusing the fixed and flexible (LongLife) schemes — resetting under the wrong one skews the next due date. On LongLife cars, filling non-LongLife oil while leaving the flexible schedule active.'
FROM _tgt t JOIN generations g ON g.id=t.gen JOIN models m ON m.id=g.model_id
WHERE t.brand='Audi';

-- ===================== Mercedes-Benz — ASSYST service reset =====================
INSERT INTO procedures (generation_id,procedure_type,slug,title,body_md,tools_required,common_mistakes)
SELECT g.id,'service_reminder_reset','assyst-service-reset',
  CONCAT('ASSYST service reset — ', m.name, ' (', COALESCE(g.codename,''), ')'),
  CONCAT('The ', m.name, ' (', COALESCE(g.codename,''),
') uses the Mercedes-Benz ASSYST / ASSYST PLUS flexible service system. The car works out the next service from mileage, elapsed time and operating conditions, and shows a wrench symbol with the days or distance remaining as the date approaches. After a service the indicator is reset from the instrument cluster.

**Reset via the steering-wheel buttons (ASSYST PLUS, multifunction cluster)**
1. Switch the ignition on without starting; use the steering-wheel buttons to select the trip/service display.
2. Open *Service* in the menu and choose *Full service* / *Confirm service* for the work carried out.
3. Confirm *Yes* to reset — the cluster then shows the new interval.

**Reset via the combination switch (older ASSYST clusters)**
1. Switch the ignition on and, within a few seconds, press the cluster scroll/*R* button to bring up the service display, then press and hold.
2. Hold until the system asks you to confirm the service reset, then release and confirm.

Because ASSYST is condition-based, an incorrect reset (or resetting jobs the system did not expect) can leave the next service date wrong; confirm the displayed interval afterwards.'),
  'In-car only — steering-wheel multifunction buttons or the cluster combination switch. No diagnostic tester needed for the standard ASSYST reset.',
  'Resetting before the service is finished. Selecting the wrong service scope. On ASSYST PLUS, assuming a full reset when only a partial service was done. Assuming a battery disconnect clears the counter — it does not reset the ASSYST schedule.'
FROM _tgt t JOIN generations g ON g.id=t.gen JOIN models m ON m.id=g.model_id
WHERE t.brand='Mercedes-Benz';

-- ---------- citations: two brand-level sources per new procedure ----------
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@bmw_om FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='BMW' AND p.slug='cbs-reset';
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@bmw_si FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='BMW' AND p.slug='cbs-reset';
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@aud_om FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='Audi' AND p.slug='service-interval-reset';
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@aud_si FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='Audi' AND p.slug='service-interval-reset';
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@mb_om FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='Mercedes-Benz' AND p.slug='assyst-service-reset';
INSERT IGNORE INTO spec_sources (spec_table,spec_id,source_id)
SELECT 'procedures',p.id,@mb_si FROM procedures p JOIN _tgt t ON t.gen=p.generation_id WHERE t.brand='Mercedes-Benz' AND p.slug='assyst-service-reset';

DROP TEMPORARY TABLE _tgt;
