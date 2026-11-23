# Lab 1 — Create a Git Repository for an MLOps Project

In this practical, you create and configure the Git repository used throughout the training series.

## Objectives

By the end of this lab, you will be able to:

- create and initialize a GitHub repository;
- clone and configure a local repository;
- initialize a structured Python package;
- stage, inspect, and commit selected changes;
- work with branches, remotes, issues, and Pull Requests;
- protect the default branch for team collaboration.

## 1. Prerequisites

-`Github`: An account on GitHub. To sign up, go to <a href="https://github.com/signup"> github.com </a>

- `uv`: An extremely fast **Python package and project manager.** uv manages project dependencies, packages and environments using the `pyproject.toml`file.

You can find installation here <a href="https://docs.astral.sh/uv/getting-started/installation/"> Install uv </a>

- `VS Code` Download Visual Studio Code. Free, built on open source, and runs everywhere. You can find installation here  <a href="https://code.visualstudio.com/download"> Install VS Code </a>

- `gh`: GitHub CLI brings GitHub to your terminal. gh is a command-line interface to GitHub for use in your terminal or your scripts. Free and open source, you can find installation here <a href="https://cli.github.com/"> install github cli </a>

- `git`: Git is a free and open source distributed version control system (VCS) designed to handle everything from small to very large projects with speed and efficiency. You can find installation here  <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"> Install Git </a>


### 1. Creating your first repository for your project on GitHub

A repository is where you keep code and files for a software project on GitHub. It stores your files, tracks each change as a commit, and gives collaborators a shared place to work. Setting up your project correctly is a critical first step.

**Follow these steps to create your first repository:**

1. In the upper-right corner of any GitHub page, select **+**, then click **New repository**.
2. In **Repository name**, enter `salaries_prediction`.
3. In **Description**, enter a short description such as `Hands-on MLOps Git and GitHub practical`.
4. Select **Public** in **Choose visibility**.
5. Select **Add README**.
6. Select **Add .gitignore** and choose **Python**.
7. Select **Add license** and choose **MIT License**.
8. Click **Create repository**.

### 2. Clone the remote repository to your local machine

- **Cloning with HTTPS URLs**

The https:// clone URLs are available on all repositories, regardless of visibility.  When you `git clone`, `git fetch`, `git pull`, or `git push` to a **private remote repository** using `HTTPS URLs` on the command line, Git will ask for your `GitHub username and password`. When Git prompts you for your password, enter your `personal access token (PAT)`. For more information, see <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens"> Managing your personal access tokens.</a>

Alternatively, you can use a credential helper like <a href="https://github.com/GitCredentialManager/git-credential-manager/blob/main/README.md"> Git Credential Manager.</a> You can use a credential helper so Git will remember your GitHub credentials every time it talks to GitHub. For more information, see <a href="https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git"> Caching your GitHub credentials in Git. </a>

Tip

- To clone a repository without authenticating to GitHub on the command line, you can use `GitHub Desktop` to clone instead. For more information, see <a href="https://docs.github.com/en/desktop/adding-and-cloning-repositories/cloning-a-repository-from-github-to-github-desktop"> Cloning a repository from GitHub to GitHub Desktop.</a>

- **Cloning with SSH URLs**

SSH URLs provide access to a Git repository via SSH, a secure protocol. To use these URLs, you must generate an **SSH keypair on your computer and add the public key to your account on GitHub**. For more information, <a href='https://docs.github.com/en/authentication/connecting-to-github-with-ssh'> see Connecting to GitHub with SSH. </a>

When you git clone, git fetch, git pull, or git push to a remote repository using `SSH URLs`, you'll be prompted for a password and

Tip

- You can use an `SSH URL` to **clone a repository to your computer**, or as a secure way of **deploying your code to production servers**.
- You can also use`SSH agent forwarding` with your **deploy script** to avoid managing keys on the server. For more information, see


- **Cloning with GitHub CLI**

GitHub CLI or gh, is a command-line interface to GitHub for use in your terminal or your scripts. For example you can use it to use `GitHub workflows` in your terminal. For more information, <a href='https://docs.github.com/en/github-cli/github-cli/about-github-cli'>> see About GitHub CLI </a> and <a href="https://cli.github.com/manual/">Github CLI manual</a>

On your local computer, type

```bash
   git clone <YOUR_GITHUB_REMOTE_URL>
```

Then go to

```bash
   cd salaries_prediction
```

Then, Run these commands to Check the Status of your files :

```bash
git status                # git-status - Show the working tree status
````

If you run `git status` command directly after a clone, you should see something like this:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

This means you have a clean working directory; in other words, none of your `tracked files` are modified. Git also doesn’t see any `untracked files`, or they would be listed here. Finally, the command tells you which branch you’re on and informs you that it has not diverged from the same branch on the server.

**References:**

- [Cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- [About remote repositories](https://docs.github.com/en/get-started/git-basics/about-remote-repositories)



### 3. Create the project structure

Complete this step from the terminal in the local clone of your GitHub repository. The goal is to organize the Python package, documentation, automation, and test files shown below.

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
├── LICENSE
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
│       ├── __init__.py
│       ├── commons/
│       ├── io/
│       ├── job/
│       └── scripts.py
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

#### 3.1.1 Initialize the Python Package

A <a href="https://packaging.python.org/en/latest/">Python package</a> is a structured collection of Python modules that can be easily `installed and shared`. **Packages** are the standard way to distribute **reusable code**.

In MLOps, The initialization phase establishes a standardized, scalable, and reproducible MLOps development environment. By standardizing your setup, you establish best practice to prevent `dependency conflicts`, `version mismatches` and `environment inconsistencies`. A well-configured setup ensures `smooth collaboration`, `reliable automation`, and `maintainable ML deployments`.

Make sure the terminal is inside your cloned repository. Then run:

```bash
uv init --python 3.11 --package --name salaries_prediction
```

This command creates `pyproject.toml` and the initial package under `src/salaries_prediction/`.

Run these commands to Check the Status of your files :

```bash
git status
```
you should see something like this:

```text
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
 .python-version
 pyproject.toml
 src/

nothing added to commit but untracked files present (use "git add" to track)
```

You can see that your new files are **untracked**, because it’s under the `Untracked files` heading in your status output. Untracked basically means that Git sees a file you didn’t have in the previous snapshot (commit), and which hasn’t yet been staged.


##### 3.1.2 Tracking a New File

To begin tracking these files, use `git add <filename>` for a specific file or `git add .` for all files.

Run these commands to begin tracking all files

```bash
git add .
```
Run these commands to Check the Status of your files :

```bash
git status
```

If you run your **git status** command again, you should see something like this:

```text
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
 new file:   .python-version
 new file:   pyproject.toml
 new file:   src/salaries_prediction/__init__.py
```

You can see that the files are **staged** because they appear under the `Changes to be committed` heading. Anything that remains `unstaged` will not be included in this commit. It will remain as a modified or untracked file in your working tree.

#### 3.1.3 Staging Modified Files
Before committing the staged files, change a tracked file. Open `pyproject.toml` and set the project description in the `[project]` section:

```toml
description = "Hands-on MLOps Git and GitHub practical"
```

```text
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
 new file:   .python-version
 new file:   pyproject.toml
 new file:   src/salaries_prediction/__init__.py

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
 modified:   pyproject.toml
```

The pyproject.toml file appears under a section named `Changes not staged for commit` — which means that a file that is tracked has been modified in the working directory but not yet staged. To stage it, you run the `git add` command.

#### 3.1.4 Viewing Your Staged and Unstaged Changes

To see what you’ve changed but not yet staged, type `git diff` with no other arguments:

```bash
git diff
```

That command compares what is in your working directory with what is in your staging area. The result tells you the changes you’ve made that you haven’t yet staged.

```text
diff --git a/pyproject.toml b/pyproject.toml
index 308cb22..76be0fa 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -1,7 +1,7 @@
 [project]
 name = "salaries-prediction"
 version = "0.1.0"
-description = "Add your description here"
+description = "Hands-on MLOps Git and GitHub practical"
```

The tracked this new change, type

```bash
git add pyproject.toml
```
you should see something like this

```text
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
 new file:   .python-version
 new file:   pyproject.toml
 new file:   src/salaries_prediction/__init__.py
```


#### 3.1.5 Committing Your Changes

Write a clear commit message

Use this format:

```text
<type>(<scope>): <imperative description>
```

| Element | Rule | Example |
| --- | --- | --- |
| `type` | Use a lowercase category that describes the change. | `feat`, `fix`, `docs` |
| `scope` | Optional, but useful when the change affects a specific area. | `readme`, `api`, `training` |
| `description` | Start with an imperative verb, such as `add`, `fix`, or `update`. | `add inference endpoint` |
| `subject length` | Keep it concise, ideally between 50 and 72 characters. | `docs(readme): update setup instructions` |
| `capitalization` | Capitalize only the first word when needed; do not use all capital letters. | `fix(api): validate request input` |
| `period` | Do not end the subject line with a period. | `test(api): add endpoint unit tests` |

#### 3.1.6 Choose the Commit Type

| Type | Use it when... | Example |
| --- | --- | --- |
| `feat` | Adding a new feature or capability. | `feat(api): add inference endpoint` |
| `fix` | Correcting a bug or error. | `fix(auth): resolve token validation` |
| `docs` | Changing documentation only. | `docs(readme): update setup guide` |
| `style` | Formatting code without changing behavior. | `style: apply Ruff formatting` |
| `refactor` | Improving code structure without changing behavior. | `refactor(core): simplify model loader` |
| `perf` | Improving speed or resource usage. | `perf(inference): optimize batch processing` |
| `test` | Adding or updating tests. | `test(api): add endpoint unit tests` |
| `build` | Changing the build system or dependencies. | `build: update uv dependencies` |
| `ci` | Changing CI/CD configuration. | `ci(github): add testing workflow` |
| `chore` | Performing maintenance that does not fit another category. | `chore: update development tooling` |
| `revert` | Reverting an earlier commit. | `revert: remove broken inference endpoint` |

#### 3.1.7 Create the Commit

Create one commit containing one logical change:

```bash
git commit -m "feat(project): initialize the Python package"
```

If the commit needs more explanation, add a body:

```bash
git commit -m "feat(project): initialize the Python package" \
  -m "Explain the required directories and add the purpose of each project file."
```

You have now created your first commit. The commit output identifies the branch, the new commit ID (SHA-1), the number of changed files, and the number of added and removed lines.

> **Staged versus unstaged**
>
> A commit records only the snapshot in the staging area. Files left unstaged remain modified in the working tree and can be included in a later commit. Run `git status` after every commit to verify exactly what Git will include next.

Every commit is a new snapshot that can be inspected, compared, or restored. Keep commits small and focused so the project history remains understandable.

#### 3.1.8 Commit Rules

| Rule | Correct example | Incorrect example |
| --- | --- | --- |
| Use an imperative description. | `add inference endpoint` | `added inference endpoint` |
| Use a lowercase commit type. | `docs(readme): update guide` | `Docs(readme): update guide` |
| Keep the subject concise. | `fix(api): validate request input` | `fix(api): update and fix all API request validation problems` |
| Do not end with a period. | `test(api): add unit tests` | `test(api): add unit tests.` |
| Commit one logical change. | One README update | README, API, and test changes in the same commit |
| Explain why in the body when it is not obvious. | `Fixes incorrect validation...` | Only `fix: update code` |
| Use `!` for a breaking change. | `feat(api)!: replace v1 endpoint` | `feat(api): replace v1 endpoint` |

#### 3.1.9 Recommended MLOps and LLMOps Scopes

| Scope | Area |
| --- | --- |
| `api` | REST API or FastAPI |
| `core` | Core application or shared business logic |
| `data` | Data processing and pipelines |
| `ml` | Machine learning |
| `dl` | Deep learning |
| `llm` | Large language models |
| `rag` | Retrieval-augmented generation |
| `agents` | AI agents |
| `training` | Model training |
| `inference` | Model prediction or generation |
| `evaluation` | Model and system evaluation |
| `monitoring` | Logs, metrics, and observability |
| `docker` | Containerization |
| `k8s` | Kubernetes |
| `github` | GitHub Actions and repository automation |
| `config` | Configuration files |
| `deps` | Dependencies |
| `security` | Security controls |

### 3.2 Create the Remaining Directories

Use `mkdir` to create directories:

```bash
mkdir -p .agents/skills
mkdir -p .github/actions/setup-venv .github/workflows
mkdir -p docs notebooks tasks env
mkdir -p src/salaries_prediction/io
mkdir -p src/salaries_prediction/job
mkdir -p src/salaries_prediction/commons
mkdir -p tests/integration_tests tests/unit_tests tests/e2e_tests
```

### 3.3 Create the Project Files

Create the automation, source, and test files:

```bash
touch .github/actions/setup-venv/action.yml
touch .github/workflows/checkers.yml
touch .github/workflows/deploy-to-dev.yml
touch .github/workflows/deploy-to-preprod.yml
touch .github/workflows/deploy-to-prod.yml
touch .github/workflows/tests.yml
touch .pre-commit-config.yaml AGENTS.md Makefile CONTRIBUTING.md
touch notebooks/experiments.ipynb
touch env/local.env env/dev.env env/preprod.env env/prod.env
touch src/salaries_prediction/__init__.py
touch src/salaries_prediction/scripts.py
touch src/salaries_prediction/io/__init__.py
touch src/salaries_prediction/io/writer.py
touch src/salaries_prediction/io/reader.py
touch src/salaries_prediction/io/base.py
touch src/salaries_prediction/commons/__init__.py
touch src/salaries_prediction/commons/utils.py
touch src/salaries_prediction/commons/constants.py
touch src/salaries_prediction/commons/exception.py
touch src/salaries_prediction/job/__init__.py
touch tasks/checkers.mk tasks/formatters.mk tasks/installers.mk
touch tasks/helpers.mk tasks/inits.mk
touch tests/integration_tests/__init__.py
touch tests/unit_tests/__init__.py
touch tests/e2e_tests/__init__.py
```

The `.gitignore`, `LICENSE`, `pyproject.toml`, and `README.md` files should already exist from repository setup and Python initialization.

### 3.4 Verify the Structure

Run the following command from the repository root:

```bash
tree .
```

If `tree` is unavailable, open the project in VS Code:

```bash
code .
```

Compare the result with the target structure. Create each missing item with `mkdir` or `touch`, then review and commit the completed structure:

```bash
git status
git diff
git add .
git commit -m "feat(project): add complete MLOps directory structure"
git log -1 --oneline
```

### 4.1 Work with GitHub Issues

| Convention | Purpose | Example |
| --- | --- | --- |
| `Refs: #123` | References an issue or pull request without closing it. | `Refs: #123` |
| `Closes: #123` | Automatically closes issue `123` when the commit is merged. | `Closes: #123` |
| `BREAKING CHANGE:` | Describes an incompatible change. | `BREAKING CHANGE: Remove the v1 API endpoint` |

### 4.2 Verify the Commit

```bash
git log -1 --oneline
git status
```

`git log -1 --oneline` displays the latest commit. `git status` confirms whether the working tree still contains unstaged or untracked changes.


```bash
uv run pre-commit install
```

## 5. Protect the Main Branch

In the GitHub repository, open **Settings > Branches** and add a branch protection rule for `main` or `master`. depend how you default branch is called
`
Require:

- a Pull Request before merging;
- at least one approving review;
- passing status checks;
- no direct pushes to `main` or `master`.

This setup protects the primary codebase and prepares the project for professional collaboration.

## 6. Optional Git File Operations

### Skip the staging area for tracked files

```bash
git commit -a -m "chore: update tracked project files"
```

This stages modified tracked files automatically. It does not stage new untracked files.

### Remove a file completely

```bash
git rm <filename>
git commit -m "chore: remove <filename>"
```

### Keep a file locally but stop tracking it

```bash
git rm --cached <filename>
git commit -m "chore: stop tracking <filename>"
```