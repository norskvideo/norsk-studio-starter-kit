#!/usr/bin/env bash
set -euo pipefail

cd "${0%/*}"
cd ../..

acct=norskvideo
name=norsk-studio

function main {
    local -r label=$1
    local -r containerName=$acct/$name

    docker manifest rm "$containerName:$label" || true
    docker manifest rm "$containerName:latest" || true

    docker manifest create "$containerName:$label" \
        "$containerName:$label-amd64" \
        "$containerName:$label-arm64"

    docker manifest create "$containerName:latest" \
        "$containerName:$label-amd64" \
        "$containerName:$label-arm64"

    docker logout || true
    docker login -u norskvideo

    docker manifest push "$containerName:$label"
    echo  docker manifest push $containerName:latest

   #  docker logout
}

main "$@"
