# Prompt to Bench - common tasks. Run `make help`.
PY ?= .venv/bin/python

.PHONY: help venv test refs designs renders slice analyze bench-local bench-claude lang all

help:
	@echo "make venv          create .venv and install requirements"
	@echo "make test          robustness tests (fake model, real OpenSCAD; ~1 min)"
	@echo "make refs          validate the checker against the reference designs"
	@echo "make designs       render every design with defaults and edge-case parameters"
	@echo "make renders       render designs/ to figures/design_library.png"
	@echo "make slice         slice every design for a Prusa MK4 (needs PrusaSlicer)"
	@echo "make bench-local   run the main benchmark on local models (hours on a CPU)"
	@echo "make bench-claude  run the hosted Claude reference (needs Claude Code)"
	@echo "make lang          run the language ablation"
	@echo "make analyze       rebuild tables, figures and the README results"

venv:
	python3 -m venv .venv && .venv/bin/pip install -r requirements.txt

test:
	$(PY) bench/test_harness.py

refs:
	$(PY) bench/build_refs.py

designs:
	$(PY) tools/check_designs.py

renders:
	$(PY) tools/render_designs.py

slice:
	$(PY) tools/slice_library.py

bench-local:
	bash bench/run_main_local.sh

bench-claude:
	$(PY) bench/run_bench.py --run main-claude --models claude:claude-haiku-4-5 claude:claude-sonnet-5-5

lang:
	bash bench/run_lang.sh lang-claude claude:claude-haiku-4-5

analyze:
	$(PY) bench/analyze.py

all: test refs designs renders analyze
