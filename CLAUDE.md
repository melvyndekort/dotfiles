# dotfiles

> For global standards, way-of-workings, and pre-commit checklist, see `~/.claude/CLAUDE.md`

## Role

Linux systems administrator.

## What This Does

Chezmoi-managed dotfiles for all Linux systems. Contains shell config, SSH config, application configs, and custom scripts. **This repo is dual-purpose**: personal-scoped for git/chezmoi hygiene, but its contents include a few work-specific scripts (e.g. `bin/granted-config.sh`, a Portbase AWS-SSO helper) that aren't personal config — don't "fix" or genericize those as if they were.

## Repository Structure

- `dot_config/` — `~/.config/` contents (application configs)
- `dot_ssh/` — `~/.ssh/` config (chezmoi-managed)
- `dot_profile`, `dot_zshenv`, `executable_dot_xprofile` — Shell environment
- `bin/` — Custom scripts
- `private_dot_gnupg/` — GPG configuration
- `private_dot_granted/` — Granted (AWS profile switcher) config
- `src/` — Maps to `~/src/` (currently just `melvyndekort/update-repos.sh`)
- `.chezmoiignore` — Keeps repo docs (`CLAUDE.md`, `SECURITY.md`) from being installed into `$HOME`
- `.chezmoi.toml.tmpl` — Chezmoi configuration template
- `.chezmoiexternal.toml` — External file downloads

## Important Notes

- No Terraform, no Python, no Makefile, no CI/CD pipeline
- Managed by `chezmoi` — files use chezmoi naming conventions (`dot_`, `private_`, `executable_`)
- Changes are applied via `chezmoi apply`. See `~/.claude/CLAUDE.md` → Dotfiles for the full workflow rule (edit source, apply, never unscoped `--force`).
- The `starship` binary is **not** installed by chezmoi: on Linux it comes from the `cli` role in `~/src/melvyndekort/systemsetup` (pinned release + enforced sha256, `--tags starship`); on macOS via brew. This repo only carries `dot_config/starship.toml` and the `$+commands[starship]`-guarded init in `dot_config/zsh/dot_zshrc.tmpl`.
- chezmoi is pinned by systemsetup (`roles/workstation/tasks/chezmoi.yml`). 2.27.0 had no `archive-file` external type and silently ignored `checksum` on archive externals; 2.73.1+ supports `archive-file` and rejects a wrong sha256 (both verified). Don't use externals for verified binary installs on a machine still running <2.73.
- `dot_config/yazi/yazi.toml` open rules carry both `name` and `url` so the same config parses on yazi 0.3.x and 26.x. Drop `name` once no machine runs 0.3.x.
