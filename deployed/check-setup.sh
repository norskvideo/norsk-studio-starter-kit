#!/usr/bin/env bash
cd "$(dirname "$0")/../support" || exit 1
if [[ ! -f oauth2/secrets/.htpasswd || ! -f oauth2/secrets/oauth2-proxy.cfg ]]; then
  bash ../deployed/setup.sh
fi
