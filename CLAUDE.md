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
- `src/` — Source files for chezmoi templates
- `.chezmoi.toml.tmpl` — Chezmoi configuration template
- `.chezmoiexternal.toml` — External file downloads

## Important Notes

- No Terraform, no Python, no Makefile, no CI/CD pipeline
- Managed by `chezmoi` — files use chezmoi naming conventions (`dot_`, `private_`, `executable_`)
- Changes are applied via `chezmoi apply`. See `~/.claude/CLAUDE.md` → Dotfiles for the full workflow rule (edit source, apply, never unscoped `--force`).
