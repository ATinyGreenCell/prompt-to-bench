"""Regression tests for Chinese task prompt constraint preservation.

Run from repository root: python -m unittest bench.prompts.test_validate_zh
No benchmark model execution is performed by these unit tests.
"""
import tempfile
import unittest
from pathlib import Path

import yaml

from bench.prompts.validate_zh import audit


class TranslationConstraintTests(unittest.TestCase):
    ENGLISH = "Place a rail at x = -25 mm along -Y, with 2 mm thickness."
    CHINESE = "将导轨设在 x = -25 mm，沿 -Y 方向，厚度为 2 mm。"

    def audit_pair(self, english, chinese):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            task_file.write_text(
                yaml.safe_dump([{"id": "rail_fixture", "prompt": english}], allow_unicode=True),
                encoding="utf-8",
            )
            trans_file.write_text(
                yaml.safe_dump({"zh": {"rail_fixture": chinese}}, allow_unicode=True),
                encoding="utf-8",
            )
            return audit(task_file, trans_file)

    def test_preserves_signed_geometry(self):
        total, problems = self.audit_pair(self.ENGLISH, self.CHINESE)
        self.assertEqual(total, 1)
        self.assertEqual(problems, [])

    def test_negative_coordinate_losing_sign_is_rejected(self):
        total, problems = self.audit_pair(
            self.ENGLISH, self.CHINESE.replace("x = -25", "x = 25")
        )
        self.assertEqual(total, 1)
        self.assertTrue(any("signed numbers" in item for item in problems))

    def test_axis_direction_reversal_is_rejected(self):
        total, problems = self.audit_pair(
            self.ENGLISH, self.CHINESE.replace("-Y", "+Y")
        )
        self.assertEqual(total, 1)
        self.assertTrue(any("signed axes" in item for item in problems))

    def test_numeric_dimension_change_is_rejected(self):
        total, problems = self.audit_pair(
            self.ENGLISH, self.CHINESE.replace("2 mm", "3 mm")
        )
        self.assertEqual(total, 1)
        self.assertTrue(any("numeric constraints" in item for item in problems))


    def test_untranslated_new_english_task_does_not_break_existing_zh_audit(self):
        # Parallel upstream PRs extend the English roster independently.
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            task_file.write_text(
                yaml.safe_dump([
                    {"id": "rail_fixture", "prompt": self.ENGLISH},
                    {"id": "new_untranslated_fixture", "prompt": "A new device with 7 slots."},
                ], allow_unicode=True), encoding="utf-8"
            )
            trans_file.write_text(
                yaml.safe_dump({"zh": {"rail_fixture": self.CHINESE}}, allow_unicode=True),
                encoding="utf-8"
            )
            total, problems = audit(task_file, trans_file)
            self.assertEqual(total, 1)
            self.assertEqual(problems, [])

    def test_unknown_translation_id_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            task_file.write_text(
                yaml.safe_dump([{"id": "rail_fixture", "prompt": self.ENGLISH}]),
                encoding="utf-8"
            )
            trans_file.write_text(
                yaml.safe_dump({"zh": {"phantom_task": self.CHINESE}}, allow_unicode=True),
                encoding="utf-8"
            )
            with self.assertRaisesRegex(ValueError, "not present in benchmark"):
                audit(task_file, trans_file)


if __name__ == "__main__":
    unittest.main()
