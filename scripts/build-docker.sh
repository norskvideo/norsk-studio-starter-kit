#!/usr/bin/env bash

# If you are using local dependencies this script will help you build the docker image.

set -eou pipefail

cd "${0%/*}"
# Need to act in the root of the project
cd ..

backupfilename=docker-prepack.tgz

function main ()
{
  # Working directory, must be in the context (.) of the docker build
  copydir=$(readlink -f $(mktemp -d -p .))

  # Look at the dependencies in the package json, pull out file: dependencies, ignoring the current module (file:.)
  mapfile -t packages < <(jq -r '.dependencies | to_entries | .[] | select  (.value !=  "file:." ) | select (.value | startswith("file:"))  |  .value  ' package.json | sed 's|^file:||')

  rm -f ${backupfilename}

  if [[ ${#packages[@]} != 0 ]]; then
    echo "${#packages[@]} local references found in package.json. Copying the dependencies to the docker build context."

    tar -czf ${backupfilename} package.json node_modules package-lock.json

    for package in ${packages[@]}; do
      echo Packing $package
      pushd $package > /dev/null
      npm pack --pack-destination $copydir

      popd > /dev/null
    done

    for module in $(ls $copydir); do
      echo Installing $module
      npm install --save $copydir/$module
    done
  fi

  docker build -t norsk-studio-starter-kit .

  if [[ -f ${backupfilename} ]]; then
    rm -Rf $copydir
    rm -Rf node_modules

    echo Restoring backup of current env
    tar -xzf ${backupfilename}
    rm ${backupfilename}

  fi
}

main "$@"
