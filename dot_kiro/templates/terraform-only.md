# <REPO_NAME>

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Cloud Engineer specializing in Terraform and AWS.

<!-- CUSTOMIZE: add any repo-specific rules or gotchas -->

## Repository Structure

<!-- CUSTOMIZE: list actual terraform files and what they manage -->

- `terraform/` — Terraform configuration
- `Makefile` — `init`, `plan`, `apply`, `fmt`, `decrypt`, `encrypt`

## Terraform Details

<!-- CUSTOMIZE -->

- Backend: S3 key `<key>.tfstate` in `mdekort-tfstate-<account-id>`
- Providers: <!-- list providers and versions -->
- Secrets: KMS context `target=<repo-name>` (if applicable)

## Outputs Consumed by Other Repos

<!-- CUSTOMIZE: list downstream consumers, or remove section if none -->

## Related Repositories

<!-- CUSTOMIZE -->
