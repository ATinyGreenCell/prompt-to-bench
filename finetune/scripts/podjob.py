#!/usr/bin/env python3
"""podjob - run work on a RunPod pod over SSH without the footguns that cost us on 2026-10-17.

Every job gets its own directory on the pod, /workspace/jobs/<run-id>/ (cmd.sh, out.log, pid, exit), so two runs
never share a log or a marker; `exit` is written atomically when the command ends, so "done" can only mean THIS
run finished; the job runs in its own session, so it outlives the SSH connection and "running" means any of its
processes is alive; a per-name lock refuses a second concurrent run of the same job; and an SSH transport failure
(exit 255, a timeout) is retried, never read as "the job is gone" - though a pod unreachable for --max-unreachable
seconds (stopped, terminated) ends the wait. Big directories come back through `runpodctl send/receive`, started
only once the sender's room is open, received into a fresh staging directory and verified file by file before
anything local is touched.

    podjob.py --host H --port P wait-ssh
    podjob.py --host H --port P push train.jsonl train_vlm.py --dest /workspace
    RUN=$(podjob.py --host H --port P run train -- bash pod_train_vlm.sh)       # prints the run id
    podjob.py --host H --port P wait "$RUN" --timeout 14400                       # exit status = the job's
    podjob.py --host H --port P pull /workspace/out.jsonl ./out.jsonl              # sha256-verified
    podjob.py --host H --port P pull-dir /workspace/out_vlm/merged16 ./out-v9     # runpodctl, verified
    podjob.py --host H --port P status "$RUN"

Exit codes: 0 ok; the job's own code for `wait`; 2 usage; 3 pod unreachable; 4 duplicate run; 5 job crashed
(every process gone, no exit file); 124 wait timed out; 6 transfer or verification failed, or a refused overwrite.
"""
from __future__ import annotations

import argparse
import hashlib
import os
import re
import secrets
import shlex
import shutil
import subprocess
import sys
import time

KEY = os.path.expanduser("~/.ssh/runpod_ft")
SSH_OPTS = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-o", "LogLevel=ERROR",
            "-o", "ConnectTimeout=20", "-o", "ServerAliveInterval=15", "-o", "ServerAliveCountMax=4"]
JOBS = "/workspace/jobs"


def log(msg: str) -> None:
    print(f"{time.strftime('%H:%M:%S')} {msg}", file=sys.stderr, flush=True)


class Pod:
    def __init__(self, host: str, port: int, retries: int = 6):
        self.host, self.port, self.retries = host, port, retries

    def ssh(self, script: str, timeout: int = 120, check_transport: bool = True) -> subprocess.CompletedProcess:
        """Run a bash script on the pod. Retries ONLY transport failures (ssh exit 255 / local timeout)."""
        cmd = ["ssh", "-i", KEY, *SSH_OPTS, "-p", str(self.port), f"root@{self.host}", "bash -s"]
        last = None
        for attempt in range(1, self.retries + 1):
            try:
                r = subprocess.run(cmd, input=script, capture_output=True, text=True, timeout=timeout)
            except subprocess.TimeoutExpired:
                last = "local timeout"
            else:
                if r.returncode != 255:
                    return r
                last = (r.stderr or "").strip()[:200] or "ssh exit 255"
            if not check_transport:
                break
            log(f"ssh transport failure ({last}); retry {attempt}/{self.retries}")
            time.sleep(min(60, 5 * attempt))
        raise ConnectionError(f"pod {self.host}:{self.port} unreachable: {last}")

    def scp(self, src: str, dst: str, timeout: int = 3600) -> None:
        cmd = ["scp", "-q", "-i", KEY, *SSH_OPTS, "-P", str(self.port), src, dst]
        for attempt in range(1, self.retries + 1):
            try:
                r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
            except subprocess.TimeoutExpired:
                why = f"no finish within {timeout}s"
            else:
                if r.returncode == 0:
                    return
                why = (r.stderr or "").strip()[:160]
            log(f"scp failed ({why}); retry {attempt}/{self.retries}")
            time.sleep(min(60, 5 * attempt))
        raise ConnectionError(f"scp {src} -> {dst} failed")

    def remote(self, path: str) -> str:
        return f"root@{self.host}:{path}"


def sha256(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for b in iter(lambda: fh.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def remote_sha(pod: Pod, path: str) -> str:
    r = pod.ssh(f"sha256sum {shlex.quote(path)} | cut -d' ' -f1")
    return r.stdout.strip()


# ------------------------------------------------------------------ commands
def cmd_wait_ssh(pod: Pod, a) -> int:
    t0 = time.time()
    while time.time() - t0 < a.timeout:
        try:
            r = pod.ssh("echo up", timeout=30, check_transport=False)
            if r.returncode == 0 and "up" in r.stdout:
                log(f"ssh up after {time.time() - t0:.0f}s")
                return 0
        except ConnectionError:
            pass
        time.sleep(10)
    log(f"pod not reachable after {a.timeout}s")
    return 3


def cmd_push(pod: Pod, a) -> int:
    bad = [f for f in a.files if not os.path.isfile(f)]
    if bad:
        log(f"not a file: {bad[0]} (push files; tar a directory first)")
        return 2
    pod.ssh(f"mkdir -p {shlex.quote(a.dest)}")
    for f in a.files:
        dst = f"{a.dest.rstrip('/')}/{os.path.basename(f)}"
        pod.scp(f, pod.remote(dst))
        lh, rh = sha256(f), remote_sha(pod, dst)
        if lh != rh:
            log(f"VERIFY FAILED {f}: local {lh[:12]} remote {rh[:12]}")
            return 6
        log(f"pushed {f} -> {dst} (sha256 {lh[:12]})")
    return 0


RUN_TEMPLATE = r'''set -u
J={jobs}/{run}
mkdir -p {jobs}
exec 8>{jobs}/{name}.lock
if ! flock -n 8; then echo "DUPLICATE: another '{name}' run holds the lock"; exit 4; fi
mkdir "$J" || {{ echo "run dir exists"; exit 4; }}
cat > "$J/cmd.sh" <<'{tag}'
{cmd}
{tag}
cd {cwd} || {{ echo "no such directory: {cwd}"; rm -rf "$J"; exit 6; }}
# the job runs in its own session, so its pid is also its process group (status checks the whole group); it
# inherits the name lock (fd 8) for its whole life and writes its exit status atomically at the end
# shellcheck disable=SC2016
setsid bash -c 'echo $$ > "$1/pid.tmp"; mv "$1/pid.tmp" "$1/pid"; bash "$1/cmd.sh" > "$1/out.log" 2>&1 < /dev/null; rc=$?; echo "$rc" > "$1/exit.tmp"; mv "$1/exit.tmp" "$1/exit"' _ "$J" > /dev/null 2>&1 < /dev/null &
for _ in $(seq 50); do [ -s "$J/pid" ] && break; sleep 0.2; done
if [ ! -s "$J/pid" ]; then echo "job did not start"; exit 6; fi
echo "STARTED {run}"
'''


def cmd_run(pod: Pod, a) -> int:
    if not a.cmd:
        log("nothing to run (put the command after --)")
        return 2
    if not re.fullmatch(r"[A-Za-z0-9_.-]+", a.name):
        log("job name: letters, digits, _ . - only")
        return 2
    run = f"{a.name}-{time.strftime('%Y%m%dT%H%M%S')}"
    cmd = " ".join(shlex.quote(c) for c in a.cmd) if len(a.cmd) > 1 else a.cmd[0]
    tag = f"PODJOB_{secrets.token_hex(8).upper()}"   # a heredoc end no command line can contain by accident
    r = pod.ssh(RUN_TEMPLATE.format(jobs=JOBS, run=run, name=a.name, cmd=cmd, cwd=shlex.quote(a.cwd), tag=tag))
    out = (r.stdout or "") + (r.stderr or "")
    if "DUPLICATE" in out or r.returncode == 4:
        log(out.strip())
        return 4
    if f"STARTED {run}" not in out:
        log(f"start failed: {out.strip()[:300]}")
        return 6
    print(run)
    log(f"started {run}")
    return 0


STATUS_SCRIPT = r'''J={jobs}/{run}
if [ ! -d "$J" ]; then echo "NOSUCHRUN"; exit 0; fi
if [ -f "$J/exit" ]; then echo "DONE $(cat "$J/exit")"; exit 0; fi
p=$(cat "$J/pid" 2>/dev/null)
# any process left in the job's process group counts: the wrapper alone is not the job
if [ -n "$p" ] && {{ kill -0 -- "-$p" 2>/dev/null || kill -0 "$p" 2>/dev/null; }}; then echo "RUNNING"; else echo "CRASHED"; fi
'''


def status(pod: Pod, run: str) -> str:
    return pod.ssh(STATUS_SCRIPT.format(jobs=JOBS, run=run)).stdout.strip()


def cmd_status(pod: Pod, a) -> int:
    print(status(pod, a.run))
    return 0


def cmd_wait(pod: Pod, a) -> int:
    t0, last_note, last_ok = time.time(), 0.0, time.time()
    while True:
        try:
            st = status(pod, a.run)
            last_ok = time.time()
        except ConnectionError as e:
            if time.time() - last_ok > a.max_unreachable:
                log(f"{e} - unreachable for {time.time() - last_ok:.0f}s: giving up (stopped or terminated pod?)")
                return 3
            log(f"{e} - still waiting (a lost connection is not a finished job)")
            st = "UNKNOWN"
        if st.startswith("DONE"):
            rc = int(st.split()[1])
            tail = pod.ssh(f"tail -n {a.tail} {JOBS}/{a.run}/out.log").stdout
            log(f"{a.run} finished rc={rc}\n{tail}")
            return rc
        if st == "CRASHED":
            # the pid can vanish a moment before the exit file lands; look once more before calling it
            time.sleep(5)
            if status(pod, a.run).startswith("DONE"):
                continue
            tail = pod.ssh(f"tail -n {a.tail} {JOBS}/{a.run}/out.log").stdout
            log(f"{a.run} CRASHED: process gone and no exit file\n{tail}")
            return 5
        if st == "NOSUCHRUN":
            log(f"no run {a.run} on this pod")
            return 2
        if time.time() - t0 > a.timeout:
            log(f"wait timed out after {a.timeout}s (job still {st}; it keeps running)")
            return 124
        if time.time() - last_note > 600:
            last_note = time.time()
            log(f"{a.run}: {st} ({time.time() - t0:.0f}s)")
        time.sleep(a.poll)


def cmd_pull(pod: Pod, a) -> int:
    if pod.ssh(f"test -f {shlex.quote(a.remote)}").returncode != 0:   # not a transport problem: don't retry it
        log(f"no such file on the pod: {a.remote}")
        return 6
    os.makedirs(os.path.dirname(os.path.abspath(a.local)) or ".", exist_ok=True)
    pod.scp(pod.remote(a.remote), a.local)
    rh, lh = remote_sha(pod, a.remote), sha256(a.local)
    if rh != lh:
        log(f"VERIFY FAILED: remote {rh[:12]} local {lh[:12]}")
        return 6
    log(f"pulled {a.remote} -> {a.local} (sha256 {lh[:12]})")
    return 0


SEND_SCRIPT = r'''set -u
cd {parent} || exit 6
pkill -f "[r]unpodctl send {base}$" || true
rm -f {base}.zip {jobs}/send-{base}.log
mkdir -p {jobs}
(setsid nohup runpodctl send {base} > {jobs}/send-{base}.log 2>&1 < /dev/null &)
echo started
'''


def cmd_pull_dir(pod: Pod, a) -> int:
    parent, base = os.path.dirname(a.remote.rstrip("/")), os.path.basename(a.remote.rstrip("/"))
    if not re.fullmatch(r"[A-Za-z0-9_.-]+", base) or base in (".", ".."):
        log("pull-dir: the remote directory's name must be letters, digits, _ . - only")
        return 2
    target = os.path.join(a.local_parent, base)
    if os.path.exists(target) and not a.replace:
        log(f"{target} exists; not touching it (--replace moves it aside once the new copy is verified)")
        return 6
    listing = pod.ssh(f"cd {shlex.quote(a.remote)} && find . -type f ! -path './.cache/*' -printf '%P %s\\n'").stdout
    expect = {p: int(s) for p, s in (ln.rsplit(" ", 1) for ln in listing.splitlines() if ln.strip())}
    if not expect:
        log(f"remote dir {a.remote} is empty or missing")
        return 6
    os.makedirs(a.local_parent, exist_ok=True)
    for attempt in range(1, 4):
        pod.ssh(SEND_SCRIPT.format(parent=shlex.quote(parent), base=base, jobs=JOBS))
        code = ""
        for _ in range(240):   # the code is printed before the zip exists; the room opens at "Sending '" (H38)
            out = pod.ssh(f"cat {JOBS}/send-{base}.log 2>/dev/null").stdout
            if "Sending '" in out:
                m = re.search(r"\b\d{4}(?:-[a-z]+){3}(?:-\d+)?\b", out)
                code = m.group(0) if m else ""
                break
            time.sleep(15)
        if not code:
            log("sender never opened its room")
            continue
        # receive into a fresh directory of our own: nothing that already exists locally is touched until the
        # new copy is complete and verified
        stage = os.path.join(a.local_parent, f".podjob-recv-{base}-{time.strftime('%Y%m%dT%H%M%S')}")
        os.makedirs(stage)
        try:
            r = subprocess.run(["runpodctl", "receive", code], cwd=stage, capture_output=True, text=True,
                               timeout=7200)
            rc, err = r.returncode, (r.stderr or "")[-160:]
        except subprocess.TimeoutExpired:
            rc, err = 124, "receive did not finish within 2 h"
        got_dir = os.path.join(stage, base)
        got = {os.path.relpath(os.path.join(d, f), got_dir): os.path.getsize(os.path.join(d, f))
               for d, _, fs in os.walk(got_dir) for f in fs if ".cache" not in d} if os.path.isdir(got_dir) else {}
        missing = [p for p in expect if got.get(p) != expect[p]]
        if not missing:
            if os.path.exists(target):
                aside = f"{target}.old-{time.strftime('%Y%m%dT%H%M%S')}"
                os.rename(target, aside)
                log(f"moved the existing {target} aside to {aside}")
            os.rename(got_dir, target)
            shutil.rmtree(stage, ignore_errors=True)
            n = sum(expect.values())
            size = f"{n / 1e9:.1f} GB" if n >= 1e9 else f"{n / 1e6:.1f} MB"
            log(f"pulled {len(expect)} files ({size}) -> {target}, sizes verified")
            pod.ssh(f"rm -f {shlex.quote(parent)}/{base}.zip")
            return 0
        shutil.rmtree(stage, ignore_errors=True)
        log(f"receive attempt {attempt}: {len(missing)} files missing or wrong size (e.g. {missing[0]}); "
            f"rc={rc} {err}")
    return 6


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--host", required=True)
    ap.add_argument("--port", type=int, required=True)
    sub = ap.add_subparsers(dest="cmd_name", required=True)
    s = sub.add_parser("wait-ssh"); s.add_argument("--timeout", type=int, default=900)
    s = sub.add_parser("push"); s.add_argument("files", nargs="+"); s.add_argument("--dest", default="/workspace")
    s = sub.add_parser("run", help="run NAME [--cwd DIR] -- COMMAND...")
    s.add_argument("name"); s.add_argument("--cwd", default="/workspace")
    s = sub.add_parser("wait"); s.add_argument("run"); s.add_argument("--timeout", type=int, default=6 * 3600)
    s.add_argument("--poll", type=int, default=30); s.add_argument("--tail", type=int, default=15)
    s.add_argument("--max-unreachable", type=int, default=900, help="give up (exit 3) after this long unreachable")
    s = sub.add_parser("status"); s.add_argument("run")
    s = sub.add_parser("pull"); s.add_argument("remote"); s.add_argument("local")
    s = sub.add_parser("pull-dir"); s.add_argument("remote"); s.add_argument("local_parent")
    s.add_argument("--replace", action="store_true", help="move an existing local copy aside after verifying")
    argv = sys.argv[1:]
    job_cmd = argv[argv.index("--") + 1:] if "--" in argv else []   # everything after -- is the job's command
    argv = argv[:argv.index("--")] if "--" in argv else argv
    a = ap.parse_args(argv)
    a.cmd = job_cmd
    pod = Pod(a.host, a.port)
    fn = {"wait-ssh": cmd_wait_ssh, "push": cmd_push, "run": cmd_run, "wait": cmd_wait, "status": cmd_status,
          "pull": cmd_pull, "pull-dir": cmd_pull_dir}[a.cmd_name]
    try:
        return fn(pod, a)
    except ConnectionError as e:
        log(str(e))
        return 3


if __name__ == "__main__":
    sys.exit(main())
