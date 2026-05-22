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
};
const GEN_SPLITS: GenSplit[] = [
  // example pending data:
  // { brand: "bmw", oldSlug: "3-series-f30-sedan-2012-2018",
  //   primarySlug: "3-series-f30-lci-sedan-2015-2019" },
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
      // 2) any sub-page (topic or trim) — catch-all with parameter pass-through
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
