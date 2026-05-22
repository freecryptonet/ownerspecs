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
    return out;
  },
};

export default nextConfig;
