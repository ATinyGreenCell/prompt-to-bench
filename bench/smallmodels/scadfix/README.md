# scadfix: rule-based repair of invalid OpenSCAD

`scadfix.py` rewrites the invalid OpenSCAD that language models write into OpenSCAD that parses. It uses small,
named text rules and nothing else: no language model, and no call to OpenSCAD. It is intervention 2a of
[`../PROTOCOL.md`](../PROTOCOL.md).

Version 1.0 was developed only on attempts outside the 16 benchmark tasks and then frozen
(sha256 `85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334`, [`FROZEN.md`](FROZEN.md)). After that it
was run once on the benchmark's saved attempts, as an offline what-if.

**In short:**
- On the 256 laptop conversations, the first files that render rose from 60 to 92. Passes rose from 2 to 3 tasks
  within three attempts (Gemma 4 E4B gained one task), so no laptop model comes near the 8-of-16 bar.
- On the NPU box (33 samples of 16 tasks), tasks passed within three attempts rose from 74 to 95, and first-attempt
  passes from 36 to 49. Qwen3.8 27B, for example, went from 4 + 4 to 6 + 9 tasks.
- 51 of the 52 attempts that pass after the fix were repaired by one rule, the one that turns a shape assigned to a
  variable (`rack = cube(...)`) into a module.
- No rule fired on any valid file, nor on any saved attempt that had rendered, so no recorded pass or render was lost.

```
python scadfix.py in.scad > out.scad            # repaired file on stdout; the rules that fired on stderr
from scadfix import fix; code, rules = fix(text)  # fix(text, skip=("close_truncated",)) leaves rules out
```

## How it works

- **Code only.** A small lexer blanks out comments and string contents, so rules match only code. A `#` that starts
  a module call is OpenSCAD's debug modifier and is treated as code. Any other `#` is a Python comment.
- **Only broken text.** Each rule matches text that OpenSCAD cannot parse. Four rules also cover text that parses
  but is meaningless: `True`/`False`/`None`, `math.*` and `range()`, which OpenSCAD reads as unknown names, and a shape
  assigned to a variable and then called. This is why a valid file comes back unchanged.
- **Fixed order, once each.** Rules run in a fixed order, each once; a few repeat internally for nested cases. A
  rule that raises an error on odd input is skipped and logged. No rule raised an error in the development or test
  runs.
- **Moved code drops its comments.** When a piece of code is moved into a one-line construct (a comprehension, a
  `?:` or `let()` expression), its comments are dropped, so a `//` cannot swallow a closing bracket.

## The rules

| Rule | What it rewrites | Example |
|---|---|---|
| `prose_lines` | a line of sentences in the code becomes a `//` comment | `Here is the code for the plate:` |
| `python_comments` | a Python `#` comment becomes `//` | `# base plate` |
| `close_truncated` | a file cut off mid-reply is cut back to its last complete statement, and its open blocks are closed (its own rule; see the test results) | `... cylinder(d = 3,` |
| `unicode_operators` | the typographic minus, en dash, times, divide, <=, >= and != signs become ASCII | `[−5, 0, 0]` |
| `python_import` | `import math` and `from x import y` become comments | `import math` |
| `python_literals` | `True`, `False`, `None` become `true`, `false`, `undef` | `center=True` |
| `python_operators` | `and`, `or`, `not`, `is (not) None`, `**` become `&&`, `\|\|`, `!`, `==`/`!= undef`, `^` | `x > 3 and x < 9` |
| `python_math` | `math.pi` and similar names; radian trigonometry is converted exactly to degrees | `math.cos(math.radians(30))` |
| `python_def` | a one-expression Python function becomes an OpenSCAD function | `def half(v): return v / 2` |
| `python_blocks` | Python's colon-and-indent blocks (`for`, `if`, `elif`, `else`) get braces | `for i in range(4):` |
| `python_for_in` | `for (i in X)` becomes `for (i = X)` | `for (x in xs)` |
| `python_comprehension` | `[e for i in X if c]` becomes `[for (i = X) if (c) e]` | `[i * 10 for i in [0 : 4]]` |
| `pipe_comprehension` | the set-builder list `[e \| i = X]` becomes `[for (i = X) e]` | `[i * 5 \| i = [0 : 3]]` |
| `bracketless_comprehension` | `xs = for (...) e;` gets its brackets (but see the bug below) | `xs = for (i = [0 : 3]) i * 4;` |
| `comprehension_let` | an assignment inside a comprehension becomes `let()` | `[for (i = X) r = f(i); [r, 0]]` |
| `list_semicolons` | a `;` between list elements becomes `,` | `[for (..) a; for (..) b;]` |
| `python_range` | `range(n)`, `range(a, b)` and `range(a, b, s)` become OpenSCAD ranges | `range(1, 4)` -> `[1 : 4 - 1]` |
| `dotdot_range` | `[a..b]` and `for (i = a..b)` become `[a : b]` | `[0..n-1]` |
| `range_brackets` | `for (i = 0 : n)` gets its brackets | `for (i = 0 : 3)` |
| `python_tuples` | a tuple used as a vector becomes a vector | `(0, 0, 12)` -> `[0, 0, 12]` |
| `rotate_vector` | `rotate(a) [x, y]` inside an expression becomes the rotation matrix times the vector (Z rotations only) | `[for (i = ..) rotate(i * 60) [10, 0]]` |
| `python_in` | `if (x in L)` becomes a test with a comprehension | `if (i + 1 in sel)` |
| `python_continue` | `if (c) continue;` in a loop body wraps the rest of the body in `if (!(c)) {...}` | `if (i % 2 == 1) continue;` |
| `function_keyword` | a function defined without the `function` keyword gets it | `w(x) = x * 2;` |
| `function_literal_equals` | `function(x) = e` loses its `=` | `f = function(s) = s * 2;` |
| `function_if_else` | if/else used as an expression in a function becomes `?:` | `function w(x) = if (x < 0) 1 else 2;` |
| `function_block` | a function written as a block with `return`, or a module that only returns, becomes one `?:`/`let()` expression | `function w(x) { if (x < 0) return 1; return 2; }` |
| `missing_semicolon` | a statement line without its `;` gets one when the next line plainly starts a new statement | `w = 10` above `h = 5;` |
| `geometry_to_module` | a shape assigned to a variable becomes a module, and its uses `name;` become `name();` (top level, module bodies) | `plate = cube(..); ... plate;` |
| `geometry_inline` | the same inside a child block, where modules cannot be defined: each use gets the shape itself | `difference() { base = cube(..); base; .. }` |
| `geometry_in_place` | a shape assigned to a name never used again, in a form that cannot parse: the shape is made where it was assigned | `star = union() {...};` inside a `difference()` |
| `bare_module_call` | a module of the file used without parentheses gets them | `peg;` -> `peg();` |

**Where the rules came from.**
- **The development data.** Twenty of the rules come from what actually failed in the development data (below). The
  main sources were list comprehensions, `rotate()` on vectors, functions with `return`, tuples, `continue`, ranges,
  and shapes inside a `difference()`.
- **The task's candidate list.** Twelve rules never fired on the development data: `prose_lines`, `python_comments`,
  `close_truncated`, `python_import`, `python_literals`, `python_math`, `python_def`, `python_blocks`, `python_range`,
  `missing_semicolon`, `geometry_to_module` and `bare_module_call`. (`python_operators` fired once.) They come from
  the task's list of candidates and were checked only on hand-written unit cases (below).

## Valid files are left alone

[`noop_check.py`](noop_check.py) runs `fix` over every verified file in the repository (2,124 files):
- `bench/reference` (16 files), `bench/variants` (3), `designs/**` (17) and `finetune/seeds` (34);
- the verified assistant code of the distilled batches A (680), B (700) and C (674).

**No rule fired on any of them** ([`noop_check.json`](noop_check.json)).

[`test_scadfix.py`](test_scadfix.py) holds 50 hand-written repair cases, generic parts that are none of the 16 tasks
([`unit_tests.txt`](unit_tests.txt)):
- each broken case fails to parse, or warns about an unknown name;
- each repaired file must parse and evaluate without an error;
- 14 valid snippets must come back unchanged.

All pass.

## Development results

**Data.** All development data lie outside the 16 tasks, in `finetune/rft/onpolicy/`:
- 12,192 first replies of the fine-tuned scadcoder versions v5, v5s1, v9, v9s1, v11 and v11s1, to batch C and (for
  v5) to batches A and B and the training families (`attempts_*.jsonl`);
- 4,020 of their replies to the benchmark's feedback on a failed batch-C attempt (`repair_t02_*.jsonl`).

The harness-search files (`bench/results/harness-search/hs_*.jsonl`) record only outcomes and a code hash, not the
code, so they could not be used.

**Method.**
- Code was extracted as the benchmark does (`run_bench.extract_code`).
- Every file was rendered, before the fix and (where a rule fired) after it, with OpenSCAD's 60 s limit.
- Each file was scored against its description's verified file with batch C's tolerances
  (`onpolicy_repairs.ref_ok`, the bounds of `rft_score`: bounding box per axis, volume, body count, triangle floor).
- This reproduces the recorded batch-C outcomes exactly; for v5, for example, 5,131 passes and 5,878 renders.
- The full set was used, not a sample: [`dev_eval.py`](dev_eval.py) wrote [`dev_results.json`](dev_results.json) and
  [`dev_attempts.jsonl`](dev_attempts.jsonl) (the attempts a rule fired on), and [`dev_parse.py`](dev_parse.py) wrote
  the parse-error counts ([`dev_parse.json`](dev_parse.json)).

| Development set | Attempts | Parse errors | A rule fired | Render | Watertight solid | Pass against the reference |
|---|---:|---:|---:|---:|---:|---:|
| First attempts (7 files) | 12,192 | 367 -> 140 | 258 | 11,412 -> 11,586 | 11,259 -> 11,409 | 7,303 -> 7,314 |
| Repair replies (6 files) | 4,020 | 340 -> 132 | 237 | 3,411 -> 3,558 | 3,298 -> 3,428 | 64 -> 72 |

**Where the rules fired.** Every file a rule fired on had a parse error, and none of them had rendered.

**First attempts.**
- The rules cleared 227 of the 367 parse errors.
- They gave 150 more watertight solids.
- They gave only 11 more passes. These models' syntax errors came with wrong geometry. The failures are concentrated
  in a few hard families: star outlines, hinges, tensile specimens and bowls. Many of the repaired files then failed on
  other modelling errors, for example a 2D polygon placed in a 3D `difference()`, or self-intersecting outlines.

| Rule | First attempts: fired / parse error gone / watertight / pass | Repair replies: fired / parse error gone / watertight / pass |
|---|---:|---:|
| `python_comprehension` | 85 / 80 / 79 / 6 | 81 / 76 / 75 / 5 |
| `rotate_vector` | 52 / 35 / 5 / 0 | 59 / 42 / 7 / 0 |
| `python_for_in` | 26 / 26 / 26 / 1 | 30 / 30 / 30 / 1 |
| `function_block` | 25 / 20 / 10 / 1 | 25 / 21 / 10 / 0 |
| `list_semicolons` | 23 / 23 / 1 / 0 | 16 / 16 / 0 / 0 |
| `function_if_else` | 21 / 19 / 11 / 2 | 16 / 15 / 8 / 2 |
| `python_continue` | 13 / 13 / 13 / 1 | 14 / 14 / 14 / 1 |
| `python_tuples` | 19 / 19 / 17 / 0 | 2 / 2 / 1 / 0 |
| `comprehension_let` | 6 / 6 / 0 / 0 | 7 / 7 / 0 / 0 |
| `geometry_in_place` | 6 / 5 / 1 / 0 | 5 / 4 / 0 / 0 |
| `dotdot_range` | 5 / 5 / 5 / 0 | 5 / 5 / 5 / 0 |
| `pipe_comprehension` | 4 / 3 / 2 / 1 | 6 / 5 / 5 / 0 |
| `python_in` | 5 / 5 / 5 / 0 | 3 / 3 / 3 / 0 |
| `range_brackets` | 4 / 4 / 4 / 0 | 3 / 3 / 3 / 0 |
| `function_keyword` | 1 / 1 / 1 / 0 | 3 / 3 / 1 / 0 |
| `geometry_inline` | 2 / 2 / 1 / 0 | 2 / 2 / 1 / 0 |
| `unicode_operators` | 1 / 1 / 1 / 0 | 1 / 1 / 1 / 0 |
| `function_literal_equals` | 1 / 1 / 1 / 0 | 1 / 1 / 1 / 0 |
| `bracketless_comprehension` | 1 / 1 / 1 / 0 | - |
| `python_operators` | - | 1 / 1 / 1 / 0 |

A file can fire several rules, so the rule rows do not add up to the totals.

## Frozen

Version 1.0 was frozen on 2026-10-20 at 02:28 EDT, after the development results were in. Its sha256 is
`85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334`. [`FROZEN.md`](FROZEN.md) lists the 32 rules in the
order they run, and its table row is ready to copy into [`../PROTOCOL.md`](../PROTOCOL.md)'s list of frozen
artefacts (this task did not modify existing files). The file was not edited afterwards.

## Test results: an offline what-if on the benchmark's saved attempts

**Run.** [`test_eval.py`](test_eval.py) ran once, from 02:28:53 to 02:31:46 EDT on 2026-10-20, over these runs:
- the laptop runs `main` (all models), `ft-scad` (scadcoder) and `main-bonsai`;
- the NPU-box run `main-tiiny` (all models; two or three samples each, all complete).

**Records.** They were loaded as `bench/analyze.py` `load_runs` does:
- the newest record per conversation;
- attempts after a pass dropped;
- `needs_rerun` records left out;
- English prompts and report feedback only.

**Scoring.**
- Every saved attempt with code went through `fix`.
- Where a rule fired, the fixed file was rendered and scored with the hidden checks exactly as `bench/rescore.py`
  does: `render()` with its default timeout, then `checks.evaluate(load_mesh(stl), task, reference_stats[task])`.
- "Before" is the recorded verdict.

**This is a what-if, not a rerun.** The model never saw the fixed file. The feedback it got and every later attempt
are unchanged. A conversation counts as passed after the fix if any of its attempts passes as recorded or, where a
rule fired, as fixed.

Of 2,249 saved attempts, a rule fired on 896 ([`test_attempts.jsonl`](test_attempts.jsonl),
[`test_results.json`](test_results.json)). None of the 896 had rendered, so no recorded render or pass was lost, and no
original needed rescoring.

| | Laptop: 16 models, 256 conversations | NPU box: 16 models, 33 samples, 528 conversations |
|---|---:|---:|
| First files that render | 60 -> 92 (84 without `close_truncated`) | 240 -> 321 (306 without `close_truncated`) |
| First-attempt passes | 0 -> 0 | 36 -> 49 |
| Tasks passed within three attempts | 2 -> 3 | 74 -> 95 |
| First-attempt syntax errors: a rule fired / renders after | 95: 68 / 24 | 141: 122 / 64 |

Per model:
- **Columns.** A cell is "before -> after".
- **Box models.** Values are given per sample, joined by "+".
- **Without `close_truncated`.** Given in brackets when it differs.
- **Syntax-error column.** Shows first attempts that stopped at a syntax error (the paper's Table 6), then how many a
  rule fired on, then how many of those render after the fix.

| Model | First files that render | First-attempt passes | Tasks passed within 3 attempts | 1st-try syntax errors: fired / render | Attempts a rule fired on (render / pass) | Rules that fired (attempts) |
|---|---:|---:|---:|---:|---:|---|
| **Laptop** | | | | | | |
| Qwen2.5-Coder 0.5B | 0 -> 1 | 0 -> 0 | 0 -> 0 | 7: 5 / 1 | 24 (3 / 0) | python_tuples 24, close_truncated 4 |
| Qwen2.5-Coder 1.5B | 1 -> 3 (2) | 0 -> 0 | 0 -> 0 | 11: 9 / 1 | 30 (6 / 0) | bracketless_comprehension 21, geometry_to_module 15, geometry_in_place 9, close_truncated 3 |
| Qwen2.5 1.5B (general) | 2 -> 5 (4) | 0 -> 0 | 0 -> 0 | 9: 7 / 2 | 36 (9 / 0) | python_for_in 18, geometry_in_place 12, close_truncated 12, python_range 9, bracketless_comprehension 6, list_semicolons 6, dotdot_range 6, geometry_to_module 3, function_keyword 3, function_block 3 |
| Qwen2.5-Coder 3B | 3 -> 5 | 0 -> 0 | 0 -> 0 | 12: 7 / 2 | 21 (6 / 0) | geometry_to_module 12, bracketless_comprehension 6, geometry_in_place 6, missing_semicolon 3, python_for_in 3 |
| Qwen3.5 2B | 0 -> 0 | 0 -> 0 | 0 -> 0 | 0: 0 / 0 | 31 (0 / 0) | close_truncated 23, missing_semicolon 5, prose_lines 5, python_operators 5, geometry_in_place 1 |
| Llama 3.2 3B | 8 -> 9 | 0 -> 0 | 0 -> 0 | 5: 2 / 1 | 7 (3 / 0) | geometry_to_module 3, range_brackets 3, close_truncated 1 |
| Granite 4.2 3B | 2 -> 4 (2) | 0 -> 0 | 0 -> 0 | 1: 0 / 0 | 21 (5 / 0) | close_truncated 14, geometry_in_place 8, geometry_to_module 2, prose_lines 1 |
| Ministral 3 3B | 1 -> 3 | 0 -> 0 | 0 -> 0 | 13: 10 / 2 | 33 (5 / 0) | python_for_in 27, dotdot_range 6, geometry_in_place 5, function_block 5, range_brackets 4, python_range 3, geometry_to_module 3, missing_semicolon 1, close_truncated 1 |
| Qwen3.5 4B | 1 -> 2 (1) | 0 -> 0 | 0 -> 0 | 1: 1 / 0 | 33 (5 / 0) | close_truncated 28, geometry_in_place 4, geometry_to_module 2, function_block 1, range_brackets 1, list_semicolons 1, bracketless_comprehension 1, missing_semicolon 1 |
| Gemma 4 E2B | 12 -> 13 | 0 -> 0 | 0 -> 0 | 4: 2 / 1 | 6 (5 / 0) | geometry_to_module 6, geometry_in_place 1 |
| Qwen2.5-Coder 7B | 1 -> 8 | 0 -> 0 | 0 -> 0 | 15: 13 / 7 | 39 (21 / 0) | geometry_to_module 36, geometry_in_place 3, bracketless_comprehension 3 |
| scadcoder (fine-tuned, ours) | 14 -> 14 | 0 -> 0 | 0 -> 0 | 1: 0 / 0 | 0 | none |
| LFM2.5 8B-A1B (MoE) | 0 -> 0 | 0 -> 0 | 0 -> 0 | 0: 0 / 0 | 34 (3 / 0) | prose_lines 26, python_operators 26, close_truncated 9, python_tuples 7, python_comments 4, missing_semicolon 4, geometry_in_place 4, range_brackets 1, python_for_in 1, unicode_operators 1 |
| Gemma 4 E4B | 9 -> 12 (11) | 0 -> 0 | 0 -> 1 | 3: 2 / 2 | 8 (5 / 1) | close_truncated 4, python_comprehension 3, geometry_to_module 1 |
| Qwen3.5 9B | 1 -> 4 (2) | 0 -> 0 | 0 -> 0 | 2: 2 / 1 | 33 (11 / 0) | missing_semicolon 22, close_truncated 18, geometry_in_place 6, geometry_inline 3, list_semicolons 1 |
| Bonsai 2 27B (ternary) | 5 -> 9 | 0 -> 0 | 2 -> 2 | 11: 8 / 4 | 22 (12 / 0) | geometry_to_module 21, python_for_in 3, range_brackets 3, geometry_in_place 2, close_truncated 1 |
| **NPU box** | | | | | | |
| Qwen3 4B Instruct-2507 | 3 + 1 -> 9 + 6 (6 + 3) | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 5: 4 / 2 + 7: 7 / 2 | 65 (28 / 0) | geometry_to_module 37, close_truncated 16, geometry_in_place 15, geometry_inline 13, python_for_in 3 |
| Qwen3 8B | 2 + 3 -> 7 + 5 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 14: 12 / 5 + 13: 13 / 2 | 76 (21 / 0) | geometry_to_module 74, python_for_in 8, geometry_in_place 6, function_literal_equals 2 |
| Qwen3.5 9B (Tiiny) | 8 + 4 -> 9 + 6 (9 + 5) | 0 + 0 -> 0 + 0 | 1 + 0 -> 1 + 0 | 3: 2 / 1 + 6: 4 / 1 | 41 (11 / 0) | geometry_to_module 21, close_truncated 16, bracketless_comprehension 9, geometry_in_place 4, geometry_inline 1, list_semicolons 1, prose_lines 1, python_operators 1 |
| gpt-oss-20b | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 0 + 0 | 0 | none |
| Gemma 4 26B-A4B | 16 + 15 + 13 -> 16 + 16 + 15 (16 + 15 + 13) | 4 + 2 + 3 -> 4 + 2 + 3 | 9 + 7 + 12 -> 9 + 7 + 12 | 0 + 0 + 1: 0 / 0 | 3 (3 / 0) | close_truncated 3 |
| Qwen3 30B-A3B Thinking-2507 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 0 + 0 | 0 | none |
| Qwen3-Coder 30B-A3B | 4 + 6 -> 10 + 12 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 11: 11 / 6 + 9: 9 / 6 | 62 (38 / 0) | geometry_to_module 62, bracketless_comprehension 6, geometry_inline 3, geometry_in_place 2 |
| Qwen3 30B-A3B Instruct-2507 | 9 + 7 -> 13 + 11 (13 + 10) | 0 + 2 -> 0 + 2 | 0 + 2 -> 0 + 2 | 4: 4 / 4 + 5: 5 / 3 | 37 (24 / 0) | geometry_to_module 24, close_truncated 10, python_for_in 6, geometry_in_place 2 |
| Qwen3.6 27B | 16 + 15 -> 16 + 15 | 3 + 3 -> 3 + 3 | 5 + 6 -> 5 + 6 | 0 + 0 | 0 | none |
| GLM-4.7-Flash 30B-A3B | 13 + 14 -> 16 + 16 | 0 + 0 -> 0 + 0 | 0 + 0 -> 0 + 0 | 3: 3 / 3 + 2: 2 / 2 | 14 (14 / 0) | geometry_to_module 9, geometry_inline 3, range_brackets 2 |
| Qwen3.8 27B | 3 + 5 -> 11 + 13 | 2 + 3 -> 4 + 7 | 4 + 4 -> 6 + 9 | 12: 9 / 8 + 11: 10 / 8 | 56 (49 / 20) | geometry_to_module 53, function_keyword 3, bracketless_comprehension 1 |
| Qwen3.5 35B-A3B | 3 + 7 -> 5 + 11 (5 + 9) | 1 + 0 -> 1 + 2 | 2 + 0 -> 2 + 2 | 7: 4 / 2 + 5: 4 / 2 | 55 (19 / 6) | geometry_to_module 30, close_truncated 21, geometry_in_place 8, prose_lines 3, python_operators 3, geometry_inline 3, missing_semicolon 2 |
| Qwen3.6 35B-A3B | 9 + 7 -> 13 + 7 (11 + 7) | 0 + 1 -> 1 + 1 | 0 + 3 -> 3 + 4 | 1: 1 / 1 + 5: 4 / 0 | 48 (21 / 7) | geometry_to_module 23, close_truncated 21, geometry_in_place 8, prose_lines 6, python_operators 6, bracketless_comprehension 2, geometry_inline 2, missing_semicolon 1, python_range 1, function_block 1, python_tuples 1 |
| Ornith-1.0 35B (MoE) | 11 + 11 -> 12 + 12 | 2 + 1 -> 3 + 2 | 3 + 1 -> 4 + 2 | 5: 5 / 1 + 4: 3 / 1 | 24 (6 / 6) | geometry_to_module 24, range_brackets 3 |
| Qwen3-Coder-Next 80B-A3B | 13 + 14 -> 15 + 14 | 1 + 2 -> 1 + 2 | 4 + 2 -> 5 + 2 | 2: 2 / 2 + 1: 1 / 0 | 14 (6 / 1) | geometry_to_module 10, close_truncated 4 |
| gpt-oss-120b | 3 + 5 -> 4 + 6 | 3 + 3 -> 4 + 4 | 4 + 5 -> 7 + 7 | 2: 1 / 1 + 3: 2 / 1 | 23 (13 / 11) | geometry_to_module 15, close_truncated 8, missing_semicolon 1, geometry_in_place 1 |

**What it shows.**
- **Shapes assigned to variables are the repairable failure.** This is the paper's "geometry as a value"
  (§6.2). `geometry_to_module` fired on 486 attempts, and 268 of them rendered after the fix. It accounts for 51 of the
  52 attempts that pass after the fix. The other is Gemma 4 E4B's seed-sowing template: `python_comprehension` repaired
  its third attempt.
- **Gains repeat across attempts.** Several models returned the same broken file after feedback, so one repair often
  applies to all three attempts of a conversation. The pass columns count conversations (tasks), not attempts.
- **The NPU box gains the most.** Qwen3.8 27B, gpt-oss-120b, the Qwen3.5 and Qwen3.6 35B-A3B models, Ornith and
  Qwen3-Coder-Next write mostly correct designs. A syntax habit stood between them and a pass.
- **The laptop gains little.** First files render more often (60 -> 92 of 256). But the small models' parts are
  wrong in other ways: no first attempt passes after the fix, and only Gemma 4 E4B gains a task (0 -> 1). Bonsai 2 27B
  stays at 2. The paper's conclusion for the laptop does not change: no model comes near 8 of 16.
- **`close_truncated` only renders partial parts.** It fired on 217 attempts and made 52 render, mostly reasoning
  models cut off at the token cap (Qwen3.5 2B, 4B and 9B, Granite, the box's Qwen3.5 and Qwen3.6 35B-A3B). None of
  them passed. The columns "without `close_truncated`" show the rest of the repair alone.
- **Twelve rules never fired in the test.** They are `python_import`, `python_literals`, `python_math`, `python_def`,
  `python_blocks`, `pipe_comprehension`, `comprehension_let`, `rotate_vector`, `python_in`, `python_continue`,
  `function_if_else` and `bare_module_call`. `center=True`, Python `def` and Python blocks did not occur in these
  files.

## Bugs found after freezing (reported, not fixed)

- **`bracketless_comprehension` wraps shape loops.**
  - **What goes wrong.** It is meant to leave a loop that makes shapes to `geometry_as_value`. But it checks only for a
    module call right after the `for (...)` header. So it brackets `holes = for (...) { translate(..) cylinder(..); }`
    (a block body) and `x = for (...) if (c) translate(..) ...` (a filter before the shape), which leaves them
    unparseable. Without it, `geometry_as_value` would have taken them as shapes.
  - **Extent.** In the test it fired on 55 attempts of 9 models: 49 had a block body and 3 a filter, so 52 are
    misfires. The other 3 had a vector body, `[...]`, and may be correct. No passing file was affected.
  - **Why development missed it.** In the development data it fired once, on a real value comprehension.
  - **Not re-scored.** A corrected version would be a new version (1.1). To keep its own test clean, its effect on
    these attempts was not measured.
- **Rules fire on whole replies of prose.** When a model's reply holds no code block and is cut off, the benchmark
  takes the whole reply as code (LFM2.5's reasoning text, some Qwen3.5 and Qwen3.6 replies). `prose_lines` then
  comments out some sentences, and `python_operators` turns English "and" and "or" into `&&` and `||`. All 41
  `python_operators` firings in the test were of this kind. These files were not code and remain broken, so outcomes
  are unaffected, but the firing counts for those two rules overstate their use on code.

## Limitations

- **The development data come from the fine-tuned scadcoder versions, not from the base models.** Their errors are
  different, so twelve rules never fired in development and were checked only on hand-written examples. One of them,
  `geometry_to_module`, turned out to be the rule that mattered most in the test.
- **The rules were not designed blind to the kinds of failure.** The task's list of candidate rules comes from the
  paper's description (§6.2, Table 6) of how the test runs failed. So the designer (Claude) knew the kinds of failure
  (for example `rack = cube(...)` and Python-style code), though not the files, before the test.
- **One accidental look at test data.** While looking for development data, Claude printed the first 600 characters
  of one base-model output on one benchmark task (`finetune/validation_run/outputs_base.json`, `tube_rack_1p5ml`). It
  showed `block = cube([...]);` followed by a Python-style hole list. This is the pattern the task description
  already names. No rule was written or changed because of it, and no other test file was opened before the freeze.
- **An offline what-if.** The model never saw the repaired file. A live run with `scadfix` between the model and
  OpenSCAD would change the feedback and the later attempts, in either direction. The numbers above are not a
  benchmark result.
- **Checks still matter.** Passing the hidden checks is the benchmark's criterion. A repaired file that renders the
  wrong part counts as a render, not a success.

## Files

| File | What it is |
|---|---|
| `scadfix.py` | the repairer (frozen version 1.0) |
| `FROZEN.md` | version, sha256, time of freezing, rule list |
| `test_scadfix.py`, `unit_tests.txt` | hand-written unit cases and their output |
| `noop_check.py`, `noop_check.json` | the check that valid files are left alone |
| `dev_eval.py`, `dev_results.json`, `dev_attempts.jsonl` | development evaluation (render, watertight, pass) |
| `dev_parse.py`, `dev_parse.json` | development parse errors before and after |
| `test_eval.py`, `test_results.json`, `test_attempts.jsonl` | the one test run (offline what-if) |

To reproduce, run from this folder with the repository's Python, with OpenSCAD 2026.10.01 at `$OPENSCAD`, and at
most 4 workers. Each command is `nice -n 10 python -I -B <script>` with:

| Script | Arguments | Takes about |
|---|---|---|
| `test_scadfix.py` | | seconds |
| `noop_check.py` | `--out noop_check.json` | seconds |
| `dev_eval.py` | `--tmp DIR` | 50 min |
| `dev_parse.py` | `--tmp DIR` | 30 min |
| `test_eval.py` | `--tmp DIR` | 3 min |
