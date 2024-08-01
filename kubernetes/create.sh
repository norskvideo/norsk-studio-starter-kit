#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage:"
    echo "  ${0##*/}"
    echo "  Starts Norsk Studio and Norsk Media Server inside a Kubernetes cluster"
    exit 1
}

if [ $# -ne 0 ]; then
    usage
fi


cd "${0%/*}"
eval $(cat ../env/components-env ../env/norsk-media-env ../env/studio-env ../env/container-versions | sed  's/#.*//;s/^/export /')

# The persistent volume mount point needs to be an absolute path
export MNT_ROOT=$(readlink -f ../mnt)

source script-helpers/_kubectl-command.sh
source script-helpers/_envsubst.sh

########################################################################
# We put as many resources as possible into the norsk-dev namespace
# (persistent volumes are not namespaced, so are an exception)
########################################################################
NAMESPACE=norsk-dev
KAPPLY="$KUBECTL apply -f -"
KAPPLYNS="$KUBECTL --namespace=$NAMESPACE apply -f -"

# We go via dry-run so that this succeeds if the namespace already exists
$KUBECTL create namespace $NAMESPACE --dry-run=client -o yaml | $KAPPLY

# Note that PVs are cluster level respurces, so do not go into the namespace...
envsubst < yaml/norsk-pv-volume.yaml | $KAPPLY

########################################################################
# Everything else goes into our namespace
########################################################################
export LICENSE_BASE64=$(base64 --wrap 0 ../secrets/license.json)
envsubst < yaml/norsk-secrets.yaml | $KAPPLYNS
unset LICENSE_BASE64

envsubst < yaml/norsk-pv-claim.yaml | $KAPPLYNS
envsubst < yaml/norsk-deployment.yaml | $KAPPLYNS
