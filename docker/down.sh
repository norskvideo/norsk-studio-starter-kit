#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

# We run the host networking down as it works for both host and docker nw
docker compose -f core.yml -f docker-networking.yml -f turn.yml down # -t 0
