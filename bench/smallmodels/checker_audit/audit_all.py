"""Re-score every saved failed attempt whose mesh was not watertight: as saved (Manifold, the default backend), after
a clean-up (merge vertices within 1e-5 mm, drop degenerate faces), and with --backend CGAL if the clean-up leaves it
open (only with CGAL=1). Writes audit_all.jsonl (in the current folder); prints progress lines only. Run from this folder:
    OPENSCAD=... nice -n 15 ~/printpaper/.venv/bin/python -I audit_all.py"""
import glob, hashlib, json, os, re, subprocess, sys, time
B = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))), "bench")
sys.path[:0] = [B, os.path.join(os.path.dirname(B), "tools")]
import yaml
from checks import evaluate
from scadreport import load_mesh, render
OS = os.environ.get("OPENSCAD", "openscad")
CGAL = os.environ.get("CGAL") == "1"  # off by default: CGAL renders take minutes
tasks = {t["id"]: t for t in yaml.safe_load(open(f"{B}/tasks.yaml"))}
refs = json.load(open(f"{B}/reference_stats.json"))
out = open("audit_all.jsonl", "w")
def score(m, task):
    r = evaluate(m, tasks[task], refs[task])
    return {"passed": r["passed"], "n_ok": r["n_ok"], "n": r["n"], "watertight": bool(m.is_watertight),
            "fails": [i["check"] for i in r["items"] if not i["ok"]]}
todo = []
for f in sorted(glob.glob(f"{B}/results/*/results.jsonl")):
    run = f.split("/")[-2]
    for ln, line in enumerate(open(f)):
        try:
            r = json.loads(line)
        except Exception:
            continue
        for a in r["attempts"]:
            c = a.get("check")
            if not c or c["passed"]:
                continue
            vol = next((i["msg"] for i in c["items"] if i["check"] == "volume"), "")
            if "watertight" not in vol and not any(i["check"] == "watertight" and not i["ok"] for i in c["items"]):
                continue
            todo.append((run, ln, r, a))
print(len(todo), "attempts to re-score", flush=True)
os.makedirs("work", exist_ok=True)
t0 = time.time()
for k, (run, ln, r, a) in enumerate(todo):
    task = r["task"]
    suffix = "".join(f"_{x}" for x, d in ((r.get("lang", "en"), "en"), (r.get("feedback", "report"), "report")) if x != d)
    path = os.path.join(B, "results", run, "code", re.sub(r"[^A-Za-z0-9._-]+", "_", r["model"]),
                        f"{task}_s{r['sample']}{suffix}_a{a['attempt']}.scad")  # as run_bench.py names them
    rec = {"run": run, "line": ln, "model": r["model"], "task": task, "sample": r["sample"], "attempt": a["attempt"],
           "conv_passed": r["passed"], "orig_score": a["score"], "orig_fails": [i["check"] for i in a["check"]["items"] if not i["ok"]]}
    if not os.path.exists(path):
        rec["error"] = "no saved file"; out.write(json.dumps(rec) + "\n"); continue
    code = open(path, encoding="utf-8", errors="replace").read()
    sha = hashlib.sha1(code.encode(errors="surrogatepass")).hexdigest()[:12]
    rec["sha_match"] = (a.get("code_sha1") is None) or (a.get("code_sha1") == sha)
    w = os.path.join("work", "x.scad")
    open(w, "w").write(code)
    try:
        rr = render(w, "work/a.stl", timeout=120)
        if not rr["ok"]:
            rec["error"] = "render failed now"; out.write(json.dumps(rec) + "\n"); continue
        m = load_mesh("work/a.stl")
        rec["now"] = score(m, task)
        m2 = m.copy(); m2.merge_vertices(digits_vertex=5); m2.update_faces(m2.nondegenerate_faces()); m2.remove_unreferenced_vertices()
        rec["clean"] = score(m2, task)
        if not m2.is_watertight and CGAL:
            p = subprocess.run([OS, "--backend", "CGAL", "--export-format", "binstl", "-o", os.path.abspath("work/b.stl"), "x.scad"],
                               cwd="work", capture_output=True, text=True, timeout=300)
            rec["cgal"] = score(load_mesh("work/b.stl"), task) if p.returncode == 0 else {"error": p.stderr[-200:]}
    except Exception as e:  # noqa: BLE001
        rec["error"] = repr(e)[:200]
    out.write(json.dumps(rec) + "\n"); out.flush()
    if k % 10 == 0:
        print(f"{k}/{len(todo)} {time.time() - t0:.0f} s", flush=True)
print("AUDIT DONE", f"{time.time() - t0:.0f} s", flush=True)
