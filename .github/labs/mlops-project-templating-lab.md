# Lab 2 - Reusable MLOps Project Templating

In this practical, you will build a reusable Python project template, generate a sample project with Cookiecutter, publish the template, then use Cruft to generate and update a second project. Jinja2 renders project-specific names and settings into each generated project.

## Objectives

By the end of this lab, you will be able to:

- explain the roles of Cookiecutter, Cruft, and Jinja2;
- create a Cookiecutter template with variables and hooks;
- generate a sample project from the template with Cookiecutter;
- generate a Cruft-managed project linked to the published template;
- update and validate projects after template changes;
- commit template and generated-project changes to Git.

## 1. Prerequisites

Complete Lab 1 and clone or open the `MLOps-Nanodegree` repository. Use a text editor to create and edit the template files.

The following tools are required:

- [Git](https://git-scm.com/)
- [GitHub CLI](https://cli.github.com/)
- [uv](https://docs.astral.sh/uv/)
- Python 3.11 or later

Verify the tools:

```bash
git --version
uv --version
python3 --version
gh --version
```

## 2. Install Cookiecutter and Cruft

Install <a href="https://cookiecutter.readthedocs.io/en/stable/index.html">Cookiecutter </a> and <a href="https://cruft.github.io/cruft/"> Cruft </a> as isolated command-line tools:

```bash
uv tool install cookiecutter
uv tool install cruft
```

Confirm that both commands are available:

```bash
cookiecutter --version
cruft --version
```

**Cookiecutter** creates projects for the first time. **Cruft** creates Cookiecutter projects and helps update projects that were generated from the same template.

## 3. Create the Template Repository

Create a separate directory for the template. Keep it separate from the `salaries_prediction` application repository so the template can be reused by other projects:

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
    │   └── workflows/
    │       └── tests.yml
    ├── .gitignore
    ├── src/
    │   └── {{cookiecutter.project_slug}}/
    │       ├── commons/
    │       │   └── __init__.py
    │       ├── io/
    │       │   └── __init__.py
    │       ├── job/
    │       │   └── __init__.py
    │       ├── __init__.py
    │       └── scripts.py
    ├── tests/
    │   ├── e2e_tests/
    │   │   └── .gitkeep
    │   ├── integration_tests/
    │   │   └── .gitkeep
    │   └── unit_tests/
    │       └── test_package_imports.py
    ├── Makefile
    ├── pyproject.toml
    └── README.md
```

The folder named `{{cookiecutter.project_slug}}` is the project template. Cookiecutter replaces that folder name and Jinja expressions inside its files with the values supplied during generation. Run the following commands from `~/templates/mlops-project-template`.

The post-generation hook creates the empty `data/`, `docs/`, `env/`, `notebooks/`, and `tasks/` directories in the generated project. Git does not preserve empty directories in the template repository.

## 4. Define Variables and Create Template Files

Create `cookiecutter.json` in the template root:

```bash
touch cookiecutter.json
```

Open `cookiecutter.json` in an editor and replace its contents with:

```json
{
  "project_name": "Salaries Prediction",
  "project_slug": "{{ cookiecutter.project_name.lower().replace(' ', '_').replace('-', '_') }}",
  "package_name": "{{ cookiecutter.project_slug }}",
  "author_name": "Your Name",
  "author_email": "your.email@example.com",
  "python_version": "3.11",
  "version": "0.1.0",
  "description": "Reusable MLOps project"
}
```

Cookiecutter prompts for `project_name`. It derives `project_slug` and `package_name` from the preceding values. Use the slug for directory names and Python imports; use the project name in user-facing text.

Create the directories and empty files in the template. The single quotes preserve the literal Jinja folder names; Cookiecutter renders those names when it generates a project.

```bash
mkdir -p hooks
mkdir -p '{{cookiecutter.project_slug}}/.github/workflows'
mkdir -p '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons'
mkdir -p '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/io'
mkdir -p '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/job'
mkdir -p '{{cookiecutter.project_slug}}/tests/unit_tests'
mkdir -p '{{cookiecutter.project_slug}}/tests/integration_tests'
mkdir -p '{{cookiecutter.project_slug}}/tests/e2e_tests'
touch '{{cookiecutter.project_slug}}/README.md'
touch '{{cookiecutter.project_slug}}/pyproject.toml'
touch '{{cookiecutter.project_slug}}/Makefile'
touch '{{cookiecutter.project_slug}}/.gitignore'
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/__init__.py'
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/scripts.py'
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons/__init__.py'
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/io/__init__.py'
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/job/__init__.py'
touch '{{cookiecutter.project_slug}}/tests/e2e_tests/.gitkeep'
touch '{{cookiecutter.project_slug}}/tests/integration_tests/.gitkeep'
touch '{{cookiecutter.project_slug}}/tests/unit_tests/test_package_imports.py'
```

Open `{{cookiecutter.project_slug}}/README.md` and add:

~~~markdown
# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

## Setup

```bash
uv sync --group test
uv run pytest
```

## Project

- Author: {{ cookiecutter.author_name }}
- Python: {{ cookiecutter.python_version }}
- Package: `{{ cookiecutter.package_name }}`
- Version: {{ cookiecutter.version }}
~~~

Open `{{cookiecutter.project_slug}}/pyproject.toml` and add:

```toml
[project]
name = "{{ cookiecutter.project_slug }}"
version = "{{ cookiecutter.version }}"
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

[build-system]
requires = ["uv_build>=0.11.8,<0.12.0"]
build-backend = "uv_build"

[tool.pytest.ini_options]
pythonpath = ["src"]
testpaths = ["tests"]
```

Open `{{cookiecutter.project_slug}}/.gitignore` and add:

```gitignore
.venv/
__pycache__/
*.py[cod]
.env
env/local.env
```

Open `{{cookiecutter.project_slug}}/tests/unit_tests/test_package_imports.py` and add a smoke test:

```python
def test_package_imports():
    import {{ cookiecutter.package_name }}
```

Add the GitHub Actions workflow shown in [Step 6](#6-add-a-github-actions-check) to `{{cookiecutter.project_slug}}/.github/workflows/tests.yml`.

## 5. Add Generation Hooks

Hooks run before or after project generation. The pre-generation hook rejects an invalid Python package name. The post-generation hook creates directories that do not need files in the template yet.

Create `hooks/pre_gen_project.py` in the template root and add:

```python
import re
import sys


project_slug = "{{ cookiecutter.project_slug }}"

if not re.fullmatch(r"^[a-z][a-z0-9_]*$", project_slug):
    print("ERROR: project_slug must contain only lowercase letters, numbers, and underscores.")
    sys.exit(1)
```

Create `hooks/post_gen_project.py` in the template root and add:

```python
from pathlib import Path


for directory in ("data", "docs", "env", "notebooks", "tasks", "tests"):
    Path(directory).mkdir(parents=True, exist_ok=True)

print("Template generation completed.")
```

Keep hooks small and avoid credentials or network access. Hooks execute on the user's machine, so generated output must be predictable and safe.

## 6. Add a GitHub Actions Check

Create `{{cookiecutter.project_slug}}/.github/workflows/tests.yml` and add:

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
      - run: uv sync --group test
      - run: uv run pytest
```

This workflow is copied into each generated project. The `test` dependency group is installed before pytest runs.

## 7. Generate a Project

First, test the template locally with Cookiecutter. This sample project is for checking the output; it is not linked to the template for future Cruft updates.

```bash
cd ~/templates
cookiecutter ./mlops-project-template
```

Enter a project name or accept the defaults. Cookiecutter creates a new directory using the generated `project_slug` (the default is `salaries_prediction`). With the default value, inspect the generated project with:

```bash
cd ~/templates/salaries_prediction
find . -maxdepth 3 -type f | sort
git status
```

If you chose a different slug, use that directory name instead.

Install the project's test dependencies and run its smoke test:

```bash
uv sync --group test
uv run pytest
```

Expected result: pytest collects `test_package_imports.py` and reports one passing test. If the generated files look correct, initialize Git and save this sample project:

```bash
git init
git add .
git -c user.name="Your Name" -c user.email="your.email@example.com" \
  commit -m "feat(project): generate sample from MLOps template"
```

Do not add real credentials to generated `env/` files. Keep only safe examples in Git and use a secret manager for actual secrets.

## 8. Manage the Template with Cruft

Cruft can apply template updates only when a template has been published and the generated project has Cruft metadata. Commit and publish the template first. Replace `YOUR_USERNAME` in the example URL with your GitHub account name:

```bash
cd ~/templates/mlops-project-template
git add .
git commit -m "feat(template): create reusable MLOps project template"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/mlops-project-template.git
git push -u origin main
```

From `~/templates`, generate a second project with Cruft. This is the project you will use for the update exercise:

```bash
cd ~/templates
cruft create https://github.com/YOUR_USERNAME/mlops-project-template.git
```

Enter `Salaries Prediction Cruft` for the project name so this project has a different slug from the Cookiecutter sample. The derived slug should be `salaries_prediction_cruft`. Change into that directory and confirm Cruft created `.cruft.json`:

```bash
cd ~/templates/salaries_prediction_cruft
test -f .cruft.json && echo "Cruft metadata found"
```

Cruft writes `.cruft.json` with the template URL, revision, and project context. Do not edit it manually. Keep this Cruft-generated project separate from the Cookiecutter sample project created in Step 7.

Initialize Git and commit the generated Cruft project before updating it:

```bash
git init
git add .
git -c user.name="Your Name" -c user.email="your.email@example.com" \
  commit -m "feat(project): generate Cruft-managed project"
```

## 9. Update the Template

Add a shared utility module to the template. In the template repository, create the file at `{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons/utils.py`:

```bash
touch '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons/utils.py'
```

Add this function to the file:

```python
def normalize_project_name(name: str) -> str:
    """Return a project name suitable for use as a Python package name."""
    return name.strip().lower().replace("-", "_").replace(" ", "_")
```

Append this test to `{{cookiecutter.project_slug}}/tests/unit_tests/test_package_imports.py`. Keep the existing package-import smoke test:

```python
from {{ cookiecutter.package_name }}.commons.utils import normalize_project_name


def test_normalize_project_name():
    assert normalize_project_name(" Salary Prediction ") == "salary_prediction"
```

Commit and push both template changes:

```bash
cd ~/templates/mlops-project-template
git add \
  '{{cookiecutter.project_slug}}/src/{{cookiecutter.project_slug}}/commons/utils.py' \
  '{{cookiecutter.project_slug}}/tests/unit_tests/test_package_imports.py'
git commit -m "feat(template): add project-name utility"
git push origin main
```

Switch back to the Cruft-generated project from Step 8 and check whether it is behind the template:

```bash
cd ~/templates/salaries_prediction_cruft
cruft check
```

If Cruft reports that the project is out of date, apply the new utility from the template:

```bash
cruft update
git diff
git status
```

Review the changes. If Cruft reports merge conflicts, resolve them in the generated project. Then run the tests and commit the template update:

```bash
uv sync --group test
uv run pytest
git add .
git -c user.name="Your Name" -c user.email="your.email@example.com" \
  commit -m "chore(template): apply project template updates"
```

## 10. Validate the Result

From the Cruft-generated project, run:

```bash
uv sync --group test
uv run pytest
cruft check
git status
```

The exercise is complete when both tests pass, `cruft check` reports the project is up to date, and `git status` shows a clean working tree after you commit the update.

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
