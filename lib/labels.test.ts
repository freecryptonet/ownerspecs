import { describe, it, expect } from "vitest";
import { massKindLabel, massKindCategory } from "./labels";

describe("massKindLabel", () => {
  it("labels the real mass_homologations vocabulary", () => {
    expect(massKindLabel("running_order")).toBe("Mass in running order (EU type-approval)");
    expect(massKindLabel("tow_braked")).toMatch(/braked trailer/i);
    expect(massKindLabel("tow_unbraked")).toMatch(/unbraked trailer/i);
    expect(massKindLabel("max_axle")).toMatch(/axle/i);
  });

  it("falls back to humanize() for an unmapped kind", () => {
    // NOTE: humanize() title-cases every word (verified against its actual
    // implementation, not its doc comment) — "Some New Kind", not "Some new
    // kind". Deviation from the plan's literal expected value; humanize()
    // is shared sitewide by every other *Label fallback so it is not
    // changed here (see plan5-task1-3-report.md).
    expect(massKindLabel("some_new_kind")).toBe("Some New Kind");
  });
});

describe("massKindCategory", () => {
  it("classifies running_order as headline", () => {
    expect(massKindCategory("running_order")).toBe("headline");
  });

  it("classifies towing/axle/combination as supporting", () => {
    expect(massKindCategory("tow_braked")).toBe("supporting");
    expect(massKindCategory("tow_unbraked")).toBe("supporting");
    expect(massKindCategory("max_axle")).toBe("supporting");
    expect(massKindCategory("max_combination")).toBe("supporting");
    expect(massKindCategory("max_laden_permissible")).toBe("supporting");
    expect(massKindCategory("max_laden_technical")).toBe("supporting");
  });

  it("NEVER classifies an actual_mass / kerb-shaped kind as headline or supporting — tax_only guard", () => {
    // Defensive: this mass_kind doesn't exist in current data (see plan Ground Truth)
    // but a future RDW ingest could add it. It must never render as "kerb weight."
    expect(massKindCategory("actual_mass")).toBe("tax_only");
  });

  it("defaults an unknown kind to supporting, never headline or tax_only silently", () => {
    expect(massKindCategory("something_unseen")).toBe("supporting");
  });
});
