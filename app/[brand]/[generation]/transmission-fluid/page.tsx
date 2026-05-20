import type { Metadata } from "next";
import { query } from "@/lib/db";
import { FluidTopicPage, type FluidTopicConfig } from "@/components/FluidTopicPage";
import { getGenerationBase, getGenerationHero, yearRange } from "@/lib/generation";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

const config: FluidTopicConfig = {
  slug: "transmission-fluid",
  label: "Transmission fluid",
  h1: "Transmission fluid type & capacity",
  fluidTypes: [
    "transmission_at",
    "transmission_cvt",
    "transmission_ecvt",
    "transmission_dct",
    "transmission_mt",
  ],
  lede: ({ make, gen, yrs }) =>
    `OEM-spec transmission fluid grade, capacity, and recommended service interval for the ${make} ${gen} (${yrs}). Covers every gearbox variant available in this generation (automatic, CVT, eCVT, DCT/DSG, or manual where applicable).`,
  buildFaq: ({ make, gen, yrs, primary, all }) => {
    const out: Array<{ q: string; a: string }> = [];
    if (primary?.capacity_qt && primary?.capacity_l) {
      const where = primary.fluid_type === "transmission_cvt" ? "CVT"
        : primary.fluid_type === "transmission_ecvt" ? "hybrid eCVT"
        : primary.fluid_type === "transmission_dct" ? "DCT/DSG"
        : primary.fluid_type === "transmission_mt" ? "manual gearbox"
        : "automatic transmission";
      out.push({
        q: `What is the transmission fluid capacity for the ${make} ${gen}?`,
        a: `The ${make} ${gen} (${yrs}) ${where} holds ${Number(primary.capacity_qt).toFixed(2)} US qt (${Number(primary.capacity_l).toFixed(2)} L)${primary.spec_standard ? ` of ${primary.spec_standard}` : ""}. Drain-and-fill leaves about half this volume; a full flush requires the listed total.`,
      });
    }
    if (primary?.spec_standard) {
      out.push({
        q: `What transmission fluid type does the ${make} ${gen} use?`,
        a: `${primary.spec_standard} is the manufacturer-specified transmission fluid for the ${make} ${gen} (${yrs}). Using a non-spec fluid risks shift quality and clutch-pack durability.`,
      });
    }
    if (primary?.drain_interval_mi) {
      out.push({
        q: `How often should the transmission fluid be changed on the ${make} ${gen}?`,
        a: `The recommended service interval is ${primary.drain_interval_mi.toLocaleString()} miles (${primary.drain_interval_km?.toLocaleString() ?? "—"} km) for the ${make} ${gen} (${yrs}).${primary.notes ? ` ${primary.notes}` : ""}`,
      });
    }
    if (all.length > 1) {
      const types = [...new Set(all.map((r) => r.fluid_type))];
      out.push({
        q: `Are there different transmission options on the ${make} ${gen}?`,
        a: `Yes — this generation offers ${types.length} different transmission variant${types.length > 1 ? "s" : ""}: ${types.map((t) => ({
          transmission_at: "torque-converter automatic",
          transmission_cvt: "CVT",
          transmission_ecvt: "hybrid eCVT",
          transmission_dct: "DCT / DSG",
          transmission_mt: "manual",
        }[t] ?? t)).join(", ")}. Each takes a different fluid type and capacity — see the table.`,
      });
    }
    return out;
  },
};

export async function generateStaticParams(): Promise<Params[]> {
  return query<Params>(
    `SELECT mk.slug AS brand, g.slug AS generation
     FROM generations g
     JOIN models m ON m.id = g.model_id
     JOIN makes mk ON mk.id = m.make_id
     WHERE g.is_active = 1
       AND EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = g.id
                   AND fluid_type IN ('transmission_at','transmission_cvt','transmission_ecvt','transmission_dct','transmission_mt'))`,
  );
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Transmission fluid type & capacity`,
    description: `OEM-spec transmission fluid (ATF, CVT, eCVT, DCT, manual) capacity and grade for the ${base.gen.display_name} (${base.make.name}, ${yrs}). Service interval included.`,
    path: `/${base.make.slug}/${base.gen.slug}/transmission-fluid`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  return <FluidTopicPage brand={brand} generation={generation} config={config} />;
}
