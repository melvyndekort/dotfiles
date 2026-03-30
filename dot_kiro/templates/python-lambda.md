# <REPO_NAME>

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Python developer and AWS engineer.

## Repository Structure

<!-- CUSTOMIZE -->

- `<package_name>/` — Lambda function source code
- `tests/` — Test suite
- `terraform/` — Infrastructure (Lambda, IAM, triggers, etc.)
- `pyproject.toml` — Project configuration (uv + hatchling)
- `Makefile` — `install`, `test`, `lint`, `format`, `package`, `deploy`, `init`, `plan`, `apply`, `decrypt`, `encrypt`

## Lambda Deployment Pattern

Terraform creates Lambdas with dummy code and `ignore_changes` on `source_code_hash`. Actual code is deployed by the CI/CD pipeline via `aws lambda update-function-code`, not by Terraform.

## Terraform Details

<!-- CUSTOMIZE -->

- Backend: S3 key `<key>.tfstate` in `mdekort-tfstate-<account-id>`
- Secrets: KMS context `target=<repo-name>`

## Related Repositories

<!-- CUSTOMIZE -->
