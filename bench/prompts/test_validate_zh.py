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
            return audit(task_file, trans_file, expected_baseline_ids={'rail_fixture'})

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


    def test_swapped_unsigned_coordinates_rejected(self):
        # Numeric-token, sign and axis-token multisets are unchanged;
        # only the scientific meaning of x and y was swapped.
        english = "Place the probe at x = 10 mm and y = 20 mm."
        chinese = "将探针放在 x = 20 mm、y = 10 mm。"
        _, problems = self.audit_pair(english, chinese)
        self.assertTrue(
            any("coordinate axis-value assignments" in p for p in problems),
            problems,
        )

    def test_coordinate_bindings_preserved_in_chinese(self):
        english = "Place at x = -25 mm, y = 30 mm, and z = 5 mm."
        chinese = "将物体放在 x = -25 mm、y = 30 mm 和 z = 5 mm。"
        _, problems = self.audit_pair(english, chinese)
        self.assertEqual(problems, [])

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
            total, problems = audit(task_file, trans_file, expected_baseline_ids={'rail_fixture'})
            self.assertEqual(total, 1)
            self.assertEqual(problems, [])


    def test_missing_baseline_translation_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            tasks = [
                {"id": "rail_fixture", "prompt": self.ENGLISH},
                {"id": "second_original", "prompt": "A 7 mm spacer."},
            ]
            task_file.write_text(yaml.safe_dump(tasks), encoding="utf-8")
            trans_file.write_text(
                yaml.safe_dump({"zh": {"rail_fixture": self.CHINESE}}, allow_unicode=True),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "Missing baseline Chinese translations"):
                audit(task_file, trans_file,
                      expected_baseline_ids={"rail_fixture", "second_original"})

    def test_missing_english_baseline_task_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            task_file.write_text(
                yaml.safe_dump([{"id": "rail_fixture", "prompt": self.ENGLISH}]),
                encoding="utf-8",
            )
            trans_file.write_text(
                yaml.safe_dump({"zh": {"rail_fixture": self.CHINESE}}, allow_unicode=True),
                encoding="utf-8",
            )
            with self.assertRaisesRegex(ValueError, "Missing baseline English benchmark tasks"):
                audit(task_file, trans_file,
                      expected_baseline_ids={"rail_fixture", "second_original"})

    def test_empty_translation_baseline_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            task_file, trans_file = root / "tasks.yaml", root / "translations.yaml"
            task_file.write_text(
                yaml.safe_dump([{"id": "rail_fixture", "prompt": self.ENGLISH}]),
                encoding="utf-8",
            )
            trans_file.write_text(
                yaml.safe_dump({"zh": {}}, allow_unicode=True), encoding="utf-8"
            )
            with self.assertRaisesRegex(ValueError, "Missing baseline Chinese translations"):
                audit(task_file, trans_file, expected_baseline_ids={"rail_fixture"})

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
                audit(task_file, trans_file, expected_baseline_ids={'rail_fixture'})


    def test_language_dispatch_fail_closed_and_opt_in(self):
        """An earlier failed language must not be hidden by a later success."""
        import os
        import shutil
        import subprocess

        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / "bench").mkdir()
            (root / ".venv/bin").mkdir(parents=True)
            (root / "fakebin").mkdir()
            script = root / "bench/run_lang.sh"
            shutil.copy2(Path(__file__).resolve().parents[1] / "run_lang.sh", script)

            # Stub the benchmark interpreter to fail only the first language.
            # No model, OpenSCAD or external service is run in this test.
            fake_python = root / ".venv/bin/python"
            fake_python.write_text(
                '#!/bin/sh\n'
                'echo "$*" >> "$PTB_LANG_TEST_LOG"\n'
                'case " $* " in *" --lang es "*) exit 7;; esac\n'
                'exit 0\n',
                encoding="utf-8",
            )
            fake_python.chmod(0o755)
            # Keep tests independent of whether the CI host has systemd-inhibit.
            fake_inhibit = root / "fakebin/systemd-inhibit"
            fake_inhibit.write_text(
                '#!/bin/sh\n'
                'while [ "$#" -gt 0 ]; do\n'
                '  case "$1" in --*) shift;; *) exec "$@";; esac\n'
                'done\n',
                encoding="utf-8",
            )
            fake_inhibit.chmod(0o755)
            log = root / "calls.txt"
            env = dict(os.environ)
            env["PTB_LANG_TEST_LOG"] = str(log)
            env["PTB_LANGUAGES"] = "es hi"
            env["PATH"] = str(root / "fakebin") + os.pathsep + env["PATH"]
            result = subprocess.run(
                ["bash", str(script), "local-probe", "fake-model"],
                env=env, text=True, capture_output=True, check=False,
            )
            self.assertEqual(result.returncode, 7, result.stderr)
            calls = log.read_text(encoding="utf-8").splitlines()
            self.assertEqual(len(calls), 1, calls)
            self.assertIn("--lang es", calls[0])

            # Positive control: opt-in Chinese language completes and forwards
            # the selected model without changing the default language set.
            log.write_text("", encoding="utf-8")
            env["PTB_LANGUAGES"] = "zh"
            result = subprocess.run(
                ["bash", str(script), "local-probe", "fake-model"],
                env=env, text=True, capture_output=True, check=False,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(
                log.read_text(encoding="utf-8").splitlines(),
                ["bench/run_bench.py --run local-probe --lang zh --prompts bench/prompts/translations.yaml --models fake-model"],
            )

if __name__ == "__main__":
    unittest.main()
