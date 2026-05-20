import type { Metadata } from "next";
import { query } from "@/lib/db";
import { FluidTopicPage, type FluidTopicConfig } from "@/components/FluidTopicPage";
import { getGenerationBase, getGenerationHero, yearRange } from "@/lib/generation";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

const config: FluidTopicConfig = {
  slug: "coolant",
  label: "Coolant",
  h1: "Coolant type, capacity & service interval",
  fluidTypes: ["coolant"],
  lede: ({ make, gen, yrs }) =>
    `OEM-spec engine coolant capacity, exact chemistry/colour, and service interval for the ${make} ${gen} (${yrs}). Mixing incompatible coolants (e.g. OAT with IAT) can lift sealing gaskets and trigger heater-core leaks — match the OEM spec.`,
  buildFaq: ({ make, gen, yrs, primary }) => {
    const out: Array<{ q: string; a: string }> = [];
    if (primary?.capacity_qt && primary?.capacity_l) {
      out.push({
        q: `What is the coolant capacity of the ${make} ${gen}?`,
        a: `Total coolant system capacity for the ${make} ${gen} (${yrs}) is ${Number(primary.capacity_qt).toFixed(2)} US qt (${Number(primary.capacity_l).toFixed(2)} L). A drain-and-fill typically recovers ~60% of this; a full flush is needed for the rest.`,
      });
    }
    if (primary?.spec_standard) {
      out.push({
        q: `What coolant does the ${make} ${gen} use?`,
        a: `${primary.spec_standard} is the OEM-specified coolant for the ${make} ${gen} (${yrs}). Do not mix with a different chemistry — this can damage sealing surfaces and the water-pump impeller over time.`,
      });
    }
    if (primary?.drain_interval_mi) {
      out.push({
        q: `How often does the coolant need to be changed on the ${make} ${gen}?`,
        a: `The recommended initial change is at ${primary.drain_interval_mi.toLocaleString()} miles (${primary.drain_interval_km?.toLocaleString() ?? "—"} km).${primary.notes ? ` ${primary.notes}` : ""}`,
      });
    }
    if (primary?.notes && /lifetime/i.test(primary.notes)) {
      out.push({
        q: `Is the coolant in the ${make} ${gen} really lifetime fill?`,
        a: `The OEM labels it lifetime, but specific gravity drops below the acceptable threshold around 100k mi / 6 yr on most engines. Test with a refractometer; flush if specific gravity is below the manufacturer minimum or if the colour has turned brown/cloudy.`,
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
       AND EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = g.id AND fluid_type = 'coolant')`,
  );
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Coolant capacity & type`,
    description: `OEM-spec coolant capacity, chemistry, colour, and service interval for the ${base.gen.display_name} (${base.make.name}, ${yrs}).`,
    path: `/${base.make.slug}/${base.gen.slug}/coolant`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  return <FluidTopicPage brand={brand} generation={generation} config={config} />;
}
