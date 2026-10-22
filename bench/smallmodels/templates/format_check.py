# Does Ollama apply the JSON schema to a model? One template pick exactly as TemplateBackend._choose sends it, printing
# the full reply (content, thinking, done_reason, token counts). Usage: python -I format_check.py <model> [item index]
import json, sys, urllib.request
sys.path[:0] = ["/home/seb/printpaper/bench/smallmodels/templates", "/home/seb/printpaper/bench/smallmodels"]
import library as L
import dev_templates as D
from backend import CHOOSE
model = sys.argv[1]
it = D.items(2, 2)[int(sys.argv[2]) if len(sys.argv) > 2 else 0]
lib = L.load()
schema = {"type": "object", "properties": {"design": {"type": "string", "enum": list(lib) + ["none"]}}, "required": ["design"]}
msgs = [{"role": "system", "content": CHOOSE},
        {"role": "user", "content": f"Library:\n{L.catalog_text(lib)}\n\nRequest:\n{it['request']}"}]
body = {"model": model, "messages": msgs, "stream": False, "format": schema, "think": False,
        "options": {"temperature": 0.2, "top_p": 0.95, "seed": 1000, "num_ctx": 8192, "num_predict": 600}, "keep_alive": "30m"}
req = urllib.request.Request("http://127.0.0.1:11434/api/chat", data=json.dumps(body).encode(), headers={"Content-Type": "application/json"})
d = json.load(urllib.request.urlopen(req, timeout=1800))
m = d.get("message") or {}
print("item", it["id"], it["kind"], it["family"])
print("done_reason", d.get("done_reason"), "eval_count", d.get("eval_count"), "prompt_eval_count", d.get("prompt_eval_count"))
print("thinking chars", len(m.get("thinking") or ""), repr((m.get("thinking") or "")[:300]))
print("content chars", len(m.get("content") or ""), repr((m.get("content") or "")[:400]), "...", repr((m.get("content") or "")[-200:]))
