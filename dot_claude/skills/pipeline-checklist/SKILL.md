---
name: pipeline-checklist
description: Use when auditing, fixing, or reviewing CI/CD pipelines and GitHub Actions workflows across melvyndekort personal repos — checking Action version drift, Dependabot config, Codecov setup, pylint/ruff/terraform fmt gates, or Docker/GHCR pipeline steps. Also use when scaffolding a new repo's CI/CD to match existing conventions.
---

# CI/CD pipeline audit checklist

Use when asked to audit, fix, or scaffold CI/CD for a personal
(`melvyndekort`) repo.

## What to check

- **GitHub Actions versions are current and consistent** across repos:
  `checkout@v6`, `setup-terraform@v4`, `setup-uv@v7`, `docker/*@v4`/`@v7`,
  `fetch-metadata@v3.0.0` (Dependabot metadata action). Version drift between
  repos is a finding.
- **Dependabot config** uses the correct ecosystem per ecosystem present —
  `uv` (never `pip`) for Python, plus `docker`, `terraform`,
  `github-actions` — with correct directories.
- **Python pipelines** include: `pytest` with coverage, `pylint` (10/10, no
  silenced findings), Codecov upload.
- **Terraform pipelines** include: `fmt -check`, `init`, `validate`, `plan`
  (PR comment), `apply` (main push only).
- **Docker pipelines** include: QEMU + Buildx setup, build + push to GHCR.
- **`codecov.yml`** exists, target 80%, threshold 1%.
- **`SECURITY.md`** uses the standard template.
- **Makefile** has all required targets for the repo's category (see
  `~/.claude/CLAUDE.md` → Makefiles).
- **Secrets**: no hardcoded values, no decrypted files committed.
- **Lambda repos**: Terraform deploys dummy code + `ignore_changes` on
  `source_code_hash`; real code deploys via a separate CI/CD step — Terraform
  must never deploy Lambda code directly.

## How to audit across all personal repos

```
find ~/src/melvyndekort -path '*/.github/workflows/*.yml'
```
Compare workflow patterns across repos to spot drift. Verify pipeline health
with `gh run list` — use the `gh` CLI, not a GitHub MCP server (see
`~/.claude/CLAUDE.md` → Tooling for why).

## Workflow

1. **Audit** — scan for issues across repos.
2. **Report** — list all findings grouped by type.
3. **Fix** — apply fixes after confirmation.
4. **Verify** — check pipeline status after push (`gh run list`, `gh run
   view`).
