# MongoDB with replica set

[![CI](https://github.com/nesvet/mongo-rs/actions/workflows/ci.yaml/badge.svg)](https://github.com/nesvet/mongo-rs/actions/workflows/ci.yaml)
[![Docker Image](https://img.shields.io/docker/v/nesvet/mongo-rs?logo=docker&sort=semver)](https://hub.docker.com/r/nesvet/mongo-rs)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**MongoDB replica set out of the box.** Based on the [official MongoDB image](https://hub.docker.com/_/mongo), with replica set init and healthcheck built in.

```bash
docker run -d -e MONGO_PASSWORD=secret nesvet/mongo-rs
```

## Features

- **Auto-init replica set** — `rs.initiate()` on first run, no manual setup
- **Built-in healthcheck** — 15s interval, ready for `depends_on: condition: service_healthy`
- **Configurable via env** — `MONGO_RS`, `MONGO_USER`, `MONGO_PASSWORD`, `MONGO_AUTHDB` (sensible defaults)
- **FCV auto-update** — `featureCompatibilityVersion` aligned with MongoDB version

## Usage

| Variable | Default | Description |
|----------|---------|-------------|
| `MONGO_RS` | `rs0` | Replica set name |
| `MONGO_AUTHDB` | `admin` | Authentication database |
| `MONGO_USER` | `root` | Admin username |
| `MONGO_PASSWORD` | `iddqd` | Admin password |

Connection string format: `mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}/?directConnection=true`

## Testing

```bash
./test.sh
```

## Support this project

**mongo-rs is free, open-source, and maintained by one developer.**

If it saves you time or improves your MongoDB replica set setup:
- ⭐ Star the repo — it helps discoverability
- 💙 Support on [Patreon](https://www.patreon.com/nesvet) — priority features & long-term maintenance

## Contributing

Source: [GitHub](https://github.com/nesvet/mongo-rs) · See [`CONTRIBUTING.md`](CONTRIBUTING.md)

## License

[MIT](LICENSE)
