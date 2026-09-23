from scripts.dq.scoring import is_present, fill_rate, modal_agreement, range_conformance, expected_presence, coc_match, within_cross_range


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
