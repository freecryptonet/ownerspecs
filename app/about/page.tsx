import Link from "next/link";
import { pageMetadata } from "@/lib/seo";
import { SiteHeader } from "@/components/SiteHeader";
import { SiteFooter } from "@/components/SiteFooter";

export const metadata = pageMetadata({
  title: "About ownerspecs",
  description:
    "ownerspecs publishes cross-verified, owner-manual-derived vehicle specifications — fluid capacities, torque values, fuse layouts, bulb codes, maintenance intervals and service procedures — for every generation, every market.",
  path: "/about",
});

export default function AboutPage() {
  return (
    <>
      <SiteHeader />
      <div className="shell guide-shell">
        <nav className="crumb">
          <Link href="/">Catalogue</Link>
          <span className="sep">/</span>
          <span>About</span>
        </nav>
        <header className="pagehead">
          <h1>About ownerspecs</h1>
          <p className="sub">
            A reference for the practical vehicle data owners and mechanics
            actually need — and a clear record of where every number comes from.
          </p>
        </header>
        <article className="prose-body">
          <h2>What we publish</h2>
          <p>
            Most spec sites stop at horsepower and 0–100 times. ownerspecs
            focuses on the data you reach for when you actually work on a car:
            fluid capacities and OEM-approved grades, tightening torques, fuse
            and relay layouts, bulb codes, maintenance schedules, tyre pressures,
            and step-by-step service-reset procedures — organised per
            generation, because a 2016 car and a 2022 car of the same name often
            take different fluids and parts.
          </p>
          <h2>How we work</h2>
          <p>
            Every value is restated in our own words and tabulations from
            primary sources (OEM owner manuals and workshop service data), and
            cross-checked where a second source is available. We publish facts,
            never copyrighted text or diagrams. The full approach — sourcing
            hierarchy, verification, and the legal basis — is documented on our{" "}
            <Link href="/methodology">methodology page</Link>, and every page
            lists the sources behind its data.
          </p>
          <h2>Independence &amp; funding</h2>
          <p>
            ownerspecs is an independent project. The site may display
            third-party advertising to cover hosting and data costs; advertising
            never influences the spec data we publish.
          </p>
          <h2>Sister sites</h2>
          <p>
            ownerspecs is part of a small family of independent automotive
            references:{" "}
            <a href="https://autodtcs.com">autodtcs.com</a> (diagnostic trouble
            codes), <a href="https://servicereset.net">servicereset.net</a>{" "}
            (service-reset &amp; calibration how-tos), and{" "}
            <a href="https://vindecoder.site">vindecoder.site</a> (VIN &amp;
            recall lookups).
          </p>
          <h2>Contact</h2>
          <p>
            Questions, corrections or partnership enquiries:{" "}
            <Link href="/contact">get in touch</Link>.
          </p>
        </article>
      </div>
      <SiteFooter />
    </>
  );
}
