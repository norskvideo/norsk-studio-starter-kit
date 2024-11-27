#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
env DEPLOY_HOSTNAME="$DEPLOY_HOSTNAME" COOKIE_SECRET="$(openssl rand -base64 32 | tr -- '+/' '-_')" \
  envsubst '${DEPLOY_HOSTNAME} ${COOKIE_SECRET}' < oauth2-proxy.cfg.template > oauth2-proxy.cfg
