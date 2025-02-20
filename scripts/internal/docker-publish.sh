#!/usr/bin/env bash
set -euo pipefail

cd "${0%/*}"
cd ../..

acct=norskvideo
localname=norsk-studio-starter-kit

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
    docker login -u $acct
    docker tag $localname:latest $acct/$localname:$tag
    docker push $acct/$name:$tag
    docker logout
}

main "$@"
