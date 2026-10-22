# OpenSCAD grammar for constrained decoding (intervention 2b)

Small local models fail the benchmark mostly by writing OpenSCAD that does not parse
([PROTOCOL.md](../PROTOCOL.md), intervention 2b). `openscad.gbnf` is a llama.cpp GBNF grammar that only
lets the sampler produce a reply that is one fenced OpenSCAD block, so a syntax error can no longer be
generated. This folder holds the grammar, its validator and report, the end-to-end test, and the
change the benchmark shim needs.

| File | What it is |
|---|---|
| `openscad.gbnf` | The grammar (generated, 314 lines). sha256 `ffade52b8c5d5df67dc5318e4bfc3e8f80c4dbe853401ec02bcea69700bcb6bc` |
| `build_grammar.py` | Writes `openscad.gbnf`: a hand-written template plus two generated parts (the identifier automaton and the whitespace automaton) |
| `validate.py` | Tests the `.gbnf` file with a line-for-line port of llama.cpp's GBNF parser and acceptor; writes `validation_report.txt` |
| `validation_report.txt` | The last full run (corpus, negatives, stack counts) |
| `negatives/` | 33 `.scad` files and 2 raw replies that must be rejected; each `.scad` file names the line it must fail on |
| `positives/syntax_tour.scad` | A hand-written file that uses every construct the grammar covers (OpenSCAD parses it too) |
| `e2e.py`, `e2e/` | End-to-end test with llama-server, and its saved replies and `summary.json` |
| `shim_grammar.patch` | Proposed `--grammar FILE` option for `bench/ollama_openai_shim.py` (not applied) |

## How to pass the grammar to llama-server

The PrismML llama-server accepts a grammar in two ways (checked in `tools/server/server-common.cpp` and
`server-schema.cpp`, and confirmed end to end, see below):

1. **Per request, in the JSON body field `grammar`** (a string holding the GBNF text). It works on the
   OpenAI-compatible `POST /v1/chat/completions` (llama.cpp copies extra body fields into its sampling
   parameters) and on `POST /completion`. A grammar that does not parse is refused with HTTP 400
   `"Failed to initialize samplers: failed to parse grammar"`, so a silently ignored grammar is not
   possible. The field cannot be combined with `json_schema` or with `tools`.

   ```python
   body = {"messages": [{"role": "user", "content": prompt}], "temperature": 0.2, "top_p": 0.95,
           "seed": 1, "max_tokens": 2048,
           "grammar": open("bench/smallmodels/grammar/openscad.gbnf").read()}
   # POST http://127.0.0.1:18090/v1/chat/completions
   ```

2. **Server-wide, with `--grammar-file`** at start-up:
   `llama-server -m model.gguf --grammar-file bench/smallmodels/grammar/openscad.gbnf ...`.
   It becomes the default grammar of every request that does not send its own `grammar` field (each
   request's sampling parameters start from the server's). Every reply on that server is then
   constrained, including replies to prompts that are not about OpenSCAD.

The grammar applies from the first generated token: the reply must start with "```openscad". It
cannot contain a reasoning block, so thinking must be off (it is, in the protocol).

## What the grammar accepts

`root` is `"```openscad"`, optional spaces, a newline (`\r\n` allowed), the program, then `"```"` and
an optional newline. Nothing may come before or after. The program is OpenSCAD as parsed by
OpenSCAD 2021 and later:

- statements: assignments; `module` and `function` definitions (nested inside module bodies too);
  module instantiations with children (`translate(v) cube(1);`, blocks `{ ... }`, empty `;`);
  `for (i = [a:b])`, `for (i = [a, b, c])`, several loop variables; `intersection_for`; `if`/`else`
  (with `else if` chains); `let (...)`, `echo (...)`, `assert (...)` as statements; the modifiers
  `* ! # %`; `include <...>` and `use <...>`; assignments inside child blocks.
- expressions with OpenSCAD's precedence, lowest first: `function (...) expr`, `let (...) expr`,
  `assert (...) expr`, `echo (...) expr`; `?:` (right-associative); `||`; `&&`; `==` `!=`;
  `<` `<=` `>` `>=`; `+` `-`; `*` `/` `%`; unary `+` `-` `!`; `^` (right-associative); calls,
  indexing `a[i]`, member access `.x .y .z` (and `.begin .step .end` of ranges).
- literals: numbers (`1`, `1.5`, `.5`, `2.`, `1e-3`, `1.5E+3`, hex `0x1F`), strings with
  `\" \\ \n \t \r \x41 \u00e9 \U01F600` escapes and any Unicode, `true` `false` `undef`; vectors
  (trailing comma allowed), ranges `[a:b]` and `[a:s:b]`, list comprehensions `[for (...) ...]`
  with `if`/`else`, `each`, `let`, C-style `for (i = 0; i < n; i = i + 1)`, nested and parenthesised.
- names: `$fn $fa $fs $t $children $preview ...` (any `$name`); built-in module names may still be used
  as variable or parameter names (`offset = 3;`, `linear_extrude(scale = 0.5)`).
- whitespace and comments (`//`, `/* */`) between any two tokens.

## What it forbids

| Forbidden | Why |
|---|---|
| Python words as names anywhere: `def return lambda True False None print elif while` | `def`/`return`/`lambda` are Python; `True`/`False`/`None` are undefined variables in OpenSCAD (silently `undef`); `print(...)`, `elif (...)`, `while (...)` parse as unknown modules that OpenSCAD ignores |
| A built-in module called inside an expression: `rack = cube(10);`, `b = translate(v) cube(1);`, `[cube(1), sphere(2)]`, `union(cube(1), sphere(2))`, `function f() = cube(1);` | modules are not values in OpenSCAD; built-in modules: cube sphere cylinder polyhedron square circle polygon text import surface children translate rotate scale mirror multmatrix color offset hull minkowski union difference intersection linear_extrude rotate_extrude projection render resize intersection_for |
| Calls to `range()`, `int()`, `float()` | Python functions OpenSCAD lacks: silently `undef`, so a loop over `range(4)` builds nothing |
| A child after a primitive that takes none (`cube(10)` followed by the next statement) | catches the missing `;` after a module call; OpenSCAD would make the next line an ignored child |
| A file with no top-level module instantiation | a file of definitions only builds nothing |
| Member names other than `x y z begin step end` | rejects `math.sqrt(2)`, `np.pi` |
| ```` ``` ```` inside a comment or string (single backticks are fine) | the harness cuts the code at the first ```` ``` ```` |
| Prose before or after the block, an unclosed block | the reply is exactly one block |
| Python/C syntax in general: `for x in ...:`, `for (i in ...)`, `[x for x in ...]`, `a if c else b`, `+=`, `i++`, `function f(x) { return ...; }`, `import math` | not OpenSCAD syntax, rejected by the structure of the grammar |

Deliberate deviations from OpenSCAD's own parser, all stricter: names must start with a letter or `_`
(OpenSCAD's lexer also takes `2x` or `0X1F` as names, deprecated); a lone `$` is not a name; strings
cannot hold a raw newline; object members other than the six above; and bounded tokens - numbers up
to 20 digits, names up to about 64 characters, strings up to 256, line comments up to 400 characters,
block comments up to 1500, runs of spaces up to 96 and at most 5 newlines in a row, so that a
constrained model cannot loop forever inside one token or on blank lines. No file in the corpus comes
near these bounds (longest comment line 296 characters, deepest indent 46 spaces, at most 2 newlines in
a row).

Grammar design notes: every token is followed by optional whitespace, and the whitespace automaton never
lets two runs of spaces meet, so the grammar stays nearly deterministic (llama.cpp keeps one stack per
live parse). Statement and vector rules are left-factored for the same reason. GBNF has no negative
lookahead, so "any identifier except these 57 words" is a minimal automaton over the trie of the
excluded words (`fname`, generated). Keywords followed by a name (`module`, `function`, `else`,
`each`) require whitespace, as OpenSCAD's lexer does (`elsex` is one name).

## Validation

**Method.** There is no `llama-gbnf-validator` target in the PrismML build: the fork has the
validator only as the test program `tests/test-gbnf-validator.cpp`, and the build is configured with
`LLAMA_BUILD_TESTS=OFF`, so building it as a target would need a reconfigure. `validate.py` therefore
ports llama.cpp's `src/llama-grammar.cpp` to Python: the GBNF parser (`llama_grammar_parser::parse`, including the rewrite of `*`, `+`, `?` and `{m,n}` into
helper rules and the 2000-rule limit), the left-recursion check, and the stack-set acceptor
(`llama_grammar_advance_stack`, `llama_grammar_accept`), fed one Unicode code point at a time. It reads
`openscad.gbnf` itself, so the tested grammar is the file llama.cpp loads. As an independent check, the
upstream `tests/test-gbnf-validator.cpp` was compiled by hand against the existing build's
`libllama.so` (which exports the grammar functions) into a scratch directory - no cmake, nothing built
or written in the llama.cpp tree - and run on the same inputs.

**ACCEPT** (each `.scad` wrapped as "```openscad\n" + file + "\n```"; the distilled assistant replies,
already fenced, used as they are):

| Corpus | Accepted |
|---|---|
| `bench/reference/*.scad` | 16 / 16 |
| `bench/variants/*.scad` | 3 / 3 |
| `designs/**/*.scad` | 17 / 17 |
| `finetune/seeds/*.scad` | 34 / 34 |
| distill A, `finetune/rft/distill/clean_shard*.jsonl` | 680 / 680 |
| distill B, `clean_b_shard*.jsonl` | 700 / 700 |
| distill C, `clean_c_shard*.jsonl` | 674 / 674 |
| **total** | **2124 / 2124** |
| extra: `positives/syntax_tour.scad` | 1 / 1 |

No file had to be excused. **REJECT:** all 35 negatives are rejected, each on the line it names
(`validation_report.txt` lists the position and character). OpenSCAD's own parser, run on the same 33
`.scad` negatives, reports a syntax error for only 18 of them; the other 15 parse and would run with at
most a warning, building the wrong part or nothing:

| Negative | Rejected at | OpenSCAD itself |
|---|---|---|
| `py_def`, `py_return`, `py_lambda`, `py_import`, `py_from_import`, `py_for_in`, `py_for_in_parens`, `py_list_comprehension`, `py_ternary`, `plus_equals`, `c_style_for`, `function_with_braces` | the Python/C construct | syntax error |
| `module_value_translate`, `module_value_difference` | the module call in the expression | syntax error |
| `unbalanced_open_brace`, `unbalanced_close_brace` | closing fence / extra `}` | syntax error |
| `missing_semicolon_assignment`, `missing_semicolon_block` | the next token | syntax error |
| `missing_semicolon_module` (`cube(...)` then a new line) | the next statement | parses: the next line becomes an ignored child |
| `module_value_cube`, `module_in_vector`, `module_as_argument`, `module_from_function` | `(` after the module name | parses: "unknown function cube" |
| `py_true`, `py_false`, `py_none` | the word | parses: undefined variable, `undef` |
| `py_print`, `elif`, `while_loop` | the word | parses: unknown module, ignored |
| `range_call`, `math_member` | `(` / the member | parses: unknown function / variable |
| `module_never_called` | the closing fence | parses, builds nothing |
| `fence_in_comment` | the second backtick | parses, but the harness would cut the code there |
| `prose_before.reply.txt`, `unclosed_fence.reply.txt` | first character / end of reply | - |

**Differential tests** (scripts kept outside the repo; numbers for the final grammar):

- *Python port vs llama.cpp's C++ engine*: the same verdict **and the same rejection position** on all
  4160 inputs tried - the 2125 accepted files, 2000 random one-edit mutants of corpus files (538 of them
  rejected) and the 35 negatives.
- *Grammar vs OpenSCAD's parser* (`openscad -o x.ast`, OpenSCAD 2026.10.01, which parses without
  rendering), on 4500 further random one-edit mutants (delete, insert, swap or replace a character, or
  delete a token; two seeds): of the 3235 mutants the grammar accepts, **none fails to parse in
  OpenSCAD**, so no case of the grammar letting invalid OpenSCAD through was found. Of the 1265 it
  rejects, 14 parse in OpenSCAD, all through the deliberate restrictions above (digit-led names such as
  `2let` or `1x`, a lone `$`, members such as `spacer.h`, a primitive left without its `;`).

**Sampling cost.** llama.cpp checks candidate tokens against every live parse stack. Over the corpus the
grammar keeps 20-31 stacks per character on average; the maximum, 132, occurs at the start of a
statement, where every kind of statement is still possible. The C++ engine accepts the largest file
(3.2 kB) in 0.12 s including the grammar parse, about 35 us per character.

Re-run: `python -I -B bench/smallmodels/grammar/validate.py` (6 processes, about 20 s);
`--file x.scad` or `--reply r.txt` checks single inputs and prints where and why a text fails.
To rebuild the C++ checker: `g++ -O2 -std=c++17 -I$L/include -I$L/src -I$L/ggml/include
$L/tests/test-gbnf-validator.cpp -L$L/build/bin -lllama -lggml-base -Wl,-rpath,$L/build/bin -o gbnf-validator`
with `L=~/src/prismml-llama.cpp`, run from `$L/tests` (relative includes), output outside the tree.

## End-to-end test

`e2e.py` on 2026-10-19, qwen2.5-coder:1.5b (the GGUF in Ollama's blob store,
`sha256-29d8c98f...`, 986 MB, read in place), PrismML llama-server
`nice -n 10 llama-server -m <blob> --host 127.0.0.1 --port 18090 -c 8192 -t 6 -np 1` (CPU, loaded in
3 s), the prompt "Design a 20 x 30 x 5 mm plate with four 3 mm holes 4 mm from each corner. Reply with
a single complete OpenSCAD file." as the only message, temperature 0.2, top-p 0.95, seed 1. The laptop
was shared with a running benchmark (Ollama's own runner at about 370 % CPU), so speeds are indicative;
free and constrained requests were alternated twice.

| Request | Reply | Tokens | Tokens/s | Grammar accepts the reply | Renders | Part |
|---|---|---|---|---|---|---|
| `/v1/chat/completions`, no grammar | prose, code block, explanation | 403 | 15.8, 16.4 | no (prose at line 1) | yes | wrong: 27.5 x 32.5 x 9 mm, 9 bodies, no holes |
| same, `"grammar"` field | one ```` ```openscad ```` block only | 287 | 14.6, 14.1 | yes | yes | wrong: 20 x 30 x 34 mm, the hole cylinders are added, not cut |
| `--grammar-file` server, no field | one block only | 217 | 14.7 | yes | yes, with warnings | wrong: 20 x 30 x 5 mm, but `cylinder(diameter=, height=)` are not cylinder parameters, so a grid of default cylinders cuts a 1 mm pocket instead of four holes |

- The server accepted the grammar through the `grammar` field of `/v1/chat/completions` and of
  `/completion` (48 tokens, starting "```openscad", with the grammar listed in the reply's
  `generation_settings`), and through `--grammar-file`. A broken grammar was refused with HTTP 400.
- Cost: about 10 % fewer tokens per second (14.4 against 16.1 on average) on this 1.5B model, about
  7 ms a token. That time does not grow with model size, so its share should be smaller on 7B models.
- The constrained replies are valid OpenSCAD and render, but this model still builds the wrong part:
  the grammar removes syntax failures, not geometry errors. The unconstrained reply happened to parse
  as well.
- **qwen2.5-coder:7b was not run.** Its GGUF is 4.7 GB and needs about 5.5 GB with `-c 8192`; Ollama's
  own runner held 7.5 GB of resident memory for the running sweep, swap was already 1.5 GB in use and
  only 5.4 GB was available, so loading it would have pushed the shared machine into swapping. Command
  for later: `python -I -B bench/smallmodels/grammar/e2e.py --model
  /usr/share/ollama/.ollama/models/blobs/sha256-60e05f2100071479f596b964f89f510f057ce397ea22f2833a0cfe029bfc2463
  --label qwen2.5-coder-7b --repeats 2`.
- Same-seed requests were not always reproducible on llama-server: the two unconstrained requests gave
  different replies (403 and 342 tokens), the constrained ones identical replies.

## The shim change (`shim_grammar.patch`, not applied)

`bench/ollama_openai_shim.py` turns run_bench's Ollama calls into `/v1/chat/completions` requests, so it
is the one place that needs to know about the grammar. The minimal change: a `--grammar FILE` option that
reads the file once at start-up into a global, and one line in `chat()` that adds
`req["grammar"] = GRAMMAR` to every forwarded request (plus the docstring and start-up message). The
`grammar` field is llama.cpp's; vLLM does not read it. Without `--grammar` the shim is unchanged.
Checked with `git apply --check`. Usage once applied:

```sh
nice -n 10 ~/src/prismml-llama.cpp/build/bin/llama-server -m <gguf> --alias <name> \
    --host 127.0.0.1 --port 18090 -c 8192 -t 6 -np 1
python bench/ollama_openai_shim.py --upstream http://127.0.0.1:18090 --port 11501 \
    --grammar bench/smallmodels/grammar/openscad.gbnf
OLLAMA_HOST=http://127.0.0.1:11501 python bench/run_bench.py --models <name> ...
```

(Starting llama-server with `--grammar-file` instead works without any shim change, but then the
grammar run cannot be told apart from a plain run by the shim command line.)

## Before a 16-task benchmark run

- Apply the shim patch (or use `--grammar-file`), and freeze the grammar: record the sha256 above in
  PROTOCOL.md's table before the test run.
- Run a no-grammar baseline through the same llama-server and shim path. llama-server uses the chat
  template embedded in the GGUF (Jinja), Ollama its Modelfile template, so a grammar run on llama-server
  against the existing Ollama runs would mix two changes.
- `--feedback checklist` asks for a plain-text checklist before the code; the grammar forbids any text
  outside the block, so that mode cannot be combined with it (the default report feedback works: every
  repair turn asks for one code block).
- Memory: while Ollama keeps a model resident (7.5 GB for the sweep's model on 2026-10-19), only small
  GGUFs fit beside it on the 16 GB laptop; 7B to 9B runs need Ollama's model unloaded first (one model
  server at a time).
- Truncation at the token cap is not fixed by the grammar: a reply cut off at `num_predict` is still an
  unclosed block. run_bench's defaults (`num_ctx` 8192, `num_predict` 2048) fit `-c 8192`.
- Expect about 10 % lower token rate on small models.
