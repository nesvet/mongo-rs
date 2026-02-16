#!/bin/bash
set -e

IMAGE="mongo-rs:test"
CONTAINER="mongo-rs-test"
VOLUME="mongo-rs-test-data"

echo "Building image..."
docker build -t "$IMAGE" .

echo "Starting container..."
docker run -d --name "$CONTAINER" \
	-e MONGO_USER=root -e MONGO_PASSWORD=iddqd \
	-v "$VOLUME:/data/db" \
	"$IMAGE"

cleanup() {
	docker rm -f "$CONTAINER" 2>/dev/null || true
}
trap cleanup EXIT

echo "Waiting for healthy..."
for i in $(seq 1 30); do
	status=$(docker inspect --format="{{.State.Health.Status}}" "$CONTAINER" 2>/dev/null || echo "")
	[ "$status" = "healthy" ] && break
	sleep 2
done
[ "$status" != "healthy" ] && { echo "Container did not become healthy"; exit 1; }

echo "Running integration tests..."
docker exec "$CONTAINER" mongosh -u root -p iddqd --authenticationDatabase admin --eval "
	assert(rs.status().members[0].stateStr === 'PRIMARY');
	db.getSiblingDB('test').test.insertOne({x:1});
	assert(db.getSiblingDB('test').test.findOne().x === 1);
	db.getSiblingDB('test').test.drop();
	const fcv = db.adminCommand({getParameter:1,featureCompatibilityVersion:1});
	assert(fcv.featureCompatibilityVersion && fcv.featureCompatibilityVersion.version);
"

echo "All tests passed"
