#!/usr/bin/env bash
set -eou pipefail

cd "${0%/*}"
cd ..

localPackageRoot=../norsk-studio
norskCore=../norsk-studio-core
if [[ ! $(compgen -G "$localPackageRoot/workspaces/*/package.json") ]] ; then
    echo "I was expecting to find local packages in $localPackageRoot/workspaces"
    echo "Can't continue"
    exit 1
fi

for package in $(cat package.json | jq -r '.dependencies | to_entries[] | select(.key | startswith("@norskvideo/norsk-studio")) | .key') ; do
    currentSource=$(cat package.json | jq -r  '.dependencies | ."'$package'"')
    case "$currentSource" in
        file:*)
            echo "Package $package is already local ($currentSource)"
            ;;
        *)
            foundPackage=false
            for localPackage in $norskCore/package.json $localPackageRoot/workspaces/*/package.json ; do
                localPackageName=$(cat $localPackage | jq -r .name || "")
                if [[ "$localPackageName" == "$package" ]] ; then
                    localPackageDir=${localPackage%/package.json}
                    echo "Found local copy of $package in $localPackageDir"
                    echo "Installing it"
                    echo
                    echo
                    npm install --save $localPackageDir
                    foundPackage=true
                    break
                fi
            done
            if [[ ! $foundPackage ]] ; then
                echo "Could not find $package in $localPackageDir"
            fi
            ;;
    esac
done
