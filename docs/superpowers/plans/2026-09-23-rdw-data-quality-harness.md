# RDW Data-Quality Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable, tested harness that scores the reliability of each RDW open-data field for a sample of vehicles, triangulating four independent signals, and emits a per-field scorecard (publish / corroborate / reject).

**Architecture:** A small Python package `scripts/dq/` with a PURE scoring core (fill-rate, within-TVV agreement, reality anchors, CoC-gold match, cross-source, verdict aggregation) that is fully unit-tested, plus a thin Socrata fetch client and a CLI (`audit.py`) that wires the signals over a curated ~12–15 vehicle sample and writes a JSON + Markdown scorecard. The pure core has no I/O so it is deterministically testable; live-fetch stays in the thin client.

**Tech Stack:** Python 3 (stdlib only: `urllib`, `json`, `collections`, `statistics`), `pytest` for tests. RDW Socrata JSON API. No new runtime deps.

## Global Constraints

- Python stdlib only — no `requests`/`pandas`; use `urllib.request` + `json` (matches existing `scripts/*.py`). One line each, verbatim from the spec/repo:
- RDW app token read from env `RDW_APP_TOKEN`, fallback to `F:\projects\kentekenfeiten\.env` (same as `scripts/rdw_masses_prototype.py`).
- RDW open data is **CC0** → citable, `public_link=1`. Never store raw VIN; work at TVV/cohort grain.
- The scoring core (`scripts/dq/scoring.py`) MUST be pure (no network, no file I/O, no clock) so tests are deterministic.
- Run all commands with the repo's Python via PowerShell (Bash tool strips `F:\` backslashes): `python scripts\...`. Tests: `python -m pytest scripts/dq/tests -v`.
- Verdict thresholds (spec §5): fill_rate < 0.5 → low_fill; within-TVV agreement < 0.80 → low_agreement; range conformance < 0.95 → out_of_range; any CoC mismatch, out-of-range, or missing-expected-value → **reject**; any lesser flag → **corroborate**; clean → **publish**.

---

### Task 1: Scoring core — presence, fill-rate, modal agreement

**Files:**
- Create: `scripts/dq/__init__.py`
- Create: `scripts/dq/scoring.py`
- Create: `scripts/dq/tests/__init__.py`
- Create: `scripts/dq/tests/test_scoring.py`
- Create: `scripts/dq/tests/conftest.py`

**Interfaces:**
- Produces: `is_present(value) -> bool`; `fill_rate(rows: list[dict], field: str) -> float`; `modal_agreement(values: list) -> tuple[value|None, float, int]` returning `(modal_value, agreement_fraction, n_present)`.

- [ ] **Step 1: Write the failing test**

```python
# scripts/dq/tests/test_scoring.py
from scripts.dq.scoring import is_present, fill_rate, modal_agreement


def test_is_present():
    assert is_present("1600") is True
    assert is_present(0) is True          # numeric zero is a value at this layer
    assert is_present(None) is False
    assert is_present("") is False
    assert is_present("   ") is False


def test_fill_rate():
    rows = [{"m": "1"}, {"m": ""}, {"m": "3"}, {"m": None}]
    assert fill_rate(rows, "m") == 0.5
    assert fill_rate([], "m") == 0.0


def test_modal_agreement():
    assert modal_agreement(["a", "a", "a", "b"]) == ("a", 0.75, 4)
    assert modal_agreement([]) == (None, 0.0, 0)
    assert modal_agreement([None, "", "x"]) == ("x", 1.0, 1)
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: FAIL with `ModuleNotFoundError: No module named 'scripts.dq.scoring'`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/dq/__init__.py
# (empty — package marker)
```

```python
# scripts/dq/tests/__init__.py
# (empty — package marker)
```

```python
# scripts/dq/tests/conftest.py
import os
import sys

# Make the repo root importable so `import scripts.dq.scoring` works from anywhere.
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..")))
```

```python
# scripts/dq/scoring.py
"""Pure reliability-scoring functions for the RDW data-quality harness.

No network, no file I/O, no clock — deterministic and unit-tested. The thin
fetch client (rdw_client.py) and the CLI (audit.py) supply the row data.
"""
from collections import Counter


def is_present(value):
    """A value counts as present if it is not None and not an empty/whitespace string.
    Numeric zero IS present here; field-specific 'zero means missing' is handled by callers."""
    if value is None:
        return False
    return str(value).strip() != ""


def fill_rate(rows, field):
    """Fraction of rows whose `field` is present. Empty rows -> 0.0."""
    if not rows:
        return 0.0
    return sum(1 for r in rows if is_present(r.get(field))) / len(rows)


def modal_agreement(values):
    """(modal_value, agreement_fraction, n_present) over present values only."""
    present = [v for v in values if is_present(v)]
    if not present:
        return (None, 0.0, 0)
    val, cnt = Counter(present).most_common(1)[0]
    return (val, cnt / len(present), len(present))
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: PASS (3 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/dq/__init__.py scripts/dq/scoring.py scripts/dq/tests/
git commit -m "feat(dq): scoring core — presence, fill-rate, modal agreement"
```

---

### Task 2: Reality anchors — range conformance & expected-presence (the body-bug catcher)

**Files:**
- Modify: `scripts/dq/scoring.py`
- Modify: `scripts/dq/tests/test_scoring.py`

**Interfaces:**
- Consumes: `is_present`, `modal_agreement` (Task 1).
- Produces: `range_conformance(rows, field, lo, hi) -> float|None` (fraction of present numeric values within `[lo,hi]`; `None` if no numeric values); `expected_presence(rows, field, must_include, min_share=0.01) -> list` (returns the `must_include` values whose observed share is below `min_share` — i.e. the ones RDW is suspiciously missing, e.g. `hatchback` for a Golf).

- [ ] **Step 1: Write the failing test**

```python
# append to scripts/dq/tests/test_scoring.py
from scripts.dq.scoring import range_conformance, expected_presence


def test_range_conformance():
    rows = [{"kg": "1600"}, {"kg": "1700"}, {"kg": "50"}, {"kg": ""}]
    # 2 of 3 present numerics within [500,4000]; the 50 is out of range
    assert range_conformance(rows, "kg", 500, 4000) == 2 / 3
    assert range_conformance([{"kg": ""}], "kg", 500, 4000) is None


def test_expected_presence_flags_the_body_bug():
    # 99 wagons, 1 hatchback -> hatchback share 0.01 which is NOT below min_share 0.02 -> flagged
    rows = [{"body": "stationwagen"}] * 99 + [{"body": "hatchback"}] * 1
    missing = expected_presence(rows, "body", must_include=["hatchback"], min_share=0.02)
    assert missing == ["hatchback"]
    # when hatchback is well represented, nothing is flagged
    rows2 = [{"body": "stationwagen"}] * 60 + [{"body": "hatchback"}] * 40
    assert expected_presence(rows2, "body", must_include=["hatchback"], min_share=0.02) == []
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: FAIL with `ImportError: cannot import name 'range_conformance'`

- [ ] **Step 3: Write minimal implementation**

```python
# append to scripts/dq/scoring.py

def _as_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def range_conformance(rows, field, lo, hi):
    """Fraction of present, numeric `field` values within [lo, hi]. None if no numerics.
    Catches physically impossible values (e.g. a 50 kg car mass)."""
    nums = [_as_float(r.get(field)) for r in rows if is_present(r.get(field))]
    nums = [n for n in nums if n is not None]
    if not nums:
        return None
    return sum(1 for n in nums if lo <= n <= hi) / len(nums)


def expected_presence(rows, field, must_include, min_share=0.01):
    """Return the `must_include` values whose observed share among present values is
    below `min_share`. Catches internally-consistent mis-coding that agreement misses —
    e.g. a Golf cohort with ~0% 'hatchback' because RDW mis-codes body as 'stationwagen'."""
    present = [str(r.get(field)).strip() for r in rows if is_present(r.get(field))]
    total = len(present)
    if total == 0:
        return list(must_include)
    counts = Counter(present)
    return [v for v in must_include if counts.get(v, 0) / total < min_share]
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: PASS (5 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/dq/scoring.py scripts/dq/tests/test_scoring.py
git commit -m "feat(dq): reality anchors — range conformance + expected-presence (body-bug catcher)"
```

---

### Task 3: Cross-check signals — CoC-gold match & cross-source range

**Files:**
- Modify: `scripts/dq/scoring.py`
- Modify: `scripts/dq/tests/test_scoring.py`

**Interfaces:**
- Consumes: `_as_float` (Task 2).
- Produces: `coc_match(rdw_value, coc_value, tol=0) -> bool|None` (None if either side absent); `within_cross_range(value, lo, hi) -> bool|None` (is a value inside a trusted external cohort range, e.g. kentekenfeiten min/max; None if inputs absent).

- [ ] **Step 1: Write the failing test**

```python
# append to scripts/dq/tests/test_scoring.py
from scripts.dq.scoring import coc_match, within_cross_range


def test_coc_match():
    assert coc_match("1160", 1160) is True          # RDW string vs CoC int
    assert coc_match("1155", 1160, tol=10) is True   # within tolerance
    assert coc_match("900", 1110) is False
    assert coc_match(None, 1110) is None
    assert coc_match("AB", "AB") is True             # text equality fallback


def test_within_cross_range():
    assert within_cross_range("1600", 1500, 1700) is True
    assert within_cross_range("1900", 1500, 1700) is False
    assert within_cross_range(None, 1500, 1700) is None
    assert within_cross_range("1600", None, None) is None
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: FAIL with `ImportError: cannot import name 'coc_match'`

- [ ] **Step 3: Write minimal implementation**

```python
# append to scripts/dq/scoring.py

def coc_match(rdw_value, coc_value, tol=0):
    """True if RDW value matches the held-CoC gold value. Numeric compare within `tol`
    when both parse as numbers; else case-insensitive text equality. None if either absent."""
    if not is_present(rdw_value) or coc_value is None or not is_present(coc_value):
        return None
    a, b = _as_float(rdw_value), _as_float(coc_value)
    if a is not None and b is not None:
        return abs(a - b) <= tol
    return str(rdw_value).strip().lower() == str(coc_value).strip().lower()


def within_cross_range(value, lo, hi):
    """True if `value` falls within a trusted external cohort range [lo, hi]
    (e.g. kentekenfeiten content/modellen min/max). None if value or bounds absent."""
    n = _as_float(value)
    if n is None or lo is None or hi is None:
        return None
    return lo <= n <= hi
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest scripts/dq/tests/test_scoring.py -v`
Expected: PASS (7 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/dq/scoring.py scripts/dq/tests/test_scoring.py
git commit -m "feat(dq): cross-check signals — CoC-gold match + cross-source range"
```

---

### Task 4: Verdict aggregator

**Files:**
- Create: `scripts/dq/verdict.py`
- Create: `scripts/dq/tests/test_verdict.py`

**Interfaces:**
- Produces: `field_verdict(signals: dict) -> dict` with keys `verdict` ∈ `{"publish","corroborate","reject"}` and `reasons: list[str]`. Input `signals` keys (all optional except fill_rate/agreement): `fill_rate: float`, `agreement: float|None`, `range_ok: float|None`, `coc_match: bool|None`, `cross_ok: bool|None`, `expected_missing: list`.

- [ ] **Step 1: Write the failing test**

```python
# scripts/dq/tests/test_verdict.py
from scripts.dq.verdict import field_verdict


def test_clean_field_publishes():
    v = field_verdict({"fill_rate": 0.99, "agreement": 0.99, "range_ok": 1.0,
                       "coc_match": True, "cross_ok": True, "expected_missing": []})
    assert v["verdict"] == "publish"
    assert v["reasons"] == []


def test_low_fill_downgrades_to_corroborate():
    v = field_verdict({"fill_rate": 0.3, "agreement": 0.99})
    assert v["verdict"] == "corroborate"
    assert "low_fill" in v["reasons"]


def test_coc_mismatch_rejects():
    v = field_verdict({"fill_rate": 0.99, "agreement": 0.99, "coc_match": False})
    assert v["verdict"] == "reject"
    assert "coc_mismatch" in v["reasons"]


def test_missing_expected_rejects_body_bug():
    v = field_verdict({"fill_rate": 1.0, "agreement": 0.99, "expected_missing": ["hatchback"]})
    assert v["verdict"] == "reject"
    assert "expected_values_missing" in v["reasons"]


def test_out_of_range_rejects():
    v = field_verdict({"fill_rate": 1.0, "agreement": 0.99, "range_ok": 0.80})
    assert v["verdict"] == "reject"
    assert "out_of_range" in v["reasons"]
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest scripts/dq/tests/test_verdict.py -v`
Expected: FAIL with `ModuleNotFoundError: No module named 'scripts.dq.verdict'`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/dq/verdict.py
"""Aggregate per-field reliability signals into a publish/corroborate/reject verdict.

Thresholds are the spec §5 Global Constraints. A hard failure (CoC mismatch,
out-of-range, or a missing expected value — the internally-consistent mis-coding
class) rejects; softer flags downgrade to corroborate; a clean field publishes.
"""

FILL_MIN = 0.5
AGREEMENT_MIN = 0.80
RANGE_MIN = 0.95

_HARD = {"coc_mismatch", "out_of_range", "expected_values_missing", "cross_source_conflict"}


def field_verdict(signals):
    reasons = []
    if signals.get("fill_rate", 0.0) < FILL_MIN:
        reasons.append("low_fill")
    agreement = signals.get("agreement")
    if agreement is not None and agreement < AGREEMENT_MIN:
        reasons.append("low_agreement")
    range_ok = signals.get("range_ok")
    if range_ok is not None and range_ok < RANGE_MIN:
        reasons.append("out_of_range")
    if signals.get("coc_match") is False:
        reasons.append("coc_mismatch")
    if signals.get("cross_ok") is False:
        reasons.append("cross_source_conflict")
    if signals.get("expected_missing"):
        reasons.append("expected_values_missing")

    if any(r in _HARD for r in reasons):
        verdict = "reject"
    elif reasons:
        verdict = "corroborate"
    else:
        verdict = "publish"
    return {"verdict": verdict, "reasons": reasons}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest scripts/dq/tests/test_verdict.py -v`
Expected: PASS (5 passed)

- [ ] **Step 5: Commit**

```bash
git add scripts/dq/verdict.py scripts/dq/tests/test_verdict.py
git commit -m "feat(dq): verdict aggregator (publish/corroborate/reject)"
```

---

### Task 5: RDW client + sample definition + audit CLI

**Files:**
- Create: `scripts/dq/rdw_client.py`
- Create: `scripts/dq/sample.py`
- Create: `scripts/dq/audit.py`
- Create: `scripts/dq/tests/test_audit.py`

**Interfaces:**
- Consumes: everything from `scoring.py` + `verdict.py`.
- Produces: `rdw_client.soda(ds, params) -> list[dict]`, `rdw_client.token() -> str|None`; `sample.SAMPLE -> list[dict]` (each: `key`, `merk`, `hb` list, `date_van`, `date_tot`, optional `coc` dict, optional `expected_body` list, `cross_ranges` dict); `audit.score_cohort(rows, spec) -> dict` (pure: field -> verdict); `audit.main()` (CLI).

- [ ] **Step 1: Write the failing test** (pure `score_cohort`, no network)

```python
# scripts/dq/tests/test_audit.py
from scripts.dq.audit import score_cohort


def test_score_cohort_flags_body_and_passes_mass():
    rows = [{"massa_rijklaar": "1160", "inrichting": "stationwagen"}] * 99 + \
           [{"massa_rijklaar": "1160", "inrichting": "hatchback"}] * 1
    spec = {
        "fields": {
            "massa_rijklaar": {"lo": 500, "hi": 4000, "coc": 1160},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
        }
    }
    out = score_cohort(rows, spec)
    assert out["massa_rijklaar"]["verdict"] == "publish"
    assert out["inrichting"]["verdict"] == "reject"
    assert "expected_values_missing" in out["inrichting"]["reasons"]
```

- [ ] **Step 2: Run test to verify it fails**

Run: `python -m pytest scripts/dq/tests/test_audit.py -v`
Expected: FAIL with `ModuleNotFoundError: No module named 'scripts.dq.audit'`

- [ ] **Step 3: Write minimal implementation**

```python
# scripts/dq/rdw_client.py
"""Thin RDW Socrata client (token + GET with 429 retry). Copied from
scripts/rdw_masses_prototype.py to keep the dq package self-contained."""
import json
import os
import re
import time
import urllib.parse
import urllib.request

R = "https://opendata.rdw.nl/resource"
KF_ENV = r"F:\projects\kentekenfeiten\.env"


def token():
    if os.environ.get("RDW_APP_TOKEN"):
        return os.environ["RDW_APP_TOKEN"]
    try:
        with open(KF_ENV, encoding="utf-8") as f:
            m = re.search(r"^RDW_APP_TOKEN=(.+)$", f.read(), re.M)
            return m.group(1).strip() if m else None
    except OSError:
        return None


_TOKEN = token()


def soda(ds, params):
    url = f"{R}/{ds}.json?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"Accept": "application/json"})
    if _TOKEN:
        req.add_header("X-App-Token", _TOKEN)
    for attempt in range(1, 6):
        try:
            with urllib.request.urlopen(req, timeout=60) as res:
                return json.load(res)
        except urllib.error.HTTPError as e:
            if e.code == 429:
                time.sleep(2 * attempt)
                continue
            raise
    raise RuntimeError(f"SODA {ds} kept failing")
```

```python
# scripts/dq/sample.py
"""The ~12-15 representative vehicle cross-section for the RDW data-quality audit.
Brands x segments x fuels x bodies + an import-heavy model + the cars we hold CoCs for.
`coc` values are gold ground-truth from held CoCs; `expected_body` lists body types the
model is KNOWN to offer (the external reality anchor); `cross_ranges` are trusted external
min/max (kentekenfeiten cohorts) for the cross-source signal. Extend as CoCs arrive."""

SAMPLE = [
    {
        "key": "kia-rio-yb", "merk": "KIA", "hb": ["RIO"],
        "date_van": "20110101", "date_tot": "20180101",
        "fields": {
            "massa_rijklaar": {"lo": 700, "hi": 2000, "coc": 1160, "coc_tvv": ("B5P11", "M61BZ1")},
            "maximum_trekken_massa_geremd": {"lo": 0, "hi": 2500},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.02},
        },
    },
    {
        "key": "vw-golf-7", "merk": "VOLKSWAGEN", "hb": ["GOLF"],
        "date_van": "20121101", "date_tot": "20201231",
        "fields": {
            "massa_rijklaar": {"lo": 900, "hi": 2200},
            "inrichting": {"expected_body": ["hatchback"], "min_share": 0.05},
        },
    },
    # TODO(sample): add ~10 more — a diesel, an EV, an MPV, a pickup/import-heavy model,
    # and the remaining CoC cars (Tucson, Sportage, i20, CX-5, Auris, Pulsar). Each entry
    # is data, not logic; adding one requires no code change.
]
```

```python
# scripts/dq/audit.py
"""CLI: run the 4-signal reliability audit over the sample, emit a scorecard.

score_cohort() is PURE (rows + spec -> per-field verdicts) and unit-tested.
main() does the live RDW fetch per sample entry and writes JSON + Markdown.
"""
import json
import os
import sys

from scripts.dq import rdw_client
from scripts.dq.sample import SAMPLE
from scripts.dq.scoring import (fill_rate, modal_agreement, range_conformance,
                                expected_presence, coc_match, within_cross_range)
from scripts.dq.verdict import field_verdict

OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "output")


def score_cohort(rows, spec):
    """Pure: given cohort rows and a spec, return {field: verdict-dict}."""
    result = {}
    for field, cfg in spec["fields"].items():
        signals = {"fill_rate": fill_rate(rows, field)}
        values = [r.get(field) for r in rows]
        _, agreement, _ = modal_agreement(values)
        signals["agreement"] = agreement if agreement else None
        if "lo" in cfg and "hi" in cfg:
            signals["range_ok"] = range_conformance(rows, field, cfg["lo"], cfg["hi"])
        if "expected_body" in cfg:
            signals["expected_missing"] = expected_presence(
                rows, field, cfg["expected_body"], cfg.get("min_share", 0.01))
        if "coc" in cfg:
            modal_val, _, _ = modal_agreement(values)
            signals["coc_match"] = coc_match(modal_val, cfg["coc"], cfg.get("tol", 5))
        if "cross_lo" in cfg and "cross_hi" in cfg:
            modal_val, _, _ = modal_agreement(values)
            signals["cross_ok"] = within_cross_range(modal_val, cfg["cross_lo"], cfg["cross_hi"])
        result[field] = {**field_verdict(signals), "signals": signals}
    return result


def _where(entry):
    hb = " or ".join(f"upper(handelsbenaming) like '%{s.upper()}%'" for s in entry["hb"])
    return (f"merk='{entry['merk']}' and ({hb}) and voertuigsoort='Personenauto' "
            f"and datum_eerste_toelating>='{entry['date_van']}' "
            f"and datum_eerste_toelating<'{entry['date_tot']}'")


def main():
    scorecard = {}
    for entry in SAMPLE:
        fields = ",".join(["variant", "uitvoering", "inrichting", "handelsbenaming"] +
                          [f for f in entry["fields"] if f not in ("inrichting",)])
        rows = rdw_client.soda("m9d7-ebf2", {"$select": fields, "$where": _where(entry),
                                             "$limit": "2000"})
        scorecard[entry["key"]] = {"n": len(rows), "fields": score_cohort(rows, entry)}
        verdicts = {f: v["verdict"] for f, v in scorecard[entry["key"]]["fields"].items()}
        print(f"{entry['key']}: n={len(rows)} {verdicts}")
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, "rdw_dq_scorecard.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(scorecard, f, ensure_ascii=False, indent=2)
    print(f"wrote {path}")


if __name__ == "__main__":
    main()
```

- [ ] **Step 4: Run test to verify it passes**

Run: `python -m pytest scripts/dq/tests/test_audit.py -v`
Expected: PASS (1 passed)

- [ ] **Step 5: Run the full suite + a live smoke of the CLI**

Run: `python -m pytest scripts/dq -v`
Expected: PASS (all tasks' tests green)
Run: `python scripts\dq\audit.py`
Expected: prints a verdict line per sample entry (e.g. `kia-rio-yb: n=... {'massa_rijklaar': 'publish', 'inrichting': 'reject', ...}`) and writes `scripts/output/rdw_dq_scorecard.json`. The `inrichting` reject on Golf/Rio confirms the harness reproduces the known body-field defect.

- [ ] **Step 6: Commit**

```bash
git add scripts/dq/rdw_client.py scripts/dq/sample.py scripts/dq/audit.py scripts/dq/tests/test_audit.py
git commit -m "feat(dq): RDW client + representative sample + audit CLI (scorecard)"
```

---

### Task 6: Expand the sample + produce the first data-quality report

**Files:**
- Modify: `scripts/dq/sample.py`
- Create: `docs/superpowers/specs/2026-09-23-rdw-field-reliability-report.md`

**Interfaces:**
- Consumes: the audit CLI + scorecard from Task 5.

- [ ] **Step 1: Fill the sample to ~12-15 entries**

Add entries to `scripts/dq/sample.py` `SAMPLE` covering: one diesel (e.g. `PEUGEOT 3008`), one BEV (`TESLA MODEL 3` or `KIA E-NIRO`), one MPV, one import-heavy model (`VOLKSWAGEN TRANSPORTER` or a US import), and the remaining CoC cars (`HYUNDAI TUCSON`, `KIA SPORTAGE`, `HYUNDAI I20`, `MAZDA CX-5`, `TOYOTA AURIS`, `NISSAN PULSAR`) with their held-CoC `coc` gold values and `expected_body` anchors. Each entry is pure data.

- [ ] **Step 2: Run the audit**

Run: `python scripts\dq\audit.py`
Expected: a verdict line per entry + updated `scripts/output/rdw_dq_scorecard.json`.

- [ ] **Step 3: Write the reliability report**

From the scorecard, write `docs/superpowers/specs/2026-09-23-rdw-field-reliability-report.md`: a table of `field × verdict` across the sample, the systematic vs brand-specific findings (e.g. `inrichting` reject fleet-wide → use `handelsbenaming`; masses/towing/axle publish; tow-ball absent), and the resulting **ingest ruleset** (which RDW fields are publish-grade, which need corroboration, which are rejected and must come from CoC/another source).

- [ ] **Step 4: Commit**

```bash
git add scripts/dq/sample.py docs/superpowers/specs/2026-09-23-rdw-field-reliability-report.md scripts/output/rdw_dq_scorecard.json
git commit -m "docs(dq): first RDW field-reliability report + ingest ruleset"
```

---

## Parallel research track (non-TDD): government-source landscape

Not a code deliverable — a research report. Dispatch research agents (or desk research) to map national + international **government** vehicle-data sources and produce `docs/superpowers/specs/2026-09-23-gov-source-landscape.md`:
- Per source (NL RDW, DE **KBA**, BE registration, EU type-approval / EUCARIS, **US NHTSA vPIC + GVWR**, **US EPA fuel economy**): fields offered, per-field reliability, openness + licence, and access method (API/bulk).
- Verdict per source for each purpose: cross-validation of RDW · gap-filling (tyres/kogeldruk) · market expansion (DE/BE) · US Moat-A support.
Runs concurrently with the harness; no code dependency.

---

## Follow-up plans (separate specs, sequenced after this one)

1. **RDW lane productionization** — promote `scripts/rdw_masses_prototype.py` to the ingest that writes `mass_homologations` + `spec_facts` (applies the ruleset from Task 6; clustering + 40 kg veto).
2. **CoC continuous-ingest pipeline** — ongoing intake (Tim shares CoCs regularly): parse (per-brand §52 dialects) → `documents`/`document_fields` → `vehicle_types` + wedge facts; each CoC also a gold cross-check for the harness sample.
3. **Moat A OEM-manual extraction** — top US/global models → `spec_facts` with manual/FSM citations (facts-only).
4. **Render layer + publish-rule** — the `no-citation → no page` / `noindex < 3 datapoints` discipline, per-value citations, trim-cluster pages with dominant + range.

## Self-Review

**Spec coverage (§5 validation plan):** 4-signal triangulation → Tasks 1-3 (agreement+fill / anchors / CoC+cross); verdict ruleset → Task 4; ~12-15 sample → Task 5 (`sample.py`) + Task 6; per-field scorecard + ingest ruleset → Task 6; gov-source landscape incl. US federal → parallel research track; Moat A OEM extraction validation → deferred to follow-up plan 3 (noted). Body-field defect reproduction → Task 5 Step 5 smoke.

**Placeholder scan:** the only `TODO` is `sample.py`'s "add ~10 more" — that is data, explicitly completed in Task 6 Step 1, not a code gap. All code steps carry complete code.

**Type consistency:** `modal_agreement` returns `(value, fraction, n)` and is destructured consistently in Task 5. `field_verdict(signals) -> {"verdict","reasons"}` matches Task 4 tests and Task 5 usage. `score_cohort(rows, spec) -> {field: {...verdict, signals}}` matches Task 5 test and Task 6 report. `soda`/`token` signatures match Task 5.
