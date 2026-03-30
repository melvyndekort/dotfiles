# <REPO_NAME>

> For global standards, way-of-workings, and pre-commit checklist, see `~/.kiro/steering/behavior.md`

## Role

Python developer and DevOps engineer.

## Repository Structure

<!-- CUSTOMIZE -->

- `<package_name>/` — Application source code
- `tests/` — Test suite
- `pyproject.toml` — Project configuration (uv + hatchling)
- `Dockerfile` — Multi-stage Docker build
- `Makefile` — `install`, `test`, `lint`, `format`, `build`, `full-build`, `clean`

## Deployment

<!-- CUSTOMIZE: where does this container run? -->

- Container image: `ghcr.io/melvyndekort/<name>:latest`
- This repo MUST be public for GHCR image pulling to work (GitHub free plan)

## Related Repositories

<!-- CUSTOMIZE -->

- `~/src/melvyndekort/homelab` — Docker Compose stacks that run this container
