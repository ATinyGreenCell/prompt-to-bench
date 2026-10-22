# Making small models work: protocol

Written on 2026-10-19 at about 22:15 US Eastern, before any of the methods below was run on the 16 benchmark tasks.
Seb, the same evening: "Lets think of other ways to make small models work" and, on the four proposed, "Lets do all
of them!".

## Why

Laptop models through Ollama passed none of the 16 tasks (README §6.1). Their failures fall into a few kinds:
- syntax OpenSCAD cannot parse (`rack = cube(...)`, Python-style code);
- replies cut off at the token cap;
- files returned unchanged after feedback;
- parts that render but have the wrong size.

A local-first cascade, which hands a part to a hosted model only when it fails a check, keeps up to 11 of 16 parts
local if the check is the benchmark's hidden checks. With a check built only from the request's numbers, the
cascade keeps more wrong parts than right ones (scratch analysis, 2026-10-19). Four interventions follow, each
aimed at one of these failures.

## The four interventions

1. **A check built from the request (`spec`).** A model, or the user, turns the request into a spec of expected
   measurements: overall size, body count, and hole counts, diameters and positions. `scadreport`'s measurements of
   the part are then compared with it automatically. This check does not need the answer key. It can gate a
   cascade, decide when to send repair feedback, and choose among samples.
2. **Syntax repair.**
   - (a) `scadfix`, a rule-based rewrite of the recurring parse errors.
   - (b) Grammar-constrained decoding in llama.cpp, so that every reply is a syntactically valid OpenSCAD program.
3. **Templates.** The model picks a parametric design from a library and fills in its parameters as JSON, instead
   of writing code. The library is the 34 seed families of the fine-tuning data engine (`finetune/seeds/`). They
   are generic parts, disjoint from the 16 tasks by construction.
4. **Features compiled to code.** The model lists the part's features (base solid, holes, hole grids, slots,
   polar arrays, revolved profiles) as JSON, and a deterministic compiler writes the OpenSCAD.
   - The feature set is designed from the seed families and batches A-C, not from the 16 tasks.
   - Its designer, Claude, knows the 16 tasks. We state that as a limitation.

## Development and test data

- **Development:** only data outside the 16 tasks:
  - the seed families;
  - the distilled batches A, B and C (`finetune/rft/distill/`, with each description's true overall size and a
    verified file);
  - the saved batch-C attempts (`finetune/rft/onpolicy/`, `bench/results/harness-search/`).
- **Test:** the 16 benchmark tasks, under the paper's protocol, once per method and model, after the method's
  prompt, rules, grammar, tolerances or compiler have been frozen.
  - Each frozen artefact's sha256 is recorded here before its test run.
  - A test result never feeds back into the method. A later fix is a new, separately labelled version.
- **Offline re-scoring of saved benchmark attempts** (for `scadfix` and the `spec` gate) also counts as a test run.
  It is done once per frozen version.

## Models

- **Laptop (Intel i7-1260P, 16 GB, no GPU):**
  - Ollama: Qwen2.5-Coder 3B and 7B, Ministral 3 3B, Llama 3.2 3B, Qwen3.5 4B and 9B, Gemma 4 E2B and E4B.
  - llama.cpp (PrismML fork, which also serves standard GGUF files): Bonsai 2 27B, and the Ollama models'
    GGUF files when a grammar is needed.
- **Settings:** temperature 0.2, top-p 0.95, a seed per attempt, thinking off, as in the main protocol.
- **Hosted:** Claude, as a reference spec writer only, on at most the 16 requests and a small development sample.
- **No rented GPU and no NPU-box time** without asking first: the box sweep keeps running.

## Measures

- **`spec`:**
  - On development data: agreement with each description's true overall size and with its verified file.
  - On the 16 tasks: the gate's precision and recall against the hidden checks, over every saved attempt, and
    the cascade's outcome (parts kept local, right and wrong; tasks sent to the hosted model).
- **`scadfix` and grammar:** first files that render, and tasks passed within three attempts, against the same
  models' standard runs.
- **Templates and features:**
  - on held-out descriptions of the library's families (development);
  - on the 16 tasks under the paper's protocol (test), where an unanswerable request counts as a failure.
- **Viability bar, unchanged (§5.5):** at least 8 of 16 tasks within three attempts, at a median of no more than
  10 minutes a task on the laptop.

## Test procedures

Fixed on 2026-10-20 at about 00:50, before any test run.

- **Spec versions** (development only):
  - v1: overall size, pieces, vertical round holes.
  - v2: the same fields. It copies stated totals, adds only plain sums, and leaves derived sizes null.
  - v3 (added 2026-10-20 ~01:00): v2 plus the outline sizes just above the bed and just below the top.
    - Why: with Claude's v1 specs, which accept all 56 development references, the gate is still only 0.76 precise.
    - Of the 48 wrong parts it accepts, 47 have the right bounding box and the wrong volume: frustums built
      without their taper, a missing recess or pocket, spoked wheels built solid.
    - An outline is checked only where the part's cross-section is one region (measurement version 3). Writers
      gave wrong overall outlines for tops made of several ribs, so a top or bottom of several regions (ribs,
      posts, teeth) is not checked.
  - The development yardstick (the batch-C verdict) has looser size tolerances than the gate (1 mm or 3% against
    0.5 mm or 2%). It also accepts parts that lack small holes, which change the volume by less than 8%. Some
    of the gate's "rejected right parts" on development data are therefore parts with missing screw holes.
  - Smoke test of the v3 measurement: it was run once on a benchmark reference file (the lab funnel), which showed
    that file's outline sizes. No gate verdict was computed, and no spec was written for a benchmark task.
- **Choosing the spec writer to freeze** (fixed before the results of the v2 prompt, Qwen3.5 9B and
  Qwen2.5-Coder 7B were in):
  - Candidates: laptop models with the v1, v2 or v3 prompt.
  - Qwen2.5-Coder 7B was dropped as a spec writer before it ran (2026-10-20 ~01:10), so that the Gemma v3 run could
    go first. Qwen3.5 9B finishes its v1 run.
  - Criterion: the highest F0.5 on the development attempts (precision against the batch-C verdict, weighted
    twice as much as recall). A wrong part kept is worse than a task sent to the hosted model.
  - Ties are broken by how many reference files the gate accepts.
  - A Claude-written spec, if run, is a reference row only and is never frozen as the laptop writer.
  - **Outcome** (2026-10-20 02:41, `spec/dev_gate.py`, 448 saved attempts on 56 development descriptions):

    | Writer | Prompt | Accepts the reference | Precision | Recall | F0.5 |
    |---|---|---:|---:|---:|---:|
    | Gemma 4 E4B | v1 | 36/56 | 0.77 | 0.73 | **0.759** |
    | Gemma 4 E4B | v2 | 36/56 | 0.75 | 0.69 | 0.734 |
    | Gemma 4 E4B | v3 | 18/56 | 0.77 | 0.32 | 0.603 |
    | Qwen3.5 4B | v1 | 26/56 | 0.72 | 0.46 | 0.647 |
    | Qwen3.5 9B | v1 | 28/56 | 0.67 | 0.54 | 0.641 |
    | Claude Sonnet 5.5 (reference) | v1 | 56/56 | 0.76 | 0.82 | 0.769 |
    | Claude Sonnet 5.5 (reference) | v2 | 56/56 | 0.74 | 0.82 | 0.756 |
    | Claude Sonnet 5.5 (reference) | v3 | 56/56 | 0.86 | 0.82 | 0.849 |

    - Frozen: **Gemma 4 E4B with the v1 prompt.** Its v3 specs got the outline sizes wrong too often: it accepts
      only 18 of the 56 references.
    - Reference rows on the 16 tasks: Claude Sonnet 5.5 with v1, the frozen prompt, and with v3, the richer
      check that only a strong writer could fill in.

- **`spec`** (`spec/bench_gate.py`):
  - The frozen writer writes one spec per task from the request alone (seed 1000, kept in `spec/bench_specs.jsonl`).
  - The gate is tried on the 16 reference parts.
  - Every saved attempt of the local runs (`main`, `main-bonsai`, `ft-scad`, `base-scad`, `main-tiiny`,
    `think-tiiny`, `box-gemma-h4`) is gated and compared with the hidden checks, on first attempts and on all
    attempts.
  - Cascade: walk each conversation and keep the first attempt the gate accepts. A rejected attempt goes on to
    the next saved attempt only when the hidden checks also failed it, since the same feedback was then sent.
    Otherwise the task goes to the hosted model and takes Claude's saved outcome. When the gate rejects a part the
    hidden checks passed, the saved conversation ends where a gate-driven loop would have asked again. These
    tasks are counted as "cut short".
  - Teams, in a fixed order; the first conversation the gate accepts is kept:
    - laptop: Gemma 4 E4B, then scadcoder, then Bonsai 2 27B;
    - box: Gemma 4 26B, then gpt-oss-120b with thinking on, then Qwen3.6 27B.
  - Best of k samples: for every model with two or more complete samples, its conversations on a task in sample
    order, keeping the first one the gate accepts.
  - The render-only gate and the hidden checks are reported beside the spec gate as floor and bound.
  - The measurements of the saved attempts do not depend on the spec. They were cached before the freeze
    (`spec/bench_measure_cache.json`); no gate verdict on them was computed or looked at before it.
- **Templates and features:** `run_bench.py --models template:<model>` (or `features:<model>`) `--samples 1
  --max-repairs 2`, with report feedback, as in the paper.
  - The seed families were built to span the tasks' structural patterns with generic parts, so several tasks
    have a related design:
    - `grid_tray`: the three tube racks;
    - `funnel`: the lab funnel;
    - `knurled_knob` (with a D-bore): the D-shaft knob;
    - `lidded_box`: the enclosure;
    - `stepped_adapter` and `flanged_bushing`: the hose reducer and the tube adapter;
    - `pipe_saddle_clamp`: the rod clip.
  - The test reports the design picked for each task. A pass with a related design shows that the library
    covers that kind of part; it does not show that the model designed it.
- **Choosing the model to freeze for templates and for features.** Fixed 2026-10-20 ~04:50, when only Gemma 4
  E4B's template results were in.
  - Templates: the model with the most right outcomes on the 96 development items. In the library, a right
    outcome is the right design with the right parameters. Out of it, a right outcome is "none", or a design whose
    built part matches the description's verified file (`templates/dev_templates_check.py`).
    - Three batch-C families have a counterpart in the library: `t_slot_nut`; `pull_handle` (`drawer_pull`);
      `spoked_wheel` (`fan_guard`).
  - Features: the most passes on the 28 development descriptions. Ties go to the higher mean score.
  - Further ties go to the shorter median time.
  - One model per method is tested, in runs `sm-template` and `sm-features`. A freeze writes the method's file
    manifest (`FROZEN.sha256`) and model (`FROZEN.model`), and the test runs only if the manifest still checks.
- **Grammar:** `grammar/run_grammar.sh`. Qwen2.5-Coder 7B is run without and then with the grammar, on the same
  llama-server path; Bonsai 2 27B is run with the grammar, and its baseline is `main-bonsai`.
  - **Bonsai's run cancelled for futility** (2026-10-20 ~11:55, before it started; Seb, the same morning: "so we
    dont waste compute and box time on broken or useless things"). Decided from Coder's first 12 grammar
    conversations:
    - The grammar was applied, and it derailed the model rather than repairing it.
      - Coder's mistakes start at a token the grammar forbids (`holes = union() ...`, `x = for ...`).
      - Pushed to the nearest allowed token, it wrote nonsense: `unionfor (`, `cylinder[r == ...`, runaway
        expressions.
      - It never got back to its own design.
    - Of the 36 replies, 18 ended at the repetition cut-off and 6 at the length cap. Every syntax error left is a
      cut-off file.
    - It passed 0 tasks, and 1 of 12 first files built (1 of 16 without the grammar).
    - A conversation took 9.0 min against 3.8 without the grammar.
    - Bonsai's 33 syntax errors in `main-bonsai` are mostly the same mistake, so the grammar would block them the
      same way:
      - shapes assigned to variables or named as statements (`outer = union() {`, `block;`);
      - C-style loops (`for (i = 0; i < n; i++)`).
    - At Coder's slow-down, Bonsai's run would have taken 10-16 h (24 min per conversation without the grammar).
    - Coder's run still finished and is reported as the grammar's test. Bonsai's grammar run was not made, and can
      be if wanted.

## Frozen artefacts

| Artefact | Version | sha256 | Frozen at | Test run |
|---|---|---|---|---|
| `grammar/openscad.gbnf` (built by `grammar/build_grammar.py`) | 1 | `ffade52b8c5d5df67dc5318e4bfc3e8f80c4dbe853401ec02bcea69700bcb6bc` | 2026-10-19 23:40 | 2026-10-20 08:24:14-12:48:56: Qwen2.5-Coder 7B without and with the grammar (`grammar-off`, `grammar-on`; `grammar/test_results.md`). Bonsai's run was cancelled for futility ("Test procedures"). (`grammar/run_grammar.sh`; checked unchanged at the start; served through `bench/ollama_openai_shim.py`, sha256 `6d895159d40334fdee283d18365b10dc8f4a4b5e983ea2c3243db303ed167b60`) |
| `scadfix/scadfix.py` (32 rules, `scadfix/FROZEN.md`) | 1.0 | `85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334` | 2026-10-20 02:28 | 2026-10-20 02:28:53-02:31:46, offline re-scoring of `main`, `ft-scad`, `main-bonsai`, `main-tiiny` (`scadfix/README.md`) |
| `spec/spec.py`: writer Gemma 4 E4B (`gemma4:e4b-it-q4_K_M`, Ollama ID `dc35e8d9c606`), prompt v1, measurement version 3, the gate's tolerances | spec 1 | `8333f8d6e1b9c1a4a47b50978e2716c9d6a5028f97aefa33541ab65020ed2541` | 2026-10-20 02:41 | 2026-10-20 02:42-03:16, `spec/bench_gate_gemma4_e4b_it_q4_K_M.md` |
| `spec/bench_gate.py` (the test procedure; also runs the Claude reference rows, v1 and v3) | 1 | `a9cf67f46041fd2d03d67a55300514f576f3134517be124dabd2e2daf8626d9d` | 2026-10-20 02:41 | 2026-10-20 02:42-03:19; Claude rows in `spec/bench_gate_claude_*.md` |
| Templates: `templates/FROZEN.sha256`, a manifest of 39 files (`templates/backend.py`, `templates/library.py`, the 34 `finetune/seeds/*.scad`, `common.py`, `plugins.py`, `bench/run_bench.py`); model Qwen2.5-Coder 7B (`qwen2.5-coder:7b`, Ollama ID `dae161e27b0e`) | templates 1 | `1de0930053202dcd9760302f540055eb52a2ecf74f47ae91edb2f74f525e6950` (the manifest) | 2026-10-20 06:28 | 2026-10-20 07:03:37-07:27:14 (`sm-template`), `templates/test_results.md` |
| Features: `features/FROZEN.sha256`, a manifest of 5 files (`features/compiler.py` with the revolve fix, `features/fbackend.py`, `common.py`, `plugins.py`, `bench/run_bench.py`); model Gemma 4 E4B (`gemma4:e4b-it-q4_K_M`, Ollama ID `dc35e8d9c606`) | features 1 | `402982a99c81aae88f5272265ac0097cad8bb2dbd4e584842a9f831ed1471588` (the manifest) | 2026-10-20 07:02 | 2026-10-20 07:27:14-08:24:01 (`sm-features`), `features/test_results.md` |

## Notes from the development work

- **scadfix** (`scadfix/README.md`):
  - While looking for development data, its builder printed 600 characters of one base-model output on a benchmark
    task (`finetune/validation_run/outputs_base.json`, the tube rack). The output showed the `block = cube(...)`
    pattern that the task description already named. No rule was written or changed because of it.
  - The list of candidate rules draws on the paper's account of how the laptop runs failed, so the designer knew
    the kinds of failure in advance.
  - A bug found after freezing is left in 1.0. `bracketless_comprehension` also wraps loops of shapes in list
    brackets. 52 of its 55 firings in the test were such misfires, which kept those loops from being repaired as
    shapes. A fix would be version 1.1, tested separately.
- **Templates and features: Qwen3.5 4B left out** (2026-10-20 ~05:45):
  - Ollama 0.30.11 does not apply the JSON schema (`format`) to Qwen3.5 4B. In the template run, 34 of its first
    36 design picks ran to the 600-token cap and the other two stopped near 500 tokens, where a pick is about 10.
  - One pick was repeated by hand (`templates/format_check.py`, the first development item). It returned OpenSCAD
    code instead of a design name and stopped at the cap (`done_reason: length`).
  - The run was stopped after those 36 picks; none was recorded. They were all in-library items, so it could have
    got at most 62 of the 96 right. Gemma 4 E4B got 90 (67 of 68 in the library; 22 "none" and 1 matching pick out
    of it), so stopping the run could not change the choice.
  - It is left out of features development for the same reason. Its spec-writer replies did parse (56 of 56): that
    prompt shows JSON examples, and the schema was probably not applied there either.
- **Templates: development result and the choice** (2026-10-20 06:27):
  - Gemma 4 E4B and Qwen2.5-Coder 7B tie at 90 of the 96 right:
    - each has 67 of the 68 library items with the right design and parameters;
    - outside the library, each has 22 "none" and 1 pick whose built part matches (`spoked_wheel` built as
      `fan_guard`).
  - Wrong picks:
    - Gemma: `drawer_pull` ×2, `fan_guard` ×2 and `t_slot_nut` ×2 for out-of-library parts, and `filleted_bracket`
      for a `corner_bracket`.
    - Coder: `drawer_pull` ×2, `rounded_plate` ×2 (for ribbed panels) and `fan_guard` ×2 for out-of-library parts.
  - The written tie-break, "shorter median time", is a sibling of both methods' bullets. We apply it to templates,
    where it is the only written tie-break that fits.
    - Gemma's median (31 s) includes 18 records from the first, one-pass run, made while the spec test shared the
      laptop (median 159 s).
    - On the 78 items Gemma ran in the two-pass run, alone on the laptop, the medians are Gemma 28.9 s and Coder
      24.5 s. Counting model compute only, they are 27.4 s and 24.0 s.
    - Coder is faster on every count, so the choice does not hang on that confound.
  - Frozen: Qwen2.5-Coder 7B.
- **Features: development result, a compiler fix, and the choice** (2026-10-20 06:57-07:02):
  - First attempts on the 28 batch-C descriptions:
    - Gemma 4 E4B: 24 build a part, 10 pass, mean score 0.61, median 22 s.
    - Qwen2.5-Coder 7B: 27 build a part, 6 pass, mean score 0.64, median 34 s.
  - Five parts built nothing watertight:
    - Gemma's two star wheels gave the outline as (radius, angle) pairs instead of x-y points. That is the model's
      error.
    - Three torus weights (two from Gemma, one from Coder) gave a revolve profile that crosses the axis. The
      compiler cuts such a profile at the axis.
  - The torus parts exposed a compiler bug. A revolve profile with points on the axis, which is how any solid of
    revolution is written, exports from OpenSCAD 2026.10.01 as a mesh that is not watertight; the benchmark's checks
    then fail it. A 3D boolean merges those points.
  - The fix, made before the freeze: such a revolve is intersected with a box around everything, which leaves the
    shape unchanged.
    - Re-scoring the 56 saved development outputs with the fixed compiler (first attempts do not depend on it) changes
      only those three parts. They now build and still fail (score 0.4). The pass counts stay at 10 and 6.
    - `test_methods.py` has a test for it (a revolved cylinder is watertight, of the right volume).
    - The paper's results do not depend on this artifact. Across all saved runs, 239 attempts built a part that is
      not watertight (26 of them use `rotate_extrude`). Every one also fails a size, piece-count or slice check.
  - By the rule (most passes): Gemma 4 E4B, frozen.

## Test results

- **`spec` 1** (2026-10-20 02:42-03:19; 2,880 saved local attempts, 166 of them right by the hidden checks):

  | Spec writer | Accepts the reference | Gate accepts | of them right | Right parts accepted |
  |---|---:|---:|---:|---:|
  | Gemma 4 E4B, v1 (frozen) | 10/16 | 321 | 0.36 | 0.70 |
  | Claude Sonnet 5.5, v1 (reference) | 15/16 | 410 | 0.38 | 0.95 |
  | Claude Sonnet 5.5, v3 (reference) | 15/16 | 404 | 0.39 | 0.95 |

  - On the benchmark, about two in three parts that the gate accepts are wrong, whoever writes the spec. On
    development data it was one in four.
    - Few of the benchmark's attempts are right: 6%, against 40% of the development attempts.
    - The hidden checks test internal features the spec cannot state. Of the wrong parts the frozen gate accepts,
      128 fail the volume check and 110 the probes for material inside the part. Others fail on hole positions
      and rectangular slots or wells.
    - Five tasks give most of them: the gel tank (55), the slide rack (46), the funnel (25), the PCR rack (20) and
      the gel comb (14).
  - Cascade, per sample of 16 tasks, parts kept local:
    - Gemma 4 26B on the box: 6 right and 3.3 wrong with the frozen gate; 9.3 right and 0 wrong with the hidden
      checks.
    - gpt-oss-120b: 3.5 right and 0.5 wrong.
    - Qwen3.8 27B: 3.5 right and 0.5 wrong.
    - Laptop models: at most 2 parts per model are kept. Only Bonsai 2 27B keeps a right one (1 right, 0 wrong);
      the others keep 0 to 2 wrong parts each.
  - Verdict: the gate passes most right parts, but it does not keep wrong parts out. A cascade needs a check closer
    to the hidden ones: probes, slots and positions written from the request.
  - This diagnosis was made after the test. It is not fed back into spec 1.
- **Templates 1** (Qwen2.5-Coder 7B, run `sm-template`, 2026-10-20 07:03:37-07:27:14; per task in
  `templates/test_results.md`):
  - 0 of 16 tasks pass within three attempts. 6 of 16 first files build, against 1 of 16 when the same model writes
    OpenSCAD (`main`). The median is 0.4 minutes a task, because most tasks end at "none".
  - Coder picked "none" for 10 tasks, 5 of them with a related design in the library: the 50 mL and PCR racks, the
    hose reducer, the tube adapter and the rod clip.
  - It picked a design for 6 tasks, and every one builds:
    - `funnel` for the funnel: 15 of 16 checks on the first attempt, failing only the hole diameter at 49.5 mm;
    - `knurled_knob` for the D-shaft knob (8 of 14), `grid_tray` for the 1.5 mL rack (7 of 12; it set a 30 mm
      pitch), `lidded_box` for the enclosure (6 of 12);
    - `rounded_plate` for the gel comb and `grid_tray` for the seed template: neither builds that kind of part.
  - The feedback barely moved the parameters. On two tasks they never changed. On the other four, one value
    changed after the first report, then stayed. No change helped: the funnel's cone went from 30 to 35 mm and its
    score from 0.94 to 0.69.
  - Verdict: templates make small models' files build, but on these tasks the generic designs and the model's
    parameters miss the specific features the checks test, and the model does not use the report to correct them.
- **Features 1** (Gemma 4 E4B, run `sm-features`, 2026-10-20 07:27:14-08:24:01; per task in
  `features/test_results.md`):
  - 1 of 16 tasks passes within three attempts: the 0.2-in-1.5 mL tube adapter, on the first attempt (1.2
    minutes). The same model writing OpenSCAD passes none (`main`).
  - 15 of 16 first files build, against 9 of 16 in `main`. The median is 3.2 minutes a task, against 6.1. Only the
    gel tank never builds.
  - Near misses:
    - the micropestle fails only its height, 64.0 mm against 63.5, on all three attempts;
    - the D-shaft knob reaches 0.64; its bore has no flat.
  - The other tasks miss counted or placed features, or the overall size:
    - holes in the racks and the seed template: 8 of 24, 4 of 6, 2 of 96 and 19 of 49;
    - the slide rack's slots, the funnel's bore and the bracket's holes;
    - the overall size of the hose reducer, the fan housing and the rod clip.
  - The best score came after feedback on 2 of 16 tasks (4 of 16 in `main`). On the other 13 failing tasks, every
    attempt scored the same.
  - Verdict: features almost always build and give this model its first pass on the benchmark. They fall far short
    of the viability bar, and, as with templates, the model does not use the report.
- **Grammar 1** (Qwen2.5-Coder 7B served by llama-server, the same path with and without the grammar; runs
  `grammar-off` 08:24:14-09:30:52 and `grammar-on` 09:30:52-12:48:56; per task in `grammar/test_results.md`):
  - 0 of 16 tasks pass, with or without the grammar. 1 of 16 first files build in both: the seed template, whose
    files build on every attempt either way.
  - The grammar was applied, but the files did not parse any better.
    - Parse errors went from 45 to 36 of 48 attempts.
    - All 36 are files cut off part-way: 27 replies ended at the repetition cut-off and 9 at the length cap. Without
      the grammar, all 48 replies ended normally.
  - The median task took 9.1 minutes, against 3.7 without the grammar.
  - How it fails:
    - The model's mistakes start at a token the grammar forbids, for example a shape assigned to a variable.
    - Pushed to the nearest allowed token, it writes nonsense (`unionfor (`, `cylinder[r == ...`).
    - It never gets back to a design.
  - Verdict: constraining the tokens does not repair this model's mistakes; it derails the model.
  - Bonsai's run was cancelled for futility before it started ("Test procedures").

## Round 2 (pre-registered 2026-10-20 ~09:05, before any round-2 code or run)

Seb, 2026-10-20: "Lets do all of these". Three follow-ups to round 1. None of them changes a frozen artefact.

- **R2. Resample instead of repair** (laptop, after the grammar runs).
  - Hypothesis, from the paper's earlier finding that small models do not use feedback (§6.4, the fine-tune's
    determinism): with the same three attempts, three fresh samples do at least as well as one sample and two feedback
    turns. Round 1 strengthened it: on 13 of 15 failing features tasks, all three attempts scored the same.
  - The frozen methods, unchanged: templates 1 (Qwen2.5-Coder 7B) and features 1 (Gemma 4 E4B). The manifests must
    still check before each run.
  - `run_bench.py --samples 8 --max-repairs 0`: each sample is a fresh conversation with the request only (seed
    1000 + 100 × sample), checked by the hidden checks; no feedback.
    - At temperature 0.2, the protocol's (runs `sm-template-r8`, `sm-features-r8`). Sample 0 repeats round 1's first
      attempt.
    - At temperature 0.7 (runs `sm-template-r8t7`, `sm-features-r8t7`), for more varied samples.
  - Primary measure: tasks with a pass among samples 0-2, against round 1's tasks passed within three attempts
    (templates 0/16, features 1/16).
  - Secondary measures: pass@1, pass@3 and pass@8 per task by the unbiased estimator over the 8 samples; distinct
    built files per task (by sha1); first files that build.
  - Order: features at 0.2, features at 0.7, templates at 0.2, templates at 0.7.
- **R3. scadfix 1.0 live in the loop** (NPU box; Seb approved box time).
  - Model: Qwen3.8 27B, which gained most in the offline what-if (4 + 4 -> 6 + 9 tasks within three attempts).
    Gemma 4 26B is not tested: it almost never makes syntax errors, and scadfix changed none of its results.
  - Three samples under the box protocol of `main-tiiny`: the sweep's frozen harness copy (commit `c43e250`,
    `HARNESS.sha256` checked), the same arguments as its Qwen3.8 jobs (none beyond `--samples`), run through the same
    tiinykit bridge. Run `box-scadfix-qwen38`.
  - The one difference: every reply's code goes through `scadfix.fix` (1.0, sha256 `85f74e83...`, checked) before it
    is written and rendered. When a rule fires:
    - the repaired file is what is rendered, checked and reported on;
    - it also replaces the code in the conversation, so the model's next turn sees the repaired file as its own;
    - the model is not told that a repair happened;
    - the record keeps the rules that fired and the original reply.
  - Implemented as a wrapper (`scadfix/live_bench.py`) that imports the harness's `run_bench.py` and wraps its
    backends; no harness file changes.
  - Measures: tasks passed within three attempts, first-attempt passes and first files that render, per sample.
    Compared with the standard samples of the same model in `main-tiiny` (2 so far), and with the what-if's
    prediction for them (6 and 9).
  - The box ignores seeds, so samples are compared as samples, never by index.
- **R4. New tasks for methods designed after round 1.** Any method designed from round-1 results is tested only on
  tasks nobody had seen when it was designed: a new set of lab parts, with reference designs and hidden checks, chosen
  with Seb. To be specified before any method is tested on them.
  - The parts (2026-10-20 ~09:50):
    - Seb's picks: a magnetic bead rack for a PCR strip, a cuvette rack, an upright Petri dish rack, a syringe
      holder, an eyepiece phone adapter, a shelf-edge pipette holder, a water-bath float for 15 mL tubes, and a
      tubing manifold with internal channels;
    - holders for 1.5 mL, 2 mL round-bottom, 15 mL, 50 mL and PCR tubes, each a different construction;
    - three added for diversity ("What we really want is a diversity of applications and shapes"): a hockey-stick
      cell spreader, a cell strainer insert for a 50 mL tube, and a tubing pinch clamp with a living hinge.
  - Authored blind. A separate agent wrote the prompts, reference designs, hidden checks and wrong-part mutants into
    `bench/heldout/`, validated them as `build_refs.py` does, and reported only counts and hashes. Claude, who
    designs the methods, knows only the part names above and does not open `bench/heldout/` until every method to
    be tested on it is frozen. Seb may read it.
  - Frozen 2026-10-20 ~11:30, from the authoring agent's report. Claude checked both manifests from the repo root at
    11:45; their paths are relative to it.
    - `bench/heldout/FROZEN.sha256`: sha256 `e49b7bea4be615a9ce4a5fe71544bf57d56a7ed02b571b758570cc14d30e44b0`.
    - `bench/heldout/harness/HARNESS.sha256` (35 files): sha256
      `2ed82d70aa698964a3f00eb475a16c611e829d59eed45d6a1e0821ecf6f5bea7`. The harness copy's templates and features
      files match their methods' `FROZEN.sha256`. The template library reads the seed files from the repo, and the
      templates manifest covers them.
    - Validation, from the agent's counts:
      - 16 tasks, 4 per category.
      - Every reference passes its own checks, still passes when rotated, mirrored and moved, and fails when scaled by
        3 %.
      - Cross-checks, 752 in all: every held-out reference fails every other held-out task and each of the 16
        original tasks; every original reference fails every held-out task.
      - All 97 wrong-part mutants fail; all 25 correct variants pass. (Corrected 2026-10-22: this said each variant was
        coded independently. Sixteen are, one per task; the other nine are variations of a reference, such as a
        coarser `$fn` or chamfered holes.)
      - No model calls were made.
    - The agent found a checker problem while authoring: some correct codings of one part exported with sliver
      triangles where unioned faces sit flush, and the frozen checker then counted extra bodies and no volume. It
      changed that task's geometry so the reference avoids them. Models' files can hit the same problem on any task;
      see "Checker audit" below.
  - What Claude has seen of the set, more than the "counts and hashes" above:
    - The agent's report also gave:
      - the 16 task ids and their categories;
      - the number of checks of each kind, mutants and variants per task;
      - its notes on the weakest checks: volume tolerances in general, the Petri dish rack, the shelf pipette holder,
        the cell strainer and the manifold.
      It gave no prompts, dimensions, tolerances or reference code.
    - Claude's own error: a hash check run from the wrong folder printed the names of 9 mutant files for two tasks
      (the cell strainer insert and the 15 mL incline rack). The names say what each mutant changes. The rest of that
      output went to a file Claude has not opened.
    - Every method tested so far was frozen before this: spec 1, scadfix 1.0, templates 1, features 1 and the grammar
      shim. For any method designed after 2026-10-20 11:40, results are reported on all 16 tasks and also on the 14
      tasks without those two.
  - Checker fix and ceiling check (2026-10-20 ~13:30-14:00; Seb, the same day: "All 4"):
    - The authoring agent put the released checker into the harness copy: `tools/scadreport.py` with the
      `load_mesh` clean-up, v0.3.1 ("Checker audit" below). It then re-ran every validation step:
      - every step passes;
      - `reference_stats.json` is byte-identical;
      - no mutant now passes;
      - the 3 flush-face codings that had failed now pass.
    - Claude Opus 5.5 passed 16 of 16 tasks on the first attempt, as on the original 16, so no task needed review.
      The run is `ceiling-opus` in the harness copy, with the original set's ceiling arguments (up to 7 attempts).
    - `FROZEN.sha256` is unchanged. `harness/HARNESS.sha256` is now
      `e157b6e91f4aebc456ac42973c658cd8681d5074b84cd20cd8fbceca8fcb4ef6`. Claude checked both from the repo root.
    - This time the report gave only counts and hashes.

### R4 test plan (drafted 2026-10-20 ~14:30; approved ~15:05, Seb: "Yes to all, pause the sweep for it": every arm, B5 included, the box arms first with the sweep paused)

Written before any model except the Opus ceiling has seen the held-out tasks. Every method tested here was frozen
before the set existed: templates 1, features 1, scadfix 1.0, spec 1, and the h4 harness (chosen on batch C, §6.4).

**Questions and measures**
- **Q1, the benchmark itself.** Do the models rank the same on new tasks?
  - Measure: tasks passed within three attempts, per sample, on the new tasks against the original 16, for every
    model run on both.
  - Expected: the same order as on the original set: Opus > Gemma 4 26B > Qwen3.8 27B > the laptop models.
- **Q2, the better prompt (h4) on Gemma 4 26B.** On the original set it raised first-attempt passes from 9/48 to
  22/48 (10 tasks more often, 0 less often), while passes within three attempts barely moved.
  - Measure: first-attempt passes per task, h4 against the standard prompt, by a one-sided sign test over tasks.
  - Secondary: passes within three attempts (two-sided).
- **Q3, scadfix live on Qwen3.8 27B.** On the original set, first files that render went from 8/32 to 35/48 and
  passes did not move clearly (R3).
  - Measure: first files that render, live against standard, by a one-sided Fisher test over conversations.
  - Secondary: passes (two-sided).
- **Q4, the laptop methods.** Templates 1 and features 1 against the same model writing OpenSCAD.
  - Measures: tasks passed within three attempts, first files that build, and median minutes a task, against the
    viability bar (8/16 within three attempts, at most 10 minutes a task).
- **Offline, free.**
  - scadfix 1.0 re-scoring of every held-out run's saved attempts, as in round 1.
  - The spec 1 gate's precision and recall on the held-out attempts.

**Arms**

| Arm | Machine | Model and method | Samples | Estimated time | Question |
|---|---|---|---:|---:|---|
| R4-0 | Claude CLI | Claude Opus 5.5, ceiling arguments | 1 | done: 16/16, first attempt | ceiling |
| R4-H | Claude CLI | Claude Sonnet 5.5 and Claude Haiku 4.5, standard | 1 each | ~1 h together | Q1 |
| R4-L1 | laptop | Qwen2.5-Coder 7B, standard | 1 | ~1.3 h | Q1, Q4 baseline |
| R4-L2 | laptop | templates 1 (Coder 7B) | 1 | ~0.5 h | Q4 |
| R4-L3 | laptop | Gemma 4 E4B, standard | 1 | ~2 h | Q1, Q4 baseline |
| R4-L4 | laptop | features 1 (Gemma 4 E4B) | 1 | ~1.1 h | Q4 |
| R4-L5 | laptop | Bonsai 2 27B ternary, standard | 1 | ~8-10 h, overnight | Q1 |
| R4-B1 | box | Gemma 4 26B, standard | 3 | ~2 h | Q1, Q2 |
| R4-B2 | box | Gemma 4 26B, h4 (`system_idioms_examples.md`, `--feedback checklist`) | 3 | ~2 h | Q2 |
| R4-B3 | box | Qwen3.8 27B, standard | 3 | ~1.4 h | Q1, Q3 |
| R4-B4 | box | Qwen3.8 27B, scadfix live | 3 | ~1.4 h | Q3 |
| R4-B5 (optional) | box | Qwen3.6 27B, standard (#2 on the original set) | 2 | ~3 h | Q1 |

- Times are the original set's per-sample times scaled by 1.25, since the new prompts are longer.
- Box total: about 7 h without B5, 10 h with it. Laptop total: about 5 h, plus Bonsai overnight.

**Conditional laptop arm, decided from R2 alone** (R2's results are not R4 data). If R2's primary measure shows
resampling beating repair for a method, at either temperature, that method is also run on the held-out set under
R2's protocol: 8 samples, one attempt each, at the better temperature.

**Procedure**
- **Harness.** Every arm runs in the held-out harness copy.
  - Both manifests are checked from the repo root before each run: `FROZEN.sha256` `e49b7bea...` and
    `harness/HARNESS.sha256` `e157b6e9...`. So are the method's own `FROZEN.sha256`, and for B4 scadfix's hash.
  - For standard runs this harness behaves like the sweep's frozen copy. The differences are the checklist option,
    a transport header, moving a redone conversation's old files aside, and the v0.3.1 checker, which both copies
    now have.
  - Box arms use the tiinykit bridge with the sweep's arguments, laptop arms use Ollama with the main protocol,
    and hosted arms use the Claude CLI with the standard arguments.
  - B4 needs one change first: `live_bench.py`'s manifest check must also accept repo-root-relative paths, as this
    harness uses. It is a wrapper change only; scadfix stays the frozen 1.0.
- **Order.**
  - The two arms of each comparison alternate sample by sample on the box: B1 s0, B2 s0, B1 s1, and so on; then B3
    and B4 the same way. Same model, so no reload, and time or box drift does not favour either arm.
  - Laptop order: L1, L2, L3, L4, any conditional arm, then L5. One Ollama job at a time, after R2 has finished.
- **When.** Laptop arms start after R2, today. Box arms run either after the sweep ends (about 09:00 on 10-21) or
  with the sweep paused at a job boundary, as Seb chooses.
- **Blinding.**
  - Results stay under `bench/heldout/` and are read only by an aggregate-only script: counts per run and sample,
    with no task ids, check names or code.
  - Per-task results stay sealed until Seb decides to open them, because once opened the set is no longer blind for
    later methods.
  - Seb may read anything.

**Execution** (launched 2026-10-20 ~15:10; scripts in Claude's scratchpad, logs with counts only):
- **Box**, user unit `r4-box` (`r4_box.sh`, log `r4_box.log`). It pauses the sweep after its next saved
  conversation and puts the v0.3.1 checker into the sweep's frozen harness at that boundary. This replaces unit
  `sweep-harness-patch`, which was stopped. Runs:
  - `r4-gemma26b-std` / `r4-gemma26b-h4`, alternating;
  - `r4-qwen38-std` / `r4-qwen38-scadfix`, alternating;
  - `r4-qwen36-std`.
  It resumes the sweep on any exit, and after 14 h whatever is left.
- **Claude CLI**, unit `r4-hosted` (`r4_hosted.sh`): run `r4-claude`, Sonnet 5.5 and Haiku 4.5. It runs alongside
  R2, which adds a few renders to the laptop's load.
- **Laptop**, unit `r4-laptop` (`r4_laptop.sh`). It waits until R2 is fully inactive, then re-checks
  `sm-features-r8` with `rescore.py --only-open` before the R2 decision. Runs:
  - `r4-coder7b`, `r4-template`, `r4-gemma4e4b`, `r4-features`;
  - `r4-<method>-r8` if the R2 rule fires;
  - `r4-bonsai`.
- All results go to `bench/heldout/harness/bench/results/<run>/`, with run_bench's own output in `run.log` there
  (sealed). Summaries come only from `r4_summary.py`, which prints counts and the pre-registered tests.

**Not run, and why**
- The grammar: it derails models ("Test results").
- A gate-driven repair loop on the box: spec 1's precision was 0.36.
- The fine-tunes: their transfer story is already told by the held-out half of the original set; possible later.
- Thinking-on runs: each sample takes hours.
- The other store models: little information per box hour.

## Round 2 results

- **R3, scadfix 1.0 live** (Qwen3.8 27B on the NPU box, run `box-scadfix-qwen38`, 2026-10-20 09:20-10:41; the
  sweep paused at 09:19:51 right after a saved task and resumed at 10:41:43):

  | | Standard (`main-tiiny`, 2 samples) | scadfix live (3 samples) |
  |---|---:|---:|
  | Tasks passed per sample | 4, 4 | 7, 4, 4 |
  | Conversations passed | 8/32 | 15/48 |
  | First-attempt passes | 5/32 | 8/48 |
  | First files that render | 8/32 | 35/48 |
  | Expected tasks with a pass in 2 samples | 6 | 8.0 (unbiased, from 3 samples) |

  - The repair made most files build: first files that render rose from 25% to 73% (one-sided Fisher p = 3e-5).
  - Rules fired on 30 of the 48 conversations, almost all `geometry_to_module` (29 attempts). 7 of those 30
    conversations passed, every one at or after the repair. The repaired file replaced the model's code in the
    conversation each time.
  - Passes rose less: 15/48 against 8/32 (31% against 25%; one-sided p = 0.37), within the box's sample-to-sample
    noise.
  - The offline what-if had predicted 6 and 9 for the standard samples (7.5 a sample); the live run gave 5.0. A
    likely reason, not tested: in the what-if each of a conversation's three attempts was repaired on its own,
    three different designs, while live the repaired first file anchors the conversation and later attempts revise
    it.
  - Verdict: in the loop, scadfix turns most of this model's syntax failures into parts that build. Seven passes
    came in conversations it repaired, but whether those would have passed anyway is unknown, and the overall gain
    is too small to separate from noise with three samples. More samples would settle it.
- **R2, resample instead of repair** (laptop, unit `smallmodels-round2`, 12:49-17:28; 8 fresh samples per task, one
  attempt each, no feedback):

  | Run | Tasks with a pass in samples 0-2 | Round 1, within 3 attempts | pass@1 | pass@3 | pass@8 | Distinct files | First files build |
  |---|---:|---:|---:|---:|---:|---:|---:|
  | features, T 0.2 (`sm-features-r8`) | 1/16 | 1/16 | 0.88 | 1.00 | 1.00 | 65/128 | 124/128 |
  | features, T 0.7 (`sm-features-r8t7`) | 1/16 | 1/16 | 1.00 | 1.38 | 2.00 | 108/128 | 126/128 |
  | templates, T 0.2 (`sm-template-r8`) | 0/16 | 0/16 | 0 | 0 | 0 | 14/128 | 47/128 |
  | templates, T 0.7 (`sm-template-r8t7`) | 0/16 | 0/16 | 0 | 0 | 0 | 21/128 | 46/128 |

  - The pass@k columns are expected tasks passed: sums over tasks of the unbiased estimate. Numbers from
    `round2_summary.py --corrections checker_audit/audit_all.jsonl`; the correction changes nothing here.
    `sm-features-r8`, which started on the old checker, was re-checked with `rescore.py --only-open`: 0 changes.
  - Primary measure: a tie for both methods at both temperatures. Three fresh samples did as well as one sample and
    two feedback turns, as the hypothesis predicted ("at least as well"), and no better.
  - Features passes the same task as in round 1, the PCR tube adapter, in 7 of 8 samples at both temperatures. At
    0.7 one more task, the 1.5 mL tube rack, passed once in 8 samples (pass@8 2.00). That takes eight tries, more
    than the three-attempt budget the primary measure compares.
  - Templates: no pass in 256 samples. First files build as often as in round 1 (36-37%, against 6/16).
  - Temperature 0.7 gave more varied files (108 against 65 distinct of 128 for features, 21 against 14 for
    templates) but no more tasks in samples 0-2.
  - **Decision for R4:** resampling did not beat repair for either method, so the conditional held-out arm does not
    run (rule in "R4 test plan"). `r4_laptop.sh` applies the same rule after L1-L4 and logs it.

## Checker audit (2026-10-20)

The held-out authoring agent found that some correct parts fail the frozen checker, and the same can happen to
models' files on the original 16 tasks.

- **Cause.** OpenSCAD 2026.10.01 exports with its Manifold backend by default.
  - Where two unioned parts meet flush, it can leave zero-area sliver triangles: for example, a spout tube whose top
    ring sits exactly on a cone's bottom ring.
  - The mesh is then not watertight, and `checks.py` counts dozens of separate bodies (49 and 113 here) and leaves
    the volume undefined.
  - With `--backend CGAL`, or after a clean-up of the exported mesh, the same file exports watertight. The clean-up
    merges vertices that round together at 1e-5 mm and drops zero-area faces.
- **Audit.** Every saved failed attempt whose mesh was not watertight, in every results folder: 239 attempts, of
  8,964 that were checked.
  - 226 were re-rendered (`checker_audit/audit_all.py`; records in `checker_audit/audit_all.jsonl`, summary by `checker_audit/impact.py`) and re-checked as saved and after the clean-up.
  - The re-render reproduced the recorded failed checks for all 226.
  - The clean-up made 24 of them watertight, and **3 now pass every check**.
  - All 3 are Qwen3.5 9B funnels with the spout sitting flush on the cone, each on its third attempt. Each was a
    failed conversation that becomes a pass:
    - `gpu-base-g3` (sample 5);
    - `gpu-base-h0-g6` (sample 4);
    - `main-tiiny` (Qwen3.5 9B, sample 0).
  - No attempt that stays open after the clean-up fails only on pieces or volume, so CGAL renders were not needed.
  - 13 attempts could not be re-rendered because their files were not kept. Each failed 4-12 checks, so none was a
    near-pass. (Corrected 2026-10-22: only the 3 `lang-claude` files were not kept. For the other 10, in the h4 runs
    `box-gemma-h4`, `gpu-base-h4-g1` and `gpu-base-h4-g10`, `audit_all.py` looked for the file without its
    `_checklist` suffix; it now adds it. `rescore.py --dry-run --only-open` on those three runs changes nothing.)
- **Correction rule (exact for pass counts).** An attempt that passes after the clean-up counts as a pass. With a
  fixed checker the conversation would have ended there, so tasks passed within three attempts and first-attempt
  passes are the same as a fixed checker's. `round2_summary.py --corrections` applies the rule to R2 and to its round
  1 comparison.
- **Decided (Seb, 2026-10-20: "All 4"): fixed and published.**
  - **Paper v0.3.1.** Released 2026-10-20 17:57 UTC. Commits `a5dce29` (the fix, `rescore.py --only-open`, tests)
    and `7376c63` (re-scored records, regenerated tables, corrected text); DOI 10.5281/zenodo.23507821. Audit in
    `meta/audits/2026-10-20_v0.3.1.md`.
  - **When each harness got the fix:**
    - The repo's `tools/scadreport.py` (`load_mesh`) has had it since ~13:00. R2's first run, `sm-features-r8`,
      started at 12:49 and imported the old file, so after R2 its records are re-checked with
      `bench/rescore.py --only-open`. The later R2 runs use the fixed file.
    - The held-out harness has it, validated, before any model ran on it except the Opus ceiling check.
    - The sweep's frozen harness got it at 15:38:32, when unit `r4-box` paused the sweep right after a saved
      conversation: `tools/scadreport.py` sha256 `46f43f39…` → `8c75e034…`, `HARNESS.sha256` checks, change noted in
      its `HARNESS_CHANGES.md`. (Unit `sweep-harness-patch`, planned for this, was stopped before it acted.) Records
      made before that are re-checked the same way when the sweep is written up.
  - **Round 1 runs** (`sm-template`, `sm-features`, `grammar-*`, `box-scadfix-qwen38`): the audit found no change
    in any of them.

## R4 results (held-out set)

Counts from `r4_summary.py` only; per-task results stay sealed. Original-set numbers come from the same script run
on `bench/results` (`main-claude`, `box-gemma-h0`, and so on).

- **R4-0, ceiling** (Claude Opus 5.5, ceiling arguments): 16/16, every task on the first attempt.
- **R4-H, hosted** (run `r4-claude`, done 15:55; one sample each, standard arguments):

  | Model, original → held-out | Passed within 3 | First-attempt passes | First files build | Median min/task |
  |---|---:|---:|---:|---:|
  | Claude Sonnet 5.5 | 16 → 16 | 16 → 16 | 16 → 16 | 0.1 → 0.2 |
  | Claude Haiku 4.5 | 14 → 10 | 11 → 7 | 15 → 13 | 1.9 → 2.2 |

  - Sonnet passes every task on the first attempt on both sets.
  - Haiku passes four fewer tasks on the new set. That is one sample against one on different tasks (Fisher
    two-sided p = 0.22), so the new set may be harder for it, but this does not show it.
- **R4-B1/B2, Gemma 4 26B on the box** (runs `r4-gemma26b-std` and `r4-gemma26b-h4`, 15:38-21:32, three samples
  each, alternating; original-set runs `box-gemma-h0` and `box-gemma-h4`):

  | Gemma 4 26B, original → held-out | Standard | h4 |
  |---|---:|---:|
  | Tasks passed per sample | 9, 7, 12 → 5, 4, 3 | 10, 12, 11 → 3, 3, 5 |
  | Conversations passed | 28/48 → 12/48 | 33/48 → 11/48 |
  | First-attempt passes | 9/48 → 3/48 | 22/48 → 2/48 |
  | First files that build | 44/48 → 42/48 | 45/48 → 40/48 |

  - **Q2, the pre-registered test: no effect on the new tasks.**
    - First-attempt passes per task, h4 against standard: 1 task more often, 2 less often, 13 level; one-sided sign
      test p = 0.875. On the original set: 10 more often, 0 less often, p = 0.001.
    - Passes within three attempts: 3 tasks more often, 3 less often, p = 1.
    - The prompt was chosen on the original set (batch C, §6.4), and its gain there did not carry over to new parts.
    - Caveat: first-attempt passes are near the floor on the new set (3/48 with the standard prompt), which limits
      how large a gain could show. But the original gain was 13 conversations over 10 tasks, and here h4 is not ahead
      at all.
  - **Q1 for this model:** about 4 tasks a sample on the new set against 9.3 on the original, with the same prompt,
    harness and box. Its first files still build (42/48), so it loses on design, not on code.
- **R4-L1 to L4, the laptop** (runs `r4-coder7b`, `r4-template`, `r4-gemma4e4b`, `r4-features`, 17:30-23:06, one
  sample each; original-set runs `main` and round 1's `sm-template` and `sm-features`):

  | Arm, original → held-out | Passed within 3 | First files build | Median min/task |
  |---|---:|---:|---:|
  | Qwen2.5-Coder 7B, standard | 0 → 0 | 1 → 0 | 3.1 → 4.8 |
  | templates 1 (Coder 7B) | 0 → 0 | 6 → 0 | 0.4 → 0.4 |
  | Gemma 4 E4B, standard | 0 → 0 | 9 → 7 | 6.1 → 11.4 |
  | features 1 (Gemma 4 E4B) | 1 → 0 | 15 → 16 | 3.2 → 3.3 |

  - **Q4: neither method reaches the viability bar** (8/16 within three attempts, at most 10 minutes a task) on the
    new tasks, as on the original set.
  - Features still writes a file that builds every time (16/16), but none passes: the parts build but are wrong.
  - Templates builds nothing on the new parts: for every one the model answered that no design in its library fits.
    The library is the 34 seed families of the fine-tuning data, several of them the same kind of part as an
    original task. (Corrected 2026-10-22: this said the library was written from the original set's part kinds.)
  - The standard laptop models pass nothing on either set.
  - No prompt was cut off: Ollama's slot records show 160 replies in L1 to L4, none truncated, the largest 7,074 of
    8,192 tokens.
  - The R2 rule, applied by `r4_laptop.sh` at 23:05:57, gave no conditional arm (features: round 1 1/16, R2 1/16 at
    both temperatures; templates: 0/16 throughout). Bonsai (L5) started next.
- **R4-B3/B4, Qwen3.8 27B on the box** (runs `r4-qwen38-std` and `r4-qwen38-scadfix`, 21:32-00:39, three samples
  each, alternating; original-set runs `main-tiiny`, 2 samples, and `box-scadfix-qwen38`, 3 samples):

  | Qwen3.8 27B, original → held-out | Standard | scadfix live |
  |---|---:|---:|
  | Tasks passed per sample | 4, 4 → 0, 2, 0 | 7, 4, 4 → 2, 3, 2 |
  | Conversations passed | 8/32 → 2/48 | 15/48 → 7/48 |
  | First-attempt passes | 5/32 → 0/48 | 8/48 → 3/48 |
  | First files that render | 8/32 → 9/48 | 35/48 → 33/48 |

  - **Q3, the pre-registered test: the render gain replicates.** First files that render, scadfix against standard:
    33/48 against 9/48, one-sided Fisher p = 7e-7 (original set: 35/48 against 8/32, p = 3e-5).
  - Passes, secondary: 7/48 against 2/48, two-sided Fisher p = 0.16; over tasks, 4 more often, 1 less often, p =
    0.375. The pass gain points the same way on both sets (15/48 against 8/32 on the original), and neither set alone
    shows it clearly. A pooled test was not pre-registered.
  - **Q1 for this model:** under one task a sample on the new set against 4 on the original. Without scadfix, three
    quarters or more of its first files do not render on either set (75% and 81%; the 75% is the two original
    samples then run, 69% over all three).
- **R4-B5, Qwen3.6 27B on the box** (run `r4-qwen36-std`, 00:39-04:18, two samples; original-set `main-tiiny`, 2
  samples): tasks passed per sample 5, 6 → 3, 2 (conversations 11/32 → 5/32); first-attempt passes 6/32 → 1/32;
  first files that build 31/32 → 27/32; median 4.4 → 6.0 minutes a task.
- **The box arms ended at 04:18:47.** `r4-box` resumed the sweep at 04:18:48 (STOP removed; job `think-tiiny`
  Qwen3-8B, 11 conversations to go). The sweep's harness is the patched one: `tools/scadreport.py` `8c75e034…`,
  `HARNESS.sha256` checks.
- **R4-L5, Bonsai 2 27B ternary on the laptop** (run `r4-bonsai`, 23:06-06:09, one sample; original-set
  `main-bonsai`): 2 → 0 tasks passed; first files that build 5 → 3; median 23.9 → 22.2 minutes a task. The
  llama-server unit and the shim stopped cleanly.
- **All arms done 2026-10-21 06:09.**

**Q1, the benchmark itself: the order holds, and every model below the top two that passes original tasks passes fewer new ones.**

| Model (machine), standard protocol | Original set: tasks passed per sample | Held-out set | Held-out as a share of original |
|---|---:|---:|---:|
| Claude Opus 5.5 (ceiling arguments) | 16 | 16, all on the first attempt | 1.00 |
| Claude Sonnet 5.5 | 16 | 16 | 1.00 |
| Claude Haiku 4.5 | 14 | 10 | 0.71 |
| Gemma 4 26B (box) | 9, 7, 12 (mean 9.3) | 5, 4, 3 (4.0) | 0.43 |
| Qwen3.6 27B (box) | 5, 6 (5.5) | 3, 2 (2.5) | 0.45 |
| Qwen3.8 27B (box) | 4, 4 (4.0) | 0, 2, 0 (0.7) | 0.17 |
| Bonsai 2 27B ternary (laptop) | 2 | 0 | 0 |
| Qwen2.5-Coder 7B (laptop) | 0 | 0 | — |
| Gemma 4 E4B (laptop) | 0 | 0 | — |

(Note, 2026-10-22: for Qwen3.6 27B and Qwen3.8 27B the original-set column gives the samples run by then. With
the finished sweep's third samples they are 5, 6, 5 (mean 5.3; share 0.47) and 4, 4, 4 (4.0; 0.17), as in the
paper's Table 15.)

- The predicted order (Opus > Gemma 4 26B > Qwen3.8 27B > the laptop models) holds, and so does the full order of
  the nine models. The only change is at the bottom, where Bonsai falls to 0 and ties the other laptop models.
  Spearman's rank correlation between the two columns is 0.99. This was not pre-registered; the order was.
- Every model below Opus and Sonnet that passes original tasks passes fewer new ones, and the weaker models lose the
  larger shares (Qwen3.8 27B and Bonsai most), though not strictly in order (Qwen3.6 27B keeps 0.45, Gemma 4 26B
  0.43). (Corrected 2026-10-22: this said every model below the top two, and that the share lost grows with
  weakness; the two laptop models that passed nothing on the original set pass nothing on the new one.)
  The two frontier models pass everything on the first attempt, so the new tasks can be solved and the checks accept
  correct parts.
- Three explanations remain, and the aggregate counts cannot separate them:
  - the new parts are harder (they were chosen for a diversity of applications and shapes);
  - the original parts resemble designs that are common online, and so in training data;
  - the new checks are stricter.
  Per-task results would show which tasks carry the drop, but reading them unblinds the set (Seb's call).
- **The four questions:**
  - Q1: same order; lower counts for every model below the top two.
  - Q2: h4 gave no gain on the new tasks (p = 0.875), against p = 0.001 on the original set.
  - Q3: scadfix's render gain replicates (p = 7e-7). Its pass gain points the same way on both sets and is not
    clear on either.
  - Q4: neither laptop method is viable on either set.

**Offline measures** (pre-registered; `r4_offline.py`, unit `r4-offline`, 2026-10-21 06:15-06:28). The script
reimplements round 1's `scadfix/test_eval.py` and `spec/bench_gate.py` for a harness copy. Pointed at the original
set it reproduces both exactly: Qwen3.8 27B's what-if (4 + 4 → 6 + 9 tasks, first renders 3 + 5 → 11 + 13), and
every model's first-attempt gate counts in `main` and `main-tiiny`, with 10/16 references accepted. Specs,
measurements and per-attempt rows are sealed in `bench/heldout/harness/bench/results/_offline/`; only counts were
read. Runs: the seven held-out standard and h4 runs of local models (642 saved attempts, none missing a file).

- **scadfix 1.0, what-if re-scoring.** A rule fired on 222 attempts, with no rule errors.

  | Run | Renders 1st try | Pass 1st try | Passed within 3 | Fixed files (render / pass) |
  |---|---:|---:|---:|---:|
  | Qwen3.8 27B, standard | 1 + 4 + 4 → 14 + 12 + 14 | 0 → 1 | 0 + 2 + 0 → 1 + 3 + 1 | 111 (90 / 7) |
  | Gemma 4 26B, standard | 13 + 14 + 15 → 14 + 15 + 16 | unchanged | 5 + 4 + 3, unchanged | 9 (8 / 0) |
  | Gemma 4 26B, h4 | 16 + 13 + 11 → 16 + 13 + 14 | unchanged | 3 + 3 + 5, unchanged | 17 (14 / 0) |
  | Qwen3.6 27B, standard | 14 + 13 → 15 + 15 | unchanged | 3 + 2, unchanged | 7 (7 / 0) |
  | Coder 7B / Gemma 4 E4B / Bonsai, standard | 0 → 6 / 7 → 9 / 3 → 4 | 0 | 0, unchanged | 42 / 14 / 22 (27 render, 0 pass) |

  - As on the original set, only Qwen3.8 27B gains passes: 2 → 5 conversations in the what-if, against 7 when
    scadfix ran live (R4-B4). On the original set the what-if predicted more than the live run gave (7.5 tasks a
    sample against 5.0); here it predicts less (1.7 against 2.3). The two agree within noise.
- **spec 1, the request-derived gate.** The frozen writer's 16 specs all parsed. The gate accepts 7/16 held-out
  reference parts, against 10/16 on the original set.

  | Same seven model-runs | Attempts | Right | Gate accepts | Precision | Recall | Wrong parts accepted |
  |---|---:|---:|---:|---:|---:|---:|
  | First attempts, original set | 208 | 42 | 55 | 0.60 | 0.79 | 22/166 (13%) |
  | First attempts, held-out | 224 | 6 | 37 | 0.05 | 0.33 | 35/218 (16%) |
  | All attempts, original set | 511 | 82 | 119 | 0.50 | 0.72 | 60/429 (14%) |
  | All attempts, held-out | 642 | 30 | 121 | 0.09 | 0.37 | 110/612 (18%) |

  - The original-set rows are round 1's test (`spec/bench_gate_gemma4_e4b_it_q4_K_M.json`) restricted to the same
    seven model-runs. Over all its local runs, round 1 gave precision 0.36 and recall 0.70.
  - The gate lets through wrong parts about as often on new tasks (16% against 13% of first attempts). But it
    rejects two in three right parts (recall 0.33 against 0.79), and right parts are rare on the new set (6 of 224
    first attempts). So 35 of its 37 acceptances are wrong parts: precision 0.05.
  - The writer was developed on batch-C descriptions. On new parts its specs reject more correct designs,
    including 9 of the 16 references. The gate does not transfer, and a gate-driven loop on new tasks would mostly
    accept wrong parts.

## Unblinding the held-out set (2026-10-21)

Seb approved opening the per-task results at about 22:15 ("okay lets do them all", item 3 of the plan: open the
held-out results task by task so the paper can say why every model below the top two drops). This plan was written at
22:18, before any task file, per-task result or log under `bench/heldout/` was opened. From here on the set is not
blind: a method designed after today must be tested on a fresh set.

None of these analyses is pre-registered. The R4 tests above are final and are not redone.

**What the analyses can separate.** R4 left three explanations for the drop (Q1): the new parts are harder; the
original parts resemble designs common online, and so in training data; the new checks are stricter.

**Planned analyses**
1. **Where the drop is.** Tasks passed within three attempts, per task and model, for every model run on both sets.
2. **Familiar against new kinds.** The held-out set includes holders for five standard tubes (Seb's picks: 1.5 mL,
   2 mL round-bottom, 15 mL, 50 mL, PCR), a kind the original set and online repositories also have. Pass rates on
   those against the other held-out tasks, model by model.
   - If the tube holders pass at about the original set's rate and the drop sits in the new kinds, that points to
     the first two explanations (new shapes are harder, or less familiar).
   - If the tube holders drop as much, that points to the set itself: stricter checks or longer requests.
   - Familiarity and simplicity are confounded here. The training-data explanation cannot be tested directly.
3. **The checks.** For the third explanation:
   - the number of hidden checks per task and their tolerances, against the original set's;
   - a hand check of the failing conversations closest to passing (one failed check, or best score at least 0.8),
     asking of each failed check whether it is right about the part;
   - the same for Claude Haiku 4.5's failures, since it passed 14 of the original 16.
4. **Task size.** Request length, reference code length and number of checks per task, on both sets, and per-task
   pass rates against them.

### Results (`heldout_unblind.py`, 2026-10-21 ~22:30)

"Pooled" below is Claude Haiku 4.5 plus the five box runs (Gemma 4 26B standard and h4, Qwen3.6 27B, Qwen3.8 27B
standard and scadfix live), the models that pass some tasks on both sets. The laptop models pass almost nothing on
either set and are left out of the rates. Original-set counts now include the sweep's third samples.

1. **Where the drop is: almost everywhere.** Pooled, 118 of 256 conversations pass on the original set (0.46) and 47
   of 240 on the held-out set (0.20). Opus and Sonnet pass every task on both.
   - 12 of the 16 held-out tasks have a pooled pass rate of 0.20 or less, against 3 of the original 16. Two held-out
     tasks pass in no pooled conversation (the inclined 15 mL rack, the syringe holder). Only the cell spreader
     (0.73) passes more often than the original set's average.
   - Haiku fails 6 held-out tasks (magnet rack, cuvette rack, syringe holder, balance stand, inclined rack, pinch
     clamp), against 2 original ones.
2. **Familiar against new kinds: no difference.** Pooled, the five tube holders pass 12 of 75 conversations (0.16)
   and the other held-out tasks 35 of 165 (0.21); Fisher p = 0.38.
   - The holders were built to differ from the original grid racks (`bench/heldout/README.md`: a revolved stand, a
     puck with half-sphere seats, tilted holes, a two-part carrier, a hook). Their purpose is familiar and their
     shapes are not.
   - So the split cannot test familiarity with designs online. It does show that a familiar purpose does not help
     when the construction is new.
3. **The checks: right about the parts.**
   - The held-out tasks carry more checks: 8-13 top-level checks per task (mean 11.3) against 5-13 (7.9), and 12-28
     checker items (mean 19.2) against 7-19 (12.6).
   - Hand check of the 37 near-misses (best attempt failing one item or scoring at least 0.8: Haiku 2, Gemma standard
     10, Gemma h4 12, Qwen3.6 4, Qwen3.8 scadfix 9). In every one, each failed check points at a real departure from
     the request. None is a checker false negative.
   - 30 of the 37 would stop the part doing its job:
     - the sleeve built at the plate's centre instead of over the camera hole (Gemma, 5 eyepiece adapters), or
       one or more radial screw holes missing (3 more);
     - a viewing window that only skims the outer millimetre of the wall and never reaches the seat (Gemma, 3);
     - seats that narrow upward instead of downward, from `cylinder(d1 = top, d2 = tip)` with the two diameters
       swapped (5: magnet rack 2, balance stand 3), and one cone 6 mm tall instead of 10;
     - outlet channels rotated to the -Y face, leaving the +Y sockets as dead ends (Qwen3.8, 2), and one channel
       network that never splits the mid-plane (Gemma h4);
     - a tilted hole cutter started at the top face, which leaves a lip across the hole mouth (Haiku, inclined rack);
     - missing or blocked holes, a missing floor, a slot cut through the strainer's wall, missing ridges, loose
       spheres inside seats, pipette holes drilled along the arm instead of through it, a flange slot 12 mm short
       (the rest).
   - 7 are small: a row of dividers 1.5 mm off (2); a label flat 1 mm too far out, after which the seat positions
     fail too, because the checker centres a part on its bounding box (1); end walls outside the deck (1); a deck
     1.5 mm high (1); a window 2 mm wider and taller than asked (1); an off-centre vent (1).
   - Haiku's other four failures are not near-misses: the cuvette rack with its open sides closed, magnet pockets
     not open at the bottom, a syringe channel that does not run through, and a pinch clamp that never rendered
     (`for (i = 90; i <= 270; i += 5)`: OpenSCAD has no `+=`, and the same line came back in all three attempts).
4. **Task size: it explains about half of the drop or more.**
   - Held-out requests are longer: 119-192 words (mean 155) against 76-193 (121). Reference files are a little
     longer: 22-34 lines (29) against 19-35 (26), but they had different authors.
   - On the original set, longer tasks pass less often. Spearman's rank correlation of pooled pass rate with request
     words is -0.70, with reference lines -0.89 (16 tasks). Within the held-out set the range is narrow and the
     correlations are weaker (-0.43, -0.20).
   - Added after the planned analyses above had been read, and not among them: a logistic model fitted to the
     original set's 256 pooled conversations (pass against request words, with a
     term for each model) predicts a held-out pass rate of 0.30, against 0.20 observed and 0.46 on the original set.
     So request length accounts for about 60% of the drop. With reference lines instead, 0.33 (about half). Checker
     items alone predict 0.42.
   - Fitted to both sets with a held-out term, the held-out odds ratio is 0.23 with no size term, 0.52 after request
     words (p = 0.015), and 0.75 after request words and checker items (p = 0.39). These p-values treat
     conversations as independent. Tasks repeat across models and samples, so the p-values overstate certainty;
     with errors clustered by task they are 0.0008, 0.19 and 0.73, so only the first odds ratio differs clearly
     from 1. (Corrected 2026-10-22: the last odds ratio was given as 0.68, p = 0.29, from a fit that took some
     original tasks' checker-item counts from attempts scored by an older checker. The fits are now section 5 of
     `heldout_unblind.py`.)

**Reading**
- The third explanation, stricter checks, does not hold: the checks are right about the parts they fail. The new
  tasks do ask for more, with more features per part and so more to get wrong. That is the first explanation, harder
  parts, and request length alone accounts for about half or more of the drop.
- The failures are spatial, not syntactic. Gemma's first files still build (42 of 48). The near-misses fail on
  orientation and placement: cones upside down, a sleeve on the wrong axis, channels rotated to the wrong face,
  cutters that stop at a surface.
- The part of the drop that size does not explain might come from unfamiliar shapes (the second explanation). Nothing
  here tests that: the only familiar group, the tube holders, has familiar purposes and new constructions, and it
  dropped as much as the rest.
- The held-out set is now open. A method designed from here on needs a fresh blind set.
