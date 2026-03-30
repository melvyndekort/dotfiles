# <REPO_NAME>

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

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
- `~/src/melvyndekort/network-documentation` — Complete home network documentation
- `~/src/melvyndekort/ignition` — Server provisioning (Fedora IoT)
