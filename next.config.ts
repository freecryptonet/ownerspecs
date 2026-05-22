import type { NextConfig } from "next";

// Generation-split redirects per herstructureringsplan Fase 1.1. When a combined
// gen slug (e.g. "3-series-f30-sedan-2012-2018") is later split into pre-LCI +
// LCI (or any other meaningful sub-generation), the old URL must 301 to the
// canonical primary half so accumulated link equity carries over.
//
// Each entry maps an old (brand, gen-slug) tuple to the gen-slug that the visitor
// should land on. The match also applies to the deep sub-pages:
//   /{brand}/{old}/oil-capacity → /{brand}/{primary}/oil-capacity
//   /{brand}/{old}/{trim} → /{brand}/{primary}/{trim}  (trim slugs survive a split
//     because trim_slug is unique within a generation; trims that lived only in
//     pre-LCI vs LCI need explicit overrides — add a `trimOverrides` map when
//     that comes up).
//
// Keep this list short and audited. Adding a redirect without checking that
// the destination gen exists will break URLs in production.
type GenSplit = {
  brand: string;
  oldSlug: string;
  primarySlug: string;
  // Per-trim overrides for trims that moved to a different new gen than
  // the primary. Keyed by old trim slug, value is the destination gen slug.
  // Used when an old combined-gen URL needs to land on the non-primary new
  // gen because that's where the trim lives now.
  trimOverrides?: Record<string, string>;
};
const GEN_SPLITS: GenSplit[] = [
  // G20 sedan split into pre-LCI (2019-2022) + LCI (2022-present) — mig 169.
  // The old combined slug used "present" as the end-year sentinel. After the
  // split the original gen was renamed to end in 2022; the LCI gen took the
  // "present" suffix. Trims were cloned from pre-LCI to LCI, so any trim
  // slug from the old combined gen resolves on the LCI half too — no
  // per-trim overrides needed.
  {
    brand: "bmw",
    oldSlug: "3-series-sedan-g20-2019-present",
    primarySlug: "3-series-sedan-g20-lci-2022-present",
  },

  // G30 sedan split into pre-LCI (2017-2020) + LCI (2020-2023) — mig 172.
  // Same pattern as G20; full trim clone means no overrides needed.
  {
    brand: "bmw",
    oldSlug: "5-series-g30-sedan-2017-present",
    primarySlug: "5-series-g30-lci-sedan-2020-2023",
  },

  // A6 C8 sedan slug shortened from 2018-present → 2018-2023 + LCI sedan
  // added — mig 195. Pre-LCI sedan trims cloned to LCI sedan, so trim
  // URLs land on real data either way; redirect to LCI as the SEO-current
  // primary.
  {
    brand: "audi",
    oldSlug: "a6-c8-sedan-2018-present",
    primarySlug: "a6-c8-lci-sedan-2023-present",
  },

  // F30 sedan split into pre-LCI (2012-2015) + LCI (2015-2018) — mig 161.
  // Primary destination is LCI (newer, more SEO-current "F30" search intent).
  // Per-trim overrides redirect pre-LCI trim URLs to the pre-LCI gen
  // because those trims moved with the original gen row when it was renamed.
  {
    brand: "bmw",
    oldSlug: "3-series-f30-sedan-2012-2018",
    primarySlug: "3-series-f30-lci-sedan-2015-2018",
    trimOverrides: {
      // 5 original 335i / ActiveHybrid trims (N55, pre-LCI only)
      "335i-306-hp":                       "3-series-f30-sedan-2012-2015",
      "335i-306-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "335i-306-hp-xdrive":                "3-series-f30-sedan-2012-2015",
      "335i-306-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      "activehybrid-3-0-340-hp-steptronic":"3-series-f30-sedan-2012-2015",
      // 19 pre-LCI trims added in mig 152 (N20 / N13 / N47 / N57)
      "316i-136-hp":                       "3-series-f30-sedan-2012-2015",
      "316i-136-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "320i-184-hp":                       "3-series-f30-sedan-2012-2015",
      "320i-184-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "320i-184-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      "328i-245-hp":                       "3-series-f30-sedan-2012-2015",
      "328i-245-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "328i-245-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      "316d-116-hp":                       "3-series-f30-sedan-2012-2015",
      "316d-116-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "318d-143-hp":                       "3-series-f30-sedan-2012-2015",
      "318d-143-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "320d-184-hp":                       "3-series-f30-sedan-2012-2015",
      "320d-184-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "320d-184-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      "325d-218-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "330d-258-hp-steptronic":            "3-series-f30-sedan-2012-2015",
      "330d-258-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      "335d-313-hp-xdrive-steptronic":     "3-series-f30-sedan-2012-2015",
      // 14 LCI trims (mig 153) are NOT in this map — they fall through to
      // the primary (LCI) destination via the catch-all rule.
    },
  },
];

// Trim-level redirects for when a trim row gets renamed (typically during a
// refactor that aligns a gen's trims with the powertrain-distinct convention
// locked in STRUCTURE.md / herstructureringsplan). Each entry 301s the old
// trim URL to the new one so accumulated link equity carries over.
//
// Use sparingly — only when the old slug shipped to production and may have
// been indexed by search engines or linked externally. New gens added under
// the powertrain-distinct convention from the start don't need these.
type TrimRedirect = {
  brand: string;
  gen: string;
  oldTrim: string;
  newTrim: string;
};
const TRIM_REDIRECTS: TrimRedirect[] = [
  // Camry XV70 marketing-trim → powertrain-distinct refactor (migration 155).
  // LE / XLE / SE all share the A25A-FKS 4-cyl 203 hp 8-AT FWD powertrain;
  // they fold into one row. LE Hybrid → hybrid row. XSE V6 → V6 row.
  { brand: "toyota", gen: "camry-xv70-2018-2024", oldTrim: "le",        newTrim: "2-5-203-hp-automatic" },
  { brand: "toyota", gen: "camry-xv70-2018-2024", oldTrim: "xle",       newTrim: "2-5-203-hp-automatic" },
  { brand: "toyota", gen: "camry-xv70-2018-2024", oldTrim: "se",        newTrim: "2-5-203-hp-automatic" },
  { brand: "toyota", gen: "camry-xv70-2018-2024", oldTrim: "le-hybrid", newTrim: "2-5-208-hp-hybrid-e-cvt" },
  { brand: "toyota", gen: "camry-xv70-2018-2024", oldTrim: "xse-v6",    newTrim: "3-5-v6-301-hp-automatic" },
  // RAV4 XA50 AWD NA HP correction (migration 157). Old row had hp=200
  // (off by 3 from Toyota's official 203 hp on the A25A-FKS).
  { brand: "toyota", gen: "rav4-xa50-suv-2019-2021", oldTrim: "2-5-200-hp-awd-automatic", newTrim: "2-5-203-hp-awd-automatic" },
];

const nextConfig: NextConfig = {
  async redirects() {
    const out: Array<{ source: string; destination: string; permanent: true }> = [];
    for (const s of GEN_SPLITS) {
      // 1) overview page
      out.push({
        source: `/${s.brand}/${s.oldSlug}`,
        destination: `/${s.brand}/${s.primarySlug}`,
        permanent: true,
      });
      // 2) per-trim overrides — must come BEFORE the catch-all so they
      //    take precedence in Next.js's first-match-wins ordering.
      if (s.trimOverrides) {
        for (const [oldTrim, destGen] of Object.entries(s.trimOverrides)) {
          out.push({
            source: `/${s.brand}/${s.oldSlug}/${oldTrim}`,
            destination: `/${s.brand}/${destGen}/${oldTrim}`,
            permanent: true,
          });
        }
      }
      // 3) catch-all for everything else (topic pages + non-overridden trims)
      out.push({
        source: `/${s.brand}/${s.oldSlug}/:rest*`,
        destination: `/${s.brand}/${s.primarySlug}/:rest*`,
        permanent: true,
      });
    }
    for (const t of TRIM_REDIRECTS) {
      out.push({
        source: `/${t.brand}/${t.gen}/${t.oldTrim}`,
        destination: `/${t.brand}/${t.gen}/${t.newTrim}`,
        permanent: true,
      });
    }
    return out;
  },
};

export default nextConfig;
