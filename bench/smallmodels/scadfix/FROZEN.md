# scadfix: frozen version

Frozen on 2026-10-20 at 02:28 US Eastern (EDT), after the development evaluation and before any test run. From
this point `scadfix.py` is not edited; a later fix would be a new, separately labelled version
([`../PROTOCOL.md`](../PROTOCOL.md)).

| Artefact | Version | sha256 | Frozen at | Test run |
|---|---|---|---|---|
| `bench/smallmodels/scadfix/scadfix.py` | 1.0 | `85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334` | 2026-10-20 02:28 EDT | offline re-scoring of the saved attempts in `main`, `ft-scad`, `main-bonsai` and `main-tiiny` (`test_eval.py`), once |

Check: `sha256sum bench/smallmodels/scadfix/scadfix.py`.

## Rules (32, in the order they run)

1. `prose_lines`
2. `python_comments`
3. `close_truncated`
4. `unicode_operators`
5. `python_import`
6. `python_literals`
7. `python_operators`
8. `python_math`
9. `python_def`
10. `python_blocks`
11. `python_for_in`
12. `python_comprehension`
13. `pipe_comprehension`
14. `bracketless_comprehension`
15. `comprehension_let`
16. `list_semicolons`
17. `python_range`
18. `dotdot_range`
19. `range_brackets`
20. `python_tuples`
21. `rotate_vector`
22. `python_in`
23. `python_continue`
24. `function_keyword`
25. `function_literal_equals`
26. `function_if_else`
27. `function_block`
28. `missing_semicolon`
29. `geometry_to_module`, `geometry_inline`, `geometry_in_place` (one pass, `geometry_as_value`, three named outcomes)
30. `bare_module_call`

## State at freezing

- Unit cases: 50 repair cases and 14 valid snippets, no failure (`unit_tests.txt`).
- No-op check: 2,124 verified files, no rule fired (`noop_check.json`).
- Development evaluation: `dev_results.json`, `dev_attempts.jsonl`, `dev_parse.json`.
- The test script `test_eval.py` was written and smoke-tested on a mock folder built from broken copies of two
  reference files (not model attempts) before freezing. It had not been run on any benchmark attempt.
