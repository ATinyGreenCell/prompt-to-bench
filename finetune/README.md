# OpenSCAD fine-tune (laptop-deployable)

A follow-up to the paper: can a **small, laptop-runnable** open model be fine-tuned into a capable
**general OpenSCAD assistant** — one that turns a written request into a correct 3D-printable part,
across mechanical parts, mounts, enclosures, fasteners, adapters and any lab or general hardware,
not only lab equipment? The paper's best laptop model scored 0/16 on the lab benchmark; the bet is
that a broad fine-tune on verified OpenSCAD closes the gap (the literature in §5.5 says narrow CAD
fine-tunes lift small models a lot; breadth should help the model learn OpenSCAD *as a language*,
which is the paper's core diagnosis of why they fail).

**Scope: general OpenSCAD, strong in the lab.** The seed library and generated tasks span general
3D-printing design — mechanical (gears, couplers, brackets, hinges, clamps), mounts (VESA, pipe,
rail), enclosures and boxes, fasteners and spacers, adapters and couplers, containers and
organizers, knobs and handles — with lab hardware as one well-covered domain. The lab benchmark
stays the held-out eval; broader training should still lift it, and demonstrates general competence.

**Deployment targets: the laptop (Ollama/GGUF) and the Tiiny box.** The laptop runs `scadcoder`
(Qwen2.5-Coder-7B, Q4 GGUF). The box runs fine-tunes of its vendor base, Qwen3.5-9B, imported through the
TiinyOS app by Hugging Face URL - its command-line `tiiny import` rejects language models, but the app's
Import Model step accepts them (corrected 2026-10-16; [`../meta/audits/2026-10-14_box_platform.md`](../meta/audits/2026-10-14_box_platform.md),
[`RUNBOOK.md`](RUNBOOK.md) B1-B6). When the box is down, the same weights are benched on a rented GPU (B5).

## Base model

**Qwen2.5-Coder-7B-Instruct** (Apache-2.0): code-specialized, ~4.7 GB as a Q4 GGUF so it fits the
16 GB laptop with context headroom, and it is already in the paper's lineup (0/16), giving a clean
before/after. Alternative to A/B later: Qwen3.5-9B (newer, 6.6 GB). Revisitable.

Pipeline: QLoRA on a rented GPU (RunPod, ~$10-75) -> merge -> convert to GGUF -> `ollama create` ->
run the benchmark harness on it.

## The one hard rule

**Training data must be disjoint from the 16 eval tasks.** If any leak in, the comparison is void.
Off-limits (do not use as seeds or targets): `tube_rack_1p5ml`, `conical_rack_50ml`,
`slide_drying_rack`, `pcr_tube_rack_sbs`, `gel_comb_10well`, `micropestle_1p5ml`, `lab_funnel_60mm`,
`seed_sowing_template`, `dshaft_knob_6mm`, `pcr_tube_adapter`, `hose_barb_reducer_8_5`,
`rod_tubing_clip`, `stirrer_fan_housing`, `nema17_motor_bracket`, `enclosure_box_and_lid`,
`mini_gel_tank`. Seeds are *novel* lab parts (e.g. `reagent_bottle_stand`).

**Disjoint means the wording too, not just the ids.** v3's distilled descriptions reused eight task prompts' sentences with other numbers (token Jaccard 0.56-0.86) and v3 passed exactly those tasks. Gate every new training prompt with `rft/distill/gen_prompts_clean.max_jaccard` (<= 0.40 against `bench/tasks.yaml`; v2's data peaks at 0.22) and keep same-kind parts out (an L-bracket is the NEMA bracket's kind) - RUNBOOK B6, hiccup H31.

## Pipeline

1. **Seeds** (`seeds/*.scad`) - novel parametric lab-hardware designs, each with `// @param name lo:hi`
   ranges. Hand-authored and model-authored, every one verified.
2. **`scripts/verify.py`** - the quality gate: render + measure, reusing `tools/scadreport.py` so
   "valid" matches the eval. Exit 0 + JSON on a sane watertight mesh. *(done, proven)*
3. **`scripts/augment.py`** *(next)* - sweep each seed's `@param` ranges, verify every variant, emit
   the valid (params -> scad) set. Valid-by-construction + verified; near-instant (~0.5 s/render).
4. **`scripts/gen_candidates.py`** *(next)* - generate novel `(prompt -> scad)` pairs with a strong
   model (the box or Claude), verified by `verify.py`; include feedback triples
   `(prompt -> flawed -> error/measurement -> corrected)` to teach using error messages (the paper's
   key failure mode).
5. **`scripts/build_dataset.py`** *(next)* - assemble verified pairs into chat-format JSONL in the
   base's template, dedup, train/val split (val from held-out seeds, never the 16 tasks), record
   provenance.
6. **`scripts/train_qlora.py`** *(next, on RunPod)* - QLoRA fine-tune -> merge -> GGUF.
7. **Eval** - run `bench/run_bench.py` on the fine-tune; compare to the base (0/16) and the paper's
   viability bar (8/16 within three attempts).

## Hosting / deploy

The fine-tune and any dataset live on Hugging Face under **`ATinyGreenCell`**
(<https://huggingface.co/ATinyGreenCell>). The merged model is converted to GGUF and run locally
with Ollama; RunPod pulls the base and pushes the result from/to that account.

## Status (2026-10-15)

- Quality gate (`verify.py`) and augmenter (`augment.py`) done and proven.
- **Seed library (7, all verified watertight, all disjoint from the 16 eval tasks):** general
  mechanical/3D-printing breadth, not just lab - `reagent_bottle_stand` (holder), `hex_standoff`
  (fastener/spacer), `pipe_saddle_clamp` (mount), `shaft_coupler` (mechanical), `spur_gear`
  (mechanical), `desk_bin` (container), `vesa_adapter` (mount). Each parametric; `augment.py` turns
  each into many verified `(prompt -> scad)` pairs.
- Next: keep growing the seed library (more mechanical/general categories), then `gen_candidates.py`
  (novel model-generated verified pairs + error-feedback triples), then `build_dataset.py`.
## Validation run (2026-10-15) — it works

First end-to-end run on a RunPod A40 (QLoRA on Qwen2.5-Coder-7B, 1,464 pairs / 13 families, 2
epochs; attempt-1 / pass@1 on the 16 eval tasks, identical protocol for base and fine-tuned):

| | base Qwen2.5-Coder-7B | fine-tuned |
|---|---|---|
| renders valid OpenSCAD | 2/16 | **13/16** |
| pass@1 | 0/16 | **1/16** (+ near-misses 0.3-0.6) |

The base writes broken OpenSCAD (14/16 don't render - the paper's diagnosis); the fine-tune renders
13/16 **zero-shot** on parts it never saw, with one full pass and a cluster of near-misses the
3-attempt repair loop + more data should convert. Clear go signal. Outputs in `validation_run/`.

**Cost:** training 15.2 min = **$0.15** (whole pod session ~37 min ≈ $0.36). ~$0.000051 per
example-epoch, so a 10k-ex x3-epoch "go ham" run ≈ ~$1.5, 50k x3 ≈ ~$7.7 — the $15 covers a large
run with iterations.

- Next: build breadth (`gen_candidates.py` + feedback triples), train bigger, score with the full
  3-attempt protocol, and prove GGUF -> Ollama laptop deploy.
- RunPod: pod terminated after the run; SSH key left registered for future runs.

## Box models (Qwen3.5-9B fine-tunes), 2026-10-16/17

All public on Hugging Face under `ATinyGreenCell/`, box-importable (`scripts/box_import_fix.py`). Results: paper §6.4,
Table 8 (GPU tier, 8 samples per task; in-family / held-out split of the 16 tasks).

| Repo | Training data | Pass@8, in-family / held out | On the box, 1 sample |
|---|---|---|---|
| `scadcoder-qwen3.5-9b` (v1) | `data/train.jsonl` (7,238), 1 epoch, rank 16 | 1/8 · 0/8 | 0/16 |
| `scadcoder-qwen3.5-9b-3ep` (v2) | same, 3 epochs, rank 32 | 1/8 · 0/8 | 0/16 |
| `scadcoder-qwen3.5-9b-v3` | v2 + 269 RFT + 336 distilled that paraphrase 8 tasks (**in-family**) | 5/8 · 1/8 | - |
| `scadcoder-qwen3.5-9b-v4` | v2 + 269 RFT + 680 held-out distilled (`build_v4.py`) | 2/8 · 0/8 | - |
| `scadcoder-qwen3.5-9b-v5` | v4 + 1,500 multi-turn report repairs (`build_v5.py`, MASK_EARLIER=1) | 3/8 · **2/8** | **3/16** |
| `scadcoder-qwen3.5-9b-v5-seed1` | v5's data and settings, seed 1 instead of 0 (a replicate: `SEED=1`) | 3/8 · 0/8 | - |
| `scadcoder-qwen3.5-9b-v6` | v4 + 700 more held-out distilled, 14 more families (`build_v6.py --base v4`) | **5/8** · 0/8 | 1/16 |
| `scadcoder-qwen3.5-9b-v7-1ep` | v4's data, 1 epoch | 3/8 · 0/8 | - |
| `scadcoder-qwen3.5-9b-v8` | v6 + the 1,500 report repairs (`v8_train`, MASK_EARLIER=1) | 3/8 · 1/8 | - |
| `scadcoder-qwen3.5-9b-v9` | v5 + 869 of v5's own failed attempts, each with its report and the reference file, x2 (`build_v9.py`, MASK_EARLIER=1) | 2/8 · 0/8 | 3/16 |
| `scadcoder-qwen3.5-9b-v9-seed1` | v9's data and settings, seed 1 instead of 0 (a replicate: `SEED=1`) | 4/8 · 1/8 | - |
| `scadcoder-qwen3.5-9b-v10` | v9 + 211 of v9's own passing repairs on batch C, x2 (rejection sampling over repair turns; `build_v10.py`, MASK_EARLIER=1) | 3/8 · 1/8 | 1/16 |

The stock base passes 2/8 · 1/8 with thinking off. Every fine-tune renders 88-99% of first attempts but rarely changes
its file after feedback (6-15% of repair turns through v8, vs 84% for the base), except those trained on their own
failures: v9 27% and, retrained with seed 1, 43% with three passes won by repair (as many as the base); v10, also
trained on its own passing repairs, 36% and one, within v9's spread. The training run itself moves these numbers: v5
retrained with seed 1 passed 3 tasks instead of 5, neither held-out one (the slide rack went from 7/8 samples to 0/8),
and changed its file after 8% of feedback messages instead of 15%; v9 retrained passed 5 instead of 2. On batch C (674
new descriptions from 14 families, 13 of them unseen, `rft/onpolicy/`) both v9 runs changed their file after 34-39% of
feedback and fixed 2.1-3.5% of failures, against 14-17% and 0.1-0.3% for both v5 runs. A better prompt instead of
training (`bench/harness_search.py`: OpenSCAD idioms, two worked examples, checklist feedback) lifted the stock base
from 2 to 6 tasks in eight samples on the GPU (5 in-family, 1 held out), but added nothing reliable to v9 seed 1
(paper Tables 9-10). Next: `build_v11.py` (v9's data + batch C for ten families, as plain examples and as v9 seed 1's
own failures; four families held out), trained with seeds 0 and 1. On the box itself (one sample per task, the box's
own quantised build, imported by URL with `scripts/box_import.py`) v5 passed the slide rack, the gel comb and the
PCR-tube adapter, all on the first attempt; v1 and v2 had passed none. With eight samples on the box v5 passed 6/16 (4 in-family, 2 held out:
the hose-barb reducer and the slide rack), against 5/16 on the GPU (`bench/results/box-v5-k8/`). v9 passed 3/16 on the box at one sample (the 1.5 mL rack, the slide
rack and the PCR-tube adapter, the last by repair after a parser error).
