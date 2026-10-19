# box-gemma-h0: Gemma 4 26B-A4B on the box, standard harness

Gemma 4 26B-A4B's three samples of the 16 tasks under the standard harness (`bench/prompts/system.md`, report
feedback), from the box sweep's main-protocol run, copied here for the comparison with
[`box-gemma-h4`](../box-gemma-h4/) in README §6.4 before the sweep's full results are published: each (task,
sample)'s final record (`results.jsonl`), the code files of its attempts, and the box's provenance for each pass
(`box_*.json`; the store build is version 20260907 throughout).

- Sample 0 ran on 2026-10-14 under the harness of commit 7a8ca5d and was rescored with the final checks of commit
  c43e250; its one conversation whose pass did not survive was run again, and the superseded record is left out.
  Samples 1 (2026-10-15) and 2 (the night of 2026-10-18) ran under c43e250, whose `run_bench.py` differs from the
  repository's only by the `--feedback checklist` option and an HTTP header.
- The box ignores the seed and is not reproducible even at temperature 0, so samples are not paired by index with
  the h4 run's.
- Timings are measured on the laptop and include the link to the box: USB-C for sample 0, Wi-Fi for samples 1 and 2.
