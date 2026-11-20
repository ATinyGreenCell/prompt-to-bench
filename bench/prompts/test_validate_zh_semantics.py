"""Regression on non-numeric reversals in the translated CAD specification.

Run: python -m unittest -v bench.prompts.test_validate_zh_semantics
"""
import unittest
from pathlib import Path
import yaml

from bench.prompts.validate_zh_semantics import REQUIRED, audit_semantics

ROOT = Path(__file__).resolve().parents[2]


class ChinesePhysicalSemanticsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.translations = yaml.safe_load(
            (ROOT / "bench/prompts/translations.yaml").read_text(encoding="utf-8")
        )

    def test_exact_16_task_anchor_inventory(self):
        self.assertEqual(len(REQUIRED), 16)
        self.assertGreaterEqual(sum(map(len, REQUIRED.values())), 45)
        self.assertEqual(audit_semantics(self.translations), [])

    def assert_detects_reversal(self, task_id, old, new):
        zh = dict(self.translations["zh"])
        original = zh[task_id]
        self.assertIn(old, original, f"Review anchor changed for {task_id}")
        zh[task_id] = original.replace(old, new, 1)
        defects = audit_semantics({"zh": zh})
        self.assertTrue(
            any(task_id in d and old in d for d in defects), defects
        )

    def test_blind_hole_mislabeled_as_through_hole(self):
        self.assert_detects_reversal("tube_rack_1p5ml", "盲孔", "通孔")

    def test_closed_floor_reversed_to_open_floor(self):
        self.assert_detects_reversal("tube_rack_1p5ml", "底部封闭", "底部敞开")

    def test_inverted_print_position_disappears(self):
        self.assert_detects_reversal("conical_rack_50ml", "倒置", "正立")

    def test_side_walls_closed_instead_of_open(self):
        self.assert_detects_reversal("conical_rack_50ml", "通孔", "盲孔")

    def test_funnel_openings_reversed(self):
        self.assert_detects_reversal(
            "lab_funnel_60mm", "顶部和底部都必须敞开", "顶部和底部都必须封闭"
        )

    def test_adapter_through_bore_reversed(self):
        self.assert_detects_reversal("pcr_tube_adapter", "直通孔", "盲孔")

    def test_rod_clip_blocks_hole(self):
        self.assert_detects_reversal("rod_tubing_clip", "不得阻塞", "应当阻塞")

    def test_gel_tank_chambers_disconnected(self):
        self.assert_detects_reversal("mini_gel_tank", "上方连通", "上方隔断")

    def test_anchored_but_contradictory_through_hole_is_rejected(self):
        # The required "blind hole" and "closed floor" anchors are intact.
        zh = dict(self.translations["zh"])
        zh["tube_rack_1p5ml"] += " 注意：所有孔都应为通孔。"
        issues = audit_semantics({"zh": zh})
        self.assertTrue(
            any("tube_rack_1p5ml: contradictory physical instruction" in e for e in issues),
            issues,
        )

    def test_anchored_but_contradictory_funnel_is_rejected(self):
        zh = dict(self.translations["zh"])
        zh["lab_funnel_60mm"] += " 另：漏斗顶部和底部都必须封闭。"
        issues = audit_semantics({"zh": zh})
        self.assertTrue(
            any("lab_funnel_60mm: contradictory physical instruction" in e for e in issues),
            issues,
        )

    def test_anchored_but_contradictory_clip_bridge_is_rejected(self):
        zh = dict(self.translations["zh"])
        zh["rod_tubing_clip"] += " 另：连接桥应阻塞孔。"
        issues = audit_semantics({"zh": zh})
        self.assertTrue(
            any("rod_tubing_clip: contradictory physical instruction" in e for e in issues),
            issues,
        )

    def test_unmodified_chinese_prompts_have_no_contradictions(self):
        self.assertEqual(audit_semantics(self.translations), [])

    def test_unknown_translation_mapping_fails(self):
        with self.assertRaisesRegex(ValueError, "Missing zh"):
            audit_semantics({"en": {}})


if __name__ == "__main__":
    unittest.main()
