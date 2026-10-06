# Audit of logic, methods and claims: printpaper (Prompt to Bench)

Snapshot audited: working tree at HEAD `0498617` plus untracked `bench/results/main/` (202 records, read 6 Oct 2026 ~17:40). Qwen3.5 4B (8/16 tasks) and Qwen3.5 9B (2/16) are **incomplete**, so every number for them is provisional.
Data sources: `bench/results/{main,main-claude,lang-claude}/results.jsonl`, `meta_*.json`, `bench/logs/*.log`, the saved `.scad`/`.reply.txt` files, and `analyze.py --no-readme` output.

**Caveat:** `refs_research.md` is **not present** at `/tmp/claude-1000/-home-seb-printpaper/20fd6f84-13bd-4473-9e16-35a18c47f756/scratchpad/` (the directory holds only `rack.scad`). So I could not check citations against the verified notes. Citation findings below cover only the places where the sentence and the cited work don't logically match. Every literature number (ITU, Microsoft, The Stack sizes, Nyamsuren, Dong, McNair 8.18%, Li 2025) still needs that check.

---

## 0. What the current data supports (headline)

| | n | pass ≤3 | pass 1st | renders 1st | renders any | mean best item-score |
|---|---|---|---|---|---|---|
| Claude Sonnet 5.5 | 16 | 16 | 15 | 16 | 16 | 1.00 |
| Claude Haiku 4.5 | 16 | 14 | 11 | 15 | 16 | 0.99 |
| 12 complete local models | 192 | **0** | 0 | 0-12 per model | 0-12 per model | 0.00-0.36 |
| Qwen3.5 4B / 9B (partial) | 8 / 2 | 0 / 0 | 0 / 0 | 1 / 1 | 1 / 1 | 0.03 / 0.44 |

What the data supports:
- **No tested local model passed any task**: 0/202 conversations. Every complete local model is at 0/16 (Wilson 95% upper bound 19%). Under p = 0.5, P(0/16) = 1.5e-5. So each complete model falls clearly short of the pre-set "half of 16" bar, *under this protocol*: Q4_K_M, thinking off, 2,048-token cap, T = 0.2, one sample, at most three oracle-triggered attempts.
- **Both hosted models are near ceiling.** Haiku 14/16 and Sonnet 16/16 are not distinguishable (Fisher p = 0.48; first try 11/16 vs 15/16, p = 0.17).
- **Language (Haiku only, one sample):** en 14, es 13, hi 12, sw 11. Paired exact McNemar p = 1.00, 0.62 and 0.38. First-try sw 6 vs en 11 (p = 0.125). There is **no detectable effect**.
- **Where local models fail** (first attempt): mostly parse errors. Much of that comes from treating geometry as values (`block = cube(...)`, `holes = for (...)`): 15/16 first files for Qwen2.5-Coder 7B, 14/16 for 1.5B, 11/16 for 3B. Four models mostly ran out of tokens (see #2).
- **Feedback did nothing for several small models.** They returned byte-identical code after every repair message: Qwen2.5-Coder 1.5B 32/32, 7B 32/32, 3B 31/32, Qwen2.5 1.5B 27/32, Qwen2.5-Coder 0.5B 24/32.

What the paper must NOT claim (details in the findings):
- any "minimal viable" local model;
- that small or local models *cannot* do this in general (the result is protocol-bound: thinking off, cap, one sample);
- any language effect;
- a Haiku-vs-Sonnet ranking;
- that `scadreport` feedback "makes small models usable";
- that "printable" means a valid printable part;
- that timings are clean;
- that Claude ran at T = 0.2;
- that the 16 designs are physically "tested".

---

## Findings

### Errors in data or code that change scores or statements

**1. [ERROR] The funnel task fails a valid reading of its own prompt, and the reference violates the spec.**
- The prompt says: "The wall is 1.6 mm thick everywhere" (`bench/tasks.yaml:155`).
- The reference `designs/tools/lab_funnel_60mm.scad` offsets the cone *horizontally* by `wall`. On a 39.8° cone that gives a wall only 1.6·cos 39.8° = **1.23 mm** thick when measured perpendicular to the surface.
- Sonnet's first attempt (`main-claude/code/claude_claude-sonnet-5-5/lab_funnel_60mm_s0_a0.scad`) used a perpendicular 1.6 mm wall ("measured perpendicular to the surface"). It passed every dimensional check and failed only `volume 7298 vs ref 5893 (±15%)` (+24%).
- The diameter tolerances (`hole_d [31.4, 0.8]`, `[55.5, 0.9]`) were evidently widened to admit both readings. The volume tolerance was not.
- **Fix (no rerun needed):** set `volume: {rel_tol: 0.35}` for `lab_funnel_60mm`, or drop the volume check (the probes and diameters already constrain the part). Then rescore the saved `.scad` files. Sonnet's first-try count becomes 16/16.
- Also add to the prompt for future versions: "(1.6 mm measured horizontally)". In §5.2, report that one false negative was found and corrected.

**2. [ERROR] "Thinking is switched off" (README:196) is false for LFM2.5, and many local failures are really truncation.**
- LFM2.5 has the `thinking` capability, and `think: false` was sent (`think=False` is recorded). Even so, **48/48 LFM2.5 replies contain `<think>` reasoning** in the content. 40/48 hit the 2,048-token cap.
- Because the `<think>` block never closed, 26 attempts were extracted as "bare" prose (whole reasoning text fed to OpenSCAD) and 10 as "no code".
- Attempts that hit the cap:

  | Model | Attempts at the 2,048 cap |
  |---|---|
  | Granite 4.2 3B | 37/48 |
  | Qwen3.5 2B | 29/48 (13 more stopped as repetition) |
  | Qwen3.5 4B (partial) | 19/24 |
  | Qwen2.5-Coder 0.5B | 4/48 (23 more stopped as repetition) |

- Spot checks (e.g. `qwen3.5_4b…/tube_rack_1p5ml_s0_a0.reply.txt`, `granite4.2_3b/tube_rack_1p5ml_s0_a0.reply.txt`) show reasoning written into `//` comments until the cap. That supports the §9 statement, but it applies to Granite too, not only Qwen3.5.
- **Fix the README:196 text** to: "'Thinking' was requested off for every model that supports it. Qwen3.5 and Granite 4.2 then reasoned inside code comments, and LFM2.5 ignored the switch and emitted `<think>` reasoning in all 48 replies. For these four models most replies (60-90%) hit the 2,048-token cap, so their score measures 'did not finish within 2,048 tokens' as much as design ability."
- Update §9 "Settings" the same way.

**3. [ERROR] `failure_stage` (analyze.py:105-119) labels truncated output as "syntax error" or "no code".**
- In Table 5, LFM2.5 shows "5 no code / 11 syntax error". All 16 were reasoning cut off at the cap.
- Most first-attempt "syntax errors" are truncations: Qwen3.5 2B 15/16, Granite 12/16, Qwen3.5 4B 7/7.
- **Fix** (insert before the render check):
  ```python
  if a.get("usage", {}).get("done_reason") in ("length", "repetition") and \
     not a.get("render", {}).get("ok"):
      return "truncated"
  ```
- Add `"truncated"` to `stages` in `table_failures` (analyze.py:381), and add "truncated (hit the token cap or looped)" to the Table 5 caption.

**4. [ERROR] "Models ran one at a time, so the timings are clean" (README:198; also `run_main_local.sh:2`) is false.**
- `main-claude` ran 15:35-16:13 and `lang-claude` ran 16:02-17:48 on 5 Oct. Both render and check every attempt with OpenSCAD and trimesh on the same CPU.
- The retained Qwen2.5-Coder 7B records (16:09-17:04) overlap the language run.
- The Haiku English run (to 16:11) and the Haiku Spanish run (from 16:03) overlapped each other.
- The author also reports other CPU work during some runs.
- **Fix:** "Local models ran one at a time, but some runs overlapped other work on the same laptop (for example, the Qwen2.5-Coder 7B run overlapped the hosted language run, whose rendering and checking use the CPU). Timings are indicative to within roughly ±20%, not clean benchmarks."
- Better still, re-time one task per model in isolation (cheap; tokens/s only).

**5. [ERROR] The token-cap protocol is not as stated (README:195, bench/README.md:37).**
- `meta_20261005_154725.json` shows `num_predict: 1024` for the first local pass.
- The cap was raised to 2,048 in commit `1ffe43e` (20:27). That was *after* seeing truncation, so it was a post-hoc protocol change.
- Qwen2.5-Coder 1.5B, Gemma 4 E4B and Ministral 3 were rerun at 2,048 and their 1,024-cap data dropped.
- **Qwen2.5-Coder 7B and 3B were kept at the 1,024 cap.** Their longest replies were 723 and 574 tokens, so the cap never bound, and with fixed seeds the outputs would be identical.
- **Fix:** add "Qwen2.5-Coder 7B and 3B ran with an earlier 1,024-token cap. None of their replies exceeded 723 tokens, so the cap never applied. All other local models ran with 2,048. We raised the cap after a first pass showed Gemma 4 E4B and others being cut off."

**6. [ERROR] The hosted-model token figures (README:197) are wrong.**

| Model | Paper says | Data shows |
|---|---|---|
| Haiku 4.5, main run | 10,000-16,000 output tokens per reply | 4,100-23,456 per reply, median ≈ 10,000 |
| Haiku 4.5, language runs | — | 1,904-26,126 output tokens (thinking 1,325-24,801) |
| Sonnet 5.5 | 400-1,200 tokens in 4-17 s | 320-1,430 tokens (median 668); 3.5-11.5 s per reply; 4-17 s per task |

- **Fix:** "Claude Haiku 4.5 used extended thinking (median about 10,000 output tokens per reply, range 4,100-23,500), while Claude Sonnet 5.5 answered directly (320-1,430 tokens, 4-12 s per reply)."
- "A correct solution needs about 400-700 tokens" (README:195) should instead cite Sonnet's passing replies: "Sonnet's passing replies used 320-1,430 tokens."

**7. [ERROR] Claude did not run at temperature 0.2, but the metadata says it did.**
- `ClaudeCLI` ignores `temperature`. The Claude CLI has no temperature flag, so Claude used the API default (1.0 with thinking).
- `main-claude/meta_*.json` and `lang-claude/meta_*.json` nonetheless record `"temperature": 0.2` (and `num_predict`).
- README:370 ("one sample per model at a low temperature") is therefore false for the hosted reference, and Claude's run-to-run variance is larger.
- **Fix the README:** add to the hosted bullet: "Claude ran at the API's default temperature (it cannot be set from the CLI), with no seed, so its results vary more between runs than the local models'."
- **Fix the code:** in `main()`, write `meta["args"]["temperature"] = None` (and `num_predict`) for `claude:` models.

**8. [ERROR] Design count (README:134).** It says "two of our designs (the 50 mL rack and the stirrer housing) are modelled that way [upside down]". At least **four** are: the 0.2 mL adapter ("Print it upside down", tasks.yaml:222) and the enclosure lid ("printed upside down", tasks.yaml:359) too. Table 2 itself lists "upside-down printing" for the adapter.
- **Fix:** "four of our designs (the 50 mL rack, the tube adapter, the enclosure lid and the stirrer housing) are modelled that way."

**9. [ERROR] Tolerance range (README:177).**
- The paper says "Dimensional tolerances are 0.25-0.6 mm". The actual absolute tolerances in tasks.yaml run **0.15-0.9 mm**: enclosure lip `island_tol 0.15`; funnel `hole_d` 0.8/0.9; most are 0.3-0.5.
- There are also relative ones: volume 5-15%, material area 4-5%, D-bore area 12%.
- The appeal to print accuracy (Li 2025) is a category error: the checks measure CAD, which has no print error.
- **Fix:** "Absolute tolerances are 0.15-0.9 mm (most 0.3-0.5 mm, tighter for the 0.2 mm clearance fit, looser where the prompt allows two readings), plus 4-15% on areas and volumes. They are set to accept every reading of the prompt we consider correct, not to mimic print accuracy."

**10. [ERROR] `scadreport` description (README:113).** It says it "slices the part horizontally at every distinct height". The code (`scadreport.py:218-223`) keeps only the 8 thickest layers of at least 0.4 mm, plus near-bottom and near-top slices.
- **Fix:** "...slices the part horizontally at up to ten representative heights (the thickest layers between distinct feature heights, plus near the bottom and top) and lists...".

**11. [ERROR] "Printable" is overstated (Table 3 "Printable 1st try", README:255; heatmap legend "no printable part", analyze.py:258; failure label "printable part with the wrong geometry").**
- `render.ok` only means OpenSCAD exported a non-empty STL. Watertightness, body count and orientation are not checked.
- Among first attempts that "rendered", the body count was wrong (floating or disconnected pieces) for: Gemma 4 E4B 6/9, Llama 3.2 5/8, Qwen2.5 1.5B 1/2, Qwen3.5 4B 1/1, Gemma 4 E2B 1/12.
- **Fix:** rename the column "Renders 1st try" and the legend entries "rendered but wrong (·)" / "nothing rendered (×)". Or define "printable" as rendered, watertight and with the expected body count, and compute it from `check.items`.

**12. [ERROR] Code extraction is described incorrectly (README:191), and early stop has a bug.**
- What the paper says: "the longest fenced OpenSCAD block".
- What `extract_code` (run_bench.py:52-65) actually does:
  1. take the longest block labelled `openscad`/`scad`, else the longest fenced block of any label;
  2. else, for an unterminated fence, everything after it;
  3. else, if any OpenSCAD keyword appears, the *whole reply*.
- For local models the stream also stops at the first complete block (`code_block_complete`), so the answer is effectively the *first* block.
- **Bug:** `code_block_complete` and `extract_code` strip only *closed* `<think>…</think>`. A snippet inside an unclosed think block stopped generation early three times (LFM2.5 micropestle a1/a2, pcr_tube_adapter a2: 1-8 line "files" taken from inside its reasoning).
- **Fix the code:** before matching, add `text = re.sub(r"<think>.*?(</think>|$)", "", text, flags=re.S)`.
- **Fix the text:** "The answer is the longest OpenSCAD-labelled fenced block (any fenced block if none is labelled; the text after an unclosed fence; or the whole reply if it contains OpenSCAD calls). Local replies stop once a complete block has arrived, so in practice the first block counts."

**13. [ERROR] The README is stale and some "AUTO" blocks are not automatic.**
- Abstract (README:16): "Results are being filled in".
- Table 3 (README:251-252): partial Haiku 9/12 and Qwen2.5-Coder 1.5B 0/9.
- Table 4: Haiku "Full hardware -".
- §6.5 (README:317): says the language ablation "runs after the main benchmark", but the Haiku language runs are done.
- Rule 12 (README:139) and tutorial line 238 are still placeholders.
- Table 3 has no "Same code after feedback" column, though `table_main` emits it, and the caption doesn't define it.
- `AUTO:abstract`, `results-overall`, `results-failures`, `results-frontier`, `results-language` and `conclusion` are **never written by analyze.py**. The only `replace_block` targets are table-models, table-prints, table-main, table-categories, table-failures and the four figures. But README:407 says analyze.py refreshes "the AUTO blocks in this README".
- **Fix:** rename the hand-written blocks `<!-- MANUAL:... -->`, or change README:407 to "tables and figures". Run `analyze.py` once both local models finish.

### Overclaims

**14. [OVERCLAIM] Tutorial line 151.** "A report like this … is what makes small free models usable. In our benchmark, models fixed many of their own mistakes this way."
- No local model passed any task after feedback. Five small models returned byte-identical code to 75-100% of repair messages (see §0).
- Only the hosted models repaired anything: Haiku 3 tasks, Sonnet 1.
- **Replace with:** "A report like this is the next best thing. In our benchmark it helped the hosted models fix most of their remaining mistakes. The small local models we tested usually ignored it and returned the same file, so with them, start a new chat or simplify the request instead."

**15. [OVERCLAIM] Tutorial Part 8 (lines 14, 229, 234-236).**
- Line 229: "You can run a capable model on your own laptop".
- Lines 234-236: the worked example is `qwen2.5-coder:7b`. That model scored 0/16; 15/16 of its first files failed to parse, and it returned identical code to all 32 repair requests.
- Line 14: "You do not need: … a paid AI subscription or a permanent internet connection". Read with Part 8, this implies the offline path works.
- **Replace line 229 with:** "You can run a model on your own laptop, with no account and no internet once it is downloaded. Be aware that none of the 14 small models we tested (up to 6.6 GB, thinking off) produced a correct part in our benchmark, so for now treat local models as an experiment and check everything."
- Change the example tag to a neutral placeholder (`ollama pull <model>`) until §6 names a recommendation.
- Line 14: "...a permanent internet connection (a free hosted chatbot works; see Part 8 for the offline option and its current limits)."

**16. [OVERCLAIM] Tutorial line 246.** "If it struggles in your language, try writing the numbers and geometry words … in English. See the paper's language results." The ablation covered one hosted model, found no significant effect, and never tested mixed-language prompts.
- **Replace with:** "We have not tested whether mixing in English geometry words helps; our language test (one hosted model) found no clear difference between English, Spanish, Hindi and Swahili requests."

**17. [OVERCLAIM] Language and model-ranking conclusions must stay null.**
- Draft for `results-language`: "With Claude Haiku 4.5, requests in Spanish, Hindi and Swahili passed 13, 12 and 11 of 16 tasks, against 14 in English. With one sample per task at the default temperature, none of these differences is statistically detectable (paired exact McNemar p ≥ 0.38). Which tasks failed differed between languages, which is what sampling noise would produce. We did not run the ablation on local models, which already passed nothing in English."
- Do not rank Haiku below Sonnet (p = 0.48).
- §1 question 3 should say it is answered only for one hosted model.

**18. [OVERCLAIM] "Small" is attached to evidence about large models.**
- README:29 says "small open models have performed poorly … (Badagabettu 2024; Alrashedy 2025; Dong 2026)", and README:231 is headed "Small models have done poorly".
- But the evidence quoted is **CodeLlama-70B** and "open-weight models of 8B parameters and up".
- **Fix:** "Open-weight models, even at 8-70B parameters, have performed poorly on CAD code generation without fine-tuning…", with the §5.5 heading "Open models have done poorly at CAD code without fine-tuning."
- Also verify against the reference notes:
  - README:344 cites Ahuja 2023 (MEGA) for "Code models degrade…". MEGA is not a code benchmark, so cite it only for the general multilingual gap.
  - README:25 cites Machado 2019 for "Among programmers of open labware, the most common choice is OpenSCAD". Check that the paper actually measured prevalence. If not, use "a widely used choice".

**19. [OVERCLAIM] "16 tested … designs" (README:9, 16, 40).** §9 says physical validation is "in progress".
- **Replace** "tested" with "geometry-checked", e.g. "16 parametric OpenSCAD lab designs, each rendered, sliced and checked against the benchmark's geometric tests (print validation in progress)".

**20. [OVERCLAIM] README:347.** "Models over about 7 GB will not fit alongside a desktop session in 16 GB of RAM; see §6.4". Nothing over 6.6 GB was tested, and §6.4 has no memory data.
- **Replace with:** "We tested models up to 6.6 GB; the 6.6 GB models ran in 16 GB of RAM with an 8,192-token context. We did not test larger ones."

**21. [OVERCLAIM] README:197.** "This is Claude as a student would actually use it". A student uses the chat app, not the CLI with a replaced system prompt and tools off.
- **Replace with:** "This is Claude with its vendor-default settings, not an equal-cost comparison."

**22. [OVERCLAIM] Validation claims (README:179-184; bench/build_refs.py) show internal consistency, not discrimination or fairness.**
- "0/240 cross-task false positives" is almost guaranteed by the bounding-box check, since no two tasks share a bbox.
- "fail when scaled by 3%" is caught mainly by bbox and volume.
- Invariance is tested for one of the seven non-identity symmetries (rot90 + mirror X).
- Nothing tests **false negatives**, i.e. correct alternative readings. #1 shows one exists.
- **Fix:** keep the list, but add: "These tests show the checks are self-consistent. They do not show that every correct reading passes; we found and fixed one false negative (funnel wall thickness, §5.2)." See #31 for the stronger tests.

### Methodology risks

**23. [RISK] The repair loop uses an oracle (README:192).**
- Feedback is sent only when the *hidden* checks fail, and the loop stops at the first pass. A real user can't know either.
- This makes "pass ≤3 tries" an upper bound. It can never turn a passing part into a failing one.
- **Replace** "This mimics a user who notices the part is wrong and pastes the report back" **with:** "Feedback is triggered by the hidden checks, so 'passed within three attempts' is an optimistic upper bound on what a user who must spot errors alone would get."

**24. [RISK] "Pre-specified" minimal-viable definition (README:233).**
- "Before running the benchmark we fixed what we would call a minimally viable…". The text first appears in commit `0c8dc60` (5 Oct 16:02). The Claude main run started at 15:35 and the local run at 15:47, and pilot runs are in `calib.log` at 15:33.
- No result could have favoured a local model by then (all local results are 0), but the claim can't be shown from the record.
- **Replace with:** "Before analysing any local-model results, we fixed…".
- Draft for the conclusion: "No tested model met the bar: all complete local models passed 0 of 16 tasks (95% upper bound 19%), and the two that need more than 10 minutes per task would have failed the time bar too."
- The models over the time bar so far: Granite median 14.8 min; Qwen3.5 4B 15.2 min, provisional; Qwen3.5 9B 27 min, provisional, from 2 tasks.

**25. [RISK] Confidence intervals and replication.**
- The Wilson CIs (README:255) treat tasks as samples from a population, and there is one sample per task. They capture neither run-to-run noise (important for Claude at T ≈ 1) nor the fixed task set.
- **Fix the caption:** "Wilson intervals over the 16 tasks of a single run; they do not include run-to-run variation."
- For partial models, the caption should say "over the tasks completed".

**26. [RISK] Bias: Claude drafted the tasks, checks, references and translations.** §9 discloses this. Sonnet's 16/16 also means the benchmark **cannot discriminate among hosted models** (ceiling effect).
- **Add to §9:** "The hosted models are at or near ceiling, so this task set cannot rank them."
- **Add** a canary string to `tasks.yaml` and the `designs/` headers so the public tasks can be detected in future training data.

**27. [RISK] The harness changed mid-study.**
- `bf70fa2` (20:37, matching "Terminated" in `main-local.log`) added `code_sha1`, the `InfraError` handling and the MAX_FACES guard, and changed `scadreport` output formatting (−0.00). Claude, Qwen2.5-Coder 7B and 3B, and the first 5 Qwen2.5-Coder 1.5B tasks ran on the earlier code; their feedback text differs cosmetically.
- `checks.py`, `tasks.yaml` and `system.md` are unchanged since `0c8dc60`, and `reference_stats.json` dates from 15:09 (before any run). Scoring is therefore very likely consistent, but this is not proven.
- **Suggest:** record `git rev-parse HEAD` in `meta`, and **rescore every saved `.scad` with the current checker** (a few minutes of renders) to confirm `passed`/`score` are unchanged. Report the result in one sentence.
- Context overflow was checked and is fine: the largest recorded prompt + reply was 7,591/8,192 tokens.

**28. [RISK] The repetition early stop can cut off legitimately repetitive code.**
- `repeating()` (run_bench.py:75) fires when the last 150 characters appear three times anywhere in the reply.
- It fired 23× (0.5B), 15× (Qwen2.5 1.5B), 13× (Qwen3.5 2B), and once each for Ministral and Llama.
- Spot checks look like genuine loops, but `ministral-3_3b/hose_barb_reducer_8_5_s0_a2` (2,992 characters of stacked barb code) is borderline.
- **Suggest:** require the repeats to be contiguous and periodic (`text.endswith(text[-k:] * reps)`), or k = 300. Report how many stops were "repetition".

**29. [RISK] Two checks are strict but defensible; say so.**
- Haiku's English enclosure failed only volume (+13%). It gave the lid lip a 1.5 mm floor, which works the same. Haiku's slide-rack slots came out 78 mm instead of 77.
- These are correct by the letter of the spec. A short "near-miss audit" (Haiku/Sonnet attempts scoring ≥ 0.9 that failed) would show readers that failures are real.
- Local near-misses:

  | Model | Task | Score | Only failed check |
  |---|---|---|---|
  | Gemma 4 E4B | micropestle | 0.91 | groove depth |
  | Qwen3.5 9B | tube rack | 0.89 | holes went through, no floor; reply hit the cap |

### analyze.py and figure bugs

**30. [SUGGEST] analyze.py.**
- (a) **No dedupe across runs.** `main_recs = runs["main"] + runs["main-claude"]` (line 437), and likewise `lang` + `lang-claude` (line 457). If a model ever appears in both, its tasks are counted twice and `complete` (`n >= 16`, line 145) becomes true wrongly. Dedupe on `(model, task, sample, lang, feedback)` after concatenating, keeping the latest `finished`, and set `complete = len({r["task"] for r in recs}) >= len(tasks)`.
- (b) `median_task_min` (line 149) takes the upper median. Use `statistics.median(walls)`.
- (c) `fig_frontier` plots partial models as if complete, e.g. Qwen3.5 9B at 27 min from 2 tasks. Skip rows with `not r["complete"]` or draw them hollow.
- (d) With every local model at 0%, the frontier and dumbbell figures are flat and carry no information. Plot instead (or as well) a graded outcome per model: % rendered, % with correct bbox and body count, mean best score.
- (e) `score` weights all check items equally, so a plain block with the right bbox scores 0.3-0.5. Label it "share of checks passed (not a quality measure)", or report the tiers from (d).
- (f) The meta for Claude runs should not record `temperature`/`num_predict` (see #7).

### Additional analyses to add (cheap, from existing data)

**31. [SUGGEST]** Each of these is a few lines over the JSONL; most numbers are already computed above.
1. **Failure taxonomy with "truncated"** (#3), plus a "geometry-as-value" column. Regex `^\s*\w+\s*=\s*(cube|cylinder|translate|union|difference|for|…)\s*[\(\[]` on first attempts gives:

   | Model | First files with geometry as a value |
   |---|---|
   | Qwen2.5-Coder 7B | 15/16 |
   | Qwen2.5-Coder 1.5B | 14/16 |
   | Qwen2.5-Coder 3B | 11/16 |
   | Ministral 3 | 8/16 |
   | Granite 4.2 | 8/16 |

   This is the single most useful finding for the tutorial's error table (tutorial:157-158).
2. **Graded outcome table** per model: renders on any attempt, valid single solid with the right bbox, mean best score, near-misses. For example, Gemma 4 E2B renders 12/16 with best score up to 0.70 and 6 tasks ≥ 0.5; Gemma 4 E4B renders 11/16 with 6 tasks ≥ 0.5; LFM2.5 and Qwen3.5 2B render 0/16.
3. **Truncation table:** share of attempts ending at the cap or as repetition, and median reply tokens per model (numbers in #2).
4. **Repair efficacy:** attempt-0 stage → final stage transitions, and the identical-code rate (already computed) in the text.
5. **Rescore sensitivity:** all saved `.scad` with the current checker, and again with the funnel fix (#1).
6. **Paired language table** (task × language, with the attempt that passed) and the McNemar p-values.
7. **Mutation tests for the checker:** per task, one variant per check (e.g. one hole shifted 1 mm, one feature missing, wrong count, depth +2 mm). Report the detection rate. Also run invariance under all 8 symmetries, and false-negative tests with alternative correct references (funnel perpendicular wall; `$fn` = 32; `center=true` vs translated).

### Minor

**32. [SUGGEST]**
- README:116-120: the "pitch came out wrong" excerpt's volume (158,139 mm³) is exactly the through-hole version (no 5 mm floor). Say "a rack whose pitch and hole depth came out wrong", or regenerate the excerpt. The slice line is cut short (the material area is omitted); add "…".
- `scadreport.py:267` reports circular *islands* by bounding length (`i['l']`) but holes by area-equivalent `d`. Use `i['d']` for consistency.
- The Ollama-reported parameter counts differ from Table §5.4 (Granite 4.2 3.7B vs "3B"; Ministral 3 3.8B vs "3.4B", probably including the vision encoder). Add a footnote "language-model parameters from model cards".
- Q4_K_M was confirmed for all local tags checked via `ollama show`.
- Tutorial:215: the ASA/PC "HDT about 85-110 °C" and the ASA emission claim (tutorial:223) are uncited. Azimi 2016 does not obviously cover ASA, so cite the Prusament TDS or drop "ASA".
- Verified correct:
  - Print totals: CSV sums 31.64 h, 482.9 g, US$12.07 at US$25/kg.
  - Wilson bounds as printed.
  - "0/240" = 16 × 15 pairs.
  - The seed-grid arithmetic (README:186).
  - The tutorial scadreport example (169,943 mm³, 211 g, 7,632 mm²).
  - Manifold is the default backend in OpenSCAD 2026.10.01.
  - The ANSI/SLAS A1 offsets.
  - All other task check geometry I recomputed: rod-clip bbox 27.37, seed bbox 84.7, hose-barb diameters, D-bore area 24.56 mm², NEMA z = 28 islands, gel-tank chambers 27 × 64.
