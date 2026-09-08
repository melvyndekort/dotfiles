# Global Context

I'm Melvyn de Kort, a DevOps engineer. My work is split across assistants:
**work-related things go through Kiro; everything personal comes to Claude
(you)**. This file is the global, cross-project steering for that personal
side. As of 2026-09-08, Kiro's config has been fully stripped of the personal
content that used to live there (agents, steering, templates, MCP servers) —
this file and `~/.claude/references/`, `~/.claude/templates/` are the sole
source of truth now, nothing to fall back to in `~/.kiro/` anymore.

## Scope split

| Scope | Paths | Assistant |
|---|---|---|
| **Personal** (yours) | `~/src/melvyndekort/**`, `~/Sync/obsidian/Tech/**` | Claude (me) |
| **Work** | Everything else, especially other repos under `~/src/` not owned by `melvyndekort` | Kiro |

- If a request touches a path under `~/src/melvyndekort/` or `~/Sync/obsidian/Tech/`,
  it's mine to own — apply the standards below.
- If a path clearly isn't in those trees, treat it as work and out of scope: say so
  rather than guessing at conventions, and suggest Kiro if relevant.
- If scope is ambiguous (e.g. a new directory, nothing under `~/src/` yet), ask.

## Working principles (apply everywhere)

1. **Read before responding.** Before answering about any repo/doc, read its
   README, Makefile/config, and relevant source — don't rely on general knowledge
   or a stale mental model from earlier in the conversation.
2. **No assumptions.** Ask, or verify by reading, rather than guessing.
3. **Be critical and honest.** Push back if something looks wrong — a stale doc,
   a bad approach, a security gap. Don't just agree.
4. **Verify before suggesting changes.** Read current state before proposing edits.

---

## Personal ecosystem (`~/src/melvyndekort/`, `~/Sync/obsidian/Tech/`)

~30 GitHub repos under `melvyndekort`, covering homelab infrastructure, AWS,
Python apps, Terraform, and static sites, plus the homelab documentation vault
at `~/Sync/obsidian/Tech/Homelab/` (an Obsidian vault, **not** a git repo — see
its own `CLAUDE.md`). Repos are cloned via `update-repos.sh`.

### Repository catalog

**Terraform (central services, mostly account `075673041815`):**
`tf-aws` (org/accounts/IAM/OIDC bootstrap), `tf-github` (repo mgmt, per-repo OIDC),
`tf-cloudflare` (DNS/Zero Trust/tunnels), `tf-grafana` (dashboards), `tf-backup`
(B2 + S3 backup infra), `tf-cloudtrail` (audit logging), `tf-cognito` (auth).

**Python — containerized → GHCR (run on homelab Docker):**
`scheduler`, `image-refresher`, `internal-dns-sync`, `router-events`, `secrets-sync`.

**Python — Lambda (account `075673041815`):**
`aws-ntfy-alerts`, `get-cookies`, `email-infra`.

**Static sites (S3/Cloudflare Pages/GitHub Pages):**
`startpage`, `cheatsheets`, `assets`, `example.melvyn.dev`, `melvyn-dev`,
`melvyndekort.github.io`.

**Homelab & infra:**
`homelab` (Docker Compose stacks + Terraform cloudflared + SOPS secrets),
`ignition` (Butane/Ignition, Fedora IoT), `systemsetup` (Ansible),
`network-monitor` (serverless monitoring, its own subaccount `844347863910`),
`dotfiles` (chezmoi).

**Special:** `minecraft-server` (ECS + Discord bot), `password-store` (pass),
`dracula-hugo-theme`.

New projects get their own AWS subaccount (pattern: `network-monitor`); existing
repos in `075673041815` are migrated to subaccounts over time.

### Engineering standards (all personal repos, before every commit)

- **Tests mandatory**, ≥80% coverage. Run before committing.
- **Pylint 10/10** on Python — fix findings, never silence them.
- **Ruff** (`ruff check` + `ruff format --check`) on Python.
- **`terraform fmt`** on all Terraform.
- **Dependencies current** — pip/uv, TF providers, GitHub Actions, Docker base
  images, npm — bump before committing.
- Python: `uv` + `hatchling`, `pytest`+`pytest-cov`, `pyproject.toml` only (no
  `setup.py`/`requirements.txt`), dev deps under `[project.optional-dependencies]`.
- Terraform: S3 backend (`mdekort-tfstate-<account-id>`), `use_lockfile = true`,
  `~> 1.10` constraint, secrets via AWS KMS Makefile targets or SOPS+age (homelab).
- Docker: multi-stage (base→build→runtime), `uv` for deps, Alpine preferred,
  `org.opencontainers.image.source` label, pushed to `ghcr.io/melvyndekort/<name>`.
  GHCR-hosted images require the repo to be **public**.
- GitHub Actions: OIDC via `aws-actions/configure-aws-credentials` (no static
  keys), region `eu-west-1`, Dependabot auto-approves patch/minor.
- Lambdas: Terraform creates them with placeholder code + `ignore_changes` on
  `source_code_hash`; a separate CI/CD pipeline deploys real code.
- Every repo has a `Makefile` with standardized targets (`.PHONY`); see
  `~/.claude/templates/` for the per-project-type target lists if scaffolding new repos.

### Home network / homelab

- Network `10.204.0.0/16`, VLAN-segmented, domain `mdekort.nl`.
- Router: MikroTik RB4011iGS+ (`ssh melvyn@10.204.50.1`).
- Servers: `pihole-1` (DNS, podman as root), `compute-1` (Docker+Portainer),
  `storage-1` (Docker+Portainer Agent).
- Deploys go through **Portainer webhooks** triggered by GitHub Actions push —
  never `docker compose up` directly on the hosts.
- Secrets: SOPS+age for homelab (age key in `pass show homelab/age-key`); AWS
  KMS (`alias/generic`) elsewhere.
- Full topology/service docs: `~/Sync/obsidian/Tech/Homelab/` — read `planning/`
  before `infrastructure/`, it can be more current. See that folder's own
  `CLAUDE.md` for the detailed structure.

### Dotfiles

Managed via [chezmoi](https://www.chezmoi.io/), source at
`~/.local/share/chezmoi`, repo `dotfiles`. When editing config under `~`
(e.g. `~/.bashrc`, `~/.config/i3/config`), run `chezmoi add <target>` to sync
back to source, then commit/push from `~/.local/share/chezmoi`.

### Tooling

- **GitHub: use the `gh` CLI, not a GitHub MCP server.** `gh` is installed and
  already authenticated via the OS keyring — no container, no separate PAT to
  maintain or rotate. This was a deliberate choice (2026-09-08) when
  finishing the Kiro/Claude split: Kiro had a `github` MCP server (podman +
  a `pass`-stored PAT); it was retired rather than ported. Don't re-add one
  without a concrete reason `gh`/`gh api` can't cover.
- **MCP servers available:** `homeassistant` (HTTP, home automation at
  compute-1) and `portainer` (stdio, container management) — both ported
  from Kiro's config, registered at user scope. No CLI equivalent for either.
- New-repo scaffolding workflow: `~/.claude/references/new-repo-workflow.md`
- CI/CD audit checklist: `~/.claude/references/pipeline-checklist.md`
- Repo-type `CLAUDE.md` scaffolds for new repos: `~/.claude/templates/`

### Response style

Concise, direct, actionable. Bullet points over prose. Explain reasoning behind
recommendations. Don't sugarcoat — say plainly when something's wrong.

---

## Work (out of scope for me)

Anything outside `~/src/melvyndekort/` and `~/Sync/obsidian/Tech/` is presumed
work-related and belongs to Kiro, not me. Don't apply the personal standards
above to it, and don't assume I have context on it — ask or say it's out of
scope rather than guessing.
