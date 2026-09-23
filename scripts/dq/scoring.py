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
