# box-gemma-h4: Gemma 4 26B-A4B on the box with the h4 harness

Gemma 4 26B-A4B (the Tiiny store's build, version 20260907, the same build as the sweep's passes in
[`box-gemma-h0`](../box-gemma-h0/)) on the box's NPU: three samples of the 16 tasks under the box protocol
(`run_bench.py --samples 3 --max-repairs 2`), with the harness that the harness search chose for the untuned
Qwen3.5-9B on batch C (h4, README §6.4, Table 10): `--system bench/prompts/system_idioms_examples.md --feedback checklist`.
It ran on 2026-10-18 from 19:12 to 20:53 at commit c0df949 (`meta_*.json`), with the model sweep paused, over the
box's Wi-Fi link. The box ignores the seed, so its samples are not paired by index with the standard harness's.
