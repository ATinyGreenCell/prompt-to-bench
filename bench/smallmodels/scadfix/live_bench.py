#!/usr/bin/env python3
"""R3 (bench/smallmodels/PROTOCOL.md, round 2): scadfix 1.0 live in the benchmark's loop.

Runs a harness copy's run_bench.py unchanged, with one difference: every reply's code goes through scadfix.fix before
the harness writes and renders it. When a rule fires, the repaired file replaces the code in the reply (so it is what
the harness renders, checks and reports on) and in the backend's conversation (so the model's next turn sees it as its
own). The model is not told. The attempt's usage record keeps the rules that fired and the original reply.

    python -I live_bench.py --harness ~/tiny/bench/20261014-sweep/harness -- --run R --models M --samples 3

Everything after `--` goes to run_bench.py as it is. Refuses to run if scadfix.py is not the frozen 1.0 or the
harness copy's HARNESS.sha256 does not check. The manifest may list paths relative to the harness (the sweep's copy)
or to the repository the harness sits in (the held-out copy, bench/heldout/harness); the check prints no file names.
"""
import hashlib
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FROZEN = "85f74e839594e33576d6923be770a90f05c918324252febda804f40b490dc334"  # scadfix 1.0 (FROZEN.md)


def sha256(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()


def manifest_checks(harness, manifest):
    """True if `sha256sum -c` passes from the harness or from the top of the git repository it sits in."""
    roots = [harness]
    top = subprocess.run(["git", "-C", harness, "rev-parse", "--show-toplevel"], capture_output=True, text=True)
    if top.returncode == 0 and top.stdout.strip():
        roots.append(top.stdout.strip())
    return any(subprocess.run(["sha256sum", "-c", "--quiet", manifest], cwd=r, capture_output=True).returncode == 0
               for r in roots)


class Scadfixed:
    """A run_bench backend whose replies have their code repaired before the harness sees them."""

    def __init__(self, inner, extract_code, fix):
        self.__dict__.update(inner=inner, extract_code=extract_code, fix=fix)

    def __getattr__(self, name):  # opts, think, messages, close ... are the inner backend's
        return getattr(self.inner, name)

    def __setattr__(self, name, value):
        setattr(self.inner, name, value)

    def chat(self, system, user):
        text, usage = self.inner.chat(system, user)
        code, _ = self.extract_code(text or "")
        if not code:
            return text, usage
        fixed, rules = self.fix(code)
        at = text.rfind(code)  # the reply's own block, after any reasoning that quotes it
        if not rules or fixed.strip() == code.strip() or at < 0:
            return text, usage
        new = text[:at] + fixed + text[at + len(code):]
        msgs = getattr(self.inner, "messages", None)
        replaced = bool(msgs and msgs[-1].get("role") == "assistant" and msgs[-1].get("content") == text)
        if replaced:
            msgs[-1]["content"] = new
        usage = dict(usage or {})
        usage["scadfix"] = {"rules": rules, "orig_code_sha1": hashlib.sha1(code.encode(errors="surrogatepass")).hexdigest()[:12],
                            "history_replaced": replaced, "orig_reply": text}
        return new, usage


def main():
    argv = sys.argv[1:]
    if "--harness" not in argv or "--" not in argv:
        sys.exit(__doc__)
    harness = os.path.abspath(os.path.expanduser(argv[argv.index("--harness") + 1]))
    bench_args = argv[argv.index("--") + 1:]
    if sha256(os.path.join(HERE, "scadfix.py")) != FROZEN:
        sys.exit("scadfix.py is not the frozen 1.0")
    manifest = os.path.join(harness, "HARNESS.sha256")
    if os.path.exists(manifest) and not manifest_checks(harness, manifest):
        sys.exit("harness copy does not check (HARNESS.sha256)")
    os.chdir(harness)
    sys.path.insert(0, os.path.join(harness, "bench"))
    sys.path.append(HERE)  # after the harness's own modules
    import run_bench as RB
    from scadfix import fix
    make = RB.make_backend
    RB.make_backend = lambda *a, **k: Scadfixed(make(*a, **k), RB.extract_code, fix)
    sys.argv = [os.path.join(harness, "bench", "run_bench.py"), *bench_args]
    RB.main()


if __name__ == "__main__":
    main()
