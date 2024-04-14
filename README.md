# MongoDB with replica set

[Official MongoDB Image](https://hub.docker.com/_/mongo) with replica set initialization on the first run (and with healthcheck)

## Usage

Env vars to set `default`

* MONGO_RS `rs0`
* MONGO_AUTHDB `admin`
* MONGO_USER `root`
* MONGO_PASSWORD `iddqd`

Connection string is about to look like `mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}/?directConnection=true`

---

[github.com/nesvet/mongo-rs](https://github.com/nesvet/mongo-rs)
