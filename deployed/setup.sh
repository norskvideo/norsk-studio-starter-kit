#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/norsk-config.sh"
cd "$(dirname "$0")/../support" || exit 1

HTPASSWD=oauth2/secrets/.htpasswd
touch $HTPASSWD
# If the password file was not already customized
if [[ "$(grep -cvEe '^$|^norsk-studio-admin:' $HTPASSWD)" -eq 0 ]]; then
  # grab the password from instance metadata
  IMAGE=xmartlabs/htpasswd@sha256:fac862e543f80d72386492aa87b0f6f3c1c06a49a845e553ebea91750ce6320c
  bash "../deployed/$DEPLOY_PLATFORM/admin-password.sh" \
    | docker run --rm -i $IMAGE -i norsk-studio-admin > $HTPASSWD
fi

./oauth2/secrets/oauth2-proxy.cfg.sh # will refresh cookie secret

if [[ -z "$DEPLOY_DOMAIN_NAME" ]]; then
  echo "" > ./extras/http.conf
else
  cat - > ./extras/http.conf <<TEMPLATE
    server {
        listen 80;
        listen 443;
        listen [::]:80;
        listen [::]:443;
        server_name $DEPLOY_PUBLIC_IP;
        return 302 https://$DEPLOY_DOMAIN_NAME\$request_uri;
    }
TEMPLATE
fi
