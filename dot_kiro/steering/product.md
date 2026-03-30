# Product Context

## Ecosystem Overview

Personal infrastructure ecosystem of ~30 GitHub repositories managed by Melvyn de Kort (`melvyndekort`). All repos are cloned to `~/src/melvyndekort/` and managed via `update-repos.sh`.

## Repository Catalog

### Terraform Infrastructure (Central Services)

| Repo | Purpose | AWS Account |
|------|---------|-------------|
| `tf-aws` | AWS Organization, accounts, IAM, OIDC bootstrap | 075673041815 (management) |
| `tf-github` | GitHub repo management, per-repo OIDC roles, secrets | 075673041815 |
| `tf-cloudflare` | Cloudflare DNS, Zero Trust, tunnels, API tokens | 075673041815 |
| `tf-grafana` | Grafana Cloud dashboards and data sources | 075673041815 |
| `tf-backup` | Backblaze B2 + AWS S3 backup infrastructure | 075673041815 |
| `tf-cloudtrail` | AWS CloudTrail audit logging | 075673041815 |
| `tf-cognito` | AWS Cognito authentication | 075673041815 |

### Python Applications (Containerized → GHCR)

| Repo | Purpose | Runs On |
|------|---------|---------|
| `scheduler` | Scheduled jobs with web UI (Flask + APScheduler) | Homelab (Docker) |
| `image-refresher` | Auto-updates Docker images on host | Homelab (Docker) |
| `internal-dns-sync` | Syncs DNS entries to PiHole via API | Homelab (Docker) |
| `router-events` | FastAPI service for RouterOS DHCP events | Homelab (Docker) |
| `secrets-sync` | Syncs and decrypts SOPS secrets from Git | Homelab (Docker) |

### Python Applications (Lambda)

| Repo | Purpose | AWS Account |
|------|---------|-------------|
| `aws-ntfy-alerts` | Forwards SNS notifications to ntfy | 075673041815 |
| `get-cookies` | Converts JWT tokens to CloudFront signed cookies | 075673041815 |
| `email-infra` | DMARC collection, email health checks, MTA-STS | 075673041815 |

### Static Sites

| Repo | Purpose | Hosting |
|------|---------|---------|
| `startpage` | Personal browser startpage (Hugo) | S3 via Terraform |
| `cheatsheets` | Linux desktop cheatsheets | S3 via Terraform |
| `assets` | Static resources site | S3 via Terraform |
| `example.melvyn.dev` | Example static website | S3 + CloudFront |
| `melvyn-dev` | Personal CV website (Hugo) | Cloudflare Pages |
| `melvyndekort.github.io` | Blog (Jekyll) | GitHub Pages |

### Homelab & Infrastructure

| Repo | Purpose |
|------|---------|
| `homelab` | Docker Compose stacks for compute-1 and storage-1, Terraform for cloudflared, SOPS secrets, DNS config |
| `network-documentation` | Complete home network documentation (topology, VLANs, services, migration plans) |
| `ignition` | Butane/Ignition configs for Fedora IoT server provisioning |
| `systemsetup` | Ansible playbooks for Linux system configuration |
| `network-monitor` | Serverless network device monitoring (Lambda + DynamoDB + Vector) |
| `dotfiles` | Chezmoi-managed dotfiles |

### Special

| Repo | Purpose |
|------|---------|
| `minecraft-server` | Minecraft on AWS ECS with Discord bot, DNS updater, idle watcher |
| `password-store` | GPG-encrypted password store (pass) |
| `dracula-hugo-theme` | Custom Hugo theme |

## AWS Organization Structure

```
Management Account (075673041815)
├── State bucket: mdekort-tfstate-075673041815
├── KMS key: alias/generic (for secrets encryption)
├── IAM user: melvyn (local dev access via awsume)
├── YubikeyRole (MFA-protected admin access)
├── OIDC providers for GitHub Actions
└── Subaccounts:
    └── network-monitor (844347863910)
        ├── State bucket: mdekort-tfstate-844347863910
        ├── AdminRole (assumable from management)
        ├── github-actions-tf-github role
        └── github-actions-network-monitor role
```

### Subaccount Bootstrap Chain (3 phases)

1. **tf-aws management** → creates AWS account via Organizations + state bucket
2. **tf-aws accounts/<name>** → bootstraps OIDC provider, AdminRole, tf-github role (via OrganizationAccountAccessRole)
3. **tf-github** → creates per-repo OIDC roles, sets AWS_ROLE_ARN secret on GitHub repo

New projects follow this pattern. Existing repos in 075673041815 will be migrated eventually.

## Cross-Repo Dependencies

### Terraform Remote State Chain

```
tf-cloudflare → provides API tokens to:
  ├── assets, cheatsheets, startpage, melvyn-dev, example.melvyn.dev
  ├── email-infra, homelab, network-monitor
  └── tf-github (for Cloudflare secrets distribution)

tf-grafana → provides Grafana tokens to:
  └── email-infra

tf-aws → provides account info to:
  └── tf-github (OIDC provider ARNs, role ARNs)

tf-backup → provides B2 keys to:
  └── homelab (via Makefile fetch-remote-secrets)
```

### Secrets Flow

- **AWS KMS** (most repos): Makefile `encrypt`/`decrypt` targets using `alias/generic` key with per-repo encryption context
- **SOPS + age** (homelab): Encrypted env files in `secrets/` directory, age key stored in `pass`
- **Terraform remote state**: Cross-repo secret sharing (Cloudflare tokens, Grafana tokens, B2 keys)
- **GitHub Actions secrets**: Set by tf-github from repositories.yaml config

### CI/CD Patterns

- **Terraform repos**: fmt → init → validate → plan (PR comment) → apply (main push)
- **Python container repos**: uv install → pytest+coverage → Codecov → Docker build+push to GHCR
- **Python Lambda repos**: uv install → pytest+coverage → Codecov (code deploy is separate from Terraform)
- **Static site repos**: build → deploy to S3 or Cloudflare Pages
- **Homelab**: push to main → GitHub Actions triggers Portainer webhook → stack redeployed

### Deployment Targets

- **AWS Lambda**: aws-ntfy-alerts, get-cookies, email-infra, network-monitor (4 lambdas)
- **GHCR containers → Homelab Docker**: scheduler, image-refresher, internal-dns-sync, router-events, secrets-sync
- **GHCR containers → AWS ECS**: minecraft-server (3 components)
- **S3 static hosting**: startpage, cheatsheets, assets, example.melvyn.dev, network-monitor (UI)
- **Cloudflare Pages**: melvyn-dev
- **GitHub Pages**: melvyndekort.github.io
- **Portainer stacks**: homelab (compute-1 and storage-1)

## Home Network

- Network: 10.204.0.0/16 with VLAN segmentation
- Router: MikroTik (ssh melvyn@10.204.50.1)
- DNS: PiHole (pihole-1, podman containers)
- Servers: compute-1 (Docker + Portainer), storage-1 (Docker + Portainer Agent)
- Provisioning: Fedora IoT via Ignition/Butane configs
- Monitoring: Grafana Cloud + network-monitor (serverless)
- Reverse proxy: Traefik via Cloudflare Tunnel
