#!/bin/bash
set -e


if [ -z "$MONGO_RS" ]; then
    MONGO_RS="rs0";
fi


if [ ! -d "/data/db/.mongodb" ]; then
    echo "🛠️ 🍃 Running MongoDB setup process"
    mongod --replSet $MONGO_RS &
    
    until mongosh --quiet --eval "db.runCommand({ connectionStatus: 1 })" >/dev/null 2>&1; do
        sleep 1
    done
    
    echo "🛠️ 🍃 Initiating replica set \"$MONGO_RS\""
    mongosh --eval "rs.initiate({ _id: \"$MONGO_RS\", members: [ { _id: 0, host: \"127.0.0.1:27017\" } ] })"
    mongosh --eval "rs.status()"
    
    echo "🛠️ 🍃 Creating root user \"$MONGO_USER\""
    mongosh --eval "db.getSiblingDB(\"${MONGO_AUTHDB:-admin}\").createUser({ user: \"${MONGO_USER:-root}\", pwd: \"${MONGO_PASSWORD:-iddqd}\", roles: [ \"root\" ] })"
    
    echo "🛠️ 🍃 Shutting down MongoDB setup process"
    mongod --shutdown
fi


echo "🍃 Running MongoDB"
mongod --replSet $MONGO_RS --auth --keyFile /security/keyfile --bind_ip_all &

until mongosh --quiet --eval "db.runCommand({ connectionStatus: 1 })" >/dev/null 2>&1; do
    sleep 1
done


FCV_CURRENT=$(mongosh -u "$MONGO_USER" -p "$MONGO_PASSWORD" --quiet --eval "db.adminCommand({ getParameter: 1, featureCompatibilityVersion: 1 }).featureCompatibilityVersion.version" | tr -d '"')

if [ -n "$FCV_CURRENT" ]; then
    FCV_TARGET="$(echo "$(mongosh --quiet --eval "db.version()" | tr -d '"')" | cut -d. -f1).0"
    
    if [[ "$FCV_CURRENT" == "$FCV_TARGET" ]]; then
        echo "⚙️ 🍃 Current featureCompatibilityVersion is actual"
    else
        echo "⚙️ 🍃 Updating featureCompatibilityVersion from \"$FCV_CURRENT\" to \"$FCV_TARGET\""
        mongosh -u "$MONGO_USER" -p "$MONGO_PASSWORD" --eval "db.adminCommand({ setFeatureCompatibilityVersion: \"$FCV_TARGET\", confirm: true })"
    fi
else
    echo "⚠️ 🍃 Unable to get featureCompatibilityVersion"
fi


wait
