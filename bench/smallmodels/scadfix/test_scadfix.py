#!/usr/bin/env python3
"""Unit cases for scadfix: hand-written examples of each rule (generic parts, none from the 16 benchmark tasks).

    python -I -B test_scadfix.py          # needs OpenSCAD ($OPENSCAD or /home/seb/.local/bin/openscad)

Each case gives broken code (it fails to parse, or - for True/None and math. - evaluates with an "unknown" warning)
and the rules that must fire; the repaired file must then parse and evaluate in OpenSCAD without an error (CSG
export, no geometry), and, where given, contain a piece of expected text. Valid code
must come back unchanged.
"""
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from scadfix import fix  # noqa: E402

OPENSCAD = os.environ.get("OPENSCAD", "/home/seb/.local/bin/openscad")

CASES = [
    ("geometry_to_module, top level", ["geometry_to_module"],
     "plate = cube([40, 30, 4]);\nhole = translate([10, 10, -1]) cylinder(d = 3, h = 10, $fn = 24);\n"
     "difference() {\n    plate;\n    hole;\n}\n", "module hole()"),
    ("geometry_to_module, a block and its use", ["geometry_to_module"],
     "body = difference() {\n    cube([20, 20, 10]);\n    translate([10, 10, -1]) cylinder(d = 5, h = 12);\n};\nbody;\n",
     "body();"),
    ("geometry_to_module inside a module body", ["geometry_to_module"],
     "module bracket(t = 3) {\n    arm = cube([30, 10, t]);\n    union() {\n        arm;\n"
     "        rotate([0, -90, 0]) arm;\n    }\n}\nbracket();\n", "module arm()"),
    ("geometry_inline in a child block", ["geometry_inline"],
     "difference() {\n    base = cube([30, 30, 5]);\n    pin = translate([15, 15, -1]) cylinder(d = 4, h = 7);\n"
     "    base;\n    pin;\n}\n", None),
    ("geometry_in_place, unused block", ["geometry_in_place"],
     "difference() {\n    star = union() { cube(10); translate([5, 5, 0]) cylinder(d = 4, h = 10); };\n"
     "    translate([5, 5, -1]) cylinder(d = 2, h = 12);\n}\n", None),
    ("geometry_in_place, keyword as the name", ["geometry_in_place"],
     "for (i = [0 : 2])\n    translate([i * 10, 0, 0])\n        module = cylinder(d = 8, h = 2);\n", None),
    ("python_literals", ["python_literals"], "cube([10, 10, 10], center=True);\nsphere(2, $fn = None);\n",
     "center=true"),
    ("python_comments keeps the # modifier", ["python_comments"], "# Base plate\ncube(5);\n#cube(3);  # debug\n",
     "#cube(3);  // debug"),
    ("python_operators", ["python_operators"],
     "x = 5;\nif (x > 3 and x < 10) cube(x);\nif (not (x == 4) or x > 9) sphere(2);\ny = 2 ** 3;\ncube(y);\n",
     "y = 2 ^ 3;"),
    ("python_def", ["python_def"], "def half(v):\n    return v / 2\n\ncube(half(10));\n",
     "function half(v) = v / 2;"),
    ("python_def on one line", ["python_def"], "def area(w, h): return w * h\ncube(area(2, 3));\n", None),
    ("python_blocks and python_range", ["python_blocks", "python_range"],
     "for i in range(4):\n    translate([i * 10, 0, 0])\n        cube(5);\ncube(1);\n", "for (i = [0 : 4 - 1]) {"),
    ("python_blocks with if/else", ["python_blocks"],
     "n = 3;\nfor i in [0 : n]:\n    if i % 2 == 0:\n        translate([i * 10, 0, 0]) cube(5);\n    else:\n"
     "        translate([i * 10, 0, 0]) sphere(2);\n", None),
    ("python_comprehension", ["python_comprehension"],
     "xs = [i * 10 for i in [0 : 4]];\nys = [i * 2 for i = [0, 1, 2] if i != 1];\n"
     "for (x = xs) translate([x, 0, 0]) cube(2);\n", "[for (i = [0, 1, 2]) if (i != 1) i * 2]"),
    ("python_comprehension, multi-line, with range", ["python_comprehension", "python_range"],
     "xs = [i * 10 - 5\n      for i in range(1, 4)];\nfor (x = xs) translate([x, 0, 0]) cube(2);\n", None),
    ("python_for_in", ["python_for_in"], "for (x in [0, 5, 10]) translate([x, 0, 0]) cube(2);\n", None),
    ("python_tuples", ["python_tuples"],
     "p = (1, 2, 3);\ntranslate(p) cube(1);\nlinear_extrude(2) polygon([(0, 0), (10, 0), (5, 8)]);\n", "[1, 2, 3]"),
    ("dotdot_range", ["dotdot_range"],
     "for (i = [0..3]) translate([i * 5, 0, 0]) cube(2);\nfor (j = 0..2) translate([0, j * 5, 0]) cube(2);\n",
     "for (j = [0 : 2])"),
    ("range_brackets", ["range_brackets"], "for (i = 0 : 3) translate([i * 5, 0, 0]) cube(2);\n",
     "for (i = [0 : 3])"),
    ("python_continue", ["python_continue"],
     "for (i = [0 : 5]) {\n    x = i * 6;\n    if (i % 2 == 1) continue;  // odd ones out\n"
     "    translate([x, 0, 0]) cube(4);\n}\n", "if (!(i % 2 == 1)) {"),
    ("function_if_else", ["function_if_else"],
     "function w(x) =\n    if (x < 0) 1\n    else if (x < 5) 2\n    else 3;\ncube(w(2));\n",
     "(x < 0) ? 1 : (x < 5) ? 2 : 3;"),
    ("function_if_else with semicolons", ["function_if_else"],
     "function w(x) =\n    if (x < 0) 1;\n    else if (x < 5) 2;\n    else 3;\ncube(w(2));\n", None),
    ("function_block", ["function_block"],
     "function w(x) {\n    if (x < 0) return 1;\n    y = x * 2;\n    return y + 1;\n}\ncube(w(2));\n", None),
    ("function_block, literal", ["function_block"], "f = function(x) { return x * 2; };\ncube(f(3));\n",
     "f = function(x) x * 2;"),
    ("function_block, a module that returns", ["function_block"],
     "module width(x) {\n    if (x < 10)\n        return 4;\n    else\n        return 6;\n}\ncube(width(3));\n",
     "function width(x) = (x < 10) ? 4 : 6;"),
    ("function_literal_equals", ["function_literal_equals"], "f = function(s) = s * 2;\ncube(f(2));\n", None),
    ("missing_semicolon after an assignment", ["missing_semicolon"], "w = 10\nh = 5;\ncube([w, h, 2]);\n", "w = 10;"),
    ("missing_semicolon on a run of lines and a shape", ["missing_semicolon", "geometry_to_module"],
     "length = 40\nwidth = 20\nbody = cube([length, width, 3])\nhole = translate([20, 10, -1]) cylinder(d = 3, h = 5)\n"
     "difference() {\n    body;\n    hole;\n}\n", "width = 20;"),
    ("missing_semicolon before }", ["missing_semicolon"],
     "difference() {\n    cube(10)\n}\ntranslate([20, 0, 0]) cube(3)\n", None),
    ("close_truncated", ["close_truncated"],
     "difference() {\n    cube([20, 20, 5]);\n    translate([5, 5, -1]) cylinder(d = 3, h = 7);\n"
     "    translate([15, 5, -1]) cylinder(d = 3,", None),
    ("close_truncated inside a module", ["close_truncated"],
     "module peg() {\n    union() {\n        cylinder(d = 5, h = 10);\n        translate([0, 0, 10]) sphere(", None),
    ("prose_lines", ["prose_lines"],
     "Here is the OpenSCAD code for the plate:\ncube([10, 10, 2]);\nThis creates a simple plate with square edges.\n",
     None),
    ("python_math", ["python_math"],
     "r = 10;\nx = r * math.cos(math.radians(30));\ny = math.sqrt(2) * math.pi;\ntranslate([x, y, 0]) cube(1);\n",
     "cos((((30) * PI / 180)) * 180 / PI)"),
    ("python_import", ["python_import", "python_math"], "import math\ncube(math.floor(5.5));\n", None),
    ("unicode_operators", ["unicode_operators"], "translate([−5, 0, 0]) cube(2 × 3);\n", None),
    ("bare_module_call", ["bare_module_call"], "module peg() { cylinder(d = 3, h = 5); }\npeg;\n", "peg();"),
    ("several at once", ["python_comments", "python_literals", "geometry_to_module"],
     "# A spacer\nouter = cylinder(d = 12, h = 5, center=True);\ninner = cylinder(d = 6, h = 6, center=True);\n"
     "difference() {\n    outer;\n    inner;\n}\n", None),
    ("pipe_comprehension", ["pipe_comprehension"],
     "xs = [i * 5 + 2 | i = [0 : 3]];\nfor (x = xs) translate([x, 0, 0]) cube(1);\n", "[for (i = [0 : 3]) i * 5 + 2]"),
    ("bracketless_comprehension with a function call", ["bracketless_comprehension"],
     "xs = for (i = [0 : 3]) sin(i * 30) * 10;\nfor (x = xs) translate([x, 0, 0]) cube(1);\n", "xs = [for"),
    ("bracketless_comprehension", ["bracketless_comprehension"],
     "xs = for (i = [0 : 3]) -6 + i * 4;\nfor (x = xs) translate([x, 0, 0]) cube(1);\n", "xs = [for (i"),
    ("comprehension_let and list_semicolons", ["comprehension_let", "list_semicolons"],
     "n = 6;\nlinear_extrude(2) polygon([for (i = [0 : n - 1])\n    r = (i % 2 == 0) ? 10 : 5;\n"
     "    [r * cos(i * 360 / n), r * sin(i * 360 / n)];\n]);\n", "let(r = (i % 2 == 0) ? 10 : 5)"),
    ("list_semicolons between two loops", ["list_semicolons"],
     "linear_extrude(2) polygon(points = [\n    for (i = [0 : 3]) [10 * cos(i * 90), 10 * sin(i * 90)];\n"
     "    for (i = [0 : 3]) [4 * cos(i * 90 + 45), 4 * sin(i * 90 + 45)];\n]);\n", None),
    ("rotate_vector", ["rotate_vector"],
     "pts = [for (i = [0 : 5]) rotate(i * 60) [10, 0]];\nq = [for (i = [0 : 2]) rotate([0, 0, i * 120]) [5, 0, 1]];\n"
     "linear_extrude(1) polygon(pts);\necho(q);\n", "(let(scadfix_a = i * 60)"),
    ("python_in", ["python_in"],
     "keep = [1, 3];\nfor (i = [0 : 4])\n    if (i in keep) translate([i * 5, 0, 0]) cube(2);\n", None),
    ("python_comprehension with comments inside", ["python_comprehension"],
     "xs = [i * 10   // scale\n      for i in [0 : 4]   // five\n      if i != 2];  // skip one\necho(xs);\n", None),
    ("pipe_comprehension with a condition and a comment", ["pipe_comprehension"],
     "idx = [i | i = [0 : 5]\n          if (i % 2 == 0)   // even (0-based)\n      ];\necho(idx);\n", None),
    ("function_keyword", ["function_keyword"], "half_w(z) = 10 - z / 2;\nlip() = 3;\ncube([half_w(4), lip(), 1]);\n",
     "function half_w(z) = 10 - z / 2;"),
    ("function_block, an if chain that falls through", ["function_block"],
     "module width(x) {\n    if (x < -5)\n        return 2;\n    else if (x > 5)\n        return 3;\n"
     "    // in between\n    return 4;\n}\ncube(width(0));\n", "(x < -5) ? 2 : (x > 5) ? 3 : 4"),
    ("prose_lines, markdown", ["prose_lines"],
     "**Note:** the plate is printed flat on the bed.\n- Use a fine layer height for the top.\ncube([10, 10, 2]);\n",
     None),
    ("python_comprehension leaves an index alone", ["python_comprehension"],
     "xs = [i * 2 for i in [0 : 4]];\nys = xs[[j for j in [0, 1]]];\necho(ys);\n", "ys = xs[[for (j = [0, 1]) j]]"),
]

VALID = [
    "#cube(5);\n%sphere(2);\n*cylinder(d = 1, h = 1);\n!translate([0, 0, 1]) cube(1);\n",
    "x = [for (i = [0 : 3]) i * 2];\ny = [for (i = [0 : 3]) if (i > 1) i];\necho(x, y);\ncube(1);\n",
    "a = 3;\nb = a;\nc = len([1, 2]) > 1 && a == 3 || !(b < 2);\necho(str(\"a and b or not c\"));\ncube(c ? 1 : 2);\n",
    "f = function(x) x * 2;\ng = let(a = 1, b = 2) a + b;\nfunction h(v) = v < 0 ? 0 : v;\ncube(f(g) + h(-1));\n",
    "for (i = [0 : 3], j = [1 : 2]) translate([i, j, 0]) cube(0.5);\n",
    "module m(s = 2) { cube(s); }\nm();\nm(s = 3);\n// True, False, None, and, or, not, ** and # in a comment\n",
    "/* a block comment with x = cube(5); and range(3) and [i for i in x] */\ncube(2);\n",
    "e = 2^3;\nv = [1, 2, 3] * 2;\nw = v[0] % 2;\ntranslate([e, w, 0]) cube(1);\n",
    "difference() {\n    cube(10);\n    translate([5, 5, -1]) cylinder(d = 2, h = 12);\n}\n",
    "if (true) cube(1); else sphere(1);\nlet (r = 2) sphere(r);\nfor (p = [[0, 0], [1, 1]]) translate(p) cube(0.1);\n",
    "points = [[0, 0], [10, 0], [5, (8)]];\nlinear_extrude(height = (2)) polygon(points);\n",
    "x = 1;\ny = x\n    + 2;\nz = y > 2\n    ? 1\n    : 0;\ncube(z + 1);\n",
    "v = [for (i = [0 : 3])\n     if (i > 1) i > 2 ? 1 :\n     0];\necho(v);\ncube(1);\n",
    "g = function(x) x + 1;\nh = g(1)(2, 3);\nechos = [each [1, 2], for (i = [0 : 1]) (i + 1) * 2];\necho(h, echos);\n",
]


def parses(code: str) -> tuple:
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "t.scad")
        with open(p, "w") as fh:
            fh.write(code)
        r = subprocess.run([OPENSCAD, "-o", os.path.join(d, "t.csg"), "t.scad"], cwd=d, capture_output=True,
                           text=True, timeout=60)
        log = r.stdout + r.stderr
        return r.returncode == 0 and "ERROR" not in log, log.strip()


def main() -> int:
    bad = 0
    for title, rules, code, expect in CASES:
        out, fired = fix(code)
        ok, log = parses(out)
        before, _ = parses(code)
        problems = []
        if before and not re.search(r"WARNING: (Ignoring unknown|Can't call function)", parses(code)[1]):
            problems.append("the broken example already parses, without a warning")
        if not ok:
            problems.append("fixed file does not parse: " + log[-300:])
        if not set(rules) <= set(fired):
            problems.append(f"rules {fired}, expected {rules}")
        if expect and expect not in out:
            problems.append(f"expected text {expect!r} missing")
        print(("ok  " if not problems else "FAIL") + f" {title}: fired {fired}")
        if problems:
            bad += 1
            print("     " + "\n     ".join(problems))
            print("     ---- fixed file ----\n" + "\n".join("     " + ln for ln in out.split("\n")))
    for code in VALID:
        out, fired = fix(code)
        ok, log = parses(code)
        if out != code or fired or not ok:
            bad += 1
            print(f"FAIL valid code changed or does not parse: fired {fired}\n{code}\n{log[-200:]}")
    print(f"{len(CASES)} repair cases, {len(VALID)} valid snippets, {bad} failures")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
