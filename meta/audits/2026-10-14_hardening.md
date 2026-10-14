# Hardening audit: harness, checker, analysis, designs and docs

**Snapshot.** HEAD `7a8ca5d` plus the working tree, 14 Oct 2026, about 17:10–18:30.

**Context.** The Tiiny NPU-box sweep was running at the time. It ran from a frozen copy of `bench/` and `tools/` (see [`bench/results/main-tiiny/README.md`](../../bench/results/main-tiiny/README.md)), so nothing below changed the protocol of runs in progress. Four report-only reviewers worked in parallel:
- harness;
- checker and feedback tool;
- analysis and tools;
- designs, tutorial and docs.

Fixes were applied afterwards, with tests. Like the earlier audits, this was done by Claude, which also wrote the work, so it is not independent review.

## Fixed

### Checker (scoring)

**A false negative in real data.** Qwen3-Coder-Next built a correct funnel (main-tiiny, sample 1, attempts 1 and 2), but its cutters ended 5 × 10⁻¹⁵ mm short of the rim and the spout. In floating point that left zero-thickness skins, which sealed the cavity, and the checker counted the sealed cavity as a second body.
- **Fix.** `split_bodies` ignores a sealed cavity that lies within 0.001 mm of the outside.
- **Unchanged.** A real sealed void, such as holes covered by a 2 mm skin or pestle grooves enclosed 1 mm inside, still counts.

**A correct knob failed when rotated.** The prompt fixes the pointer only relative to the flat of the D, but the probes assumed the flat faced +X, so a correct knob turned 10° or 45° failed. The task now sets `rotation_step: 1`, which tries every 1° rotation.

**Loopholes closed.** In these, a wrong part could pass. The new checks are:
- **`bores`:** a vertical ray up every bore and through-hole (funnel, 50 mL rack, PCR rack, hose barb, adapter). A skin, plug or floor fails, except a zero-thickness skin.
  - Before: a funnel blocked by a 2.5 mm shell passed, as did a plugged spout, skinned-over rack holes, and a PCR rack with a 0.9 mm floor or a 2 mm top skin.
- **Edge probes**, just inside and just outside each feature, 0.3–0.6 mm from its edge:
  - the NEMA boss hole and M3 holes, including their 31 mm pattern;
  - the stirrer's cable notch;
  - the gel tank's wire holes;
  - the seed template's notch;
  - the PCR rack's chamfer;
  - the knob's pointer groove, which must start at the centre and be 1.5 × 1 mm at the rim.
  - Before: holes 1.5 mm or 20.5 mm wide, an M3 pattern of 29.5 or 32.5 mm, cable notches of 2 × 4 or 40 × 19 mm, 8 mm wire holes, a 1.5 × 12 mm notch and a chamfer with 15 mm legs all passed.
- **Depth brackets:** two slices within ±0.6 mm, for the tube-rack floor and the slide-rack slots. A line through a gap of the comb now measures the spine.
  - Before: holes 22 or 28 mm deep, slots 7.5 or 12.5 mm deep, and comb teeth 14.4 mm long on a 9.6 mm spine all passed.
- **The knob's D-bore** is now measured as a 6.2 × 4.7 mm rectangle, not only by its area.
  - Before: a 5.9 mm bore and a 4.3 mm flat passed.
- **`hole_d` and `island_d`** now also require a round outline: the enclosing rectangle within 1.5 × the tolerance of d.
  - Before: 15.6 × 7 mm slots with the area of an 11.2 mm hole passed the tube rack.

**Regression parts.**
- 28 of these parts were added to `bench/mutants/`, which now holds 32 known-wrong parts.
- A new folder, `bench/variants/`, holds 3 known-right parts that `build_refs.py` requires to pass: the knob at 10° and 45°, and Coder-Next's funnel.
- `build_refs.py` replaces `assert` with checks that still run under `python -O`.

**Tolerances checked against saved passes.** A first version of the new checks failed two of Haiku's Swahili passes:
- a 4.5 mm floor where 5 mm was asked;
- a wedge-shaped pointer that widens to 1.5 mm at the rim.

Both are within the paper's tolerances or are a fair reading of the prompt, so the depth brackets were set to ±0.6 mm and the pointer is measured near the rim.

### Harness (`run_bench.py`, `scadreport.py`)

**Runtime errors are never scored and never crash a run.**
- An error event in the middle of a stream (commit `7a8ca5d`) and a stream that ends without "done" are retried, and the partial reply is never scored. The Reviewer-2 audit had listed the second as found but not fixed.
- These are now runtime errors that skip the task: an `IncompleteRead`, a stream line that is not an event, and a "no thinking switch" answer on the last retry. Each used to crash the run.

**Resume and run setup.**
- Conversations that a rescore flags `needs_rerun` are redone on resume. The newest record per conversation decides; it used to be file order.
- Resume skips models whose tasks are all done, so a deleted model no longer stops the run.
- Duplicate model names, `m` together with `m:latest`, and names that share a code folder are refused.
- Repairing a damaged `results.jsonl` writes a temporary file, syncs it and renames it, so a full disk can no longer truncate the good lines.
- A folder name containing `.scad` (or `.stl`, in `slice_library.py`) no longer breaks file names.

**Render messages and feedback.**
- Duplicate messages from `render()` are removed in linear time. A file that floods the log no longer stalls the harness.
- When there are more than 20 messages (15 in the feedback), the decisive ones are kept, in their original order. Feedback with 15 or fewer messages is byte-identical.
- If the measurement report fails, a pass is no longer turned into a render failure. A failing part then gets the generic feedback.

**Extraction and settings.**
- If a chat template wrote `<think>` itself, the reasoning before an orphan `</think>` is no longer taken as the answer.
- New `--num-ctx` flag. The default is 8,192, as before, with a warning when replies could overflow it on Ollama. The Tiiny bridge ignores `num_ctx`.
- `prompt_tokens` is recorded as `None`, not 0, when the harness stopped the stream early.
- The fake-backend tests can no longer reach a real server.

### Analysis (`analyze.py`)

**A mistyped `--runs` name** emptied four paper tables and `summary.csv`, and still printed "README updated". It is now an error and nothing is written.

**Record handling.**
- The newest record by finish time wins, whatever the line order of a merged file.
- Records flagged `needs_rerun` are left out, with a warning.

**Runs with several samples per task (the Tiiny box)** are refused in the main tables. They are reported per sample through `--box-runs`, with:
- a table;
- an outcome grid counting the samples that passed;
- a figure of tasks passed against model size;
- `summary_tiiny.csv`.

Pooled columns use complete samples only. `--think-runs` adds a thinking-on vs thinking-off table.

**Model table and smaller fixes.**
- An unknown local model shows "-", not "hosted".
- The model table lists only models with results, and has a new "Runs on" column.
- The print-estimate total counts its own rows.
- The size figure plots total parameters, so Gemma 4 E2B and E4B sit at 5.1 and 8 B.

**README writing.** A README block is replaced only when exactly one whole-line pair of markers exists; otherwise there is a warning. The README is written in UTF-8 through a temporary file.

### Build log (`meta/build_log.py`, privacy)

- Tool inputs are redacted before they are shortened. A cut-off e-mail address used to slip past the patterns.
- Private IPv4 and link-local IPv6 addresses, MAC addresses and 32-hex device ids are redacted.
- The token pattern no longer swallows words such as `skip_existing_files`.
- MCP tool inputs (mail, documents, devices) are not logged.
- The file is written through a temporary file.

### Designs

Every default part still renders byte-identical.

- **Funnel.** A `spout_od` of 7.5 or a `wall` of 2.6 mm or more silently gave a solid cone, because OpenSCAD dropped the inner cone.
  - The extension under the junction now shrinks to fit.
  - An assert catches a wall that would close the spout.
  - The header gives the rule for upright printing: at most 45° from vertical.
- **Clearance coupon.** The edge assert measured to the far edge of the plate, which allowed 28.4 mm holes; the real limit is 20.4 mm. There is also a new limit that keeps holes out of the labels.
- **Enclosure.** The cable hole could open the rim or sit behind the lid's lip. It now has an assert and a new `cable_z` parameter.
- **Rod clip.** The snap-opening cutters had fixed lengths and left slivers with ½-inch tubing. They now scale with the rings.
- **NEMA bracket.**
  - New asserts: the M4 holes stay inside the base and clear of the gussets, and the gussets clear the screw heads.
  - `mount_pos`, which the Customizer could not show, is now `mount_x` and `mount_y`.
- **Hose barb.** An assert catches a collar too short for its 45° underside.
- **Seed template.** An assert catches merging holes.
- **Slide rack.** Asserts catch drain channels that would leave 0.25 mm fins and drain holes that would merge.
- **Knob.** The wall assert now counts the grip grooves and the mouth chamfer.
- **Gel tank.** The header said the wire climbs the end wall; it climbs the +Y side wall.
- **`check_designs.py`.**
  - New cases cover all of the above.
  - A hollowness check requires slices to cut a hole at given heights.
  - A render timeout no longer aborts the run.

### Tutorial and docs

- **Part 4 coupon.** The recipe kept the bottom 3 mm of the rack, where there are no holes. It now keeps the top 3 mm and moves it to the bed, or changes the design's parameters. Both were rendered and checked.
- **Setup.** The clone now goes to `~/prompt-to-bench`, where later steps expect it. The venv is activated before `claude`, so `scadreport` finds its packages.
- **Commands.** `python …` became `.venv/bin/python …` throughout. Current Ubuntu has no `python` command, and its system Python refuses `pip install`.
- **Paper §6.2.** The sentence about the best local attempt predated the Reviewer-2 slices. It now says the Gemma 4 E4B pestle met 13 of 17 checks, and the partial Qwen3.5 9B rack 8 of 9.
- **LICENSE.** The paths now match the folders: `designs/**`, `bench/reference` and `bench/mutants` are CERN-OHL-P; the scripts are MIT.
- **Run scripts.** They now work on macOS bash 3.2 under `set -u`, and `run_lang.sh` refuses to run without a model.

## Found, not fixed

Each of these would change what models see, so they were not changed mid-study.

**Render time in repair prompts.** The measurement report includes "rendered OK in X s", so a repair prompt depends on machine load.

**Feedback report gaps.**
- A cavity sealed only by a zero-thickness skin is reported as "N separate bodies". This misled the model in 3 saved conversations.
- The report cannot show several faults the checks do catch: the comb's tooth count, missing grip grooves, and holes through vertical walls.
- It prints rectangles as long × short, without their axes.

**Code-fence edge cases.** An inline ```…``` span before the code block, and four-backtick fences, are not handled. None of about 900 saved replies has either.

**No memory cap on OpenSCAD.**

**Counting with more than 3 attempts.** With `--max-repairs` above 2, the outcome grid and graded tiers count a pass on any attempt, while the "≤3 tries" columns use the first three.

## Rescoring with the new checks (dry run)

The dry run re-rendered and re-checked every saved attempt. The final checks were frozen in commit `3746556` but not yet applied to the stored records.

**Laptop, hosted and language runs.** `main` (210 conversations), `main-claude` (32) and `lang-claude` (48): partial scores changed (105, 6 and 15 attempts), and no verdict changed.

**Tiiny box, `main-tiiny`** (94 conversations at the time; the sweep keeps adding to it). The partial scores of 98 attempts changed, and these verdicts:
- Qwen3-Coder-Next, funnel, sample 1: the first attempt now passes, where the third used to. This is the zero-thickness skin above.
- Three conversations stopped at a pass the old checks gave and now fail, so they need to be run again:
  - Qwen3-Coder-Next, PCR rack, sample 0: its "chamfer" is a rotated box that cuts a lopsided notch, not a 45° chamfer with 5 mm legs.
  - Qwen3-Coder-Next, seed template, sample 1: the notch runs from x = 0 to 10 instead of being centred.
  - Gemma 4 26B-A4B, seed template, sample 0: the notch is 12 mm wide, not 10, because the cutter was widened by 1 mm on each side.

