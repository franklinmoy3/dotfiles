#!/bin/bash

##################################### WARNING #################################
###### THIS INSTALL SCRIPT IS ONLY FOR COPYING AND APPLYING P13N CONFIGS ######
###### TO SET UP THE IMAGE ITSELF, CONSIDER USING DEV CONTAINER FEATURES ######

RED='\033[0;31m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

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

restore_and_exit_with_code() {
    
    # Return to whatever dir the user was in before installing
    popd
    exit $1
}

# Prepare by manipulating working directory
prepare_install

# Interrupt handler
trap 'echo Received SIGINT/SIGTERM... && restore_and_exit_with_code 1' SIGINT SIGTERM

# Get the repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
echo dotfiles clone is rooted at \"$REPO_ROOT\"

# zsh and omz can be configured via Dev Container feature
#  ghcr.io/devcontainers/features/common-utils

# DIRECTORY CHANGE: Change to zsh folder to apply zsh configs
cd $REPO_ROOT/zsh

# Install powerline-fonts
echo -e ${LIGHT_BLUE}Installing Powerline fonts...${NC}
source install-powerline-fonts.sh

# Copy aliases
echo -e ${LIGHT_BLUE}Copying aliases dotfile...${NC}
cp ./.aliases $HOME/.aliases

# Apply .zshrc
echo -e ${LIGHT_BLUE}Copying zsh dotfiles...${NC}
cp ./.zshrc ./.zprofile $HOME

restore_and_exit_with_code 0
