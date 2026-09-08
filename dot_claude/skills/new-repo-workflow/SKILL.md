---
name: new-repo-workflow
description: Use whenever creating a new personal GitHub repo under melvyndekort, or when asked to scaffold a repo, bootstrap a project, set up a new Terraform/Python/Lambda/static-site repo, or add a repo to tf-github. Covers the Terraform-based repo creation workflow (never `gh repo create`), AWS subaccount decisions, and the standard files every new repo needs.
---

# Creating a new personal repo

Applies to any new repo under `melvyndekort` on GitHub.

## Repository creation workflow

ALL repositories are created via Terraform in `~/src/melvyndekort/tf-github`.
**Never use `gh repo create`.**

1. Determine if the project needs AWS — if yes, create a dedicated subaccount
   first (`tf-aws`).
2. Determine visibility — if Docker images are needed, the repo MUST be
   public (GHCR only works on the GitHub free plan for public repos).
3. Add the repository to `terraform/repositories.yaml`.
4. Add an AWS OIDC role to `terraform/github-oidc-roles.tf` (if AWS needed).
5. Add secret lookups to `terraform/repositories.tf` (if secrets needed).
6. Run `terraform plan` and `apply`.
7. Clone and initialize the local repository.
8. Detect project type and create all standard files.
9. Check `~/.claude/references/mcp-catalog.md` against what the repo
   actually touches (Cloudflare DNS/Pages/Tunnel, Grafana dashboards, the
   MariaDB instance, Portainer-managed stacks) and suggest adding any
   matching project-scoped MCP server — don't add one speculatively, ask
   first.

## Standard files for every new repo

- `CLAUDE.md` (from `~/.claude/templates/<category>.md`)
- `.github/dependabot.yml` (use `uv` ecosystem, not `pip`, for Python repos)
- `.github/workflows/dependabot.yml` (auto-approve patch/minor)
- `.github/workflows/` (project-specific pipelines — see the
  `pipeline-checklist` skill for what each pipeline type needs)
- `Makefile` with standard targets
- `SECURITY.md` (standard template)
- `LICENSE` (MIT)
- `README.md`
- `codecov.yml` (Python repos, target 80%)

## Project type detection

- Terraform: `terraform/` directory
- Python/uv: `pyproject.toml` + `uv.lock`
- Node.js: `package.json`
- Docker: `Dockerfile`
- Multi-component: `docker/` with multiple Dockerfiles

## Way-of-workings baked into every new repo

- Python: pylint must score 10/10 (CI + Makefile), pytest with ≥80% coverage
- Terraform: `terraform fmt` enforced, `required_version ~> 1.10`
- Lambda: dummy code in Terraform with `ignore_changes`, separate deploy
  pipeline (see `~/.claude/CLAUDE.md`)
- Dependencies: Dependabot with correct ecosystems (uv, docker, terraform,
  github-actions)
- Actions: latest stable versions (checkout@v6, setup-terraform@v4,
  setup-uv@v7, etc.)

## Process

1. Ask: public or private?
2. Ask: project type(s)?
3. Ask: needs AWS? If yes, new subaccount.
4. Find 2-3 similar existing repos as reference.
5. Check `~/.claude/references/mcp-catalog.md` for a matching MCP server.
6. Show the plan.
7. Execute after confirmation.

The same MCP-catalog check applies later too, not just at creation — if an
*existing* repo's scope changes (e.g. it starts managing Cloudflare DNS, or
gets a Grafana dashboard), suggest adding the matching project-scoped
server then, the same way.

## Never

- Use `gh repo create`
- Create workflows without checking existing repos first
- Hardcode values that should be secrets
- Skip the three-file Terraform secret configuration (repositories.yaml,
  github-oidc-roles.tf, repositories.tf)
- Use the `pip` ecosystem in Dependabot (use `uv`)
- Create a repo without a `CLAUDE.md`
