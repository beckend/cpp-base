#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$DIR/script-base.sh"

DIR_VCPKG=$(readlink -e "$DIR/../vcpkg")
DIR_VCPKG_PORTS="${DIR_VCPKG}/ports"
DIR_VCPKG_PORTS_CUSTOM=$(readlink -e "$DIR/../vcpkg-custom-ports")
FILE_VCPKG="$DIR_VCPKG/vcpkg"
FILE_VCPKG_JSON="$DIR_ROOT/vcpkg.json"

function check() {
    if ! [[ -x "$FILE_VCPKG" ]]; then
        echo "executable: \"$FILE_VCPKG\" does not exist." 1>&2
        exit 1
    fi
}

function linkCustomPorts() {
    (
        mkdir -p "${DIR_VCPKG_PORTS}"
        cd "${DIR_VCPKG_PORTS}"
        ln -sf $DIR_VCPKG_PORTS_CUSTOM/* . || true
    )
}

function installPackages() {
    VCPKG_FEATURE_FLAGS="binarycaching,manifests" "$FILE_VCPKG" install
}

# run argument as function
if [[ $# -eq 0 ]]; then
    check
    linkCustomPorts
    installPackages
else
    $1
fi
