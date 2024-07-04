kubectl_error() {
  echo "Error:"
  echo "  \$KUBECTL needs to be set in the env\kubectl-command file"
  echo "  to the correct \"kubectl\" equivalent for your environment"
  usage
}

__kubectl_file=env/kubectl-command
echo $__kubectl_file
if [[ ! -f $__kubectl_file ]] ; then
  kubectl_error
fi

eval $(cat $__kubectl_file | sed  's/#.*//;s/^/export /')
if [[ -z $KUBECTL ]] ; then
kubectl_error
fi

command -v $KUBECTL >/dev/null 2>&1 || {
  kubectl_error
}
