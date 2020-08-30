#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$DIR/script-base.sh"

GIT_REPO_TARGET_URL="git@github.com:beckend/cpp-base.git"
GIT_REPO_NAME_THIS="cpp-base"
GIT_REPO_NAME_CURRENT="$(basename $(git rev-parse --show-toplevel))"

function initCheck() {
    if [[ "$GIT_REPO_NAME_THIS" = "$GIT_REPO_NAME_CURRENT" ]]; then
        logError "update-base will not update since it's the same repo."
        exit 1
    fi

    checkRequiredCommand git
}

function addBaseSubmodules() {
    git submodule add https://github.com/TheLartians/Ccache.cmake "${DIR_ROOT_INTERNALS_CORE}/Ccache.cmake" || true
    git submodule add https://github.com/microsoft/vcpkg "${DIR_ROOT_INTERNALS_CORE}/vcpkg" || true
}

function updateRepo() {
    addBaseSubmodules

    local DIR_SUBMODULE_TARGET="${DIR_ROOT_INTERNALS_CORE}/${GIT_REPO_NAME_THIS}"
    local VERSION_SUBMODULE=$(cat ${DIR_ROOT_INTERNALS}/VERSION)
    local VERSION_CURRENT=$(cat ${DIR_ROOT_INTERNALS}/VERSION)
    local COPY_ROOT_TARGETS=(
        "internals/scripts"
        "CMakeLists.txt"
        "CMakeList-base.txt"
        "Makefile"
        ".vscode"
    )

    if [[ -d "$DIR" ]]; then
        echo "submodule target directory ${DIR_SUBMODULE_TARGET} already exists, skip cloning."
        git submodule update --init --recursive
    else
        git submodule add "${GIT_REPO_TARGET_URL}" "${DIR_SUBMODULE_TARGET}"
    fi

    if [[ "$VERSION_SUBMODULE" = "$VERSION_CURRENT" ]]; then
        echo "base is up to date.".
        return 0
    fi

    for CP_TARGET in ${COPY_ROOT_TARGETS[@]}; do
        cp -a "${CP_TARGET}" "${DIR_ROOT}/${CP_TARGET}"
    done

    echo "base syncronized."
}

initCheck
updateRepo
