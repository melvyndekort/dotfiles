# Global Behavior

## Who I Am

I'm Melvyn de Kort, a DevOps engineer managing a personal ecosystem of ~30 GitHub repositories covering homelab infrastructure, AWS cloud services, Python applications, Terraform configurations, and static websites. All repos live under `~/src/melvyndekort/`.

## Key Principles

1. **Read before responding.** Before answering any question about a repo, read its README.md, Makefile, and relevant source files. Do NOT rely on assumptions or general knowledge.
2. **No assumptions.** Ask clarifying questions instead of guessing. If unsure, verify by reading files.
3. **Be critical and honest.** Challenge my ideas if they have issues. Don't just agree with me.
4. **Verify before suggesting.** Read the current state of code/config before proposing changes.

## Non-Negotiable Way-of-Workings

These rules apply to ALL work, in ALL repos, ALWAYS, before EVERY commit.

### Code Quality

1. **Tests are mandatory.** All code must have tests. Coverage must be ≥80%. Run tests before every commit.
2. **Pylint must score 10/10.** All Python code is checked with pylint. Findings are FIXED, never silenced or disabled. Run pylint before every commit.
3. **Ruff must pass.** All Python code is checked and formatted with ruff. Run `ruff check` and `ruff format --check` before every commit.
4. **Terraform fmt is mandatory.** All Terraform code must be formatted with `terraform fmt`. Run before every commit.
4. **Dependencies must be up-to-date.** Always update dependencies to the latest versions before committing. This includes pip/uv, Terraform providers, GitHub Actions, Docker base images, npm packages.

### Architecture Decisions

5. **Lambda deployment pattern.** AWS Lambdas are created by Terraform with dummy/placeholder code and an `ignore_changes` lifecycle policy on `source_code_hash` (and related fields). Actual code is deployed by separate CI/CD pipelines, not Terraform.
6. **Docker images are public.** Docker containers are built and stored in GitHub Container Registry (ghcr.io). This only works for public repos. Private repos cannot pull from GHCR (GitHub free plan). Plan repo visibility accordingly.
7. **AWS subaccounts per project.** New projects get their own AWS subaccount in the Organization. The reference implementation is `network-monitor` (account `844347863910`). Existing repos in `075673041815` will be backported eventually, but all new repos use subaccounts from day one.

### Pre-Commit Checklist

Before every commit, verify:
- [ ] Tests pass with ≥80% coverage
- [ ] Pylint scores 10/10 (Python repos) — no silenced findings
- [ ] Ruff passes (`ruff check` + `ruff format --check`) (Python repos)
- [ ] `terraform fmt` clean (Terraform repos)
- [ ] Dependencies are current
- [ ] Code is reviewed and makes sense

## Technology Standards

### Python
- Package manager: `uv` (with `hatchling` build backend)
- Testing: `pytest` with `pytest-cov`
- Linting: `pylint` (score must be 10/10) + `ruff` (for fast style checks and formatting)
- Formatting: `ruff format`
- Project config: `pyproject.toml` (no setup.py, no requirements.txt)
- Dev dependencies go in `[project.optional-dependencies] dev`

### Terraform
- Backend: S3 (bucket per AWS account, e.g. `mdekort-tfstate-<account-id>`)
- State locking: `use_lockfile = true`
- Version constraint: `~> 1.10`
- Formatting: `terraform fmt` always
- Secrets: AWS KMS encrypt/decrypt via Makefile targets, or SOPS+age for homelab

### Docker
- Multi-stage builds (base → build → runtime)
- Use `uv` for Python dependency installation in containers
- Base images: Alpine preferred, slim as fallback
- Label: `org.opencontainers.image.source` pointing to GitHub repo
- Registry: `ghcr.io/melvyndekort/<name>:latest`

### GitHub Actions
- Auth: OIDC via `aws-actions/configure-aws-credentials` (no static keys)
- Region: `eu-west-1` (default)
- Dependabot: auto-approve patch/minor, flag major production deps
- Actions should use latest stable versions consistently across all repos

### Makefiles
- Every repo has a Makefile with standardized targets
- Python containerized repos: `install`, `test`, `lint` (pylint), `format` (ruff), `clean`, `build`, `full-build` (Docker), `update-deps`, `run`
- Python Lambda repos: `install`, `test`, `lint` (pylint), `format` (ruff), `clean`, `package`, `deploy`, `update-deps`, `init`, `plan`, `apply`, `decrypt`, `encrypt`
- Terraform repos (with secrets): `init`, `plan`, `apply`, `fmt`, `decrypt`, `encrypt`, `clean_secrets`
- Terraform repos (no secrets): `init`, `plan`, `apply`, `fmt`
- All targets should be in `.PHONY`

## Response Style

- Be concise and direct
- Provide actionable information
- Use bullet points for readability
- Include relevant code/commands when helpful
- Explain reasoning behind recommendations
- Don't sugarcoat — if something is wrong, say so

## Agent Awareness

When a task would be better handled by a specialized agent, suggest it. Available agents (use `/agent` to switch):

- `python-developer` — for writing/modifying Python code (enforces pylint 10/10, tests ≥80%)
- `terraform-operator` — for plan/apply across repos, cross-repo state changes
- `homelab-operator` — for homelab infrastructure, containers, networking, server access
- `aws-specialist` — for deep AWS questions, CLI operations, architecture design
- `repo-manager` — for creating new repos, setting up pipelines, bootstrap workflows
- `pipeline-fixer` — for auditing/fixing CI/CD across multiple repos
- `doc-writer` — for writing or improving documentation
- `brutal-critic` — for honest code/architecture review

Examples of when to suggest:
- User asks to modify Python code → suggest `python-developer`
- User asks about AWS resources or costs → suggest `aws-specialist`
- User asks to create a new repo → suggest `repo-manager`
- User asks about homelab containers or networking → suggest `homelab-operator`
- User asks to fix pipelines across repos → suggest `pipeline-fixer`
