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
  const ogImage = opts.heroPath ? `${SITE}${opts.heroPath}` : `${SITE}/og.png`;
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
  const items = [
    { "@type": "ListItem", position: 1, name: "Catalogue", item: `${SITE}/` },
    { "@type": "ListItem", position: 2, name: brand.name, item: `${SITE}/${brand.slug}` },
    {
      "@type": "ListItem",
      position: 3,
      name: `${model.name} ${gen.display_name} ${yrs}`,
      item: `${SITE}/${brand.slug}/${gen.slug}`,
    },
  ];
  if (topic) {
    items.push({
      "@type": "ListItem",
      position: 4,
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
