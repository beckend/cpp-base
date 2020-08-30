#!/usr/bin/env bash
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
DIR_ROOT=$(readlink -e "$DIR/../../..")
DIR_ROOT_INTERNALS="${DIR_ROOT}/internals"
DIR_ROOT_INTERNALS_CORE="${DIR_ROOT_INTERNALS}/core"

function checkRequiredCommand() {
    for i in "$@"; do
        if ! [ -x "$(command -v "$i")" ]; then
            echo "Error: $i is not installed." >&2
            exit 1
        fi
    done
}

function checkRequiredArgs() {
    for i in "$@"; do
        if [[ -z "$i" ]]; then
            echo "Arguments are missing." >&2
            exit 1
        fi
    done
}

function dirExists() {
    if [[ -d "$1" ]]; then
        echo "0"
    else
        echo "1"
    fi
}

function fileExists() {
    if [[ -f "$1" ]]; then
        echo "0"
    else
        echo "1"
    fi
}

function logError() {
    echo "$@" 1>&2
}
