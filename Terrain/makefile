#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = TerrainExtractor
PYTHON_VERSION = 3.12
PYTHON_INTERPRETER = python

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Delete all compiled Python files
.PHONY: clean
clean:
		find . -type f -name "*.py[co]" -delete
		find . -type d -name "__pycache__" -delete


## Lint using ruff (use `make format` to do formatting)
.PHONY: lint
lint:
		ruff format --check
		ruff check

## Format source code with ruff
.PHONY: format
format:
		ruff check --fix
		ruff format


## Set up Python interpreter environment with conda
.PHONY: create_conda_env
create_conda_env:
		conda -V
		conda env create -f environment.yml

## Activate conda environment
.PHONY: activate_conda_env
activate_conda_env:
		conda activate terrainExtractor

## Render terrain
.PHONY: render
render:
		$(PYTHON_INTERPRETER) convert_asc.py


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available commands:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
		@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)