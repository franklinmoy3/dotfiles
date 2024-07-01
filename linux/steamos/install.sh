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

dir_setup() {
    # Preserve whatever dir the user was in before installing
    pushd $(pwd)

    # Force working dir to be the location of this script (linux/steamos)
    SCRIPT_LOCATION="$(dirname "$0")"
    cd $SCRIPT_LOCATION
}

dir_restore_and_exit() {
    popd
    exit $1
}

# Prepare by manipulating working directory
dir_setup

# Interrupt handler
trap 'echo Received SIGINT/SIGTERM... && dir_restore_and_exit 1' SIGINT SIGTERM

# Make sure we're not running as root

if [ $(whoami) = "root" ];then
    echo -e ${RED}You must not run this script as root.${NC}
    dir_restore_and_exit 1
fi

# Set a password if one is not yet set
passwd -S deck | grep -q " NP "
if [[ $? == 0 ]];then
    echo You must set a user password to continue setup.
    passwd
    if [[ $? != 0 ]]; then
        echo -e ${RED}You need to set a user password to use this script. Please try again.${NC}
        dir_restore_and_exit 1
    fi
fi

# Disable SteamOS's FS protection
DISABLE_READ_ONLY_CMD="sudo steamos-readonly disable"
echo -e ${LIGHT_BLUE}Disabling read-only mode...${NC}
echo $DISABLE_READ_ONLY_CMD
$DISABLE_READ_ONLY_CMD

# Prepare pacman
PACMAN_KEY_INIT_CMD="sudo pacman-key --init"
PACMAN_KEY_POPULATE_CMD="sudo pacman-key --populate archlinux holo"
echo -e ${LIGHT_BLUE}Preparing pacman...${NC}
echo $PACMAN_KEY_INIT_CMD
$PACMAN_KEY_INIT_CMD
echo $PACMAN_KEY_POPULATE_CMD
$PACMAN_KEY_POPULATE_CMD

# Install zsh via pacman
INSTALL_ZSH_CMD="sudo pacman -Syu zsh"
echo -e ${LIGHT_BLUE}Installing zsh via pacman...${NC}
echo $INSTALL_ZSH_CMD
$INSTALL_ZSH_CMD

# Re-enable SteamOS FS protection
ENABLE_READ_ONLY_CMD="sudo steamos-readonly enable"
echo -e ${LIGHT_BLUE}Re-enabling read-only mode${NC}
echo $ENABLE_READ_ONLY_CMD
$ENABLE_READ_ONLY_CMD

# Configure SSH Agent to launch on login with systemd
cp ./ssh-agent.service $HOME/.config/systemd/user/ssh-agent.service
systemctl --user enable --now ssh-agent

# Set zsh as the default shell
ADD_ZSH_TO_SHELLS_CMD="sudo sh -c 'echo $(which zsh) >> /etc/shells'"
CHANGE_SHELL_CMD="chsh -s $(which zsh)"
echo -e ${LIGHT_BLUE}Setting zsh as default shell...${NC}
echo $ADD_ZSH_TO_SHELLS_CMD
$ADD_ZSH_TO_SHELLS_CMD
echo $CHANGE_SHELL_CMD
$CHANGE_SHELL_CMD

# Install oh-my-zsh
INSTALL_OH_MY_ZSH_CMD="sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended"
echo -e ${LIGHT_BLUE}Installing oh-my-zsh...${NC}
echo $INSTALL_OH_MY_ZSH_CMD
$INSTALL_OH_MY_ZSH_CMD

# DIRECTORY CHANGE: Change to zsh folder to apply zsh configs
CHANGE_TO_ZSH_DIR_CMD="cd ./../../zsh"
echo $CHANGE_TO_ZSH_DIR_CMD
$CHANGE_TO_ZSH_DIR_CMD

# Install powerline-fonts
INSTALL_POWERLINE_FONTS_CMD="source install-powerline-fonts.sh"
echo -e ${LIGHT_BLUE}Installing Powerline fonts...${NC}
echo $INSTALL_POWERLINE_FONTS_CMD
$INSTALL_POWERLINE_FONTS_CMD

# Copy aliases
COPY_ALIASES_DOTFILE_CMD="cp ./.aliases $HOME/.aliases"
echo -e ${LIGHT_BLUE}Copying aliases dotfile...${NC}
echo $COPY_ALIASES_DOTFILE_CMD
$COPY_ALIASES_DOTFILE_CMD

# Apply .zshrc
COPY_ZSH_DOTFILES_CMD="cp ./.zshrc $HOME/.zshrc"
echo -e ${LIGHT_BLUE}Copying zsh dotfiles...${NC}
echo $COPY_ZSH_DOTFILES_CMD
$COPY_ZSH_DOTFILES_CMD

# Download VS Code
DOWNLOAD_VSCODE_CMD="curl -L https://update.code.visualstudio.com/latest/linux-x64/stable --output code-stable-x64-latest.tar.gz"
EXTRACT_VSCODE_CMD="tar -xf code-stable-x64-latest.tar.gz --directory $HOME --overwrite"
CLEAN_UP_VSCODE_CMD="rm code-stable-x64-latest.tar.gz"
echo -e ${LIGHT_BLUE}Downloading VS Code tarball...${NC}
echo $DOWNLOAD_VSCODE_CMD
$DOWNLOAD_VSCODE_CMD
$EXTRACT_VSCODE_CMD
echo Cleaning VS Code tarball...
echo $CLEAN_UP_VSCODE_CMD
$CLEAN_UP_VSCODE_CMD

# DONE! Now let the user know of any postrequisite steps
printf "${LIGHT_BLUE}To see VS Code as an item under the Development menu, you need to add it via KMenuEdit.${NC}\n"
printf "${LIGHT_BLUE}The program should be \"$HOME/VSCode-linux-x64/code\".${NC}\n"
printf "${LIGHT_BLUE}You can find a thumbnail to use at \"$HOME/VSCode-linux-x64/resources/app/resources/linux/code.png\"${NC}\n"

dir_restore_and_exit 0
