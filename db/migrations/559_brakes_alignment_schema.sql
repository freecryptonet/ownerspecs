-- 559: Brakes & wheel-alignment spec tables (new moat page type).
-- HaynesPro Adjustment Data carries brake disc/drum dimensions, wear limits and
-- wheel-geometry (camber/caster/toe) that we extract alongside fluids/torques
-- but never stored. These two tables back the /[brand]/[generation]/brakes page.
--
-- Grain: gen-scoped, optional trim_id (sport packages run bigger discs) and
-- market_id (per the project nullable-override convention). Brake dimensions are
-- clean numerics; alignment values are faithfully stored as the manufacturer's
-- text (degrees + minutes + tolerance) since they don't reduce to a single decimal.

CREATE TABLE IF NOT EXISTS `brake_specs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `generation_id` int(10) unsigned NOT NULL,
  `trim_id` int(10) unsigned DEFAULT NULL,
  `market_id` smallint(5) unsigned DEFAULT NULL,
  `axle` varchar(8) NOT NULL,                          -- 'front' | 'rear'
  `brake_type` varchar(24) DEFAULT NULL,               -- 'disc_vented' | 'disc_solid' | 'drum'
  `disc_diameter_mm` decimal(5,1) DEFAULT NULL,        -- nominal disc diameter
  `disc_thickness_mm` decimal(4,1) DEFAULT NULL,       -- new disc thickness
  `disc_min_thickness_mm` decimal(4,1) DEFAULT NULL,   -- wear / machining limit
  `pad_min_mm` decimal(4,1) DEFAULT NULL,              -- minimum pad friction thickness
  `drum_diameter_mm` decimal(5,1) DEFAULT NULL,        -- drum brakes only
  `drum_max_mm` decimal(5,1) DEFAULT NULL,             -- drum max machining diameter
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_brake_specs_gen` (`generation_id`),
  KEY `fk_brake_specs_trim` (`trim_id`),
  KEY `fk_brake_specs_market` (`market_id`),
  CONSTRAINT `fk_brake_specs_generation` FOREIGN KEY (`generation_id`) REFERENCES `generations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_brake_specs_market` FOREIGN KEY (`market_id`) REFERENCES `markets` (`id`),
  CONSTRAINT `fk_brake_specs_trim` FOREIGN KEY (`trim_id`) REFERENCES `trims` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `alignment_specs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `generation_id` int(10) unsigned NOT NULL,
  `trim_id` int(10) unsigned DEFAULT NULL,
  `market_id` smallint(5) unsigned DEFAULT NULL,
  `axle` varchar(8) NOT NULL,                          -- 'front' | 'rear'
  `camber` varchar(48) DEFAULT NULL,                   -- e.g. "-0°35' ± 30'"
  `caster` varchar(48) DEFAULT NULL,                   -- front only, usually
  `toe` varchar(48) DEFAULT NULL,                      -- total or per-wheel as published
  `thrust_angle` varchar(48) DEFAULT NULL,             -- rear, optional
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_alignment_specs_gen` (`generation_id`),
  KEY `fk_alignment_specs_trim` (`trim_id`),
  KEY `fk_alignment_specs_market` (`market_id`),
  CONSTRAINT `fk_alignment_specs_generation` FOREIGN KEY (`generation_id`) REFERENCES `generations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_alignment_specs_market` FOREIGN KEY (`market_id`) REFERENCES `markets` (`id`),
  CONSTRAINT `fk_alignment_specs_trim` FOREIGN KEY (`trim_id`) REFERENCES `trims` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
