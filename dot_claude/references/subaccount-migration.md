# AWS subaccount migration plan

Boy-scout basis: don't do this as a big-bang project. When you're already
touching one of the repos below for something else, check whether it's time
to also migrate it out of the management account. Investigated 2026-09-08 —
re-verify resource lists with `grep -rhoE '^resource "[a-z_]+"'` on the
repo's `terraform/*.tf` before relying on this if it's been a while.

## Stays in management (`075673041815`) — not migration candidates

These are shared/cross-account plumbing, not isolated workloads. Moving them
adds re-pointing work for zero isolation gain.

| Repo | Why |
|---|---|
| `tf-aws` | Is the org/management layer itself |
| `tf-github` | Cross-account by nature — assumes roles into every subaccount |
| `tf-cloudflare` | Zero AWS resources; outputs feed 7+ repos |
| `tf-cognito` | Shared user pool — consumed by `get-cookies`, `tf-cloudflare` (Zero Trust), `tf-grafana` (SSO) |
| `tf-grafana` | Same shared-service shape |
| `tf-backup` | Issues B2/IAM backup credentials `homelab` consumes centrally |
| `tf-cloudtrail` | See gap below — also inherently account-scoped, not per-workload |
| `assets`, `cheatsheets`, `melvyn-dev`, `homelab` | Despite `aws_account` in `tf-github/repositories.yaml`, these create **zero `aws_*` resources** (pure Cloudflare Pages/Zero Trust). The field only controls Terraform state location + OIDC scope, not real infra placement. Not real candidates. |
| `aws-ntfy-alerts` | Lambda+SNS, role-based (no static keys already). Low isolation value; it's the alerting system, may want visibility into management-account events. Explicitly **not recommended** to move. |

## ⚠️ Prerequisite gap: CloudTrail doesn't cover subaccounts

`tf-cloudtrail`'s trail has `is_multi_region_trail = true` but **no
`is_organization_trail`** — it only audits the account it's deployed in
(management). `network-monitor`'s existing subaccount (`844347863910`)
already has **zero CloudTrail coverage**. Every new subaccount from this
plan will too, unless fixed first: either convert to an org trail (deployed/
delegated from the org management account) or bootstrap a per-account trail
alongside each new subaccount's OIDC bootstrap phase. Worth doing before or
alongside migration #1, not after all four.

## Migration candidates, in priority order

### 1. `minecraft-server` → own new subaccount
ECS + EFS + security groups (real running cost). Discord bot holds a static
IAM access key with account-wide standing (unavoidable — bot runs outside
AWS, can't assume a role) — isolating it bounds what that key can reach if
leaked.

### 2. `email-infra` → own new subaccount
SES (sending reputation/abuse risk) + Lambda. **4 separate static-cred IAM
users**: `gmail-melvyn`, `gmail-karin` (SMTP relay for personal Gmail),
`calibre`, `spotweb` (third-party apps sending via SES). All external
non-AWS clients that can't use OIDC — same rationale as #1, higher count of
standing credentials so higher priority.

### 3. `get-cookies` → own new subaccount
Lambda + API Gateway, JWT→CloudFront-signed-cookie exchange. Already
consumes `tf-cognito` cross-account via remote state, so splitting it out
follows an existing pattern (no new cross-account wiring style needed).

### 4. `example.melvyn.dev` + `startpage` → one shared new "static-web" subaccount
CloudFront + S3 + ACM, no IAM users, already low blast radius (OAI, no
static creds). Consolidate these two into **one** subaccount rather than
one each — not worth two bootstraps for near-zero incremental risk
reduction between them.

## Net result

4 new subaccounts (`minecraft-server`, `email-infra`, `get-cookies`,
`static-web`) → 5 non-management accounts total + management, up from just
`network-monitor` today. Each follows the standard 3-phase bootstrap in
`terraform-cross-repo`'s skill doc (same as the `network-monitor` reference
implementation): `tf-aws` account creation → `tf-aws` accounts/<name> OIDC +
AdminRole → `tf-github` per-repo role.

## When you touch one of these repos

1. Check this file for whether it's a migration candidate and its priority.
2. If yes and you have appetite for it right now: follow the 3-phase
   bootstrap, referencing `tf-aws/accounts/network-monitor/` as the
   template.
3. Update this file's table (strike through / move to a "done" section)
   once a repo is migrated, so the plan doesn't go stale.
4. If it's a shared-service repo in the "stays in management" table, don't
   suggest migrating it — the reasoning above still applies unless the
   dependency shape has changed.
