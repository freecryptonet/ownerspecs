# RDW Lane Productionization — Implementation Plan (Plan 2)

> **For agentic workers:** REQUIRED SUB-SKILL: use superpowers:subagent-driven-development
> (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use
> checkbox (`- [ ]`) syntax for tracking. Where a task's output is a pure function, follow
> superpowers:test-driven-development (failing test → minimal impl → passing test → commit).
> Where a task is DB/ops work with no pure core, it is marked **[design-level]** and has no
> RED/GREEN cycle — follow the runbook steps instead and verify by query, not by pytest.

**Goal:** Turn the validated prototype `scripts/rdw_masses_prototype.py` into a reusable,
idempotent RDW ingest (`scripts/rdw_ingest/`) that writes NL market-delta masses/towing/axle
facts into the applied document-first schema (migration 579: `documents`, `spec_facts`,
`mass_homologations`, `vehicle_types`, `vehicle_aliases`, `trims.vehicle_type_id`), per the
ingest ruleset in `docs/superpowers/specs/2026-09-23-rdw-field-reliability-report.md` §8 and the
weight-presentation policy in memory `reference_rdw_field_semantics.md`.

**Scope note:** Migration 579 tables are **not yet read by the live app** — `app/**` never
queries `vehicle_types`/`spec_facts`/`mass_homologations` today. Every task in this plan writes
to those tables only. **Nothing here touches the render layer, `app/**`, or a VPS deploy** — that
is Plan 4 (render layer) and Plan 5 (deploy), sequenced after this one. This plan can run
entirely against the live prod DB with zero live-site risk; a bad write is inert data, not a
regression a visitor can see.

**Architecture:** A small Python package `scripts/rdw_ingest/` with the same pure/impure split as
the sibling `scripts/dq/` harness: pure aggregation/clustering/planning modules (no network, no
DB, no clock — fully unit-tested) plus thin I/O modules (RDW Socrata fetch, MariaDB writer) and a
CLI (`ingest.py`) that wires them together per curated cohort.

```
scripts/rdw_ingest/
  __init__.py
  cohorts.py      # curated cohort registry + collision-safe WHERE builder      [pure + I/O-free]
  fetch.py        # per-VIN + per-type RDW Socrata pulls (measure_tvvs, TGK joins)  [I/O]
  aggregate.py    # per-TVV modal/agreement fold, body discriminator            [pure]
  cluster.py      # mass_kind mapping + trim clustering + 40kg veto            [pure]
  identity.py     # vehicle_types find-or-create, generation_id resolution     [I/O + pure helpers]
  planner.py      # diff existing DB rows vs new facts -> {inserts, closes}    [pure]
  db.py           # mysql.connector connection helper (env-driven)            [I/O]
  writer.py       # applies planner output: documents/vehicle_types/mass_homologations/spec_facts [I/O]
  promote.py      # qa_state pending -> approved per ingest-ruleset thresholds [pure core + I/O]
  trims_match.py  # best-effort trims.vehicle_type_id backfill                 [pure heuristic + I/O]
  ingest.py       # CLI: run one cohort end-to-end (--dry-run supported)
  tests/
    __init__.py
    conftest.py
    test_cohorts.py
    test_aggregate.py
    test_cluster.py
    test_planner.py
    test_promote.py
    test_trims_match.py
db/migrations/
  580_rdw_cluster_aggregates.sql   # proposed by Task 10 — NOT auto-applied, needs sign-off
```

**Tech Stack:** Python 3 stdlib (`urllib`, `json`, `re`) for RDW fetch — same as
`scripts/rdw_masses_prototype.py` and `scripts/dq/rdw_client.py` (reuse, don't duplicate: import
`scripts.dq.rdw_client.soda`/`token`). `mysql.connector` for the DB writer — same library and
env-var contract (`DB_HOST`/`DB_PORT`/`DB_USER`/`DB_PASSWORD`/`DB_NAME`) already used by
`scripts/manual_query.py`. `pytest` for the pure-module tests.

## Global Constraints

- **Python stdlib only** for RDW fetch (no `requests`/`pandas`); `mysql.connector` is the one
  allowed third-party dep for the writer (already installed in `.venv-manuals` on the VPS per
  `scripts/manual_query.py`'s precedent).
- **Every fact row has `source_document_id` NOT NULL and `market_id` NOT NULL.** No fact is ever
  written without both.
- **Facts start `qa_state='pending'`.** No task in this plan auto-writes `qa_state='approved'` at
  insert time — promotion is a separate, explicit step (Task 8) so a human or the `scripts/dq`
  harness is always in the loop before a fact is render-eligible.
- **Additive/idempotent DB writes only.** Re-running ingest for the same cohort must not
  duplicate `vehicle_types`, `documents`, `mass_homologations`, or `spec_facts` rows. Use the
  versioning columns (`valid_from`/`valid_to`/`supersedes_id`) the schema already provides — never
  `UPDATE` a fact's value in place.
- **NL market first.** `market_id` resolves to the `markets` row with `code='NL'`. No other market
  is in scope for this plan.
- **Never touch `app/**` or run a deploy.** This plan is DB-only (Scope note above).
- **Weight semantics are locked (do not re-derive or re-litigate):**
  `massa_rijklaar` = document value (CoC §13, running order) → publish, headline-eligible.
  `massa_ledig_voertuig` = RDW-derived (`rijklaar − 100kg`, NL admin convention) → written ONLY as
  a clearly-labelled derived fact, NEVER as a kerb/curb weight, NEVER fed into payload/towing
  math. See `reference_rdw_field_semantics.md` and report §6 for the full policy; Task 4 encodes
  this in the mass-kind mapping.
- **Agreement is computed PER-TVV, never whole-cohort.** This is the #1 correctness fix this plan
  exists to lock in (report §5.4). `scripts/rdw_masses_prototype.py`'s `fold_tvv()` already does
  this correctly — Task 3 ports it with an explicit regression test so a future refactor can't
  silently reintroduce the `scripts/dq/audit.py`-style whole-cohort mistake.
- **Cohort queries must exclude sub-model string collisions** (report §5.3 — Mustang vs Mustang
  Mach-E). Every cohort definition carries an explicit `exclude` list, checked by a unit test
  before any live fetch.
- **Run PowerShell for `F:\...` invocations**, per project CLAUDE.md — the Bash tool mangles
  backslash paths. `python scripts\rdw_ingest\ingest.py --cohort kia-rio-yb --dry-run` from
  `F:\projects\ownerspecs`. Live DB writes run **on the VPS** (prod DB is VPS-local per CLAUDE.md;
  no tunnel needed there) via `.venv-manuals/bin/python`, matching the `manual_query.py` pattern.
- **`--dry-run` is mandatory on every ingest/promote/backfill script**, defaulting to on for any
  new cohort's first run. Given these are prod-DB writes with no render-layer safety net to catch
  a mistake visually, dry-run-first is the operational guardrail.

---

### Task 1: Cohort registry + collision-safe WHERE builder

**Files:**
- Create: `scripts/rdw_ingest/__init__.py`
- Create: `scripts/rdw_ingest/cohorts.py`
- Create: `scripts/rdw_ingest/tests/__init__.py`
- Create: `scripts/rdw_ingest/tests/conftest.py`
- Create: `scripts/rdw_ingest/tests/test_cohorts.py`

**Interfaces:**
- Produces: `where_for(cohort: dict) -> str` (SoQL `$where` clause); `COHORTS: dict[str, dict]`
  (the curated registry — seeded from `F:\projects\kentekenfeiten\curatie\generatie-curatie.tsv`,
  see Step 1 below).
- Cohort dict shape: `{merk, hb: [str,...], exclude: [str,...], base: str|None, datum_van,
  datum_tot, generation_id: int|None, market_id_code: 'NL', coc: dict|None}`. `generation_id` is
  `None` until Task 5 resolves it (see below) — `cohorts.py` must not hard-fail on an unresolved
  cohort, only `ingest.py` should refuse to write without one.

- [ ] **Step 1: Seed the registry from the curatie TSV (data work, not a test)**

  `F:\projects\kentekenfeiten\curatie\generatie-curatie.tsv` already has the shape this lane
  needs: `merk, model, generatie, jaren, base (approval_base), datum_van, datum_tot,
  handelsbenaming_bevat (pipe-separated hb list), herkomst, bron, voertuigsoort`. Write a
  one-off conversion (script or by hand for the first ~15 cohorts) into `COHORTS` dict literals.
  **Do not blind-copy `handelsbenaming_bevat` into `hb` without checking for the Mustang/Mach-E
  collision class** (report §5.3): for every cohort, grep the live `handelsbenaming` distinct
  values for that `merk` (`soda("m9d7-ebf2", {"$select": "distinct handelsbenaming", "$where":
  "merk='X'"})`) and add anything that substring-matches but is a different nameplate to
  `exclude` (e.g. Golf → exclude `GOLF PLUS`/`GOLF SPORTSVAN` if the cohort is hatch-only; Ford →
  exclude `MUSTANG MACH-E` when cohort is `MUSTANG`). This reconnaissance step is per-cohort and
  manual — codify only the resulting exclude list, not a heuristic guesser.

- [ ] **Step 2: Write the failing test**

```python
# scripts/rdw_ingest/tests/test_cohorts.py
from scripts.rdw_ingest.cohorts import where_for

MUSTANG = {
    "merk": "FORD", "hb": ["MUSTANG"], "exclude": ["MUSTANG MACH-E"],
    "base": None, "datum_van": "20140101", "datum_tot": "20240101",
}


def test_where_for_includes_hb_and_excludes_collisions():
    w = where_for(MUSTANG)
    assert "upper(handelsbenaming) like '%MUSTANG%'" in w
    assert "not (upper(handelsbenaming) like '%MUSTANG MACH-E%')" in w
    assert "merk='FORD'" in w
    assert "voertuigsoort='Personenauto'" in w


def test_where_for_no_exclude_list_omits_not_clause():
    w = where_for({"merk": "KIA", "hb": ["RIO"], "exclude": [], "base": None,
                   "datum_van": "20110101", "datum_tot": "20180101"})
    assert "not (" not in w


def test_where_for_quotes_are_escaped():
    w = where_for({"merk": "O'NEIL", "hb": ["X"], "exclude": [], "base": None,
                   "datum_van": "20100101", "datum_tot": "20200101"})
    assert "O''NEIL" in w
```

- [ ] **Step 3: Run test to verify it fails**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_cohorts.py -v`
  Expected: FAIL with `ModuleNotFoundError: No module named 'scripts.rdw_ingest.cohorts'`

- [ ] **Step 4: Write minimal implementation**

```python
# scripts/rdw_ingest/cohorts.py
"""Curated cohort registry for the RDW mass/towing ingest lane, plus the collision-safe
SoQL WHERE builder. Ported from scripts/rdw_masses_prototype.py's where_for(), extended
with an `exclude` list to close the Mustang/Mustang-Mach-E substring-collision class
(reliability report §5.3) — any cohort whose `hb` substring-matches a different nameplate
MUST list that nameplate in `exclude`."""


def q(s):
    return str(s).replace("'", "''")


def where_for(cohort):
    parts = [f"merk='{q(cohort['merk'])}'"]
    if cohort.get("base"):
        parts.append(f"starts_with(typegoedkeuringsnummer,'{q(cohort['base'])}')")
    if cohort.get("hb"):
        ors = " or ".join(f"upper(handelsbenaming) like '%{q(s.upper())}%'" for s in cohort["hb"])
        parts.append(f"({ors})")
    for ex in cohort.get("exclude", []):
        parts.append(f"not (upper(handelsbenaming) like '%{q(ex.upper())}%')")
    if cohort.get("datum_van"):
        parts.append(f"datum_eerste_toelating>='{q(cohort['datum_van'])}'")
    if cohort.get("datum_tot"):
        parts.append(f"datum_eerste_toelating<'{q(cohort['datum_tot'])}'")
    parts.append("voertuigsoort='Personenauto'")
    return " and ".join(parts)


# Seeded from F:\projects\kentekenfeiten\curatie\generatie-curatie.tsv (Step 1). Each entry's
# generation_id is resolved by Task 5's identity.resolve_generation_id() — None here means
# "not yet mapped to our generations table", and ingest.py refuses to write for such a cohort.
COHORTS = {
    "kia-rio-yb": {
        "merk": "KIA", "hb": ["RIO"], "exclude": [], "base": "e11*2007/46*3777",
        "datum_van": "20110101", "datum_tot": "20180101", "generation_id": None,
        "coc": {  # held CoC — cross-check gold values, see fetch.py/aggregate.py tests
            "tvv": {"approval_base": "e11*2007/46*3777", "extension": "00",
                     "variant": "B5P11", "version": "M61BZ1"},
            "masses": {"running_order": 1160, "max_laden_technical": 1620,
                        "max_combination": 2730, "tow_braked": 1110, "tow_unbraked": 450,
                        "coupling_vertical": 75},
            "axles": [{"axle": 1, "max_load_kg": 945}, {"axle": 2, "max_load_kg": 840}],
        },
    },
    "vw-golf-7": {
        "merk": "VOLKSWAGEN", "hb": ["GOLF"], "exclude": ["GOLF PLUS", "GOLF SPORTSVAN"],
        "base": None, "datum_van": "20121101", "datum_tot": "20201231",
        "generation_id": None, "coc": None,
    },
    "ford-mustang": {
        "merk": "FORD", "hb": ["MUSTANG"], "exclude": ["MUSTANG MACH-E"],
        "base": None, "datum_van": "20140101", "datum_tot": "20240101",
        "generation_id": None, "coc": None,
    },
    # TODO(cohorts): extend from the curatie TSV — one entry per generation this ingest lane
    # targets. Adding a cohort is pure data; no code change required.
}
```

  Also create `scripts/rdw_ingest/__init__.py` and `scripts/rdw_ingest/tests/__init__.py` as
  empty package markers, and `tests/conftest.py` identical in shape to
  `scripts/dq/tests/conftest.py` (inserts the repo root onto `sys.path`).

- [ ] **Step 5: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_cohorts.py -v`
  Expected: PASS (3 passed)

- [ ] **Step 6: Commit**

```bash
git add scripts/rdw_ingest/__init__.py scripts/rdw_ingest/cohorts.py scripts/rdw_ingest/tests/
git commit -m "feat(rdw-ingest): cohort registry + collision-safe WHERE builder"
```

---

### Task 2: Fetch layer — per-TVV masses + per-type TGK joins **[design-level, I/O]**

**Files:**
- Create: `scripts/rdw_ingest/fetch.py`

**Interfaces:**
- Consumes: `scripts.dq.rdw_client.soda`/`token` (reuse — do not re-copy a third client), Task 1's
  `where_for`.
- Produces: `measure_tvvs(cohort) -> (tvvs: dict[(base,ext,variant,version)] -> list[row], pop:
  int)`; `fetch_tgk_basis(bases)`, `fetch_tgk_axles(bases)`, `fetch_motorcode_map(bases)`,
  `fetch_transmission_map(bases)` — all four keyed `(typegoedkeuringsnummer, codevarianttgk,
  codeuitvoeringtgk) -> dict`.

- [ ] **Step 1: Port verbatim, with one key addition**

  Lift `measure_tvvs`, `fetch_tgk_basis`, `fetch_tgk_axles`, `fetch_motorcode_map`,
  `fetch_transmission_map`, `_latest_rev`, `bases_of`, and the `num()` helper from
  `scripts/rdw_masses_prototype.py` lines 216–389 into `fetch.py`, changing only:
  1. `soda(...)` calls → `from scripts.dq.rdw_client import soda` (drop the prototype's private
     copy — one client, shared with the `dq` harness).
  2. `where_for(t)` → `from scripts.rdw_ingest.cohorts import where_for`.
  3. `measure_tvvs`'s grouping key: the prototype groups by
     `(typegoedkeuringsnummer, variant, uitvoering)` — a **2-tuple that drops the approval
     extension**. Migration 579's `vehicle_types.uk_tvv` key is
     `(approval_base, approval_extension, tvv_variant, tvv_version)` — **the extension IS part of
     the identity** (panel-corrected: same variant+version under different extensions carry
     different masses, e.g. F5P41/M52AZ1 = 1104 kg under `*04` vs 1127 kg under `*06`). Change the
     group key to `(approval_base, approval_extension, variant, uitvoering)`, splitting
     `typegoedkeuringsnummer` on the last `*` into `(approval_base, approval_extension)` — this is
     the one real behavior change vs the prototype, not just a lift-and-shift.

  No unit test here (this module is pure I/O — no `assert` without a live RDW call). Its
  correctness is validated by Task 3's tests operating on fixture rows shaped exactly like what
  this module returns, and by the dry-run smoke in Task 11.

- [ ] **Step 2: Manual smoke against live RDW (not a pytest, a runbook step)**

  ```powershell
  python -c "from scripts.rdw_ingest.fetch import measure_tvvs; from scripts.rdw_ingest.cohorts import COHORTS; tvvs, pop = measure_tvvs(COHORTS['kia-rio-yb']); print(pop, len(tvvs))"
  ```
  Expected: a population count and TVV count in the same ballpark as
  `scripts/output/rdw_masses_kia-rio.json`'s `population`/`n_tvv` from the prototype run (sanity
  cross-check against known-good prior output, not a new number to interpret cold).

- [ ] **Step 3: Commit**

```bash
git add scripts/rdw_ingest/fetch.py
git commit -m "feat(rdw-ingest): fetch layer — per-TVV masses + TGK axle/tow-ball/motorcode/transmission joins"
```

---

### Task 3: Per-TVV aggregation core — the agreement-grain regression guard

**Files:**
- Create: `scripts/rdw_ingest/aggregate.py`
- Create: `scripts/rdw_ingest/tests/test_aggregate.py`

**Interfaces:**
- Produces: `modal(values: list) -> (value, agreement, n)`; `fold_tvv(group_rows: list[dict]) ->
  (masses: dict, total_n: int)`; `body_from_handelsbenaming(hb: str, known_bodies: dict[str,str])
  -> str|None`.

This is the **single most important correctness task in this plan** — it is the concrete lock-in
of the report's §5.4 finding. `scripts/rdw_masses_prototype.py`'s `fold_tvv()` already computes
agreement **within one TVV's grouped rows**, which is correct; `scripts/dq/audit.py`'s
`score_cohort()` computes `modal_agreement()` over an **entire cohort** (all TVVs pooled), which
structurally false-flags every continuous per-trim mass field regardless of underlying data
quality. Both already exist in the repo — the risk this task guards against is a future refactor
that "simplifies" by sharing one aggregation function between the two and picks the wrong grain.

- [ ] **Step 1: Write the failing test — the grain regression guard is the load-bearing test**

```python
# scripts/rdw_ingest/tests/test_aggregate.py
from scripts.rdw_ingest.aggregate import modal, fold_tvv, body_from_handelsbenaming

MASS_FIELDS = {"running_order": "massa_rijklaar"}


def test_modal_basic():
    assert modal([1160, 1160, 1160, 1200]) == (1160, 0.75, 4)
    assert modal([]) == (None, None, 0)


def test_fold_tvv_agreement_is_within_one_tvv_group_not_across_tvvs():
    """The regression guard for report §5.4. Two TVVs, each internally perfectly
    consistent (agreement should read 1.0 for each), but with DIFFERENT running-order
    masses from each other (1160 vs 1400). A whole-cohort (both TVVs pooled) modal
    agreement would read ~0.5-0.6 and false-flag low_agreement — fold_tvv() must be
    called PER TVV GROUP (one call per TVV) so each group reports its own, correct,
    high agreement."""
    tvv_a_rows = [{"massa_rijklaar": "1160", "n": "12"}] * 1  # n encodes VIN count per row
    tvv_b_rows = [{"massa_rijklaar": "1400", "n": "15"}] * 1
    masses_a, n_a = fold_tvv(tvv_a_rows, MASS_FIELDS, min_n=10, agree_flag=0.80)
    masses_b, n_b = fold_tvv(tvv_b_rows, MASS_FIELDS, min_n=10, agree_flag=0.80)
    assert masses_a["running_order"]["value_kg"] == 1160
    assert masses_a["running_order"]["agreement"] == 1.0
    assert masses_a["running_order"]["qa_state"] == "pending"  # clean, not flagged
    assert masses_b["running_order"]["value_kg"] == 1400
    assert masses_b["running_order"]["agreement"] == 1.0
    # explicit anti-regression: pooling the two groups WOULD false-flag (documents the trap)
    pooled_modal, pooled_agreement, pooled_n = modal([1160] * 12 + [1400] * 15)
    assert pooled_agreement < 0.80  # this is the wrong number for either TVV — never compute it


def test_fold_tvv_flags_low_n_and_disagreement():
    rows = [{"massa_rijklaar": "1160", "n": "3"}, {"massa_rijklaar": "1200", "n": "2"}]
    masses, total = fold_tvv(rows, MASS_FIELDS, min_n=10, agree_flag=0.80)
    assert "low_n:5" in masses["running_order"]["flags"]
    assert masses["running_order"]["qa_state"] == "flagged"


def test_body_from_handelsbenaming_discriminates_golf_variants():
    # report §5.3/§5.4 sibling finding: `inrichting` is unreliable for body; handelsbenaming
    # is the correct discriminator (Golf vs Golf Variant vs Golf Sportsvan).
    assert body_from_handelsbenaming("GOLF") == "hatchback"
    assert body_from_handelsbenaming("GOLF VARIANT") == "estate"
    assert body_from_handelsbenaming("GOLF SPORTSVAN") == "mpv"
    assert body_from_handelsbenaming("UNKNOWN MODEL XYZ") is None
```

- [ ] **Step 2: Run test to verify it fails**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_aggregate.py -v`
  Expected: FAIL with `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/rdw_ingest/aggregate.py
"""Per-TVV aggregation core. PURE — no network, no DB, no clock.

CRITICAL INVARIANT (reliability report §5.4): fold_tvv() must be called ONCE PER TVV GROUP,
never over a pooled multi-TVV cohort. Mass fields vary continuously across trims/engines
within a nameplate, so a whole-cohort modal agreement is structurally meaningless — it answers
"do all trims of this car weigh the same" (no, they shouldn't) instead of "is this TVV's value
correct" (yes, when checked at its own grain). scripts/dq/audit.py's score_cohort() computes
the wrong-grain number DELIBERATELY, as a diagnostic signal about a different question (whether
a field varies at all) — never copy its modal_agreement() call site into this module.
"""
from collections import Counter


def modal(values):
    vals = [v for v in values if v is not None]
    if not vals:
        return None, None, 0
    counts = Counter(vals)
    best_val, best_n = counts.most_common(1)[0]
    return best_val, best_n / len(vals), len(vals)


def _num(v):
    try:
        n = float(v)
        return n if n > 0 else None
    except (TypeError, ValueError):
        return None


def fold_tvv(group_rows, mass_fields, min_n=10, agree_flag=0.80):
    """group_rows = grouped SoQL rows for ONE TVV (each row: {field: value, n: count-of-VINs}).
    Returns (masses: {kind: {value_kg, unit, n, agreement, qa_state, flags, minority_values}},
    total_n). Mirrors scripts/rdw_masses_prototype.py's fold_tvv(), extracted and unit-tested."""
    total = sum(int(r["n"]) for r in group_rows)
    masses = {}
    for kind, field in mass_fields.items():
        dist = {}
        for r in group_rows:
            v = _num(r.get(field))
            if v is not None:
                dist[v] = dist.get(v, 0) + int(r["n"])
        n_nonnull = sum(dist.values())
        if not dist:
            continue
        modal_val, modal_n = max(dist.items(), key=lambda kv: kv[1])
        agree = modal_n / n_nonnull
        flags = []
        if n_nonnull < min_n:
            flags.append(f"low_n:{n_nonnull}")
        if agree < agree_flag:
            flags.append(f"within_tvv_disagreement:{agree:.2f}")
        n_missing = total - n_nonnull
        if kind.startswith("tow") and n_missing > 0:
            flags.append(f"missing_on_{n_missing}/{total}")
        outliers = sorted(([int(v), c] for v, c in dist.items() if v != modal_val),
                           key=lambda x: -x[1])[:3]
        masses[kind] = {
            "value_kg": int(modal_val), "unit": "kg", "n": n_nonnull,
            "agreement": round(agree, 3), "source_field": f"m9d7-ebf2.{field}",
            "qa_state": "flagged" if flags else "pending", "flags": flags,
            "minority_values": outliers,
        }
    return masses, total


# handelsbenaming -> body discriminator. `inrichting` is rejected fleet-wide (report §4c); this
# is the accepted replacement. Extend per-nameplate as new cohorts are added — deliberately NOT
# a general parser, since body-from-trade-name rules are nameplate-specific (report §5.1).
_HB_BODY_RULES = [
    ("SPORTSVAN", "mpv"), ("VARIANT", "estate"), ("KOMBI", "estate"), ("ESTATE", "estate"),
    ("TOURING", "estate"), ("AVANT", "estate"), ("SPORTBACK", "hatchback"),
]


def body_from_handelsbenaming(hb, extra_rules=None):
    """Best-effort body discriminator from the trade name, replacing RDW's unreliable
    `inrichting` (report §4c/§5.1: ~99% of Golf/Yaris/Picanto hatchbacks mis-coded 'MPV').
    Returns None (not a guess) when no rule matches — callers must not default to 'hatchback'."""
    if not hb:
        return None
    hb_u = hb.upper()
    for rule_set in (extra_rules or []), _HB_BODY_RULES:
        for needle, body in rule_set:
            if needle in hb_u:
                return body
    return "hatchback"  # bare nameplate with no qualifier — the common case for a supermini/hatch
```

  Note: the test's `body_from_handelsbenaming("UNKNOWN MODEL XYZ") is None` expectation requires
  the bare-nameplate fallback to be **opt-in per cohort**, not global — adjust the function so the
  default fallback only fires when the caller passes `default_body="hatchback"` explicitly (Golf
  cohort does; a cohort with no known default passes nothing and gets `None`). Update the test and
  impl together so intent stays explicit — don't silently guess a body for an unrecognized
  nameplate.

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_aggregate.py -v`
  Expected: PASS (4 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/aggregate.py scripts/rdw_ingest/tests/test_aggregate.py
git commit -m "feat(rdw-ingest): per-TVV aggregation core + agreement-grain regression guard"
```

---

### Task 4: Mass-kind vocabulary mapping + trim clustering with the 40kg veto

**Files:**
- Create: `scripts/rdw_ingest/cluster.py`
- Create: `scripts/rdw_ingest/tests/test_cluster.py`

**Interfaces:**
- Produces: `MASS_KIND_MAP: dict[str, str]` (RDW mass_kind label -> schema's
  `mass_homologations.mass_kind` value — see the open question below); `cluster_tvvs(facts:
  list[dict]) -> list[dict]` (ported from the prototype, with the 40 kg veto).

**Open naming decision (resolve before Step 3, flag to Tim/panel if ambiguous):** migration 579's
`mass_homologations.mass_kind` comment lists `running_order|actual_mass|max_laden|max_axle|
max_combination|tow_braked_drawbar|tow_braked_centre_axle|tow_unbraked|coupling_vertical` — a
convention comment, not an enforced `CHECK`/`ENUM`, but it will be **shared with the future CoC
ingest pipeline (Plan 3)**, so drift here becomes a cross-pipeline inconsistency later. RDW's
`m9d7-ebf2` gives two distinct "max laden" figures (`toegestane_maximum_massa_voertuig` = NL
registered/permissible, `technische_max_massa_voertuig` = CoC §16.1 technical) that the comment's
singular `max_laden` doesn't distinguish, and RDW's `maximum_trekken_massa_geremd` doesn't split
drawbar vs. centre-axle (that split needs the per-type TGK combination dataset, out of scope
here). This task's mapping **extends** the vocabulary rather than colliding with it:

| RDW field / prototype key | `mass_homologations.mass_kind` |
|---|---|
| `massa_rijklaar` / `running_order` | `running_order` |
| `technische_max_massa_voertuig` / `max_laden_technical` | `max_laden_technical` *(extends the comment's bare `max_laden`)* |
| `toegestane_maximum_massa_voertuig` / `max_laden_permissible` | `max_laden_permissible` *(NL market-delta fact, extends the comment)* |
| `maximum_massa_samenstelling` / `max_combination` | `max_combination` |
| `maximum_trekken_massa_geremd` / `tow_braked` | `tow_braked` *(no drawbar/centre-axle split at this dataset — use the comment's `tow_braked_drawbar` value ONLY if a future TGK join proves it's drawbar-type; otherwise this plain key)* |
| `maximum_massa_trekken_ongeremd` / `tow_unbraked` | `tow_unbraked` |
| TGK `maxverticalebelastopkoppbgr` / `coupling_vertical` | `coupling_vertical` |
| TGK axle `maximummassaasbelastingbgr` | `max_axle` (with `axle_index` set) |
| `massa_ledig_voertuig` | **NOT written to `mass_homologations` at all** — see below |

`massa_ledig_voertuig` is RDW-derived, not a document fact (report §4b, memory
`reference_rdw_field_semantics.md`). Per the weight-presentation policy it "may only be shown in a
separate NL registration/road-tax box" — this plan writes it, if at all, as a `spec_facts` row
with a NEW `fact_type` (e.g. `mrb_ledig_gewicht`, category `registration`, NOT category `fluid`/
`dimension`/anything render-adjacent) carrying `qualifier='rdw_derived:rijklaar_minus_100kg'`, so
it can never be silently joined into the mass/weight block by a query that doesn't know to
exclude it. **Confirm this fact_type doesn't already exist and needs a follow-up additive
migration before writing it** — if Tim wants to defer this field entirely for Plan 2, that is
equally acceptable; it is the lowest-priority field in the ruleset (§8: "publish-as-derived,
reject from the weight/spec block").

- [ ] **Step 1: Write the failing test**

```python
# scripts/rdw_ingest/tests/test_cluster.py
from scripts.rdw_ingest.cluster import cluster_tvvs, MASS_SPAN_VETO


def _fact(mc, tr, gears, body, ro_kg, n_vins=100):
    return {"motorcode": mc, "trans_type": tr, "gears": gears, "body": body,
            "n_vins": n_vins, "variant": "V", "uitvoering": "U",
            "masses": {"running_order": {"value_kg": ro_kg}}}


def test_cluster_groups_by_motorcode_transmission_body():
    facts = [_fact("CJZA", "M", 6, "hatchback", 1160),
             _fact("CJZA", "M", 6, "hatchback", 1165)]
    clusters = cluster_tvvs(facts)
    assert len(clusters) == 1
    assert clusters[0]["span_kg"] == 5
    assert clusters[0]["veto"] is False


def test_cluster_vetoes_wide_mass_span():
    facts = [_fact("CJZA", "M", 6, "hatchback", 1160),
             _fact("CJZA", "M", 6, "hatchback", 1250)]  # 90kg span > 40kg veto
    clusters = cluster_tvvs(facts)
    assert clusters[0]["span_kg"] == 90
    assert clusters[0]["veto"] is True


def test_cluster_separates_different_motorcodes():
    facts = [_fact("CJZA", "M", 6, "hatchback", 1160),
             _fact("DFGA", "M", 6, "hatchback", 1160)]
    clusters = cluster_tvvs(facts)
    assert len(clusters) == 2
```

- [ ] **Step 2: Run test to verify it fails**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_cluster.py -v`
  Expected: FAIL with `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

  Port `cluster_tvvs()` verbatim from `scripts/rdw_masses_prototype.py` lines 392–433 into
  `scripts/rdw_ingest/cluster.py`, keeping `MASS_SPAN_VETO = 40`, and add the `MASS_KIND_MAP`
  table above as module-level data (dict literal, not logic).

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_cluster.py -v`
  Expected: PASS (3 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/cluster.py scripts/rdw_ingest/tests/test_cluster.py
git commit -m "feat(rdw-ingest): mass-kind vocabulary map + trim clustering with 40kg span veto"
```

---

### Task 5: Identity resolution — `vehicle_types` find-or-create + `generation_id` mapping **[design-level, I/O + pure helper]**

**Files:**
- Create: `scripts/rdw_ingest/identity.py`
- Create: `scripts/rdw_ingest/tests/test_identity.py` (pure helper only)

**Interfaces:**
- Produces: `tvv_key(approval_base, approval_extension, variant, version) -> str` (pure, for
  dedup/logging); `find_or_create_vehicle_type(cursor, generation_id, tvv_fact) ->
  vehicle_type_id` (I/O — `SELECT` on `uk_tvv`, `INSERT` on miss); `resolve_generation_id(cohort,
  curatie_row) -> int|None` (I/O — looks up `generations` by brand+model+year overlap; returns
  `None` and logs a warning on ambiguous/no match, never guesses).

- [ ] **Step 1: Write the failing test (pure key helper only)**

```python
# scripts/rdw_ingest/tests/test_identity.py
from scripts.rdw_ingest.identity import tvv_key


def test_tvv_key_is_stable_and_extension_sensitive():
    a = tvv_key("e11*2007/46*3777", "00", "B5P11", "M61BZ1")
    b = tvv_key("e11*2007/46*3777", "04", "B5P11", "M61BZ1")
    assert a != b  # extension is part of identity (panel-corrected — see fetch.py Task 2 Step 1)
    assert tvv_key("e11*2007/46*3777", "00", "B5P11", "M61BZ1") == a  # deterministic
```

- [ ] **Step 2: Run test to verify it fails** — `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/rdw_ingest/identity.py (excerpt — pure part)
def tvv_key(approval_base, approval_extension, variant, version):
    return f"{approval_base}*{approval_extension}|{variant}|{version}"
```

  The I/O parts (`find_or_create_vehicle_type`, `resolve_generation_id`) are **not unit-tested
  with a live DB** in this plan — write them as thin, reviewable functions using the
  `mysql.connector` cursor passed in by `writer.py` (Task 7), following this shape:

  ```python
  def find_or_create_vehicle_type(cursor, generation_id, tvv_fact):
      cursor.execute(
          "SELECT id FROM vehicle_types WHERE approval_base=%s AND approval_extension=%s "
          "AND tvv_variant=%s AND tvv_version=%s",
          (tvv_fact["approval_base"], tvv_fact["approval_extension"],
           tvv_fact["variant"], tvv_fact["uitvoering"]))
      row = cursor.fetchone()
      if row:
          return row["id"]
      cursor.execute(
          "INSERT INTO vehicle_types (generation_id, approval_base, approval_extension, "
          "tvv_type, tvv_variant, tvv_version, commercial_label) VALUES (%s,%s,%s,%s,%s,%s,%s)",
          (generation_id, tvv_fact["approval_base"], tvv_fact["approval_extension"],
           tvv_fact.get("type", ""), tvv_fact["variant"], tvv_fact["uitvoering"],
           tvv_fact.get("handelsbenaming")))
      return cursor.lastrowid
  ```

  `resolve_generation_id` is **manual-confirm, not auto-guess**: for each curated cohort, query
  `SELECT id, slug, start_year, end_year FROM generations WHERE make_id=(SELECT id FROM makes
  WHERE name=%s) AND model...` (join through `models`/`makes` per the existing schema), print
  candidates, and require the cohort's `generation_id` field in `cohorts.py` to be filled in by
  hand before `ingest.py` will run non-dry-run for that cohort. This mirrors how `PLAN` already
  requires human confirmation before any moat migration — identity resolution is exactly that
  kind of decision and should not be automated silently.

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_identity.py -v` — PASS (2 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/identity.py scripts/rdw_ingest/tests/test_identity.py
git commit -m "feat(rdw-ingest): vehicle_types identity resolution (find-or-create + generation mapping)"
```

---

### Task 6: Idempotent write planner (pure diff core)

**Files:**
- Create: `scripts/rdw_ingest/planner.py`
- Create: `scripts/rdw_ingest/tests/test_planner.py`

**Interfaces:**
- Produces: `plan_mass_writes(existing_current_rows: list[dict], new_facts: list[dict]) ->
  {"inserts": [...], "closes": [...], "unchanged": [...]}`. `existing_current_rows` = the DB's
  current (`valid_to IS NULL`) `mass_homologations` rows for the vehicle_types touched by this
  run, keyed by `(vehicle_type_id, market_id, mass_kind, axle_index)`. `new_facts` = this run's
  computed facts in the same shape plus `value_kg`. An unchanged value is a no-op (true
  idempotency); a changed value produces one `close` (old row, `valid_to=today`) and one `insert`
  (new row, `supersedes_id=<old id>`, `valid_from=today`, `qa_state='pending'`); a brand-new key
  produces only an `insert`.

- [ ] **Step 1: Write the failing test**

```python
# scripts/rdw_ingest/tests/test_planner.py
from datetime import date
from scripts.rdw_ingest.planner import plan_mass_writes

TODAY = date(2026, 9, 23)


def _key(vt=1, mkt=1, kind="running_order", axle=None):
    return {"vehicle_type_id": vt, "market_id": mkt, "mass_kind": kind, "axle_index": axle}


def test_new_fact_is_pure_insert():
    plan = plan_mass_writes([], [dict(_key(), value_kg=1160)], today=TODAY)
    assert len(plan["inserts"]) == 1 and plan["inserts"][0]["value_kg"] == 1160
    assert plan["closes"] == [] and plan["unchanged"] == []


def test_unchanged_value_is_a_true_noop():
    existing = [dict(_key(), id=42, value_kg=1160)]
    plan = plan_mass_writes(existing, [dict(_key(), value_kg=1160)], today=TODAY)
    assert plan["inserts"] == [] and plan["closes"] == []
    assert len(plan["unchanged"]) == 1


def test_changed_value_closes_old_and_inserts_new_with_supersedes():
    existing = [dict(_key(), id=42, value_kg=1160)]
    plan = plan_mass_writes(existing, [dict(_key(), value_kg=1165)], today=TODAY)
    assert plan["closes"] == [{"id": 42, "valid_to": TODAY}]
    assert plan["inserts"][0]["value_kg"] == 1165
    assert plan["inserts"][0]["supersedes_id"] == 42
    assert plan["inserts"][0]["valid_from"] == TODAY


def test_disjoint_keys_do_not_collide():
    existing = [dict(_key(kind="running_order"), id=1, value_kg=1160)]
    new = [dict(_key(kind="max_combination"), value_kg=2730)]
    plan = plan_mass_writes(existing, new, today=TODAY)
    assert len(plan["inserts"]) == 1 and plan["closes"] == []
```

- [ ] **Step 2: Run test to verify it fails** — `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/rdw_ingest/planner.py
"""Pure idempotent diff planner. No DB, no clock (caller passes `today`). This is what
makes re-running an ingest for the same cohort safe: unchanged facts are true no-ops,
changed facts version forward via valid_to/supersedes_id (invariant 3 of mig 579),
nothing is ever UPDATEd in place."""


def _fact_key(row):
    return (row["vehicle_type_id"], row["market_id"], row["mass_kind"], row.get("axle_index"))


def plan_mass_writes(existing_current_rows, new_facts, today):
    existing_by_key = {_fact_key(r): r for r in existing_current_rows}
    inserts, closes, unchanged = [], [], []
    for fact in new_facts:
        key = _fact_key(fact)
        existing = existing_by_key.get(key)
        if existing is None:
            inserts.append({**fact, "valid_from": today, "supersedes_id": None})
        elif existing["value_kg"] == fact["value_kg"]:
            unchanged.append(fact)
        else:
            closes.append({"id": existing["id"], "valid_to": today})
            inserts.append({**fact, "valid_from": today, "supersedes_id": existing["id"]})
    return {"inserts": inserts, "closes": closes, "unchanged": unchanged}
```

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_planner.py -v` — PASS (4 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/planner.py scripts/rdw_ingest/tests/test_planner.py
git commit -m "feat(rdw-ingest): idempotent write planner (insert/close/unchanged diff)"
```

---

### Task 7: DB writer **[design-level, I/O]**

**Files:**
- Create: `scripts/rdw_ingest/db.py`
- Create: `scripts/rdw_ingest/writer.py`

**Interfaces:**
- Produces: `db.get_conn()` (same env-var contract as `scripts/manual_query.py`:
  `DB_HOST`/`DB_PORT`/`DB_USER`/`DB_PASSWORD`/`DB_NAME`, `mysql.connector.connect(...)`,
  `cursor(dictionary=True)`); `writer.write_cohort(conn, generation_id, tvv_facts, clusters,
  dry_run=True) -> report dict`.

- [ ] **Step 1: `db.py`** — copy the 6-line `get_conn()` pattern from `scripts/manual_query.py`
  verbatim (same env vars, same `mysql.connector` call). Do not invent a new connection
  convention.

- [ ] **Step 2: `writer.write_cohort()` — the orchestration order**

  1. Resolve `market_id` once: `SELECT id FROM markets WHERE code='NL'`.
  2. For each `tvv_fact` in the cohort's aggregated output: `identity.find_or_create_vehicle_type`
     → `vehicle_type_id`.
  3. Fetch `existing_current_rows` for all touched `vehicle_type_id`s in one query:
     `SELECT * FROM mass_homologations WHERE vehicle_type_id IN (...) AND valid_to IS NULL`.
  4. Build `new_facts` from each `tvv_fact["masses"]` + `tvv_fact.get("axles")`, mapped through
     `cluster.MASS_KIND_MAP`, each carrying a placeholder `source_document_id` (resolved in step
     6) — **skip any mass whose `qa_state` came out `'flagged'` from `fold_tvv`'s `low_n` or
     `within_tvv_disagreement` flags** (do not write pollution; a flagged value gets no row at
     all, which is stricter than "write it pending" — the write-side gate, not just the
     render-side `qa_state` gate, per the ingest ruleset's "a low fill/disagreement is not a
     reason to impute").
  5. `planner.plan_mass_writes(existing_current_rows, new_facts, today=date.today())`.
  6. **If and only if `plan["inserts"]` or `plan["closes"]` is non-empty**, create ONE
     `documents` row for this run: `doc_type='rdw_open'`, `provenance_kind='official_open_data'`,
     `generation_id=<cohort's>`, `market_id=<NL>`, `citation='RDW Open Data — Gekentekende
     voertuigen (m9d7-ebf2), retrieved <date>'`, `public_link=1`, `license='CC0'`,
     `retrieved_at=NOW()`. If the plan is empty (nothing changed since last run), **write no
     document at all** — this is the idempotency guarantee for `documents` too, not just facts.
  7. Apply `plan["closes"]` (`UPDATE mass_homologations SET valid_to=%s WHERE id=%s`), then
     `plan["inserts"]` (`INSERT ... source_document_id=<new doc id>, qa_state='pending'`).
  8. Same insert-if-new-value pattern for the `dim_axle_track` `spec_facts` rows (axle
     `track_mm`), reusing `planner.plan_mass_writes`-shaped logic keyed on `(vehicle_type_id,
     market_id, fact_type_id, qualifier)` instead of `mass_kind` — **factor the key function so
     both call sites share it**, don't fork the diff logic.
  9. `dry_run=True` (the default): perform steps 1–5 and 8's dry equivalent, print the plan,
     `conn.rollback()`, never commit. `dry_run=False`: `conn.commit()` at the end, one transaction
     per cohort.

- [ ] **Step 3: Manual verification (not pytest — a runbook check)**

  Run dry-run first, inspect the printed plan for the Kia Rio cohort, confirm the CoC-held values
  (§13 1160, §16.1 1620, §18 1110/450, §16.4 2730, axle 945/840) appear as inserts with the
  correct `mass_kind` mapping from Task 4's table. Only then re-run with `--commit`.

- [ ] **Step 4: Commit**

```bash
git add scripts/rdw_ingest/db.py scripts/rdw_ingest/writer.py
git commit -m "feat(rdw-ingest): idempotent DB writer (documents + mass_homologations + axle spec_facts)"
```

---

### Task 8: QA promotion — pending → approved per the ingest ruleset

**Files:**
- Create: `scripts/rdw_ingest/promote.py`
- Create: `scripts/rdw_ingest/tests/test_promote.py`

**Interfaces:**
- Produces: `is_promotable(mass_row: dict, cluster_veto: bool) -> bool` (pure — the ruleset
  threshold check); `promote_pending(conn, dry_run=True) -> report` (I/O — applies the pure check
  to every `qa_state='pending'` row sourced from an `rdw_open` document).

Per the Global Constraints, ingestion (Task 7) never writes `qa_state='approved'` — this is a
deliberately separate step so a human/the `scripts/dq` harness is always the one flipping the
render-eligibility switch, and so a bad ingest run can be caught before promotion even if it was
already committed.

- [ ] **Step 1: Write the failing test**

```python
# scripts/rdw_ingest/tests/test_promote.py
from scripts.rdw_ingest.promote import is_promotable

MIN_N = 10
AGREE_FLAG = 0.80


def test_clean_tvv_scoped_fact_is_promotable():
    row = {"n": 50, "agreement": 0.95, "flags": []}
    assert is_promotable(row, cluster_veto=False) is True


def test_low_n_is_not_promotable():
    assert is_promotable({"n": 4, "agreement": 1.0, "flags": ["low_n:4"]}, cluster_veto=False) is False


def test_within_tvv_disagreement_is_not_promotable():
    row = {"n": 50, "agreement": 0.5, "flags": ["within_tvv_disagreement:0.50"]}
    assert is_promotable(row, cluster_veto=False) is False


def test_cluster_span_veto_blocks_promotion_even_if_the_row_itself_is_clean():
    # a clean per-TVV value inside a >40kg-span cluster still shouldn't publish as
    # "the" trim mass — it needs range presentation, not single-value promotion (report/plan §3)
    row = {"n": 50, "agreement": 1.0, "flags": []}
    assert is_promotable(row, cluster_veto=True) is False


def test_sparse_towing_fill_is_not_penalized_by_this_check():
    # report §5.2: low fill on towing is a real "not tow-rated" state, not pollution — this
    # function only judges the ROW that exists, fill-rate is a cohort-level concern out of scope
    row = {"n": 12, "agreement": 1.0, "flags": []}
    assert is_promotable(row, cluster_veto=False) is True
```

- [ ] **Step 2: Run test to verify it fails** — `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/rdw_ingest/promote.py
"""qa_state pending -> approved gate. Encodes the ingest ruleset (report §8): a per-TVV
mass fact is promotable when it has enough VINs, high within-TVV agreement, and is not
inside a cluster the 40kg span veto flagged (a clean single TVV value inside a vetoed
cluster still needs range presentation on render, not single-value promotion — that
render decision is Plan 4's job; this gate just withholds promotion so Plan 4 never sees
a falsely-confident single number)."""
MIN_N = 10
AGREE_FLAG = 0.80


def is_promotable(mass_row, cluster_veto):
    if cluster_veto:
        return False
    if mass_row.get("n", 0) < MIN_N:
        return False
    if mass_row.get("agreement", 0) < AGREE_FLAG:
        return False
    if mass_row.get("flags"):
        return False
    return True
```

  `promote_pending(conn, dry_run=True)` (I/O, not unit-tested live): `SELECT mh.*, GROUP_CONCAT
  cluster info FROM mass_homologations mh JOIN documents d ON d.id=mh.source_document_id WHERE
  d.doc_type='rdw_open' AND mh.qa_state='pending'`, re-derive `n`/`agreement`/`flags` either by
  re-reading them from a JSON sidecar written by `writer.py` at insert time (recommended — avoids
  recomputing) or by re-querying RDW (avoid — expensive, and could disagree with the value that
  was actually written). **Design decision: `writer.py` should stash `n`, `agreement`, and `flags`
  on the `mass_homologations` row's own audit trail** — since the current mig-579 schema has no
  column for this, use `conditions` (an existing free-text `VARCHAR(255)` column, e.g.
  `"n=50;agreement=0.95"`) as a stopgap, and flag this as a candidate field for the mig-580 add-on
  in Task 10 if a structured column proves worth adding.

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_promote.py -v` — PASS (5 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/promote.py scripts/rdw_ingest/tests/test_promote.py
git commit -m "feat(rdw-ingest): QA promotion gate (pending->approved per ingest ruleset)"
```

---

### Task 9: `trims.vehicle_type_id` backfill matcher

**Files:**
- Create: `scripts/rdw_ingest/trims_match.py`
- Create: `scripts/rdw_ingest/tests/test_trims_match.py`

**Interfaces:**
- Produces: `match_score(trim: dict, cluster: dict) -> float` (pure — 0.0–1.0 heuristic);
  `best_cluster_for_trim(trim, clusters, threshold=0.7) -> cluster|None` (pure); `backfill_trims
  (conn, generation_id, dry_run=True) -> report` (I/O).

Existing catalog `trims` rows have no TVV data — this is a best-effort match on the signals both
sides share: engine (motorcode via `engines.code`, or displacement+fuel as fallback),
transmission type, and body (via `trims`' existing body/label field). **Unmatched trims are left
alone (`vehicle_type_id` stays NULL) — never force a low-confidence match.**

- [ ] **Step 1: Write the failing test**

```python
# scripts/rdw_ingest/tests/test_trims_match.py
from scripts.rdw_ingest.trims_match import match_score, best_cluster_for_trim

TRIM = {"engine_code": "CJZA", "transmission": "manual", "gears": 6, "body": "hatchback"}
CLUSTER_MATCH = {"label": "CJZA 6MT hatchback", "cluster_key": "mc|CJZA|M|6|hatchback"}
CLUSTER_MISS = {"label": "DFGA 6MT hatchback", "cluster_key": "mc|DFGA|M|6|hatchback"}


def test_match_score_full_agreement_scores_high():
    assert match_score(TRIM, CLUSTER_MATCH) >= 0.9


def test_match_score_different_engine_scores_low():
    assert match_score(TRIM, CLUSTER_MISS) < 0.5


def test_best_cluster_for_trim_respects_threshold():
    assert best_cluster_for_trim(TRIM, [CLUSTER_MATCH, CLUSTER_MISS], threshold=0.7) == CLUSTER_MATCH
    assert best_cluster_for_trim(TRIM, [CLUSTER_MISS], threshold=0.7) is None
```

- [ ] **Step 2: Run test to verify it fails** — `ModuleNotFoundError`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/rdw_ingest/trims_match.py
"""Best-effort trims.vehicle_type_id backfill. Unmatched trims stay NULL — never force a
low-confidence link; a wrong link would silently misattribute document-verified masses to
the wrong marketed trim."""


def match_score(trim, cluster):
    key_parts = cluster["cluster_key"].split("|")  # ("mc", motorcode, trans, gears, body) or ("cc", ...)
    if key_parts[0] != "mc":
        return 0.0  # no motorcode on this cluster -> too weak a signal to match a catalog trim
    _, mc, tr, gears, body = key_parts
    score, weights = 0.0, 0.0
    for trim_val, cluster_val, weight in (
        (trim.get("engine_code"), mc, 0.5),
        (trim.get("transmission"), {"M": "manual", "A": "automatic"}.get(tr, tr), 0.2),
        (str(trim.get("gears")), gears, 0.1),
        (trim.get("body"), body, 0.2),
    ):
        weights += weight
        if trim_val and cluster_val and str(trim_val).lower() == str(cluster_val).lower():
            score += weight
    return score / weights if weights else 0.0


def best_cluster_for_trim(trim, clusters, threshold=0.7):
    scored = sorted(((match_score(trim, c), c) for c in clusters), key=lambda x: -x[0])
    if scored and scored[0][0] >= threshold:
        return scored[0][1]
    return None
```

  `backfill_trims(conn, generation_id, dry_run=True)` (I/O): `SELECT` trims for the generation +
  clusters for the generation (from Task 4's output, persisted — see Task 10), apply
  `best_cluster_for_trim`, then `UPDATE trims SET vehicle_type_id=%s WHERE id=%s` using the
  cluster's `dominant_vehicle_type_id`. Log every trim left unmatched for manual follow-up; do not
  treat an unmatched trim as an error.

- [ ] **Step 4: Run test to verify it passes**

  Run: `python -m pytest scripts/rdw_ingest/tests/test_trims_match.py -v` — PASS (3 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/rdw_ingest/trims_match.py scripts/rdw_ingest/tests/test_trims_match.py
git commit -m "feat(rdw-ingest): best-effort trims.vehicle_type_id backfill matcher"
```

---

### Task 10: Materialized cluster aggregates **[design-level — schema change requires sign-off]**

**Files:**
- Create (proposed, NOT auto-applied): `db/migrations/580_rdw_cluster_aggregates.sql`
- Create: `scripts/rdw_ingest/materialize.py`

**Why:** item 6 of this plan's brief — SSG build must not aggregate thousands of `vehicle_types`
rows at build time (the homepage already had to become `force-dynamic` once for a similar
correlated-subquery cost, per CLAUDE.md's SSG-timeout note; don't repeat that mistake pre-emptively
here). A rollup table lets any future render layer (Plan 4) do a single indexed lookup per
generation instead of a live `GROUP BY` over `vehicle_types`/`mass_homologations`.

- [ ] **Step 1: Author the proposed migration (do not apply without Tim's sign-off — this
  extends the migration-579 family of tables and should get the same review pass 579 got)**

```sql
-- db/migrations/580_rdw_cluster_aggregates.sql (PROPOSED — requires sign-off before applying)
-- Derived/rebuildable rollup, NOT a fact table: no provenance columns, no qa_state — it is
-- always safe to TRUNCATE + repopulate from vehicle_types + mass_homologations at any time.
CREATE TABLE IF NOT EXISTS vehicle_type_clusters (
  id                       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  generation_id            INT UNSIGNED NOT NULL,
  cluster_key              VARCHAR(160) NOT NULL,   -- "mc|<motorcode>|<trans>|<gears>|<body>"
  label                    VARCHAR(160) NOT NULL,
  n_tvv                    SMALLINT UNSIGNED NOT NULL,
  total_vins               INT UNSIGNED NOT NULL,
  dominant_vehicle_type_id INT UNSIGNED NULL,
  running_order_kg         SMALLINT UNSIGNED NULL,
  running_order_lo_kg      SMALLINT UNSIGNED NULL,
  running_order_hi_kg      SMALLINT UNSIGNED NULL,
  span_veto                TINYINT(1) NOT NULL DEFAULT 0,
  computed_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_vtc (generation_id, cluster_key),
  CONSTRAINT fk_vtc_gen FOREIGN KEY (generation_id) REFERENCES generations(id) ON DELETE CASCADE,
  CONSTRAINT fk_vtc_dom FOREIGN KEY (dominant_vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

- [ ] **Step 2: `materialize.py` — rebuild, don't incrementally patch**

  `rebuild_clusters(conn, generation_id, dry_run=True)`: read all approved `vehicle_types` +
  current `mass_homologations` for the generation, re-run `cluster.cluster_tvvs()` (Task 4) over
  them, then `DELETE FROM vehicle_type_clusters WHERE generation_id=%s` + bulk `INSERT` the fresh
  result. This is safe to run repeatedly (it's a derived table, not a fact) and should run as the
  last step of `ingest.py` for a cohort, and independently as a periodic "recompute all
  generations with approved facts" maintenance script.

- [ ] **Step 3: Explicitly out of scope for this task**

  Wiring `vehicle_type_clusters` into any `app/**` render is Plan 4's job. This task only
  produces and populates the table — confirm no `app/` file is touched.

- [ ] **Step 4: Commit (migration file only — do not run it against prod without Tim's go-ahead)**

```bash
git add db/migrations/580_rdw_cluster_aggregates.sql scripts/rdw_ingest/materialize.py
git commit -m "feat(rdw-ingest): propose migration 580 (cluster rollup table) + materializer"
```

---

### Task 11: Ops — CLI orchestrator + smoke/verify + runbook

**Files:**
- Create: `scripts/rdw_ingest/ingest.py`
- Modify: `F:\projects\ownerspecs\CLAUDE.md` (add the runbook section below to "Common
  operations" or a new "RDW ingest lane" section)

**Interfaces:**
- Produces: `ingest.py --cohort <key> [--dry-run|--commit] [--promote] [--materialize]` — one CLI
  entrypoint chaining Tasks 2–10 for a single cohort.

- [ ] **Step 1: `ingest.py` orchestration**

  ```
  1. cohort = COHORTS[args.cohort]; assert cohort["generation_id"] is not None (Task 5 gate)
  2. tvvs, pop = fetch.measure_tvvs(cohort)
  3. tvv_facts = [aggregate.fold_tvv(grp, MASS_FIELDS, MIN_N, AGREE_FLAG) for grp in tvvs.values()]
     + body via aggregate.body_from_handelsbenaming, + TGK enrichment (fetch.fetch_tgk_*)
     + motorcode/transmission maps
  4. clusters = cluster.cluster_tvvs(publishable_facts)
  5. conn = db.get_conn(); report = writer.write_cohort(conn, cohort["generation_id"],
     tvv_facts, clusters, dry_run=not args.commit)
  6. if args.promote: promote.promote_pending(conn, dry_run=not args.commit)
  7. if args.materialize: materialize.rebuild_clusters(conn, cohort["generation_id"],
     dry_run=not args.commit)
  8. print a summary: TVVs, clusters, vetoed clusters, facts inserted/closed/unchanged,
     promoted count. Write scripts/output/rdw_ingest_<cohort>.json (same convention as the
     prototype's output) for audit trail even on --dry-run.
  ```

- [ ] **Step 2: Ops prerequisites (checklist, not code)**

  - `RDW_APP_TOKEN` env var set (or fallback to `F:\projects\kentekenfeiten\.env`, same as the
    prototype and `scripts/dq`). Without it, RDW throttles to ~1000 req/hr — fine for one cohort,
    not for a batch run.
  - `soda()`'s existing 429-retry/backoff (from `scripts.dq.rdw_client`, reused per Task 2) is the
    only rate-limit handling needed — do not add a second one in `rdw_ingest`.
  - DB writes run **on the VPS** (`ssh -i ~/.ssh/autodtcs_key root@72.62.154.119`, `sudo -u deploy
    bash -c "cd /home/deploy/ownerspecs && set -a && source .env.local && set +a &&
    ./.venv-manuals/bin/python scripts/rdw_ingest/ingest.py --cohort kia-rio-yb --commit"`) — same
    pattern as `manual_query.py`'s VPS-local DB access (CLAUDE.md's manual-pipeline section). Code
    must be `scp`'d to the VPS first per the standard deploy-a-code-change recipe (this is a
    script, not the Next.js app, so no `npm run build`/`pm2 restart` needed — just land the files
    under `/home/deploy/ownerspecs/scripts/rdw_ingest/`).
  - Local dry-runs against a **local/tunnel** DB are possible via the existing
    `~/start-mariadb-tunnel.bat`-style tunnel (see CLAUDE.md's manual SSH tunnel note — port 3307,
    not the `.bat`'s 3306) if Tim wants to preview without touching the VPS directly; otherwise
    dry-run directly on the VPS is equally safe since `dry_run=True` never commits.
  - Curated cohort seeding: start with the 3 cohorts in Task 1 (Kia Rio — held CoC cross-check;
    VW Golf 7 — high-volume, exercises the exclude-list fix; Ford Mustang — exercises the
    exclude-list fix on the exact collision the report found), then expand from
    `generatie-curatie.tsv` one generation at a time, always doing the per-cohort
    `handelsbenaming` collision recon (Task 1 Step 1) before adding it.

- [ ] **Step 3: Smoke/verify step**

  After any `--commit` run: `SELECT COUNT(*) FROM vehicle_types WHERE generation_id=X`,
  `SELECT mass_kind, COUNT(*), AVG(value_kg) FROM mass_homologations WHERE generation_id=X AND
  valid_to IS NULL GROUP BY mass_kind`, and re-run the same cohort with `--dry-run` immediately
  after — expect `plan["inserts"]` and `plan["closes"]` to both be empty (true idempotency; if
  anything shows up, the writer has a determinism bug worth chasing before the next cohort).

- [ ] **Step 4: Commit**

```bash
git add scripts/rdw_ingest/ingest.py CLAUDE.md
git commit -m "feat(rdw-ingest): CLI orchestrator + ops runbook (RDW ingest lane)"
```

---

## Self-Review

**Reliability ruleset coverage (report §8):** `massa_rijklaar`/`technische_max`/`tow_braked`/
`tow_unbraked`/`max_combination` → publish-grade, TVV-scoped → Task 3 (`fold_tvv`) + Task 4
(mass-kind map) + Task 8 (promotion gate uses exactly the report's `n≥10, agreement≥0.80`
thresholds). `toegestane_maximum_massa_voertuig` → NL market-delta fact → Task 4's map includes it
as `max_laden_permissible`, distinct from the technical max. `inrichting` → rejected fleet-wide,
replaced by `handelsbenaming` discrimination → Task 3's `body_from_handelsbenaming`. Cohort
substring-collision operational note (§5.3, Mustang/Mach-E) → Task 1's `exclude` list + explicit
test + a named `ford-mustang` cohort exercising exactly that case.

**Agreement-grain fix (report §5.4) — the plan's core correctness fix:** Task 3's
`test_fold_tvv_agreement_is_within_one_tvv_group_not_across_tvvs` is a literal regression guard
encoding the exact failure mode the harness hit (12/12, 11/11, 10/11 false `low_agreement` flags)
and proves the fix by computing the wrong (pooled) number inline and asserting it would have
failed the 0.80 bar while the correct per-TVV numbers pass. Task 8's promotion gate consumes only
per-TVV `agreement`/`n`/`flags` — never a cohort-pooled number — closing the loop from computation
through to the qa_state gate that controls render-eligibility.

**Weight-presentation policy (report §6 / memory `reference_rdw_field_semantics.md`):**
`massa_rijklaar` flows to `mass_kind='running_order'`, publish-eligible, matching "headline weight,
CoC-traceable". `massa_ledig_voertuig` is explicitly kept OUT of `mass_homologations` (Task 4's
mapping table has no row sending it there) and is only discussed as a possible future
`spec_facts` addition with an isolating `fact_type`/`qualifier` so it can never be silently joined
into a weight block — Task 4 flags this as needing confirmation rather than writing it
speculatively, which is the conservative reading of "publish-as-derived, reject from the
weight/spec block" until a render consumer (Plan 4) actually needs the NL-registration box.
`massa_ledig` is never used in any promotion, clustering, or payload-adjacent calculation anywhere
in this plan.

**Idempotency:** Task 6's `plan_mass_writes` is the single diff mechanism reused by both the mass
writer (Task 7) and the axle `spec_facts` writer (Task 7 Step 2.8) and is unit-tested for all
three cases (insert/no-op/version-forward). Task 7 additionally makes `documents` creation
conditional on a non-empty plan, so a full re-run of an unchanged cohort writes literally nothing.

**Scope discipline:** no task in this plan edits any file under `app/`, no task runs `npm run
build` or `pm2 restart`, and Task 10 explicitly calls out that wiring the new rollup table into a
render is out of scope. The Scope note at the top and the Global Constraints both restate this so
an agentic worker can't drift into Plan 4/5 territory mid-task.

**Open items surfaced (not blocking, flagged for Tim/panel):**
1. `mass_homologations.mass_kind` vocabulary extension (Task 4) — new values
   `max_laden_technical`/`max_laden_permissible` beyond the migration-579 comment's `max_laden` —
   worth a one-line confirmation since Plan 3 (CoC pipeline) shares this column.
2. Whether `massa_ledig_voertuig` gets written at all in Plan 2, and if so under which new
   `fact_type` (Task 4) — currently designed as "flag and defer," not "write speculatively."
3. `mass_homologations` has no structured column for `n`/`agreement` audit trail; Task 8 proposes
   overloading the free-text `conditions` column as a stopgap and flags a structured column as a
   migration-580 candidate — needs a decision before Task 8's `promote_pending` is implemented for
   real (the pure `is_promotable()` core doesn't care where the inputs come from, so this doesn't
   block Tasks 1–9).
4. `resolve_generation_id` (Task 5) is deliberately manual-confirm — this means cohort onboarding
   has a human step that doesn't disappear as the cohort list grows; acceptable for the curated,
   low-volume rollout this plan targets, but worth knowing it doesn't scale to "ingest every
   generatie-curatie.tsv row unattended."
