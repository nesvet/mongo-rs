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
- Dependabot Docker image updates

### Changed

- Update MongoDB version to 8.2.5
- Replace build script with GitHub Actions release workflow

### Fixed

- Relax healthcheck intervals for replica set initialization
- Use localhost and remove redundant MONGOSH exports in `entrypoint.sh`

## [8.2.3] - 2026-01-23

### Added

- Default values for MongoDB user credentials in `entrypoint.sh` (`MONGO_USER`, `MONGO_PASSWORD`, `MONGO_AUTHDB`, `MONGO_RS`)

### Changed

- Update MongoDB version to 8.2.3

[Unreleased]: https://github.com/nesvet/mongo-rs/compare/8.2.5...HEAD
[8.2.5]: https://github.com/nesvet/mongo-rs/releases/tag/8.2.5
[8.2.3]: https://github.com/nesvet/mongo-rs/releases/tag/8.2.3
