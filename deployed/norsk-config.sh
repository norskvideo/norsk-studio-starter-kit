#!/usr/bin/env bash
export DEPLOY_PLATFORM="$("$(dirname "$0")/detect.sh")"
source "$(dirname "$0")/$DEPLOY_PLATFORM/$(basename "$0")"
