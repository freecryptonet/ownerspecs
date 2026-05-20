import type { Metadata } from "next";
import { query } from "@/lib/db";
import { FluidTopicPage, type FluidTopicConfig } from "@/components/FluidTopicPage";
import { getGenerationBase, getGenerationHero, yearRange } from "@/lib/generation";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

const config: FluidTopicConfig = {
  slug: "ac-refrigerant",
  label: "A/C refrigerant",
  h1: "A/C refrigerant type & charge",
  fluidTypes: ["ac_refrigerant"],
  lede: ({ make, gen, yrs }) =>
    `OEM-spec A/C refrigerant (R-134a or R-1234yf) and charge weight for the ${make} ${gen} (${yrs}). R-1234yf became mandatory in the US in 2017 and EU in 2017 — older same-platform cars can still legally use R-134a but the two are NOT interchangeable.`,
  buildFaq: ({ make, gen, yrs, primary }) => {
    const out: Array<{ q: string; a: string }> = [];
    if (primary?.capacity_l) {
      const grams = Math.round(Number(primary.capacity_l) * 1000);
      out.push({
        q: `How much A/C refrigerant does the ${make} ${gen} hold?`,
        a: `The factory A/C charge is ${grams} ±25 g (${Number(primary.capacity_l).toFixed(2)} L equivalent) for the ${make} ${gen} (${yrs}). Always recharge by weight (use scales), never by sight-glass or pressure.`,
      });
    }
    if (primary?.spec_standard) {
      out.push({
        q: `Does the ${make} ${gen} use R-134a or R-1234yf?`,
        a: `${primary.spec_standard} is the OEM refrigerant for the ${make} ${gen} (${yrs}). R-1234yf and R-134a are NOT interchangeable — they use different schrader fittings, different PAG oil grades, and mixing them voids EU/US refrigerant containment compliance.${primary.notes ? ` ${primary.notes}` : ""}`,
      });
    }
    out.push({
      q: `Can I use R-1234yf instead of R-134a in the ${make} ${gen}?`,
      a: `Only if the system was factory-charged with R-1234yf. The two refrigerants use incompatible service-port fittings and different lubricants. Retrofitting an older R-134a system to R-1234yf requires changing every O-ring, the PAG oil, and the desiccant bag — usually not cost-effective.`,
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
       AND EXISTS (SELECT 1 FROM fluid_specs WHERE generation_id = g.id AND fluid_type = 'ac_refrigerant')`,
  );
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — A/C refrigerant type & charge`,
    description: `OEM-spec A/C refrigerant (R-1234yf or R-134a) and charge weight for the ${base.gen.display_name} (${base.make.name}, ${yrs}). PAG oil grade included.`,
    path: `/${base.make.slug}/${base.gen.slug}/ac-refrigerant`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  return <FluidTopicPage brand={brand} generation={generation} config={config} />;
}
