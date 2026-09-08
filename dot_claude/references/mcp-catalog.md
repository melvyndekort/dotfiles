# Project-scoped MCP servers

Ported from Kiro's per-repo `.kiro/settings/mcp.json` files (2026-09-08) —
that source of truth is gone now that those files are deleted, so this is
the only record of what's configured where and how to reconnect it.
Registered via `claude mcp add -s project ...` (writes `.mcp.json` at the
repo root; needs a one-time approval the first time Claude Code opens that
project).

Checked 2026-09-08: none of these have a competing CLI already installed on
this machine (`wrangler`/`flarectl`/`cloudflared`, `grafana-cli`,
`mysql`/`mariadb`, `portainer-cli` all absent) — see
`~/.claude/CLAUDE.md` → Tooling for the general principle. Re-check before
assuming that's still true.

## `cloudflare`

HTTP, hosted OAuth MCP (no `pass` secret — first use in a repo needs a
one-time browser auth). DNS, tunnels, Zero Trust, Pages.

**Repos:** `email-infra`, `homelab`, `melvyn-dev`, `minecraft-server`,
`tf-aws`, `tf-cloudflare`, `tf-cognito`

```
claude mcp add -s project --transport http cloudflare https://mcp.cloudflare.com/mcp
```

**Suggest adding** when a repo gets Cloudflare DNS records, a Pages
project, a Tunnel, or Zero Trust/Access policies.

## `grafana`

Stdio, `pass grafana/mcp-token`. Dashboards, data sources, alerts on
Grafana Cloud (`mdekort.grafana.net`).

**Repos:** `email-infra`, `network-monitor`, `tf-grafana`

```
claude mcp add -s project grafana -- bash -c 'GRAFANA_URL=https://mdekort.grafana.net GRAFANA_SERVICE_ACCOUNT_TOKEN=$(pass grafana/mcp-token) exec uvx mcp-grafana --disable-oncall --disable-incident --disable-sift --disable-asserts --disable-pyroscope --disable-admin'
```

**Suggest adding** when a repo gets Grafana dashboards, alerts, or metrics
export.

## `mysql`

Stdio, `pass mariadb/mcp-user` + `mariadb/mcp-password`. MariaDB at
`compute-1.mdekort.nl:3306`.

**Repos:** `homelab`, `router-events`

```
claude mcp add -s project mysql -- bash -c 'MYSQL_HOST=compute-1.mdekort.nl MYSQL_PORT=3306 MYSQL_USER=$(pass mariadb/mcp-user) MYSQL_PASSWORD=$(pass mariadb/mcp-password) MYSQL_DATABASE=information_schema exec uvx --from mysql-mcp-server mysql_mcp_server'
```

**Suggest adding** when a repo reads/writes that MariaDB instance directly.

## `portainer`

Stdio, `pass portainer/api-token`. Container/stack management on
`portainer.mdekort.nl`.

**Repos:** `homelab`, `network-monitor`

```
claude mcp add -s project portainer -- bash -c 'exec /home/melvyn/.local/bin/portainer-mcp -server portainer.mdekort.nl -token $(pass portainer/api-token) -disable-version-check -tools /tmp/portainer-tools.yaml'
```

**Suggest adding** when a repo's containers/stacks are managed through
Portainer directly (most homelab-deployed repos just get redeployed via the
webhook — see the `homelab-operator` skill — and don't need this).

## `homeassistant` — global, not project-scoped

The one deliberate exception: HTTP, `pass homeassistant/mcp-token`, already
registered at user scope (`~/.claude.json`), not per-repo. Home automation
isn't tied to a specific repo, matching Kiro's own original design.
