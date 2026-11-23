# CHECKERS
.PHONY: check-quality check-format checkers check-precommit

# Check the project code quality with ruff.
check-quality:
	uv run ruff --config pyproject.toml check src/ tests/

# Check the project source format with ruff.
check-format:
	uv run ruff format --config pyproject.toml --check src/ tests/


# Check the project code types with mypy
check-types:
	uv run mypy --no-namespace-packages src/ tests/

# Check the project code security with bandit
check-security:
	uv run bandit --recursive --configfile=pyproject.toml src/


# Run all the checkers
checkers: check-types check-format check-quality check-security #check-coverage
