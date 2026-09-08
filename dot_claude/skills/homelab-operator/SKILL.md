---
name: homelab-operator
description: Use when diagnosing homelab container or service issues, checking container status/logs, SSHing into pihole-1/compute-1/storage-1, managing SOPS-encrypted secrets, or making changes to Docker Compose stacks in ~/src/melvyndekort/homelab. Also use when asked to deploy, restart, troubleshoot, or check the health of a homelab service.
---

# Homelab operations

Read `~/Sync/obsidian/Tech/Homelab/` (`planning/` before `infrastructure/`)
first for current topology/service state before diagnosing anything —
this skill is the *procedure*, that vault is the *current facts*.

## Servers and their container runtime

- `pihole-1` — DNS. Podman containers running **as root** — use sudo.
- `compute-1` — Portainer runs as podman (root/systemd); every other
  container runs in Docker (use sudo).
- `storage-1` — Portainer Agent runs as podman (root/systemd); every other
  container runs in Docker (use sudo).
- SSH config: `~/.ssh/config` (should already have host aliases set up).

## Diagnostic commands

```
ssh <host> docker ps
ssh <host> docker logs <container>
ssh <host> podman ps
ssh <host> podman logs <container>
ssh <host> systemctl status <unit>
```

Remember which runtime each host/container actually uses (see above) before
picking `docker` vs `podman` — guessing wrong just wastes a round trip.

## Deploying — do NOT run `docker compose up` on the hosts

Stack files deploy through **Portainer**, triggered by a GitHub Actions
webhook on push to the `homelab` repo. If a stack needs to change:

1. Edit the compose file in `~/src/melvyndekort/homelab`.
2. Commit and push.
3. The GitHub Actions workflow triggers the Portainer webhook, which
   redeploys the stack.

Never deploy directly with `docker compose`/`podman compose` on the host —
it'll drift from what's in git and get silently overwritten on the next
push anyway.

## Secrets

SOPS + age. Age key: `pass show homelab/age-key`. Encrypted env files live
in `secrets/` in the `homelab` repo. **Never commit decrypted secrets** —
check `make secrets-list` (or equivalent Makefile target) before assuming
what's available, rather than guessing at variable names.

## Before making changes

Always read the relevant stack file *and* its README in `homelab` before
editing — compose files reference secrets, networks, and volumes defined
elsewhere in the repo that aren't obvious from the file alone.
