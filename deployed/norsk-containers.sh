#!/usr/bin/env bash
source "$(dirname "$0")/norsk-config.sh"
cd "$(dirname "$0")/../docker" || exit 1

export NORSK_MEDIA_IMAGE=norskvideo/norsk:v1.0.387-main
export NORSK_STUDIO_IMAGE=norskvideo/norsk-studio:1.0.382
export PUBLIC_URL_PREFIX=https://$DEPLOY_HOSTNAME/norsk

networkDir="host-networking"
docker compose \
  -f yml/servers/norsk-media.yml -f yml/$networkDir/norsk-media.yml \
  -f yml/servers/norsk-studio.yml -f yml/$networkDir/norsk-studio.yml \
  "$@"
