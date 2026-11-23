.PHONY: venv install-dep install-hooks update-hooks update-lockfile installers

# Defaults
VENV_NAME ?= .venv
GROUP ?= all


venv:
	@echo "Creating virtual environment: $(VENV_NAME)"
	uv venv $(VENV_NAME)
	@echo "Virtual environment created successfully!"



install-dep:
	@echo "Installing dependencies..."
ifeq ($(GROUP),all)
	@echo "Installing all dependency groups and extras..."
	uv sync --all-groups --all-extras
else
	@echo "Installing dependency group: $(GROUP)"
	uv sync --group $(GROUP)
endif
	@echo "Dependencies installed successfully!"


# Install the project commit hooks
# from default_install_hook_types in pre-commit-config.yaml
install-hooks:
	@uv run pre-commit install

# Updating all hooks in pre-commit-config.yaml
update-hooks:
	@uv run pre-commit autoupdate

# Update the project's uv lockfile
update-lockfile:
	uv lock

# Run all the installers.
installers: install-dep install-hooks update-hooks
