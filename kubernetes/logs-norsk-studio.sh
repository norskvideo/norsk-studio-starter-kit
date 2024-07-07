#!/usr/bin/env bash
set -eo pipefail

usage() {
    echo "Usage:"
    echo "  ${0##*/}"
    echo "  Show the logs for the Norsk Studio container"
    exit 1
}


cd "${0%/*}"
source script-helpers/_kubectl-command.sh

$KUBECTL  -n norsk-dev logs -f deployments/norsk-studio -c norsk-studio