#!/usr/bin/env bash
export DEPLOY_PLATFORM="$("$(dirname "$BASH_SOURCE")/detect.sh")"
source "$(dirname "$BASH_SOURCE")/$DEPLOY_PLATFORM/$(basename "$BASH_SOURCE")"
