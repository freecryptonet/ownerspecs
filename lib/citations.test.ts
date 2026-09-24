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

describe("mergeAndNumberSources — null/empty inputs (crash-safety)", () => {
  it("returns empty, consistent output for no sources and no links at all", () => {
    const idx = mergeAndNumberSources([], [], []);
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("trims", 1)).toEqual([]);
  });

  it("does not throw when renderedRows is undefined and there is nothing to render", () => {
    expect(() => mergeAndNumberSources([], [], undefined)).not.toThrow();
    const idx = mergeAndNumberSources([], [], undefined);
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("fluid_specs", 42)).toEqual([]);
  });

  it("ignores a link whose source id does not exist in rawSources (dangling legacy link)", () => {
    const links: RawLink[] = [{ table: "trims", id: 1, sourceSpace: "legacy", sourceId: 999 }];
    const idx = mergeAndNumberSources([], links, [{ table: "trims", id: 1 }]);
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("trims", 1)).toEqual([]);
  });

  it("ignores a document-lane link whose source_document_id has no matching document", () => {
    const links: RawLink[] = [
      { table: "mass_homologations", id: 5, sourceSpace: "document", sourceId: 777 },
    ];
    // No document with id=777 (and no id=777 in the "legacy" space either) was ever fetched
    // into rawSources — simulates a spec row whose FK target was deleted/never joined.
    const idx = mergeAndNumberSources([], links, [{ table: "mass_homologations", id: 5 }]);
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("mass_homologations", 5)).toEqual([]);
  });

  it("excludes everything when renderedRows is an explicit empty array (not undefined)", () => {
    const sources = [src(1, "A"), src(2, "B")];
    const links: RawLink[] = [
      { table: "trims", id: 1, sourceSpace: "legacy", sourceId: 1 },
      { table: "trims", id: 2, sourceSpace: "legacy", sourceId: 2 },
    ];
    // renderedRows: [] is NOT the same as undefined — an explicit "the page rendered
    // nothing" signal must suppress every row, unlike the undefined "render everything" default.
    const idx = mergeAndNumberSources(sources, links, []);
    expect(idx.sources).toEqual([]);
    expect(idx.citationsFor("trims", 1)).toEqual([]);
    expect(idx.citationsFor("trims", 2)).toEqual([]);
  });

  it("tolerates null/undefined-ish optional fields on a source row without throwing", () => {
    const sparse: RawSource = {
      id: 1,
      type: "manual",
      citation: "Sparse Source",
      url: null,
      public_link: 0,
      retrieved_at: "2026-01-01T00:00:00.000Z",
      notes: null,
      sourceSpace: "legacy",
    };
    const links: RawLink[] = [{ table: "procedures", id: 3, sourceSpace: "legacy", sourceId: 1 }];
    expect(() => mergeAndNumberSources([sparse], links, [{ table: "procedures", id: 3 }])).not.toThrow();
    const idx = mergeAndNumberSources([sparse], links, [{ table: "procedures", id: 3 }]);
    expect(idx.sources).toHaveLength(1);
    expect(idx.sources[0].url).toBeNull();
    expect(idx.sources[0].notes).toBeNull();
    expect(idx.citationsFor("procedures", 3)).toEqual([1]);
  });

  it("citationsFor returns [] for a table/id combination that was never linked at all", () => {
    const idx = mergeAndNumberSources([src(1, "A")], [], [{ table: "trims", id: 1 }]);
    expect(idx.citationsFor("nonexistent_table", 0)).toEqual([]);
    expect(idx.citationsFor("trims", 1)).toEqual([]); // has a source but no link to it
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
