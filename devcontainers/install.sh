#!/bin/bash

# Silent pushd and popd
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

prepare_install() {
    # Preserve whatever dir the user was in before installing
    pushd $(pwd)

    # Force working dir to be the location of this script (linux/steamos)
    SCRIPT_LOCATION="$(dirname "$0")"
    cd $SCRIPT_LOCATION
}

# Get the repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
echo dotfiles clone is rooted at \"$REPO_ROOT\"

# Prepare by manipulating working directory
prepare_install

# Detect Linux distro
distro=$(cat /etc/os-release | grep -e '^ID=' | cut -d '=' -f2)

case $distro in
    "debian")
        ./debian/install.sh
    ;;

    *)
        echo "Auto-config not yet available for \"$distro\""
    ;;
esac

popd
