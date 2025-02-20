#!/usr/bin/env bash
set -euo pipefail

cd "${0%/*}"
cd ../..

acct=norskvideo
localName=norsk-studio-starter-kit:latest

function main {
    local -r arch=$(uname -m)
    local -r label=$1
    local tag
    case $arch in
    aarch64)
        tag=$label-arm64
        ;;

    x86_64)
        tag=$label-amd64
        ;;
    *)
        echo "Unsupported arch"
        exit 1
        ;;
    esac
    local remoteName=$acct/norsk-studio:$tag
    docker login -u $acct
    docker tag $localName $remoteName
    docker push $remoteName
    docker logout
}

main "$@"
