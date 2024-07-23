#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

declare TURN_DEFAULT
declare NETWORK_MODE_DEFAULT

if [[ "$OSTYPE" == "linux"* ]]; then
    TURN_DEFAULT=none
    NETWORK_MODE_DEFAULT="host"
else
    TURN_DEFAULT=local
    NETWORK_MODE_DEFAULT="docker"

fi

usage() {
    echo "Usage: ${0##*/} [options]"
    echo "  Options:"
    echo "    --network-mode [docker|host] : whether the example should run in host or docker network mode.  Defaults to $NETWORK_MODE_DEFAULT on $OSTYPE"
}

main() {
    local -r upDown="$1"
    local action
    local networkMode=$NETWORK_MODE_DEFAULT

    local localTurn="false"
    local includeStudio="true"
    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            usage
            exit 0
            ;;
        --turn)
            localTurn="true"
            shift 1
            ;;
        --noStudio)
            includeStudio="false"
            shift 1
            ;;
        --network-mode)
            if [[ "$OSTYPE" == "linux"* ]]; then
                case "$2" in
                docker | host)
                    networkMode=$2
                    shift 2
                    ;;
                *)
                    echo "Unknown network-mode $2"
                    usage
                    exit 1
                    ;;
                esac
            else
                echo "network-mode is unsupported on $OSTYPE"
                usage
                exit 1
            fi
            ;;
        esac
    done

    local networkDir
    if [[ "$networkMode" == "host" ]]; then
        networkDir="host-networking"
    else
        networkDir="docker-networking"
    fi

    local turnSettings=""
    if [[ $localTurn == "true" ]]; then
        turnSettings="-f yml/servers/turn.yml -f yml/$networkDir/turn.yml"
    fi

    local studioSettings=""
    if [[ $includeStudio == "true" ]]; then
        studioSettings="-f yml/servers/norsk-studio.yml -f yml/$networkDir/norsk-studio.yml"
    fi

    norskMediaSettings="-f yml/servers/norsk-media.yml -f yml/$networkDir/norsk-media.yml"

    ./down.sh
    local cmd="docker compose $norskMediaSettings $studioSettings $turnSettings up -d"
    echo "Launching with:"
    echo "  $cmd"
    $cmd

}

main "$@"
