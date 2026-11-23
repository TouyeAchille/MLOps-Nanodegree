# MLOps Foundations: Git and GitHub

This repository contains hands-on practical work for learning professional version-control workflows and reproducible MLOps project organization.

## Learning objectives

At the end of these practicals, students will be able to:

- create and clone a GitHub repository;
- initialize a structured Python package;
- use the working tree, staging area, and commit history;
- create, merge, and synchronize branches;
- use issues and Pull Requests for collaboration;
- protect a shared branch and use automated checks.

## Practicals

| Practical | Topic | Lab guide |
| --- | --- | --- |
| TP1 | Git, GitHub, branches, merges, and Pull Requests | [Git/GitHub collaboration lab](.github/labs/git-github-collaboration-lab.md) |
| TP2 | Cookiecutter, Cruft, Jinja2, and project scaffolding | `lab guide to be added` |

The numbered sections in TP1 should be completed in order:

1. Create a GitHub repository.
2. Clone the repository locally.
3. Initialize and organize the Python project.
4. Track and commit changes.
5. Create and merge branches.
6. Open a Pull Request and protect the main branch.

## Prerequisites

Before starting the practical, install and configure:

- a [GitHub account](https://github.com/signup);
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git);
- [GitHub CLI](https://cli.github.com/) (`gh`);
- [Visual Studio Code](https://code.visualstudio.com/);
- [uv](https://docs.astral.sh/uv/getting-started/installation/) for Python dependencies and environments.

Verify the installations:

```bash
git --version
gh --version
uv --version
code --version
```

Configure Git before your first commit:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Project structure

The target structure is a convention for reproducible MLOps work. It separates source code, tests, documentation, automation, notebooks, configuration, and environment-specific settings.

```text
.
├── .github/
│   ├── labs/
│   │   └── git-github-collaboration-lab.md
│   └── workflows/
├── .gitignore
├── .pre-commit-config.yaml
├── .python-version
├── AGENTS.md
├── Makefile
├── README.md
├── pyproject.toml
├── uv.lock
├── docs/
├── env/
│   ├── dev.env
│   ├── local.env
│   ├── preprod.env
│   └── prod.env
├── notebooks/
│   └── experiments.ipynb
├── src/
│   └── salaries_prediction/
│       ├── commons/
│       ├── io/
│       └── job/
├── tasks/
│   ├── checkers.mk
│   ├── formatters.mk
│   ├── helpers.mk
│   ├── installers.mk
│   └── inits.mk
└── tests/
    ├── e2e_tests/
    ├── integration_tests/
    └── unit_tests/
```

## Local setup

Run these commands after cloning the repository:

```bash
cd salaries_prediction
uv sync
git status
```

Keep the working tree clean whenever a practical step is completed. Review changes with `git diff`, stage intentional files with `git add`, and explain the resulting snapshot with `git commit`.

## Useful commands

| Goal | Command |
| --- | --- |
| Show the working-tree state | `git status` |
| Compare unstaged changes | `git diff` |
| Stage a file | `git add <file>` |
| Stage all changes | `git add .` |
| Commit staged changes | `git commit -m "docs(readme): add lab instructions"` |
| Show recent commits | `git log --oneline` |
| Create a branch | `git switch -c <branch-name>` |
| Switch branches | `git switch <branch-name>` |
| Push a branch | `git push -u origin <branch-name>` |
