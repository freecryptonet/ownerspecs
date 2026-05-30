/**
 * Shared SEO metadata builder for gen + topic pages.
 *
 * Centralizes the openGraph / twitter / robots boilerplate so every
 * page emits per-page values instead of inheriting the site default —
 * which was making every shared link use the same generic OG image
 * and root URL.
 *
 * Competitors (auto-data.net, ultimatespecs.com) emit zero
 * structured data. Adding JSON-LD is our cheapest SEO leapfrog.
 */
import type { Metadata } from "next";

const SITE = "https://ownerspecs.com";

export function pageMetadata(opts: {
  title: string;
  description: string;
  path: string; // e.g. "/toyota/rav4-xa50-suv-2019-2021/oil-capacity"
  heroPath?: string | null; // e.g. "/images/toyota/rav4-xa50-suv-2019-2021/hero.jpg"
}): Metadata {
  const { title, description, path } = opts;
  const url = `${SITE}${path}`;
  const ogImage = opts.heroPath ? `${SITE}${opts.heroPath}` : `${SITE}/opengraph-image`;
  return {
    title,
    description,
    alternates: { canonical: path },
    openGraph: { type: "article", url, title, description, images: [ogImage] },
    twitter: { card: "summary_large_image", title, description, images: [ogImage] },
    robots: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  };
}

/** BreadcrumbList JSON-LD for a generation-scoped page. */
export function breadcrumbsJsonLd(opts: {
  brand: { slug: string; name: string };
  model: { slug: string; name: string };
  gen: { slug: string; display_name: string; start_year: number; end_year: number | null };
  topic?: { label: string; path: string };
}) {
  const { brand, model, gen, topic } = opts;
  const yrs = gen.end_year ? `${gen.start_year} – ${gen.end_year}` : `${gen.start_year} – present`;
  // Mirror the visible breadcrumb trail exactly (Catalogue / Brand / Model / Gen [/ Topic]).
  // The Model level is a real, statically-generated page (/{brand}/{model}); omitting it here
  // made the structured data disagree with the rendered crumb.
  const items = [
    { "@type": "ListItem", position: 1, name: "Catalogue", item: `${SITE}/` },
    { "@type": "ListItem", position: 2, name: brand.name, item: `${SITE}/${brand.slug}` },
    {
      "@type": "ListItem",
      position: 3,
      name: model.name,
      item: `${SITE}/${brand.slug}/${model.slug}`,
    },
    {
      "@type": "ListItem",
      position: 4,
      name: `${gen.display_name} ${yrs}`,
      item: `${SITE}/${brand.slug}/${gen.slug}`,
    },
  ];
  if (topic) {
    items.push({
      "@type": "ListItem",
      position: 5,
      name: topic.label,
      item: `${SITE}${topic.path}`,
    });
  }
  return {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: items,
  };
}

/** Build a Vehicle schema object for the generation hub page. */
export function vehicleJsonLd(opts: {
  brand: { slug: string; name: string };
  model: { name: string };
  gen: {
    slug: string;
    display_name: string;
    body_type: string;
    codename: string | null;
    start_year: number;
    end_year: number | null;
    fuel_tank_l?: string | number | null;
    cargo_l?: number | null;
  };
  heroPath?: string | null;
}) {
  const { brand, model, gen } = opts;
  return {
    "@context": "https://schema.org",
    "@type": "Vehicle",
    name: `${brand.name} ${gen.display_name}`,
    brand: { "@type": "Brand", name: brand.name },
    model: model.name,
    modelDate: gen.end_year ? `${gen.start_year}-${gen.end_year}` : `${gen.start_year}-present`,
    bodyType: gen.body_type,
    vehicleConfiguration: gen.codename ?? undefined,
    image: opts.heroPath ? `${SITE}${opts.heroPath}` : undefined,
    url: `${SITE}/${brand.slug}/${gen.slug}`,
    ...(gen.fuel_tank_l && {
      fuelCapacity: { "@type": "QuantitativeValue", value: Number(gen.fuel_tank_l), unitText: "L" },
    }),
    ...(gen.cargo_l && {
      cargoVolume: { "@type": "QuantitativeValue", value: gen.cargo_l, unitText: "L" },
    }),
  };
}

/** FAQPage JSON-LD for a topic page. Captures "People Also Ask" SERP boxes
 *  for question-format queries like "What is the oil capacity of ..." */
export function faqJsonLd(qa: Array<{ q: string; a: string }>) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: qa.map((p) => ({
      "@type": "Question",
      name: p.q,
      acceptedAnswer: {
        "@type": "Answer",
        text: p.a,
      },
    })),
  };
}

/** Dataset JSON-LD for an engine-comparison topic page (oil-capacity, coolant,
 *  torque, etc.). Signals to Google that the page is a structured table of
 *  per-engine values, eligible for Dataset rich-results / SERP table previews. */
export function datasetJsonLd(opts: {
  name: string;
  description: string;
  path: string;
  reviewDate: string;
  variables: Array<{ name: string; unitText?: string }>;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "Dataset",
    name: opts.name,
    description: opts.description,
    url: `${SITE}${opts.path}`,
    creator: { "@type": "Organization", name: "ownerspecs", url: SITE },
    publisher: { "@type": "Organization", name: "ownerspecs", url: SITE },
    license: "https://creativecommons.org/licenses/by-sa/4.0/",
    dateModified: opts.reviewDate,
    variableMeasured: opts.variables.map((v) => ({
      "@type": "PropertyValue",
      name: v.name,
      ...(v.unitText ? { unitText: v.unitText } : {}),
    })),
  };
}

/** A TechArticle schema for a single topic page (oil-capacity, etc.). */
export function techArticleJsonLd(opts: {
  title: string;
  description: string;
  path: string;
  heroPath?: string | null;
  reviewDate: string;
}) {
  return {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    headline: opts.title,
    description: opts.description,
    url: `${SITE}${opts.path}`,
    image: opts.heroPath ? `${SITE}${opts.heroPath}` : undefined,
    dateModified: opts.reviewDate,
    author: { "@type": "Organization", name: "ownerspecs", url: SITE },
    publisher: { "@type": "Organization", name: "ownerspecs", url: SITE },
  };
}
