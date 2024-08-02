#!/usr/bin/env bash
set -eo pipefail
cd "${0%/*}"

SOURCES_DIR=$(readlink -f ../sources)


usage() {
    echo "Usage: ${0##*/} <camera1|camera2> <start|stop>"
    echo "  Start a sample SRT source that sends a stream to camera 1 or camera 2 on port 5001"
}

function downloadMediaAssets() {
    mkdir -p $SOURCES_DIR
    MEDIA_ASSETS="Weaving.ts InkDrop.ts TraditionalMusic.mp4"

    for i in $MEDIA_ASSETS; do
        if [[ ! -f $SOURCES_DIR/$i ]]; then
            wget -q -O "$SOURCES_DIR/$i" "https://s3.eu-west-1.amazonaws.com/norsk.video/media-examples/data/$i"
        fi
    done
}


main() {
    downloadMediaAssets

    if [[ $# -ne 2 ]] ; then
        usage
        exit 1
    fi
    local source
    case $1 in
        camera1)
            source=${SOURCE:-"InkDrop.ts"}
        ;;
        camera2)
            source=${SOURCE:-"Weaving.ts"}
        ;;
        *)
            usage
            exit 1
    esac


    case $2 in
        start)
        ;;
        stop)
        ;;
        *)
            usage
            exit 1
    esac
    local -r action=$2

    local name=$1
    for i in $(docker ps --all --format '{{.Names}}' | grep -e ^sample-srt-$name\$); do
        echo Stopping $i
        docker rm -f $i
        # If we are about to start the source again, back off for a couple of seconds first
        if [[ $action == "start" ]] ; then
            sleep 5
        else
            # We can just exit - we've stopped the source
            exit 0
        fi
    done
    name=$name source=$source docker compose -f yml/sample-sources/srt-camera.yml up -d
}

main "$@"