# <REPO_NAME>

> For global standards, way-of-workings, and pre-commit checklist, see `~/.claude/CLAUDE.md`

## Role

Networking specialist, DevOps engineer, and homelab enthusiast.

## Repository Structure

<!-- CUSTOMIZE -->

## Server Access Notes

- `pihole-1` — podman containers running as root, use sudo
- `compute-1` — Portainer as podman (root/systemd), all other containers in Docker (use sudo)
- `storage-1` — Portainer Agent as podman (root/systemd), all other containers in Docker (use sudo)
- SSH config: `~/.ssh/config`

## Deploying

- Stack files deploy through Portainer, NOT directly via Docker/docker-compose
- GitHub Actions workflows trigger Portainer webhooks to refresh stacks

## Related Repositories

<!-- CUSTOMIZE -->

- `~/src/melvyndekort/homelab` — Docker Compose stacks, Terraform, DNS, secrets
- `~/Sync/obsidian/Tech/Homelab` — Complete home network documentation (Obsidian vault, not a git repo)
- `~/src/melvyndekort/ignition` — Server provisioning (Fedora IoT)
