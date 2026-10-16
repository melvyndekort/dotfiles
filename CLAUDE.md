# dotfiles

> For global standards, way-of-workings, and pre-commit checklist, see `~/.claude/CLAUDE.md`

## Role

Linux and macOS systems administrator.

## What This Does

Chezmoi-managed dotfiles for all Linux systems and the macOS MacBook. Contains shell config, SSH config, application configs, and custom scripts. **This repo is dual-purpose**: personal-scoped for git/chezmoi hygiene, but its contents include a few work-specific scripts (e.g. `bin/granted-config.sh`, a Portbase AWS-SSO helper) that aren't personal config — don't "fix" or genericize those as if they were.

## Repository Structure

- `dot_config/` — `~/.config/` contents (application configs)
- `dot_ssh/` — `~/.ssh/` config (chezmoi-managed)
- `dot_profile`, `dot_zshenv`, `executable_dot_xprofile` — Shell environment
- `bin/` — Custom scripts
- `private_dot_gnupg/` — GPG configuration
- `private_dot_granted/` — Granted (AWS profile switcher) config
- `src/` — Maps to `~/src/` (currently just `melvyndekort/update-repos.sh`)
- `.chezmoiignore` — Template. Keeps repo docs and `Brewfile` out of `$HOME`; on non-Linux it also drops the whole X11/WM desktop stack and the Linux-only `bin/` scripts
- `Brewfile` — macOS packages (public repo, so no secrets and nothing work-specific by name). Linux packages come from `~/src/melvyndekort/systemsetup`
- `.chezmoi.toml.tmpl` — Chezmoi configuration template
- `.chezmoiexternal.toml.tmpl` — External file downloads (the Openbox theme is Linux-only)

## Important Notes

- No Terraform, no Python, no Makefile, no CI/CD pipeline
- Managed by `chezmoi` — files use chezmoi naming conventions (`dot_`, `private_`, `executable_`)
- Changes are applied via `chezmoi apply`. See `~/.claude/CLAUDE.md` → Dotfiles for the full workflow rule (edit source, apply, never unscoped `--force`).
- `~/.claude` and `~/.kiro` are intentionally **not** managed by chezmoi: this repo is public, and that config (CLAUDE.md, skills, references, templates, settings, MCP config, agents) holds personal infrastructure details (account IDs, hostnames, family-member device info, secret paths). They stay live-only. Never `chezmoi add` anything from them.
- `~/.local/share/remmina` is not tracked either (connection profiles with internal and work hostnames). Don't `chezmoi add` it.
- The `starship` binary is **not** installed by chezmoi: on Linux it comes from the `cli` role in `~/src/melvyndekort/systemsetup` (pinned release + enforced sha256, `--tags starship`); on macOS via brew. This repo only carries `dot_config/starship.toml` and the `$+commands[starship]`-guarded init in `dot_config/zsh/dot_zshrc.tmpl`.
- chezmoi is pinned by systemsetup (`roles/workstation/tasks/chezmoi.yml`). 2.27.0 had no `archive-file` external type and silently ignored `checksum` on archive externals; 2.73.1+ supports `archive-file` and rejects a wrong sha256 (both verified). Don't use externals for verified binary installs on a machine still running <2.73.
- `dot_config/yazi/yazi.toml` open rules carry both `name` and `url` so the same config parses on yazi 0.3.x and 26.x. Drop `name` once no machine runs 0.3.x.

## macOS

One repo serves both OSes. Branch on `.chezmoi.os` (`linux` / `darwin`) inside templates and in `.chezmoiignore`; don't fork the repo. When a file needs an OS difference it becomes a `.tmpl`, and the Linux rendering must stay identical to before (check with `git show HEAD:<file> | chezmoi execute-template | diff - <(chezmoi execute-template < <file>.tmpl)`).

- **Bootstrap order** (the order matters: `git`'s `core.pager = delta` and the `gh` credential helper need the Brewfile packages, and every `encrypted_` file needs the GPG key):
  1. Xcode CLT, then Homebrew
  2. `brew install chezmoi`, then `chezmoi init melvyndekort/dotfiles` (no `--apply`). The init prompts are matched on their **full prompt text**, not the key, so use: `--promptString "What is your e-mail address=..." --promptBool "Is this a laptop (y/n)=true" --promptBool "Do you use this device for work (y/n)=true"`. Short keys like `work=true` are silently ignored and give `false`.
  3. `brew bundle install --file="$(chezmoi source-path)/Brewfile"`
  4. Import the GPG key and clone the `pass` store, then `chezmoi apply` (scoped, per the usual rule)
- On macOS `docker` is an alias for `podman` (zshrc); there is no docker CLI.
- `ssh` must be Homebrew's `openssh` (first in `PATH`): the `yubikey-*` keys are `sk-ssh-ed25519` and Apple's build has no FIDO support. The ssh `ControlPath` uses `%C` because macOS caps unix socket paths at 104 bytes.
- Known and deliberately untouched: `alias d` is defined twice in the zshrc (docker, then `kitten diff`; the latter wins); `zoxide` is in the Brewfile but not wired up (OMZ's `z` plugin is used).
- Untested on real macOS: everything here was verified by rendering templates with `.chezmoi.os` faked to `darwin`.
