#!/bin/bash

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

    # Force working dir to be the location of this script (linux/ubuntu)
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

# Make sure we're not running as root

if [ $(whoami) = "root" ];then
    echo -e ${RED}You must not run this script as root.${NC}
    restore_and_exit_with_code 1
fi

# Get the repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
echo dotfiles clone is rooted at \"$REPO_ROOT\"

# Update apt packages
echo -e ${LIGHT_BLUE}Updating and upgrading apt packages...${NC}
sudo apt update && sudo apt upgrade -y

if [[ $? != 0 ]];then
    echo -e ${RED}A critical step has failed. Please try again.${NC}
    restore_and_exit_with_code 1 
fi

# Install apt packages
echo -e ${LIGHT_BLUE}Installing zsh via apt...${NC}
sudo apt install zsh

if [[ $? != 0 ]];then
    echo -e ${RED}A critical step has failed. Please try again.${NC}
    restore_and_exit_with_code 1 
fi

# Set zsh as the default shell
echo -e ${LIGHT_BLUE}Setting zsh as default shell...${NC}
CHANGE_SHELL_CMD="chsh -s $(which zsh)"
$CHANGE_SHELL_CMD

if [[ $? != 0 ]];then
    echo -e ${RED}You can perform the chsh yourself later: $CHANGE_SHELL_CMD${NC}
    CHSH_FAILED=true
fi

# Install oh-my-zsh
echo -e ${LIGHT_BLUE}Installing oh-my-zsh...${NC}
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# DIRECTORY CHANGE: Change to zsh folder to apply zsh configs
cd $REPO_ROOT/zsh

# Install powerline-fonts
echo -e ${LIGHT_BLUE}Installing Powerline fonts...${NC}
source install-powerline-fonts.sh

# Copy aliases
echo -e ${LIGHT_BLUE}Copying aliases dotfile...${NC}
mkdir -p $HOME/.aliases && cp ./.aliases $HOME/.aliases

# Apply .zshrc
echo -e ${LIGHT_BLUE}Copying zsh dotfiles...${NC}
cp ./.zshrc ./.zprofile $HOME

# DIRECTORY CHANGE: Copy containers.conf
echo Copying containers config...
cd $REPO_ROOT/linux
mkdir -p $HOME/.config/containers
cp ./containers.conf $HOME/.config/containers/containers.conf

# DONE! Now let the user know of any postrequisite steps
echo -e ${LIGHT_BLUE}Done! Install script completed successfully.${NC}

if [ -n $CHSH_FAILED ];then
    echo -e ${RED}You should run chsh to change the default shell: $CHANGE_SHELL_CMD${NC}
fi

restore_and_exit_with_code 0
