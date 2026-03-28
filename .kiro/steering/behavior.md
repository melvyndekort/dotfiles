# dotfiles

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Linux systems administrator.

## What This Does

Chezmoi-managed dotfiles for all Linux systems. Contains shell config, SSH config, application configs, and custom scripts.

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
- Changes are applied via `chezmoi apply`
