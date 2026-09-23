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
