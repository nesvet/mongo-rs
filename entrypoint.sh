#!/bin/bash

set -e

if [ -n "$MONGO_PASSWORD_FILE" ] && [ -f "$MONGO_PASSWORD_FILE" ]; then
	MONGO_PASSWORD=$(cat "$MONGO_PASSWORD_FILE")
fi

if [ -z "$MONGO_USER" ]; then
	MONGO_USER="root";
fi

if [ -z "$MONGO_PASSWORD" ]; then
	MONGO_PASSWORD="iddqd";
fi

if [ -z "$MONGO_AUTHDB" ]; then
	MONGO_AUTHDB="admin";
fi

if [ -z "$MONGO_RS" ]; then
	MONGO_RS="rs0";
fi

if [ ! -d "/data/db/.mongodb" ]; then
	echo "🛠️ 🍃 Running MongoDB setup process"
	mongod --replSet "$MONGO_RS" &

	until mongosh --quiet --eval "db.runCommand({ connectionStatus: 1 })" >/dev/null 2>&1; do
		sleep 1
	done

	echo "🛠️ 🍃 Initiating replica set \"$MONGO_RS\""
	mongosh --eval "rs.initiate({ _id: \"$MONGO_RS\", members: [ { _id: 0, host: \"localhost:27017\" } ] })"
	mongosh --eval "rs.status()"

	echo "🛠️ 🍃 Creating root user \"$MONGO_USER\""
	mongosh --eval "db.getSiblingDB(\"$MONGO_AUTHDB\").createUser({ user: \"$MONGO_USER\", pwd: \"$MONGO_PASSWORD\", roles: [ \"root\" ] })"

	echo "🛠️ 🍃 Shutting down MongoDB setup process"
	mongod --shutdown
fi

echo "🍃 Running MongoDB"
mongod --replSet "$MONGO_RS" --auth --keyFile /security/keyfile --bind_ip_all &

until mongosh --quiet --eval "db.runCommand({ connectionStatus: 1 })" >/dev/null 2>&1; do
	sleep 1
done

FCV_CURRENT=$(mongosh -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_AUTHDB" --quiet --eval "db.adminCommand({ getParameter: 1, featureCompatibilityVersion: 1 }).featureCompatibilityVersion.version" | tr -d '"')

if [ -n "$FCV_CURRENT" ]; then
	FCV_TARGET="$(mongosh -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_AUTHDB" --quiet --eval "db.version()" | tr -d '"' | cut -d. -f1).0"

	if [[ "$FCV_CURRENT" == "$FCV_TARGET" ]]; then
		echo "⚙️ 🍃 Current featureCompatibilityVersion is actual"
	else
		echo "⚙️ 🍃 Updating featureCompatibilityVersion from \"$FCV_CURRENT\" to \"$FCV_TARGET\""
		mongosh -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase "$MONGO_AUTHDB" --eval "db.adminCommand({ setFeatureCompatibilityVersion: \"$FCV_TARGET\", confirm: true })"
	fi
else
	echo "⚠️ 🍃 Unable to get featureCompatibilityVersion"
fi

wait
