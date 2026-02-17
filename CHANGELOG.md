# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [8.2.5] - 2026-02-17

### Added

- CI workflow with lint and integration tests
- Local test script (`test.sh`)
- README, repository metadata, and contribution templates
- `compose.yaml` for Docker Compose quick start
- `healthcheck.sh` with auth support (`-u`, `-p`, `--authenticationDatabase`)
- `MONGO_PASSWORD_FILE` for Docker secrets / Kubernetes
- Production checklist and connection string docs in README
- Shellcheck for `test.sh` in CI
- `versions.txt` — file-based source of versions (7.0.30, 8.2.5)
- `renovate.json` — Renovate for auto-updating MongoDB in versions.txt
- Support for MongoDB branches 7 and 8 (both images built per release)
- `ARG MONGO_VERSION` in Dockerfile — version without hardcode

### Changed

- Update MongoDB version to 8.2.5
- Replace build script with GitHub Actions release workflow
- Healthcheck now uses credentials (robust with custom passwords)
- README: Docker Compose section, multi-service example, Production section
- Release: file-based instead of tag-based (trigger — push to versions.txt or workflow_dispatch)
- Release: last version in list gets `latest` tag
- CI and test.sh: version from `tail -1 versions.txt` instead of `git describe`
- Replaced Dependabot with Renovate

### Fixed

- Relax healthcheck intervals for replica set initialization
- Use localhost and remove redundant MONGOSH exports in `entrypoint.sh`

### Removed

- `.github/dependabot.yml`
- Tag-based release trigger

## [8.2.3] - 2026-01-23

### Added

- Default values for MongoDB user credentials in `entrypoint.sh` (`MONGO_USER`, `MONGO_PASSWORD`, `MONGO_AUTHDB`, `MONGO_RS`)

### Changed

- Update MongoDB version to 8.2.3

[Unreleased]: https://github.com/nesvet/mongo-rs/compare/8.2.5...HEAD
[8.2.5]: https://github.com/nesvet/mongo-rs/releases/tag/8.2.5
[8.2.3]: https://github.com/nesvet/mongo-rs/releases/tag/8.2.3
