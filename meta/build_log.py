#!/usr/bin/env python3
"""Export the Claude Code sessions that built this repository as a readable, redacted log.

    python meta/build_log.py            # writes meta/BUILD_LOG.md

Includes: the human's prompts (verbatim), the assistant's visible replies, and one line
per tool call (what was run / which file was written). Excludes: model reasoning,
raw tool outputs, images, and the system context Claude Code injects.
Redacts: e-mail addresses, home paths, tokens, and anything listed in meta/redact.txt
(one literal string per line - put private names there). Review the output before
publishing it.
"""
import glob
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SESSIONS = os.path.expanduser("~/.claude/projects/" + re.sub(r"[^A-Za-z0-9]", "-", ROOT))
OUT = os.path.join(ROOT, "meta", "BUILD_LOG.md")
EXTRA = os.path.join(ROOT, "meta", "redact.txt")

PATTERNS = [
    (re.compile(r"<system-reminder>.*?</system-reminder>", re.S), ""),
    (re.compile(r"[\w.+-]+@[\w-]+\.[\w.-]+"), "[email]"),
    (re.compile(r"[\w.+-]+@(?=[^\w.]|$)"), "[email]"),  # a bare "user@", e.g. in a grep pattern
    (re.compile(r"\b(gho|ghp|github_pat|sk-ant|sk)-?_?[A-Za-z0-9_\-]{12,}"), "[token]"),
    (re.compile(r"/tmp/claude-\d+/[^\s`'\")]*"), "[scratch]"),
    (re.compile(re.escape(os.path.expanduser("~"))), "~"),
]


def load_extra():
    if not os.path.exists(EXTRA):
        return []
    return [s.strip() for s in open(EXTRA) if s.strip() and not s.startswith("#")]


def redact(text, extra):
    for pat, rep in PATTERNS:
        text = pat.sub(rep, text)
    for s in extra:
        text = re.sub(re.escape(s), "[redacted]", text, flags=re.I)
    return text.strip()


def tool_line(block):
    name, inp = block.get("name", "?"), block.get("input") or {}
    if not isinstance(inp, dict):
        inp = {"input": inp}
    if name == "Bash":
        cmd = (inp.get("command") or "").strip().splitlines()
        desc = inp.get("description") or ""
        first = cmd[0][:140] + (" …" if len(cmd) > 1 or len(cmd[0]) > 140 else "") if cmd else ""
        return f"`Bash` {desc} — `{first}`"
    if name in ("Write", "Edit", "Read"):
        return f"`{name}` {inp.get('file_path', '')}"
    if name == "Agent":
        return f"`Agent` (sub-agent) {inp.get('description', '')}"
    if name in ("AskUserQuestion",):
        qs = inp.get("questions") or []
        return "`AskUserQuestion` " + " / ".join(str(q.get("question", "")) for q in qs if isinstance(q, dict))
    return f"`{name}` " + ", ".join(f"{k}={str(v)[:60]}" for k, v in list(inp.items())[:3])


def text_of(content):
    if isinstance(content, str):
        return content
    if not isinstance(content, list):
        return ""
    return "\n".join(str(b.get("text", "")) for b in content if isinstance(b, dict) and b.get("type") == "text")


def is_human(txt):
    """Typed by the person, not a background-task notification or harness message."""
    t = txt.lstrip()
    return bool(t) and not t.startswith(("<local-command", "<command-name>", "<command-message>", "Caveat:",
                                         "<task-notification", "[SYSTEM NOTIFICATION", "<system-reminder", "<agent-message"))


def events(path):
    for line in open(path, errors="replace"):
        try:
            d = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(d, dict) or d.get("isSidechain"):
            continue
        t, ts = d.get("type"), str(d.get("timestamp") or "")
        m = d.get("message") if isinstance(d.get("message"), dict) else {}
        if t == "user" and not d.get("isMeta") and not d.get("toolUseResult"):
            c = m.get("content")
            if isinstance(c, list) and any(b.get("type") == "tool_result" for b in c if isinstance(b, dict)):
                continue
            txt = text_of(c)
            if isinstance(c, list) and any(b.get("type") == "image" for b in c if isinstance(b, dict)):
                txt += "\n[screenshot omitted]"
            if is_human(txt):
                yield ts, "human", txt
        elif t == "queue-operation" and d.get("operation") == "enqueue" and is_human(str(d.get("content") or "")):
            yield ts, "human", str(d["content"])
        elif t == "assistant":
            content = m.get("content") or []
            for b in [{"type": "text", "text": content}] if isinstance(content, str) else content:
                if not isinstance(b, dict):
                    continue
                if b.get("type") == "text" and str(b.get("text") or "").strip():
                    yield ts, "claude", b["text"]
                elif b.get("type") == "tool_use":
                    yield ts, "tool", tool_line(b)


def main():
    extra = load_extra()
    files = sorted(glob.glob(os.path.join(SESSIONS, "*.jsonl")), key=os.path.getmtime)
    if not files:
        sys.exit(f"no Claude Code sessions found in {SESSIONS}")
    out = ["# Build log", "",
           "How this repository was built: the human's prompts, Claude's replies and every tool call, "
           "exported from Claude Code sessions by [`meta/build_log.py`](build_log.py). Model reasoning, raw tool "
           "output and images are omitted; private details are redacted.", ""]
    seen = set()
    for f in files:
        evs = list(events(f))
        if not evs:
            continue
        out += [f"## Session {os.path.basename(f)[:8]} (started {evs[0][0][:16].replace('T', ' ')} UTC)", ""]
        tools = []
        for ts, who, txt in evs:
            txt = redact(txt, extra)
            if not txt or (who, txt) in seen and who == "human":
                continue
            if who == "tool":
                tools.append(txt)
                continue
            if tools:
                out += ["<details><summary>" + f"{len(tools)} tool call(s)" + "</summary>", ""]
                out += [f"- {t}" for t in tools] + ["", "</details>", ""]
                tools = []
            if who == "human":
                seen.add((who, txt))
                out += [f"### 🧑 {ts[11:16]} UTC", "", "> " + txt.replace("\n", "\n> "), ""]
            else:
                out += [txt, ""]
        if tools:
            out += ["<details><summary>" + f"{len(tools)} tool call(s)" + "</summary>", ""]
            out += [f"- {t}" for t in tools] + ["", "</details>", ""]
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w").write("\n".join(out) + "\n")
    print(f"wrote {OUT} ({len(out)} lines) from {len(files)} session file(s)")


if __name__ == "__main__":
    main()
