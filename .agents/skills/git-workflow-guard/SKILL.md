---
name: git-workflow-guard
description: Use for this repository whenever Codex handles Git operations, branches, commits, pushes, pull requests, release promotion, merge rules, collaborator permissions, default branch changes, branch protection, GitHub Actions quality gates, or repository workflow documentation.
---

# Git Workflow Guard

## Overview

Use this skill as the local guardrail for GitHub workflow work in
`raqamli-nazorat/raqamli-sovchi-mobile`. It keeps agent Git behavior aligned
with protected branches and the repository release path.

## Required Context

Before taking action, read:

- `AGENTS.md`
- `doc/GIT_WORKFLOW.md`
- `git status --short --branch`
- `git remote -v`

If changing code, architecture, dependencies, security, UI, or tests, also read
`doc/ARCHITECTURE_TECHNICAL_SPEC.md`.

## Branch Rules

- Treat `dev` as default base branch.
- Never push directly to `dev`, `prod`, or `main`.
- Create scoped work branches from `origin/dev` for normal work:
  `feature/*`, `fix/*`, or `chore/*`.
- Use `dev -> prod` only for release promotion.
- Use `prod -> main` only for production snapshot.
- Do not change branch protection, merge settings, default branch, or
  collaborator permissions unless the user explicitly asks.

## Local Workflow

1. Fetch remote state.
2. Confirm current branch and dirty files.
3. Preserve unrelated user changes.
4. Create or switch to a scoped branch before committing.
5. Stage only files in scope by explicit path.
6. Commit with a short imperative message.
7. Push the scoped branch.
8. Open PR to the correct base branch.

## PR Expectations

PRs must satisfy:

- `flutter-analyze`
- `flutter-format`
- `promotion-guard`
- 1 approval
- resolved conversations
- up-to-date branch

`flutter-test` is not a GitHub merge gate in this repository. Run local or
targeted tests when the change needs them, but do not require that job in branch
protection.

If CI is still running, report the run URL and current status instead of
claiming success.

## Safety Checks

- Run `git diff --check` before commit.
- Run relevant project checks when code changes.
- Use `gh` for GitHub settings verification when available.
- Report any protected-branch or permission blocker with exact command result.
- Do not merge PRs unless the user explicitly asks and the active GitHub account
  is `Nomonjon0124`.
