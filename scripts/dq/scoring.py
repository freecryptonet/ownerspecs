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
