#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

docker compose -f core/norsk-media.yml -f core/norsk-studio.yml -f docker-networking/norsk-media.yml -f docker-networking/norsk-studio.yml -f turn.yml up -d