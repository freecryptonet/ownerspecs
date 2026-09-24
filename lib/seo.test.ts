import { describe, it, expect } from "vitest";
import { vehicleMassJsonLd } from "./seo";

describe("vehicleMassJsonLd", () => {
  it("emits a schema.org Vehicle fragment with a weight QuantitativeValue in kg", () => {
    const ld = vehicleMassJsonLd({ path: "/kia/rio-yb-hatchback-2018-2023/towing", massKg: 1160, reviewDate: "2026-09-24" });
    expect(ld["@type"]).toBe("Vehicle");
    expect(ld.weight).toEqual({ "@type": "QuantitativeValue", value: 1160, unitCode: "KGM" });
    expect(ld.url).toBe("https://ownerspecs.com/kia/rio-yb-hatchback-2018-2023/towing");
    expect(ld.dateModified).toBe("2026-09-24");
  });
});
