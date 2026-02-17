#!/bin/sh

user="${MONGO_USER:-root}"
pass="${MONGO_PASSWORD:-iddqd}"
authdb="${MONGO_AUTHDB:-admin}"

if [ -n "$MONGO_PASSWORD_FILE" ] && [ -f "$MONGO_PASSWORD_FILE" ]; then
	pass=$(cat "$MONGO_PASSWORD_FILE")
fi

mongosh --quiet \
	-u "$user" -p "$pass" --authenticationDatabase "$authdb" \
	--eval "db.adminCommand({ ping: 1 })" localhost:27017 || exit 1
