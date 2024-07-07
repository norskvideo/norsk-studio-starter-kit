#!/usr/bin/env bash
set -eou pipefail

cd "${0%/*}"
cd ..

for package in $(cat package.json | jq -r '.dependencies | to_entries[] | select(.key | startswith("@norskvideo/norsk-studio-")) | .key') ; do
    currentSource=$(cat package.json | jq -r  '.dependencies | ."'$package'"')
    case "$currentSource" in
        file:*)
            # In order to fully remove local dependencies from package-lock.json we delete the (local)
            # package and then install it again
            echo "Local reference to $package found - uninstalling"
            npm uninstall --save $package
            echo
            echo
            echo "Installing $package from npm"
            npm install --save $package

            # Even with a full uninstall / reinstall we see "../norsk-studio/workspaces/XXX" entries left in the
            # package-lock.json, so tidy them up
            tmpFile=$(mktemp)
            cp package-lock.json $tmpFile
            localPath=${currentSource#file:}
            echo localPath $localPath
            cat $tmpFile | jq 'del(.packages["'$localPath'"])' > package-lock.json
            rm $tmpFile


            ;;
        *)

            echo "Package $package is already installed from npm - updating to latest"
            npm install --save $package
            ;;
        esac
done
exit

