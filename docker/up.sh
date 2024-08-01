#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

source ../env/container-versions
export NORSK_MEDIA_IMAGE=$NORSK_MEDIA_IMAGE
export NORSK_STUDIO_IMAGE=$NORSK_STUDIO_IMAGE

declare TURN_DEFAULT
declare NETWORK_MODE_DEFAULT

if [[ "$OSTYPE" == "linux"* ]]; then
    TURN_DEFAULT=none
    NETWORK_MODE_DEFAULT="host"
else
    TURN_DEFAULT=local
    NETWORK_MODE_DEFAULT="docker"

fi

LICENSE_FILE="../secrets/license.json"

usage() {
    echo "Usage: ${0##*/} [options]"
    echo "  Options:"
    echo "    --network-mode [docker|host] : whether the example should run in host or docker network mode.  Defaults to $NETWORK_MODE_DEFAULT on $OSTYPE"
    echo "    --no-studio : only launch Norsk Media so that you can run Norsk Studio from source"
    echo "    --turn : launch a local turn server"
}

main() {
    local -r upDown="$1"
    local action
    local -r licenseFilePath=$(readlink -f $LICENSE_FILE)
    local networkMode=$NETWORK_MODE_DEFAULT

    # Make sure that a license file is in place
    if [[ ! -f  $licenseFilePath ]] ; then
        echo "No license.json file found in $licenseFilePath"
        echo "  See Readme for instructions on how to obtain one."
        exit 1
    fi

    local localTurn="false"
    local includeStudio="true"
    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            usage
            exit 0
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
        --no-studio)
            includeStudio="false"
            shift 1
            ;;
        --turn)
            localTurn="true"
            shift 1
            ;;
        *)
            echo "Error: unknown option $1"
            usage
            exit 1
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
