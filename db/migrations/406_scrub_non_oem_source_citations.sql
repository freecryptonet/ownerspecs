-- mig 406: scrub non-OEM party names from PUBLIC (rendered) source citations + notes
--
-- EEAT / brand-integrity fix. Rendered citations must name OEM documentation ONLY — never
-- aggregators, parts retailers, oil brands, forums, or wikis. The per-brand oil-spec sources
-- (603-625) and a few others leaked their cross-verification parentheticals into the live
-- Sources block, e.g. "BMW factory oil specification (TIS via Pelican Parts + Blauparts +
-- Kroon-Oil cross-verification)" rendered verbatim on every BMW oil-capacity page.
--
-- The internal cross-verification trail stays intact in the is_public=0 source rows; this only
-- rewrites the PUBLIC-facing citation + notes text to OEM-only wording. No spec_sources links
-- change, so citation counts/badges are unaffected.
--
-- NOT touched here (judgment call left for Tim): the door-placard / battery-fitment rows that
-- say "(aggregated reference)" / "(non-OEM)" — 882,886,888,891,893,895,896,897,899. Those name
-- no third party but are honestly NOT OEM (PSI/battery pulled from an aggregator because the OM
-- defers to the placard). Relabelling them as OEM would fudge provenance. Decide separately:
-- reword to "manufacturer placard data", set is_public=0, or keep the honest label.

-- ---- citations: rewrite to OEM-only ----
UPDATE sources SET citation='Kia EV6 — manufacturer press specifications'                     WHERE id=594;
UPDATE sources SET citation='Toyota Tundra 2023 factory service specification'                WHERE id=601;
UPDATE sources SET citation='Ford F-150 (P702) factory service specification'                 WHERE id=602;
UPDATE sources SET citation='BMW factory engine-oil specification (TIS)'                       WHERE id=603;
UPDATE sources SET citation='Mercedes-Benz factory engine-oil specification'                  WHERE id=604;
UPDATE sources SET citation='Toyota/Lexus factory engine-oil specification'                   WHERE id=605;
UPDATE sources SET citation='Honda factory engine-oil specification'                          WHERE id=606;
UPDATE sources SET citation='Hyundai/Kia/Genesis factory engine-oil specification'            WHERE id=607;
UPDATE sources SET citation='Mazda/Subaru factory engine-oil specification'                   WHERE id=608;
UPDATE sources SET citation='VW Group factory engine-oil specification'                       WHERE id=609;
UPDATE sources SET citation='GM factory engine-oil specification'                             WHERE id=610;
UPDATE sources SET citation='Stellantis (FCA) factory engine-oil specification'               WHERE id=611;
UPDATE sources SET citation='Volvo factory engine-oil specification (Volvo Cars owner portal)' WHERE id=613;
UPDATE sources SET citation='Multi-OEM factory fluid specification'                           WHERE id=614;
UPDATE sources SET citation='Land Rover factory engine-oil specification (JLR TOPIx)'         WHERE id=617;
UPDATE sources SET citation='Mitsubishi factory engine-oil specification'                     WHERE id=619;
UPDATE sources SET citation='Nissan factory engine-oil specification'                         WHERE id=620;
UPDATE sources SET citation='Nissan factory engine-oil specification'                         WHERE id=621;
UPDATE sources SET citation='Ford/Lincoln factory engine-oil specification (Motorcraft)'      WHERE id=625;

-- ---- notes: rewrite to OEM-only (these render under the citation in the Sources block) ----
UPDATE sources SET notes='Cross-verified dimensions and fuel-tank capacity against manufacturer specifications.' WHERE id=592;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Toyota/Lexus service documentation.'  WHERE id=605;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Honda service documentation.'        WHERE id=606;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Hyundai/Kia/Genesis service documentation.' WHERE id=607;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Mazda/Subaru service documentation.' WHERE id=608;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from VW Group (Audi/VW/Škoda) service documentation.' WHERE id=609;
UPDATE sources SET notes='Per-engine factory oil capacities (with filter) from GM service documentation.'         WHERE id=610;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Stellantis (Mopar) service documentation.' WHERE id=611;
UPDATE sources SET notes='Per-engine factory oil capacity and viscosity from Volvo Cars service documentation.'   WHERE id=613;
