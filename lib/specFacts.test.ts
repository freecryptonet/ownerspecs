import { describe, it, expect, vi, afterEach } from "vitest";
import {
  MASS_SPAN_VETO_KG,
  summarizeMassKind,
  summarizeAllMassKinds,
  isSpecFactsEnabled,
  hasEnoughVerifiedData,
  type MassFactRow,
} from "./specFacts";

const row = (over: Partial<MassFactRow>): MassFactRow => ({
  id: 1, vehicle_type_id: 1, mass_kind: "running_order", value_kg: 1160,
  source_document_id: 1, ...over,
});

describe("summarizeMassKind", () => {
  it("collapses to a single value when all rows agree", () => {
    const rows = [row({ id: 1, value_kg: 1160 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order");
    expect(s).toEqual({
      kind: "running_order", min: 1160, max: 1160, n: 2, spanKg: 0,
      isRange: false, rowIds: [1, 2], documentIds: [1],
    });
  });

  it("reports a range but does NOT collapse to a misleading single number when span <= 40kg", () => {
    const rows = [row({ id: 1, value_kg: 1155 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order")!;
    expect(s.min).toBe(1155);
    expect(s.max).toBe(1160);
    expect(s.spanKg).toBe(5);
    expect(s.isRange).toBe(false); // small span: fine to show a single "up to" style number upstream
  });

  it("flags isRange=true (the 40kg veto) when span exceeds the threshold — never silently pick one value", () => {
    const rows = [row({ id: 1, value_kg: 1100 }), row({ id: 2, value_kg: 1160, vehicle_type_id: 2 })];
    const s = summarizeMassKind(rows, "running_order")!;
    expect(s.spanKg).toBe(60);
    expect(s.spanKg).toBeGreaterThan(MASS_SPAN_VETO_KG);
    expect(s.isRange).toBe(true);
  });

  it("ignores rows for a different mass_kind and null values", () => {
    const rows = [
      row({ id: 1, mass_kind: "tow_braked", value_kg: 1000 }),
      row({ id: 2, mass_kind: "running_order", value_kg: null }),
    ];
    expect(summarizeMassKind(rows, "running_order")).toBeNull();
  });

  it("returns null for an empty/absent kind", () => {
    expect(summarizeMassKind([], "running_order")).toBeNull();
  });
});

describe("summarizeAllMassKinds", () => {
  it("groups the real 7-kind Kia Rio vocabulary into 7 summaries", () => {
    const kinds = ["running_order", "max_laden_permissible", "max_laden_technical",
      "max_combination", "tow_braked", "tow_unbraked", "max_axle"];
    const rows = kinds.map((k, i) => row({ id: i + 1, mass_kind: k, value_kg: 1000 + i }));
    const summaries = summarizeAllMassKinds(rows);
    expect(summaries.map((s) => s.kind).sort()).toEqual([...kinds].sort());
  });
});

describe("hasEnoughVerifiedData", () => {
  it("requires at least 3 distinct populated mass kinds", () => {
    const two = [{ kind: "a", n: 1 }, { kind: "b", n: 1 }] as any;
    const three = [{ kind: "a", n: 1 }, { kind: "b", n: 1 }, { kind: "c", n: 1 }] as any;
    expect(hasEnoughVerifiedData(two)).toBe(false);
    expect(hasEnoughVerifiedData(three)).toBe(true);
  });
});

describe("isSpecFactsEnabled", () => {
  const ORIGINAL = process.env.USE_SPEC_FACTS;
  afterEach(() => { process.env.USE_SPEC_FACTS = ORIGINAL; });

  it("defaults OFF when unset", () => {
    delete process.env.USE_SPEC_FACTS;
    expect(isSpecFactsEnabled()).toBe(false);
  });
  it("is ON only for the literal string '1'", () => {
    process.env.USE_SPEC_FACTS = "1";
    expect(isSpecFactsEnabled()).toBe(true);
    process.env.USE_SPEC_FACTS = "true"; // deliberately NOT truthy — avoid accidental enable via any non-empty string
    expect(isSpecFactsEnabled()).toBe(false);
  });
});
