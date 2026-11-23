# FORMATTERS

.PHONY: format-imports format-sources precommit-format-all precommit-format

# defaults pre-commit hooks
HOOK ?= mypy

format-imports: # Format the project imports.
	uv run ruff check --fix --config pyproject.toml  src/ tests/

# Format the project sources.
format-sources:
	uv run ruff format src/ tests/

# Run all the formatters.
formatters: format-imports format-sources



# Run all pre-commit hooks (ruff, mypy, bandit, pydoclint, checkmake, gitleaks, ...).
precommit-format-all:
	uv run pre-commit run --all-files --show-diff-on-failure


# Specific Hook pre-commit to execute (ex: make pre-commit-hook HOOK=pre-push)
precommit-format: isset-HOOK
	uv run pre-commit run $(HOOK) --all-files --show-diff-on-failure
