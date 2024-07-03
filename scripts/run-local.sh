#!/usr/bin/env bash
set -eou pipefail

cd "${0%/*}"
# Need to act in the root of the project
cd ..

LOG_LEVEL=silly \
DEBUG_TEST=1 \
PUBLIC_URL_PREFIX=http://192.168.253.225:8080 \
STUDIO_WORKING_DIRECTORY=/mnt/data \
STUDIO_DOCUMENT=/mnt/data/studio-save-files/OverlayBug.yaml \
STUDIO_DOCUMENT_OVERRIDES=/mnt/data/overrides/example-overrides.yaml \
_GLOBAL_ICE_SERVERS='[{"url": "turn:turn:3478", "reportedUrl": "turn:192.168.253.225:3478", "username": "norsk", "credential": "norsk" }]' \
STUDIO_LIBRARY_ROOT=$PWD/node_modules \
npm run server

