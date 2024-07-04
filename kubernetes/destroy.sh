#!/usr/bin/env bash
set -euo pipefail
cd "${0%/*}"

usage() {
    echo "${0##*/}"
    echo "Stops the Norsk Studio and Norsk Media Server instance in your Kubernetes cluster"
    echo "and deletes all associated resources"
    exit 1
}
source script-helpers/_kubectl-command.sh

########################################################################
# Delete the namespace - that removes all the resources associated with it
########################################################################
$KUBECTL delete namespace norsk-dev || true

########################################################################
# That only leaves the persisten volume - which is a cluster level
# reourse, so do not go into the namespace...
########################################################################
$KUBECTL delete pv norsk-pv-volume || true
