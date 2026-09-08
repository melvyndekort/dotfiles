---
name: terraform-cross-repo
description: Use when running terraform plan/apply across melvyndekort personal repos, doing AWS CLI operations or troubleshooting, creating a new AWS subaccount, changing a Terraform output that other repos consume, or investigating cross-repo Terraform state dependencies. Also use for AWS architecture questions, cost considerations, or anything touching the personal AWS Organization (management account, subaccounts, OIDC).
---

# Terraform & AWS across personal repos

Melvyn's Terraform is split across many small repos with real state
dependencies between them — this is the operational judgment that doesn't
fit in a per-repo `CLAUDE.md`.

## Remote state dependency chain

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

Before changing an `output` in any of these repos, check who consumes it —
a rename or type change breaks the downstream `terraform plan` silently
until someone runs it.

## AWS subaccount bootstrap (3 phases)

1. **`tf-aws` management** — creates the AWS account via Organizations +
   its state bucket.
2. **`tf-aws` accounts/<name>** — bootstraps the OIDC provider, `AdminRole`,
   and `tf-github` role (via `OrganizationAccountAccessRole`).
3. **`tf-github`** — creates per-repo OIDC roles, sets the `AWS_ROLE_ARN`
   secret on the GitHub repo.

New projects get a dedicated subaccount from day one (reference:
`network-monitor`, account `844347863910`). Existing repos still in the
management account (`075673041815`) get migrated to subaccounts over time,
not proactively.

## AWS facts

- Management account: `075673041815`. Region: `eu-west-1` (default).
- Auth: OIDC for CI/CD, `awsume` for local dev, `YubikeyRole` for
  MFA-protected admin access. **No static access keys, ever.**
- State: S3 backend per account, `mdekort-tfstate-<account-id>`,
  `use_lockfile = true`, `~> 1.10` version constraint.
- Secrets: KMS `alias/generic` with per-repo encryption context, via
  Makefile `encrypt`/`decrypt` targets (or SOPS+age for `homelab` — see the
  `homelab-operator` skill).

## Operating rules

- **Always `plan` before `apply`.** Never apply blind, even for
  "trivial" changes.
- **Warn about cross-repo impact** before changing an output — check the
  dependency chain above first.
- State operations (`import`, `mv`, `rm`) need real caution — confirm
  before running, and explain what could go wrong if the state and reality
  diverge.
- **Require confirmation for destructive operations** (`destroy`,
  `state rm`) — never run these on your own judgment call.
- **Never commit decrypted secrets.**
- For AWS CLI: read-only operations (`describe-*`, `list-*`, `get-*`,
  `sts get-caller-identity`) are fine to run freely. Warn before anything
  destructive, and flag cost implications when relevant (e.g. spinning up
  anything non-trivial, changing instance sizes, enabling expensive
  services).
