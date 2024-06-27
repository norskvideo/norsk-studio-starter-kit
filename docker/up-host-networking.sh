#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

docker compose -f core.yml -f host-networking.yml up -d