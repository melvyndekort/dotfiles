---
name: daan-whitelist
description: Use when asked to allow, whitelist, or unblock a domain/site/app for Daan's Chromebook, or to check/investigate what's currently being blocked for it. Covers adding Pi-hole allow rules via the API and diagnosing whether something is a real block vs. a false alarm.
---

# Daan's Chromebook whitelist

Pi-hole default-deny allowlist for Daan's school Chromebook. Full design,
current threat model, and rule categories: see `parental-controls.md` in
`~/Sync/obsidian/Tech/Homelab/infrastructure/` — read it first if you
haven't already this session.

## Credentials

API passwords for both instances live in `pass`, never typed in chat:

```
PIHOLE1_PW=$(pass show pihole/pihole-1-api-password)
PIHOLE2_PW=$(pass show pihole/pihole-2-api-password)
```

Auth against each host (`pihole-1.mdekort.nl`, `pihole-2.mdekort.nl`) via
`POST /api/auth` with `{"password": "..."}`, use the returned `session.sid`
as the `sid` header on subsequent calls. **Always apply changes to both
instances** — pihole-2 is the VRRP backup and must stay in sync so the
policy survives a failover.

## Adding a domain

Group id is `4` (`Daan`). Choose the rule type:

- **Apex regex-allow** (`POST /api/domains/allow/regex`, domain pattern
  `(\.|^)<apex>$`) — for a domain that's entirely one single-purpose tool
  or vendor (a school site, an edu tool, a textbook publisher). Safe to
  allow the whole apex and all subdomains.
- **Exact-allow** (`POST /api/domains/allow/exact`, the literal hostname)
  — for a hostname under a shared multi-tenant platform (`google.com`,
  `googleapis.com`, `gstatic.com`, `googleusercontent.com`, `appspot.com`,
  `web.app`, `cloudfront.net`, etc.) where allowing the whole apex would
  open unrelated content too. Default to this when in doubt.

Both take `{"domain": ..., "comment": "Daan - <what/why>", "groups": [4]}`.

Skip pure ad/tracking/telemetry domains that aren't required for the page
to function (analytics beacons, ad networks, Chrome background pings) —
only add what's actually needed to unblock the thing being asked for.

## Checking current blocks / verifying a fix

Query `pihole-FTL.db` on pihole-1 directly (faster than the API for bulk
reads, read-only so no session cost):

```
ssh pihole-1 "sudo podman exec pihole pihole-FTL sqlite3 /etc/pihole/pihole-FTL.db \
  '.headers on' '.mode column' \
  \"SELECT domain, status, COUNT(*) cnt, MAX(datetime(timestamp,'unixepoch')) last_seen \
    FROM queries WHERE client='10.204.10.108' AND timestamp > <epoch> \
    AND status IN (1,4,5,9,10,11) GROUP BY domain ORDER BY last_seen DESC;\""
```

Client IP `10.204.10.108` may drift (DHCP) — cross-check against
`gravity.db`'s `client` table (MAC `74:4c:a1:55:f9:55`, **lowercase**) if
queries stop showing up for that IP.

**Before reporting something as still-blocked after adding a rule:**
compare the query's timestamp against the rule's `date_added` in
`gravity.db` (`SELECT date_added FROM domainlist WHERE id=<id>`) — a
query logged moments before the rule existed will show blocked and looks
identical to a real leak. Only a query timestamped *after* the rule was
added is a real signal.

## Gotchas

- Bound any `pihole-FTL.db` query with `timestamp >` — a leading-wildcard
  `LIKE '%...'` scan over the full history can hang for minutes and stall
  other DB writes.
- API session cap is 16 concurrent per instance
  (`webserver.api.max_sessions`); avoid leaving sessions open across many
  calls in one script run.
- After a rule change, it's live immediately — no reload needed. If
  something still looks blocked and the timestamp check above rules out
  a false alarm, `pihole reloaddns` (reload lists + flush cache, no
  restart) on the affected instance is the next step.
