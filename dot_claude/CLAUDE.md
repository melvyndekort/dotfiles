# Global Context

I'm Melvyn de Kort, a DevOps engineer. My work is split across assistants:
**work-related things go through Kiro; everything personal comes to Claude
(you)**. This file is the global, cross-project steering for that personal
side. As of 2026-09-08, Kiro's config has been fully stripped of the personal
content that used to live there (agents, steering, templates, MCP servers) —
this file plus `~/.claude/references/`, `~/.claude/templates/`, and
`~/.claude/skills/` are the sole source of truth now, nothing to fall back to
in `~/.kiro/` anymore.

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

Full list with categories and AWS accounts:
`~/.claude/references/repo-catalog.md`. New projects get their own AWS
subaccount (pattern: `network-monitor`); existing repos in `075673041815`
are migrated to subaccounts over time.

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

Network `10.204.0.0/16`, domain `mdekort.nl`. Full topology, server, and
deploy details live in `~/Sync/obsidian/Tech/Homelab/CLAUDE.md` and its
`infrastructure/`/`planning/` docs — that file auto-loads whenever the
working directory is inside the vault, so it isn't duplicated here. One
thing worth keeping top-of-mind even outside that directory: secrets there
use SOPS+age (`pass show homelab/age-key`), and deploys go through
**Portainer webhooks**, never `docker compose up` directly on the hosts.

### Syncthing (`~/Sync`)

Everything under `~/Sync` (including `~/Sync/obsidian/Tech/`) is synced
across multiple personal devices via **Syncthing**, not git — a materially
different environment from the rest of the system:
- No git history/blame/revert here (confirmed: the Homelab vault itself
  isn't a git repo) — destructive edits are less recoverable than elsewhere.
- Another device can change a file between reads in the same session — don't
  assume exclusive access, especially across a long-running operation.
- Watch for Syncthing conflict files (`*.sync-conflict-<date>-<device>.*`) —
  if one shows up, flag it and ask rather than silently picking a side.

### Dotfiles

Managed via [chezmoi](https://www.chezmoi.io/), source at
`~/.local/share/chezmoi`, repo `dotfiles`, GPG-encrypted secrets via inline
`{{ pass "..." }}` template calls. **Rule: any change to a chezmoi-managed
path must be reflected in chezmoi, not just made live** — check first with
`chezmoi managed | grep <path>` if unsure whether something is tracked.

- For a managed path: either edit the source directly
  (`~/.local/share/chezmoi/dot_foo/...`) then `chezmoi apply`, or edit the
  live file then `chezmoi add <target>` to pull the change back into source.
  Either way, confirm `chezmoi status` is clean for that path before calling
  it done, then commit + push from `~/.local/share/chezmoi`.
- **Never run `chezmoi apply --force` unscoped.** It applies *every* pending
  change across all of `$HOME`, not just the path you're working on —
  learned the hard way (2026-09-08): an unscoped `--force` silently reverted
  unrelated local drift in `~/bin/granted-config.sh` and
  `~/.config/mimeapps.list`, since recovered. If `--force` is needed to skip
  a `/dev/tty` prompt, scope it: `chezmoi apply --force <specific-target>`.
- `~/.kiro` (Kiro config) and `~/.claude` (CLAUDE.md, settings.json,
  references/, templates/, skills/ — not credentials/sessions/cache/plugins)
  are both chezmoi-managed as of 2026-09-08.
- **This laptop is dual-purpose.** The `dotfiles` repo is personal-scoped
  (git/chezmoi hygiene here is mine to own), but its *contents* aren't all
  personal — e.g. `~/bin/granted-config.sh` is a work AWS-SSO helper for
  Portbase (`m.de.kort@portbase.com`, in `chezmoi.toml`'s `work`/`email`
  data). Don't "fix" or genericize work-flavored scripts/aliases found in
  here as if they were personal config — leave their content alone, only
  touch chezmoi mechanics (tracking, drift, sync).

### Secrets (`pass`)

Not an exhaustive list — just entries encountered so far. Check `pass ls`
(or `pass find <term>`) before assuming something doesn't exist rather than
asking.

| Entry | Used for |
|---|---|
| `homelab/age-key` | SOPS+age decryption key for `homelab` repo secrets |
| `homeassistant/mcp-token` | Bearer token for the `homeassistant` MCP server |
| `portainer/api-token` | Auth token for the `portainer` MCP server |
| `github/cli-token` | Orphaned — was used by Kiro's retired `github` MCP server; `gh` CLI auths via the OS keyring instead, not `pass` |

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
- Repo-type `CLAUDE.md` scaffolds for new repos: `~/.claude/templates/`
- Repo catalog: `~/.claude/references/repo-catalog.md`
- New-repo scaffolding and CI/CD-audit procedures are `new-repo-workflow`
  and `pipeline-checklist` **Skills** (`~/.claude/skills/`) — they trigger
  automatically on relevant requests, no need to go read them proactively.

### Response style

Concise, direct, actionable. Bullet points over prose. Explain reasoning behind
recommendations. Don't sugarcoat — say plainly when something's wrong.

---

## Work (out of scope for me)

Anything outside `~/src/melvyndekort/` and `~/Sync/obsidian/Tech/` is presumed
work-related and belongs to Kiro, not me. Don't apply the personal standards
above to it, and don't assume I have context on it — ask or say it's out of
scope rather than guessing.
