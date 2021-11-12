SCRIPT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL=help
.PHONY: help
help:  ## help for this Makefile
	@grep -E '^[a-zA-Z0-9_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

mypy:  ## mypy duck_cache.py
	@mypy --follow-imports=skip --ignore-missing-imports \
		--check-untyped-defs $(SCRIPT_DIR)/python/duck_cache.py

pytest:  ## pytest presto-api.py
	@pytest $(SCRIPT_DIR)/python/test_duck_cache.py

.PHONY: black
black:  ## black Python formatter
	@black -l 79 $(SCRIPT_DIR)/python

.PHONY: pytype
pytype:  ## pytype type checker
	@pytype $(SCRIPT_DIR)/python

.PHONY: pyright
pyright:  ## pyright type checker
	PYTHONPATH=python:${PYTHONPATH} pyright -v $(pipenv --venv) $(SCRIPT_DIR)/python

yapf:  ## yapf -i presto-api.py
	@yapf -r -i $(SCRIPT_DIR)/python

flake8:  ## flake8 presto-api.py
	@flake8 $(SCRIPT_DIR)/python

run:  ## run duck_cache.py
	@python $(SCRIPT_DIR)/python/duck_cache.py

.PHONY: clean
clean:  ## remove targets and intermediate files
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} \;
	find . -type d -name ".pytype" -exec rm -rf {} \;
