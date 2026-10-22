"""From audit_all.jsonl: which conversations change verdict once non-watertight meshes are cleaned, per run and model."""
import collections, json, sys
recs = [json.loads(l) for l in open(sys.argv[1] if len(sys.argv) > 1 else "audit_all.jsonl")]
err = [r for r in recs if r.get("error")]
print(len(recs), "re-scored;", len(err), "errors:", collections.Counter(r["error"][:40] for r in err).most_common(4))
same = sum(1 for r in recs if r.get("now") and r["now"]["fails"] == r["orig_fails"])
print("re-render reproduces the recorded failed checks:", same, "of", sum(1 for r in recs if r.get("now")))
wt = sum(1 for r in recs if (r.get("clean") or {}).get("watertight"))
print("watertight after clean-up:", wt)
flip = [r for r in recs if (r.get("clean") or {}).get("passed") or (r.get("cgal") or {}).get("passed")]
print(len(flip), "attempts pass after clean-up")
conv = collections.OrderedDict()
for r in flip:
    k = (r["run"], r["model"], r["task"], r["sample"])
    conv.setdefault(k, []).append(r)
print(len(conv), "conversations; of them already passed:", sum(v[0]["conv_passed"] for v in conv.values()))
for (run, model, task, s), v in conv.items():
    a = min(x["attempt"] for x in v)
    print(f"  {run:<18} {model:<44} {task:<24} s{s} first flipped attempt a{a}  conv was {'PASS' if v[0]['conv_passed'] else 'fail'}  orig fails {v[0]['orig_fails']}")
