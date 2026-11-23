# Lab 2 - Reusable MLOps Project Templating

In this practical, you turn the `salaries_prediction` project into a reusable MLOps template. You will use Cookiecutter to generate projects, Jinja2 to render project-specific values, and Cruft to keep projects synchronized with template updates.

## Objectives

By the end of this lab, you will be able to:

- explain the roles of Cookiecutter, Cruft, and Jinja2;
- create a Cookiecutter template with variables and hooks;
- generate a new MLOps project from the template;
- link an existing project to a template with Cruft;
- update and validate projects after template changes;
- commit template and generated-project changes to Git.

## 1. Prerequisites

Complete Lab 1 and clone or open the `MLOps-Nanodegree` repository.

The following tools are required:

- [Git](https://git-scm.com/)
- [GitHub CLI](https://cli.github.com/)
- [uv](https://docs.astral.sh/uv/)
- Python 3.11 or later

Verify the tools:

```bash
git --version
uv --version
python --version
```

## 2. Install Cookiecutter and Cruft

Install Cookiecutter and Cruft as isolated command-line tools:

```bash
uv tool install cookiecutter
uv tool install cruft
```

Confirm that both commands are available:

```bash
cookiecutter --version
cruft --version
```

Cookiecutter creates projects for the first time. Cruft creates Cookiecutter projects and helps update projects that were generated from the same template.

## 3. Create the Template Repository

Create a separate directory for the template and leave the existing salary-prediction repository unchanged while scaffolding it:

```bash
mkdir -p ~/templates
cd ~/templates
mkdir -p mlops-project-template
cd mlops-project-template
git init
```

The template repository must follow Cookiecutter's directory convention:

```text
mlops-project-template/
├── cookiecutter.json
├── hooks/
│   ├── post_gen_project.py
│   └── pre_gen_project.py
└── {{cookiecutter.project_slug}}/
    ├── .github/
    ├── docs/
    ├── env/
    ├── notebooks/
    ├── src/
    │   └── {{cookiecutter.project_slug}}/
    │       ├── commons/
    │       ├── io/
    │       └── job/
    ├── tasks/
    ├── tests/
    ├── Makefile
    ├── pyproject.toml
    └── README.md
```

The `{{cookiecutter.project_slug}}` directory and every Jinja expression inside it are rendered when Cookiecutter generates a project.

## 4. Define Template Variables

Create `cookiecutter.json` in the template root:

```json
{
  "project_name": "Salaries Prediction",
  "project_slug": "{{ cookiecutter.project_name.lower().replace(' ', '_').replace('-', '_') }}",
  "package_name": "{{ cookiecutter.project_slug }}",
  "author_name": "Your Name",
  "author_email": "your.email@example.com",
  "python_version": "3.11",
  "description": "Reusable MLOps project"
}
```

The first prompt uses `project_name`. Cookiecutter derives `project_slug` automatically. Use `project_slug` for directory names and import paths, and use `project_name` for human-readable content.

Create a simple template `README.md`:

~~~markdown
# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

## Setup

```bash
uv sync
uv run pytest
```

## Project

- Author: {{ cookiecutter.author_name }}
- Python: {{ cookiecutter.python_version }}
- Package: `{{ cookiecutter.package_name }}`
~~~

Create `pyproject.toml` with Jinja values:

```toml
[project]
name = "{{ cookiecutter.project_slug }}"
version = "0.1.0"
description = "{{ cookiecutter.description }}"
readme = "README.md"
requires-python = ">={{ cookiecutter.python_version }}"
authors = [
    { name = "{{ cookiecutter.author_name }}", email = "{{ cookiecutter.author_email }}" }
]

[dependency-groups]
test = [
    "pytest>=9.2.0",
]

[tool.pytest.ini_options]
pythonpath = ["src"]
testpaths = ["tests"]
```

Create package directories and initialization files:

```bash
mkdir -p "{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}"/{commons,io,job}
mkdir -p "{{cookiecutter.project_slug}}"/{docs,env,notebooks,tasks,tests}
touch "{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/__init__.py"
touch "{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/scripts.py"
touch "{{cookiecutter.project_slug}}/tests/__init__.py"
```

## 5. Add Generation Hooks

Hooks run around project generation. A pre-generation hook validates variables, while a post-generation hook performs deterministic cleanup.

Create `hooks/pre_gen_project.py`:

```python
import re
import sys


project_slug = "{{ cookiecutter.project_slug }}"

if not re.fullmatch(r"^[a-z][a-z0-9_]*$", project_slug):
    print("ERROR: project_slug must contain only lowercase letters, numbers, and underscores.")
    sys.exit(1)
```

Create `hooks/post_gen_project.py`:

```python
from pathlib import Path


for directory in ("docs", "env", "notebooks", "tasks", "tests"):
    Path(directory).mkdir(parents=True, exist_ok=True)

print("Template generation completed.")
```

Keep hooks small and avoid credentials or network access. Hooks execute on the user's machine, so generated output must be predictable and safe.

## 6. Add a GitHub Actions Check

Add `{{cookiecutter.project_slug}}/.github/workflows/tests.yml`:

```yaml
name: Tests

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v7
        with:
          python-version: "{{ cookiecutter.python_version }}"
      - run: uv sync
      - run: uv run pytest
```

This workflow is rendered into each generated project and validates the project immediately after generation.

## 7. Generate a Project

Return to the parent template directory and generate a project locally:

```bash
cd ~/templates
cookiecutter ./mlops-project-template
```

Enter the project name and accept or override the other prompts. Then inspect the result:

```bash
cd <project_slug>
find . -maxdepth 3 -type f | sort
git status
```

Initialize Git only after verifying the generated files:

```bash
git init
git add .
git -c user.name="Your Name" -c user.email="your.email@example.com" \
  commit -m "feat(project): generate project from MLOps template"
```

Initialize and test the generated package:

```bash
uv init --package --name <project_slug>
uv sync
uv run pytest
```

Do not commit secrets in `env/*.env` files. Store secret names and example values only, and use the platform's secret manager for real credentials.

## 8. Manage the Template with Cruft

Publish the template repository to GitHub, replacing the URL below with your repository URL:

```bash
cd ~/templates/mlops-project-template
git add .
git commit -m "feat(template): create reusable MLOps project template"
git branch -M main
git remote add origin <YOUR_TEMPLATE_REPOSITORY_URL>
git push -u origin main
```

Create a project from the remote template with Cruft:

```bash
cd ~/templates
cruft create <YOUR_TEMPLATE_REPOSITORY_URL>
```

Cruft records the template URL and committed revision in `.cruft.json`:

```json
{
  "template": "<YOUR_TEMPLATE_REPOSITORY_URL>",
  "commit": "<TEMPLATE_COMMIT_HASH>",
  "checkout": null,
  "context": {
    "cookiecutter": {}
  }
}
```

Do not edit `.cruft.json` manually. It is generated metadata used for future comparisons.

## 9. Update the Template

Add or improve one small template feature, for example a shared utility module.

In `{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons/utils.py`, add:

```python
def normalize_project_name(name: str) -> str:
    """Return a project name suitable for use as a Python package name."""
    return name.strip().lower().replace("-", "_").replace(" ", "_")
```

Commit and push the template change:

```bash
cd ~/templates/mlops-project-template
git add .
git commit -m "feat(template): add project-name utility"
git push origin main
```

Inside a project created by Cruft, preview updates:

```bash
cd ~/templates/<generated-project>
cruft check
```

Apply approved updates:

```bash
cruft update
git diff
git status
```

Cruft may report merge conflicts when it cannot combine template changes with local edits. Resolve each conflict in the generated project, then verify and commit the result:

```bash
git add .
git -c user.name="Your Name" -c user.email="your.email@example.com" \
  commit -m "chore(template): apply project template updates"
```

## 10. Validate the Result

From a generated project, run:

```bash
git status
uv sync
uv run pytest
cruft check
```

The project is ready when it has a clean Git working tree, passes tests, and reports that it is in sync with the template revision used by Cruft.

## 11. Delivery Checklist

- [ ] Cookiecutter and Cruft are installed.
- [ ] `cookiecutter.json` contains project variables.
- [ ] Jinja2 renders the project name, package name, author, and Python version.
- [ ] Pre- and post-generation hooks execute successfully.
- [ ] A project is generated and initialized in Git.
- [ ] A `.cruft.json` file links the generated project to the template.
- [ ] The template update is applied with `cruft update`.
- [ ] Tests pass in the generated project.
- [ ] The template and generated project changes are committed.

## 12. Submit the Practical

Provide:

1. the URL of the template repository;
2. the URL of at least one project generated from it;
3. evidence that `cruft check` succeeds or that template updates were applied;
4. a short explanation of what Jinja2 renders and how Cruft performs updates.
