import type { Metadata } from "next";
import { query } from "@/lib/db";
import { FluidTopicPage, type FluidTopicConfig } from "@/components/FluidTopicPage";
import { getGenerationBase, getGenerationHero, yearRange } from "@/lib/generation";
import { pageMetadata } from "@/lib/seo";

type Params = { brand: string; generation: string };

const config: FluidTopicConfig = {
  slug: "differential-fluid",
  label: "Differential & AWD fluid",
  h1: "Differential, transfer-case & AWD fluid",
  fluidTypes: [
    "front_differential",
    "rear_differential",
    "transfer_case",
    "haldex_oil",
    "gear_reducer_front",
    "gear_reducer_rear",
  ],
  lede: ({ make, gen, yrs }) =>
    `OEM-spec differential, transfer-case, Haldex (AWD coupling) and reduction-gearbox fluids for the ${make} ${gen} (${yrs}). On AWD/4WD vehicles these are the most-skipped services and the most expensive failures — short interval, wrong viscosity, or wrong friction modifier all damage limited-slip clutch packs.`,
  buildFaq: ({ make, gen, yrs, all }) => {
    const out: Array<{ q: string; a: string }> = [];
    const rear = all.find((r) => r.fluid_type === "rear_differential");
    const front = all.find((r) => r.fluid_type === "front_differential");
    const tc = all.find((r) => r.fluid_type === "transfer_case");
    const haldex = all.find((r) => r.fluid_type === "haldex_oil");
    if (rear?.capacity_l) {
      out.push({
        q: `What is the rear differential fluid capacity for the ${make} ${gen}?`,
        a: `${Number(rear.capacity_l).toFixed(2)} L (${rear.capacity_qt ? Number(rear.capacity_qt).toFixed(2) : "—"} qt) ${rear.spec_standard ? `of ${rear.spec_standard}` : ""} on the ${make} ${gen} (${yrs}).${rear.notes ? ` ${rear.notes}` : ""}`,
      });
    }
    if (front?.spec_standard) {
      out.push({
        q: `What gear oil does the ${make} ${gen} front differential use?`,
        a: `${front.spec_standard} is the OEM-spec gear oil for the front diff on the ${make} ${gen} (${yrs})${front.capacity_l ? `. Capacity is ${Number(front.capacity_l).toFixed(2)} L` : ""}.`,
      });
    }
    if (tc?.spec_standard) {
      out.push({
        q: `What fluid does the transfer case on the ${make} ${gen} use?`,
        a: `${tc.spec_standard}${tc.capacity_l ? `, ${Number(tc.capacity_l).toFixed(2)} L capacity` : ""}. ${tc.notes ?? "4WD/AWD trims only."}`,
      });
    }
    if (haldex?.drain_interval_mi) {
      out.push({
        q: `How often does the Haldex AWD coupling need service on the ${make} ${gen}?`,
        a: `Every ${haldex.drain_interval_mi.toLocaleString()} miles (${haldex.drain_interval_km?.toLocaleString() ?? "—"} km). The Haldex coupling has a filter and an oil that wears at clutch-pack life rather than mileage, so severe-duty use halves the interval.`,
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
                   AND fluid_type IN ('front_differential','rear_differential','transfer_case','haldex_oil','gear_reducer_front','gear_reducer_rear'))`,
  );
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { brand, generation } = await params;
  const base = await getGenerationBase(brand, generation);
  if (!base) return { title: "Not found" };
  const yrs = yearRange(base.gen.start_year, base.gen.end_year);
  const heroPath = await getGenerationHero(base.gen.id);
  return pageMetadata({
    title: `${base.make.name} ${base.gen.display_name} ${yrs} — Differential & transfer-case fluid`,
    description: `OEM-spec gear oil grade and capacity for the front diff, rear diff, transfer case, Haldex/AWD coupling and reduction gearboxes on the ${base.gen.display_name} (${base.make.name}, ${yrs}).`,
    path: `/${base.make.slug}/${base.gen.slug}/differential-fluid`,
    heroPath,
  });
}

export default async function Page({ params }: { params: Promise<Params> }) {
  const { brand, generation } = await params;
  return <FluidTopicPage brand={brand} generation={generation} config={config} />;
}
