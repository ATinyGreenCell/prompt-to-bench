#!/usr/bin/env python3
"""Write openscad.gbnf, the GBNF grammar for grammar-constrained decoding of OpenSCAD in llama.cpp.

    python bench/smallmodels/grammar/build_grammar.py            # rewrites openscad.gbnf next to this file

Most of the grammar is the TEMPLATE below, written by hand. Two parts are generated, because GBNF has no
negative lookahead and no set difference:
  * `fname`, the identifiers that may be called as functions: every identifier except the OpenSCAD keywords,
    the forbidden Python words and the built-in module names. It is a minimal DFA over the trie of the
    excluded words, so that `cube(` cannot start an expression but `cubes(`, `cube_w` and `my_cube(` can.
  * `ws`, whitespace and comments between tokens: an unambiguous state machine (no two space runs in a row)
    that also caps the number of consecutive newlines, so that llama.cpp keeps few parse stacks and a model
    cannot loop on blank lines.

llama.cpp GBNF rules: rule names are [a-zA-Z0-9-]; outside parentheses a rule ends at the line end, so long
alternations are split with a trailing `|`; no left recursion; a bounded repetition {m,n} expands into n
rules, and llama.cpp refuses n >= 2000.
"""
from __future__ import annotations

import pathlib

OUT = pathlib.Path(__file__).resolve().with_name("openscad.gbnf")

# --------------------------------------------------------------------------- word sets
KEYWORDS = ["module", "function", "if", "else", "let", "assert", "echo", "for", "each",
            "true", "false", "undef", "include", "use"]           # never identifiers in OpenSCAD
PYTHON = ["def", "return", "lambda", "True", "False", "None", "print", "elif", "while"]  # forbidden everywhere
LEAF_MODULES = ["cube", "sphere", "cylinder", "polyhedron", "square", "circle", "polygon", "text",
                "import", "surface", "children"]                  # built-in modules that take no children
GROUP_MODULES = ["translate", "rotate", "scale", "mirror", "multmatrix", "color", "offset", "hull",
                 "minkowski", "union", "difference", "intersection", "linear_extrude", "rotate_extrude",
                 "projection", "render", "resize", "intersection_for"]  # built-in modules with children
NOCALL = ["range", "int", "float"]  # Python functions OpenSCAD does not have: allowed as names, never called

MAX_NEWLINES = 5      # consecutive newlines between two tokens (4 blank lines)
MAX_SPACES = 96       # one run of spaces/tabs
MAX_IDENT_TAIL = 48   # identifier characters after the part that is checked against the excluded words
IDC = sorted("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
FIRST = sorted("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")


def char_class(chars) -> str:
    """GBNF character class for a set of identifier characters, with ranges."""
    cs = sorted(set(chars), key=ord)
    out, i = [], 0
    while i < len(cs):
        j = i
        while j + 1 < len(cs) and ord(cs[j + 1]) == ord(cs[j]) + 1:
            j += 1
        out.append(cs[i] if j == i else (cs[i] + cs[j] if j == i + 1 else f"{cs[i]}-{cs[j]}"))
        i = j + 1
    return "[" + "".join(out) + "]"


def alts(name: str, options: list[str], per_line: int = 1) -> str:
    """name ::= a | b | ... with one or more alternatives per line (a trailing | continues the rule)."""
    lines, cur = [], []
    for o in options:
        cur.append(o)
        if len(cur) == per_line:
            lines.append(" | ".join(cur)); cur = []
    if cur:
        lines.append(" | ".join(cur))
    pad = " " * (len(name) + 5)
    return f"{name} ::= " + (" |\n" + pad).join(lines)


def lit(w: str) -> str:
    return '"' + w + '"'


# --------------------------------------------------------------------------- fname: identifier DFA
def fname_rules() -> str:
    excluded = sorted(set(KEYWORDS + PYTHON + LEAF_MODULES + GROUP_MODULES + NOCALL))
    trie: dict = {}
    for w in excluded:
        node = trie
        for ch in w:
            node = node.setdefault(ch, {})
        node["$end"] = True

    sig_name: dict = {}
    rules: list[str] = []

    def visit(node: dict, prefix: str) -> str:
        kids = {ch: visit(sub, prefix + ch) for ch, sub in sorted(node.items()) if ch != "$end"}
        accept = bool(prefix) and not node.get("$end")
        sig = (accept, tuple(sorted(kids.items())), prefix == "")
        if sig in sig_name:
            return sig_name[sig]
        name = "fname" if prefix == "" else f"fname-{len(sig_name)}"
        sig_name[sig] = name
        alphabet = FIRST if prefix == "" else IDC
        others = [c for c in alphabet if c not in kids]
        opts = [f'"{ch}" {sub}' for ch, sub in kids.items()]
        if others:
            opts.append(f"{char_class(others)} id-tail")
        body = " | ".join(opts)
        rules.append(f"{name} ::= ( {body} )?" if accept else f"{name} ::= {body}")
        return name

    visit(trie, "")
    rules.reverse()  # root first
    head = ("# fname: an identifier that is not a keyword, a forbidden Python word or a built-in module name,\n"
            "# i.e. a name that may be called as a function. Excluded words: " + " ".join(excluded) + "\n")
    return head + "\n".join(rules) + "\n" + f"id-tail ::= [a-zA-Z0-9_]{{0,{MAX_IDENT_TAIL}}}\n"


# --------------------------------------------------------------------------- ws: whitespace state machine
def ws_rules() -> str:
    """ws-a<c>: c consecutive newlines so far, last item not a space run; ws-b<c>: last item was a space run.
    `ws` is ws-a0. A line comment ends with its newline (c = 1 after it); a block comment resets c to 0."""
    out = ["# ws: optional whitespace and comments between two tokens. Every token is followed by ws, so ws",
           "# never meets ws; space runs never follow each other; at most %d newlines in a row." % MAX_NEWLINES]
    for c in range(MAX_NEWLINES + 1):
        a = "ws" if c == 0 else f"ws-a{c}"
        nxt = f"ws-a{c + 1}"
        a_opts = [f"sp ws-b{c}"] + ([f"nl {nxt}"] if c < MAX_NEWLINES else []) + ["lcom ws-a1", "bcom ws"]
        b_opts = ([f"nl {nxt}"] if c < MAX_NEWLINES else []) + ["lcom ws-a1", "bcom ws"]
        out.append(f"{a} ::= ( {' | '.join(a_opts)} )?")
        out.append(f"ws-b{c} ::= ( {' | '.join(b_opts)} )?")
    out.append("# ws1: whitespace that is not empty (after keywords followed by a name)")
    out.append("ws1 ::= sp ws-b0 | nl ws-a1 | lcom ws-a1 | bcom ws")
    return "\n".join(out) + "\n"


# --------------------------------------------------------------------------- the hand-written part
TEMPLATE = r'''# openscad.gbnf - OpenSCAD for grammar-constrained decoding in llama.cpp (llama-server, llama-cli).
# GENERATED by build_grammar.py - edit that file, then run it. Tested by validate.py.
#
# A reply is exactly one fenced block:  ```openscad <newline> PROGRAM ```  and nothing else.
# PROGRAM is OpenSCAD (the 2021+ grammar: let, each, list comprehensions, function literals), with these
# restrictions, all aimed at small-model mistakes:
#   - no Python words as names: def return lambda True False None print elif while;
#   - a built-in module (cube, translate, difference, ...) is never called inside an expression,
#     so `rack = cube(10);` and `b = translate(v) cube(1);` do not parse; range() int() float() neither;
#   - a primitive that takes no children (cube, sphere, cylinder, square, circle, polygon, polyhedron,
#     text, import, surface, children) must be followed by ";" - catches a missing semicolon before the
#     next statement, which OpenSCAD would read as an ignored child;
#   - member access is .x .y .z (vectors) or .begin .step .end (ranges) - rejects math.pi, np.sqrt(...);
#   - the top level instantiates at least one module (a file of only definitions builds nothing);
#   - "```" cannot occur inside a comment or string, so the first ``` always closes the block;
#   - bounded tokens: numbers <= 20 digits, names <= ~64 chars, strings <= 256 chars (no raw newline),
#     line comments <= 400 characters, block comments <= 1500, space runs <= 96, <= 5 newlines in a row;
#   - names start with a letter or _ (OpenSCAD also lexes 2x or 0X1F as names, deprecated).

root ::= "```openscad" [ \t]{0,8} "\r"? "\n" program "```" "\n"?

# ---------------------------------------------------------------- program and statements
program ::= ws pre-item* inst-item top-item*
pre-item ::= ";" ws | assignment | module-def | function-def | include-stmt | use-stmt
inst-item ::= "{" ws stmt* "}" ws | inst
top-item ::= stmt | use-stmt
assignment ::= pname ws assign-tail
assign-tail ::= "=" ws expr ";" ws

stmt ::= ";" ws | "{" ws stmt* "}" ws | stmt-id | inst-other | module-def | function-def | include-stmt
# a name at the start of a statement: an assignment or a module instantiation (left-factored)
stmt-id ::= stmt-name ws ( assign-tail | "(" ws args ")" ws child ) |
            leaf-mod ws ( assign-tail | "(" ws args ")" ws ";" ws ) |
            special ws assign-tail
inst ::= stmt-name ws "(" ws args ")" ws child | leaf-mod ws "(" ws args ")" ws ";" ws | inst-other
inst-other ::= [!#%*] ws inst | kw-inst | if-stmt
kw-inst ::= ( "for" | "let" | "echo" | "assert" ) ws "(" ws args ")" ws child
if-stmt ::= "if" ws "(" ws expr ")" ws child ( "else" ( ws1 child | child-punct ) )?
child ::= ";" ws | "{" ws child-item* "}" ws | inst
child-punct ::= ";" ws | "{" ws child-item* "}" ws | [!#%*] ws inst
child-item ::= ";" ws | "{" ws child-item* "}" ws | stmt-id | inst-other | include-stmt
module-def ::= "module" ws1 name ws "(" ws params ")" ws stmt
function-def ::= "function" ws1 name ws "(" ws params ")" ws "=" ws expr ";" ws
include-stmt ::= "include" [ \t]{0,8} "<" path ">" ws
use-stmt ::= "use" [ \t]{0,8} "<" path ">" ws
path ::= [^\t\r\n>`]{1,200}

params ::= ( param ( "," ws param )* ( "," ws )? )?
param ::= pname ws ( "=" ws expr )?
args ::= ( arg ( "," ws arg )* ( "," ws )? )?
arg ::= pname ws "=" ws expr | expr

# ---------------------------------------------------------------- expressions (lowest precedence first)
expr ::= ternary | fn-lit | let-expr | assert-expr
expr-nolet ::= ternary | fn-lit | assert-expr
fn-lit ::= "function" ws "(" ws params ")" ws expr
let-expr ::= "let" ws "(" ws args ")" ws expr
assert-expr ::= ( "assert" | "echo" ) ws "(" ws args ")" ws expr?
ternary ::= or-e ( "?" ws expr ":" ws expr )?
or-e ::= and-e ( "||" ws and-e )*
and-e ::= eq-e ( "&&" ws eq-e )*
eq-e ::= cmp-e ( ( "==" | "!=" ) ws cmp-e )*
cmp-e ::= add-e ( ( "<=" | ">=" | "<" | ">" ) ws add-e )*
add-e ::= mul-e ( [+\x2D] ws mul-e )*
mul-e ::= un-e ( [*/%] ws un-e )*
un-e ::= [+\x2D!] ws un-e | pow-e
pow-e ::= post-e ( "^" ws un-e )?
# a call needs a callable name: built-in modules (novar) may be read as variables but never called
post-e ::= prim postfix* | callable ws postfix* | novar ws ( index-or-member postfix* )?
postfix ::= "(" ws args ")" ws | index-or-member
index-or-member ::= "[" ws expr "]" ws | "." ws member ws
member ::= "x" | "y" | "z" | "begin" | "step" | "end"
prim ::= number ws | string ws | ( "true" | "false" | "undef" ) ws | "(" ws expr ")" ws | vector

# the same chain for an operand that starts with punctuation, used after `else` and `each` written
# without a space (`else[1]`, `each(...)`): `elsex` is one name in OpenSCAD, not `else x`
ternary-p ::= or-p ( "?" ws expr ":" ws expr )?
or-p ::= and-p ( "||" ws and-e )*
and-p ::= eq-p ( "&&" ws eq-e )*
eq-p ::= cmp-p ( ( "==" | "!=" ) ws cmp-e )*
cmp-p ::= add-p ( ( "<=" | ">=" | "<" | ">" ) ws add-e )*
add-p ::= mul-p ( [+\x2D] ws mul-e )*
mul-p ::= un-p ( [*/%] ws un-e )*
un-p ::= [+\x2D!] ws un-e | pow-p
pow-p ::= post-p ( "^" ws un-e )?
post-p ::= prim-p postfix* | special ws postfix*
prim-p ::= dotnum ws | string ws | "(" ws expr ")" ws | vector

# ---------------------------------------------------------------- vectors, ranges, list comprehensions
vector ::= "[" ws vec-body
vec-body ::= "]" ws | expr-nolet vec-first | vec-elem-x vec-tail
vec-first ::= ":" ws expr ( ":" ws expr )? "]" ws | vec-tail
vec-tail ::= ( "," ws vec-elem )* ( "," ws )? "]" ws
vec-elem ::= expr-nolet | vec-elem-x
vec-elem-x ::= lc-nolet | "let" ws "(" ws args ")" ws vec-elem
vec-elem-p ::= "(" ws lc-proper ")" ws | ternary-p
lc-nolet ::= lc-for | lc-if | lc-each | "(" ws lc-proper ")" ws
lc-proper ::= lc-for | lc-if | lc-each | "let" ws "(" ws args ")" ws lc-p
lc-p ::= lc-proper | "(" ws lc-proper ")" ws
lc-for ::= "for" ws "(" ws args ( ";" ws expr ";" ws args )? ")" ws vec-elem
lc-if ::= "if" ws "(" ws expr ")" ws vec-elem ( "else" lc-after-kw )?
lc-each ::= "each" lc-after-kw
lc-after-kw ::= ws1 vec-elem | vec-elem-p

# ---------------------------------------------------------------- tokens
number ::= [0-9]{1,20} ( "." [0-9]{0,20} )? exponent? | dotnum | "0x" [0-9a-fA-F]{1,16}
dotnum ::= "." [0-9]{1,20} exponent?
exponent ::= [eE] [+\x2D]? [0-9]{1,4}
string ::= "\"" str-char{0,256} "\""
str-char ::= [^"\\\n`] | "\\" ( [\\"nrt] | "x" [0-7] [0-9a-fA-F] | "u" [0-9a-fA-F]{4} | "U" [0-9a-fA-F]{6} )
special ::= "$" [a-zA-Z0-9_]{1,32}

name ::= fname | novar
pname ::= name | special
stmt-name ::= fname | group-mod | nocall
callable ::= fname | special
novar ::= leaf-mod | group-mod | nocall
@LEAF@
@GROUP@
@NOCALL@

@FNAME@
@WS@
sp ::= [ \t]{1,@MAXSP@}
nl ::= "\r"? "\n"
# a line comment runs to its newline; a backtick is never followed by another one
lcom ::= "//" lcom-char{0,400} "`"? "\n"
lcom-char ::= [^\n`] | "`" [^\n`]
bcom ::= "/*" bcom-char{0,1500} "*"{1,80} "/"
bcom-char ::= [^*`] | "`" [^*`] | "*"{1,80} [^*/`]
'''


def main() -> None:
    text = TEMPLATE
    text = text.replace("@LEAF@", alts("leaf-mod", [lit(w) for w in LEAF_MODULES], per_line=6))
    text = text.replace("@GROUP@", alts("group-mod", [lit(w) for w in GROUP_MODULES], per_line=6))
    text = text.replace("@NOCALL@", alts("nocall", [lit(w) for w in NOCALL], per_line=6))
    text = text.replace("@FNAME@", fname_rules())
    text = text.replace("@WS@", ws_rules())
    text = text.replace("@MAXSP@", str(MAX_SPACES))
    OUT.write_text(text)
    print(f"wrote {OUT} ({len(text.splitlines())} lines)")


if __name__ == "__main__":
    main()
