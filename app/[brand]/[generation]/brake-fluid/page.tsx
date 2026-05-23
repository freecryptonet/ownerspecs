import type { Metadata } from "next";
import { query } from "@/lib/db";
import { FluidTopicPage, type FluidTopicConfig } from "@/components/FluidTopicPage";
import { getGenerationBase, getGenerationHero, yearRange } from "@/lib/generation";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

const config: FluidTopicConfig = {
  slug: "brake-fluid",
  label: "Brake fluid",
  h1: "Brake fluid type & service interval",
  fluidTypes: ["brake_fluid"],
  lede: ({ make, gen, yrs }) =>
    `OEM-spec brake fluid grade (DOT 3 / DOT 4 / DOT 4 LV / DOT 5.1) and service interval for the ${make} ${gen} (${yrs}). Brake fluid is hygroscopic — water content above ~3% drops the boiling point enough to cause pedal fade under heavy braking.`,
  buildFaq: ({ make, gen, yrs, primary }) => {
    const out: Array<{ q: string; a: string }> = [];
    if (primary?.viscosity || primary?.spec_standard) {
      out.push({
        q: `What brake fluid does the ${make} ${gen} use?`,
        a: `The ${make} ${gen} (${yrs}) uses ${primary?.viscosity ?? "DOT 3"} brake fluid${primary?.spec_standard ? ` — specifically ${primary.spec_standard}` : ""}. Using a lower-spec fluid is unsafe; a higher-spec fluid is acceptable if the dry/wet boiling points meet or exceed OEM minimums.`,
      });
    }
    if (primary?.drain_interval_months) {
      out.push({
        q: `How often should the brake fluid be flushed on the ${make} ${gen}?`,
        a: `Every ${primary.drain_interval_months} months, regardless of mileage. Brake fluid absorbs water from the air through caliper seals; once water content exceeds ~3% the wet boiling point drops below 300°F / 150°C and the pedal fades during aggressive braking.${primary.notes ? ` ${primary.notes}` : ""}`,
      });
    }
    out.push({
      q: `Can I mix DOT 3 and DOT 4 brake fluid in the ${make} ${gen}?`,
      a: `Yes — DOT 3 and DOT 4 are glycol-based and chemically miscible. DOT 4 has a higher boiling point so it's the safer upgrade. NEVER mix with DOT 5 (silicone) — that will damage seals and ABS solenoids.`,
    });
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
       AND EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = g.id AND fluid_type = 'brake_fluid')`,
  );
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Brake fluid type & flush interval`,
    description: `OEM-spec brake fluid grade and replacement interval for the ${base.gen.display_name} (${base.make.name}, ${yrs}).`,
    path: `/${base.make.slug}/${base.gen.slug}/brake-fluid`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  return <FluidTopicPage brand={brand} generation={generation} config={config} />;
}
