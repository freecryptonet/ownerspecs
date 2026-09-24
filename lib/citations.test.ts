import { describe, it, expect } from "vitest";
import { mergeAndNumberSources, type RawSource, type RawLink } from "./citations";

const src = (id: number, citation: string): RawSource => ({
  id, type: "manual", citation, url: null, public_link: 0,
  retrieved_at: "2026-01-01T00:00:00.000Z", notes: null, sourceSpace: "legacy",
});

describe("mergeAndNumberSources — legacy-only (regression baseline)", () => {
  it("numbers sources 1..N in id order and maps citationsFor by rendered row", () => {
    const sources = [src(5, "Source A"), src(9, "Source B")];
    const links: RawLink[] = [
      { table: "trims", id: 100, sourceSpace: "legacy", sourceId: 5 },
      { table: "trims", id: 100, sourceSpace: "legacy", sourceId: 9 },
    ];
    const idx = mergeAndNumberSources(sources, links, [{ table: "trims", id: 100 }]);
    expect(idx.sources.map((s) => s.citation)).toEqual(["Source A", "Source B"]);
    expect(idx.citationsFor("trims", 100)).toEqual([1, 2]);
  });

  it("excludes a source with no citation in the rendered set (suppressed-row rule)", () => {
    const sources = [src(1, "Only cites a suppressed row")];
    const links: RawLink[] = [{ table: "trims", id: 200, sourceSpace: "legacy", sourceId: 1 }];
    const idx = mergeAndNumberSources(sources, links, [{ table: "trims", id: 999 }]); // 200 not rendered
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("trims", 200)).toEqual([]);
  });

  it("falls back to citing everything when renderedRows is undefined (gen-overview convention)", () => {
    const sources = [src(1, "A")];
    const links: RawLink[] = [{ table: "trims", id: 1, sourceSpace: "legacy", sourceId: 1 }];
    const idx = mergeAndNumberSources(sources, links, undefined);
    expect(idx.citationsFor("trims", 1)).toEqual([1]);
  });
});

describe("mergeAndNumberSources — legacy + document ID-space collision (the new-table case)", () => {
  it("does not collide sources.id=1 with documents.id=1 when both are cited", () => {
    const legacy: RawSource = { id: 1, type: "manual", citation: "Legacy source #1",
      url: null, public_link: 0, retrieved_at: "2026-01-01T00:00:00.000Z", notes: null, sourceSpace: "legacy" };
    const doc: RawSource = { id: 1, type: "rdw_open", citation: "RDW Open Data (CC0)",
      url: null, public_link: 1, retrieved_at: "2026-09-01T00:00:00.000Z", notes: null, sourceSpace: "document" };
    const links: RawLink[] = [
      { table: "trims", id: 10, sourceSpace: "legacy", sourceId: 1 },
      { table: "mass_homologations", id: 20, sourceSpace: "document", sourceId: 1 },
    ];
    const idx = mergeAndNumberSources([legacy, doc], links, [
      { table: "trims", id: 10 }, { table: "mass_homologations", id: 20 },
    ]);
    expect(idx.sources).toHaveLength(2); // both survive — NOT deduped as "the same id"
    expect(idx.citationsFor("trims", 10)).toEqual([1]);
    expect(idx.citationsFor("mass_homologations", 20)).toEqual([2]);
  });
});

describe("mergeAndNumberSources — mass_homologations lane end-to-end shape", () => {
  it("renders one shared document citation across multiple mass_homologations rows", () => {
    const doc: RawSource = { id: 1, type: "rdw_open", citation: "RDW Open Data (CC0)",
      url: null, public_link: 1, retrieved_at: "2026-09-01T00:00:00.000Z", notes: null, sourceSpace: "document" };
    const links: RawLink[] = [
      { table: "mass_homologations", id: 1, sourceSpace: "document", sourceId: 1 },
      { table: "mass_homologations", id: 9, sourceSpace: "document", sourceId: 1 },
      { table: "mass_homologations", id: 17, sourceSpace: "document", sourceId: 1 },
    ];
    const idx = mergeAndNumberSources([doc], links, [
      { table: "mass_homologations", id: 1 }, { table: "mass_homologations", id: 9 }, { table: "mass_homologations", id: 17 },
    ]);
    expect(idx.sources).toHaveLength(1); // one document, cited by all three rows
    expect(idx.citationsFor("mass_homologations", 1)).toEqual([1]);
    expect(idx.citationsFor("mass_homologations", 17)).toEqual([1]);
  });
});
