# Personal repo catalog

~30 GitHub repos under `melvyndekort`, cloned to `~/src/melvyndekort/` via
`update-repos.sh`.

**Terraform (central services, mostly account `075673041815`):**
`tf-aws` (org/accounts/IAM/OIDC bootstrap), `tf-github` (repo mgmt, per-repo OIDC),
`tf-cloudflare` (DNS/Zero Trust/tunnels), `tf-grafana` (dashboards), `tf-backup`
(B2 + S3 backup infra), `tf-cloudtrail` (audit logging), `tf-cognito` (auth).

**Python — containerized → GHCR (run on homelab Docker):**
`scheduler`, `image-refresher`, `internal-dns-sync`, `router-events`, `secrets-sync`.

**Python — Lambda (account `075673041815`):**
`aws-ntfy-alerts`, `get-cookies`, `email-infra`.

**Static sites (S3/Cloudflare Pages/GitHub Pages):**
`startpage`, `cheatsheets`, `assets`, `example.melvyn.dev`, `melvyn-dev`,
`melvyndekort.github.io`.

**Homelab & infra:**
`homelab` (Docker Compose stacks + Terraform cloudflared + SOPS secrets),
`ignition` (Butane/Ignition, Fedora IoT), `systemsetup` (Ansible),
`network-monitor` (serverless monitoring, its own subaccount `844347863910`),
`dotfiles` (chezmoi).

**Special:** `minecraft-server` (ECS + Discord bot), `password-store` (pass),
`dracula-hugo-theme`.

New projects get their own AWS subaccount (pattern: `network-monitor`); existing
repos in `075673041815` are migrated to subaccounts over time.
