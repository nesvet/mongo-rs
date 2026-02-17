# MongoDB with replica set

[![CI](https://github.com/nesvet/mongo-rs/actions/workflows/ci.yaml/badge.svg)](https://github.com/nesvet/mongo-rs/actions/workflows/ci.yaml)
[![Docker Image](https://img.shields.io/docker/v/nesvet/mongo-rs?logo=docker&sort=semver)](https://hub.docker.com/r/nesvet/mongo-rs)

**Your app needs a replica set** — Node.js driver, Mongoose, Change Streams, transactions all require it. The [official `mongo` image](https://hub.docker.com/_/mongo) runs standalone; `mongo-rs` extends it with a replica set on first run. One container, no init scripts.

```bash
docker run -d -e MONGO_PASSWORD=secret nesvet/mongo-rs
```

### Docker Compose

```bash
docker compose up -d
```

Example with app service:

```yaml
services:
  mongo:
    image: nesvet/mongo-rs
    environment:
      MONGO_PASSWORD: ${MONGO_PASSWORD:-secret}
    volumes:
      - mongo-data:/data/db
    restart: unless-stopped

  app:
    image: myapp:latest
    environment:
      MONGO_URI: mongodb://root:${MONGO_PASSWORD:-secret}@mongo:27017/?directConnection=true
    depends_on:
      mongo:
        condition: service_healthy

volumes:
  mongo-data:
```

## Features

- **Auto-init replica set** — `rs.initiate()` on first run, no manual setup
- **Built-in healthcheck** — 15s interval, ready for `depends_on: condition: service_healthy`
- **Env-based config** — `MONGO_RS`, `MONGO_USER`, `MONGO_PASSWORD`, `MONGO_AUTHDB`
- **Secrets support** — `MONGO_PASSWORD_FILE` for Docker secrets / Kubernetes
- **FCV auto-update** — `featureCompatibilityVersion` aligned with MongoDB version

## Use cases

**→ Local dev with Node.js / Mongoose**  
No more `MongoServerSelectionError: connection refused`. Your driver expects a replica set; **mongo-rs** provides one.

**→ Docker Compose with depends_on**  
Healthcheck built in. `depends_on` works out of the box.

**→ Same setup dev → prod**  
Single node locally, add nodes in production. Same connection string format, no code changes.

## Usage

| Variable | Default | Description |
|----------|---------|-------------|
| `MONGO_RS` | `rs0` | Replica set name |
| `MONGO_AUTHDB` | `admin` | Authentication database |
| `MONGO_USER` | `root` | Admin username |
| `MONGO_PASSWORD` | `iddqd` | Admin password |
| `MONGO_PASSWORD_FILE` | — | Path to file with password (Docker secrets) |

**Connection string** (single-node, use `directConnection=true`): [options](https://www.mongodb.com/docs/manual/reference/connection-string-options/)

```
mongodb://root:${MONGO_PASSWORD}@mongo:27017/?directConnection=true
```

## Production

- **Change default password** — `iddqd` is for dev only
- **Use secrets** — `MONGO_PASSWORD_FILE` with Docker secrets or an external secret manager:

  ```yaml
  services:
    mongo:
      image: nesvet/mongo-rs
      environment:
        MONGO_PASSWORD_FILE: /run/secrets/mongo_password
      secrets:
        - mongo_password
      volumes:
        - mongo-data:/data/db
      restart: unless-stopped

  secrets:
    mongo_password:
      file: ./secrets/mongo_password.txt

  volumes:
    mongo-data:
  ```
- See [SECURITY.md](https://github.com/nesvet/mongo-rs/blob/main/SECURITY.md) for vulnerability reporting

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

[GitHub](https://github.com/nesvet/mongo-rs) • See [`CONTRIBUTING.md`](https://github.com/nesvet/mongo-rs/blob/main/CONTRIBUTING.md)

## License

[MIT](https://github.com/nesvet/mongo-rs/blob/main/LICENSE)
