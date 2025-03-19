#!/usr/bin/env bash
source "$(dirname "$0")/norsk-config.sh"
source "$(dirname "$0")/versions"
cd "$(dirname "$0")/../docker" || exit 1

export PUBLIC_URL_PREFIX=${PUBLIC_URL_PREFIX:-https://$DEPLOY_HOSTNAME/norsk}
export STUDIO_URL_PREFIX=${STUDIO_URL_PREFIX:-/studio}
export STUDIO_DOCS_URL=${STUDIO_DOCS_URL:-https://$DEPLOY_HOSTNAME/docs/studio/index.html}
# These need to be set as ids because they are
# names on the host system, not inside the container
export NORSK_USER=$(id -u norsk)
export NORSK_GROUP=$(getent group disk | cut -d: -f3)

if [[ "${1:-}" = "up" || "${1:-}" = "start" ]]; then
  bash ../deployed/check-setup.sh
fi

networkDir="host-networking"

declare -a composeFiles
composeFiles=(
  -f yml/servers/norsk-media.yml -f yml/$networkDir/norsk-media.yml
  -f yml/servers/norsk-studio.yml -f yml/$networkDir/norsk-studio.yml
  -f yml/norsk-users.yaml
  -f yml/volumes/norsk-logs.yml
)
if [[ -n "${DEPLOY_HARDWARE:-}" ]]; then
  composeFiles+=(
    -f "$DEPLOY_HARDWARE"
  )
fi

docker compose "${composeFiles[@]}" "$@"
