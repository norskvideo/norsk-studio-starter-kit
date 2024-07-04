#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage:"
    echo "  ${0##*/} env_file"
    echo "  Starts Norsk Studio and Norsk Media Server inside a Kubernetes cluster"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

if [[ ! -f $1 ]]; then
  echo "Env file $1 not found"
  usage
fi

eval $(cat "$1" | sed  's/#.*//;s/^/export /')

cd "${0%/*}"
source script-helpers/_kubectl-command.sh
source script-helpers/_envsubst.sh

envsubst < yaml/norsk-pv-volume.yaml | $KUBECTL apply -f -
envsubst < yaml/norsk-pv-claim.yaml | $KUBECTL apply -f -
envsubst < yaml/norsk-deployment.yaml | $KUBECTL apply -f -
