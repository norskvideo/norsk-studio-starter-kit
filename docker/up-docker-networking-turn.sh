#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

docker compose -f core.yml -f docker-networking.yml -f turn.yml up -d