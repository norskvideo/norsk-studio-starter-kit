#!/usr/bin/env bash
set -euo pipefail
cd "${0%/*}"

usage() {
    echo "${0##*/}"
    echo "Stops the Norsk Studio and Norsk Media Server instance in your Kubernetes cluster"
    exit 1
}
source script-helpers/_kubectl-command.sh


$KUBECTL delete deployment norsk-studio || true
$KUBECTL delete pvc norsk-pv-claim || true
$KUBECTL delete pv norsk-pv-volume || true