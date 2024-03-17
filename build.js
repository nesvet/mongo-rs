#!/usr/bin/env bun

import { $ } from "bun";


const name = "nesvet.dev/insite/mongo";


await $`docker buildx build --tag ${name}:latest --platform=linux/amd64,linux/arm64 --builder multi --push .`;
