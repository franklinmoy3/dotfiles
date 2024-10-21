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

# Make sure we're not running as root

if [ $(whoami) = "root" ];then
    echo -e ${RED}You must not run this script as root.${NC}
    restore_and_exit_with_code 1
fi

# Get the repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
echo dotfiles clone is rooted at \"$REPO_ROOT\"

# Set a password if one is not yet set
passwd -S "$(logname)" | grep -q " NP "
if [[ $? == 0 ]];then
    echo You must set a user password to continue setup.
    passwd
    if [[ $? != 0 ]]; then
        echo -e ${RED}You need to set a user password to use this script. Please try again.${NC}
        restore_and_exit_with_code 1
    fi
fi

# Install dnf packages
echo -e ${LIGHT_BLUE}Installing zsh via dnf...${NC}
sudo dnf check-update && sudo dnf install htop git zsh fcitx5 fcitx5-autostart fcitx5-chinese-addons fcitx5-rime kcm-fcitx5 -y

if [[ $? != 0 ]];then
    echo -e ${RED}A critical step has failed. Please try again.${NC}
    restore_and_exit_with_code 1 
fi

# Install VS Code
echo -e ${LIGHT_BLUE}Preparing to install VSCode by importing MSFT keys...${NC}
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
echo -e ${LIGHT_BLUE}Installing VS Code using dnf...${NC}
sudo dnf install code -y

# Set zsh as the default shell
echo -e ${LIGHT_BLUE}Setting zsh as default shell...${NC}
sudo sh -c 'echo $(which zsh) >> /etc/shells'
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
cp ./.aliases $HOME/.aliases

# Apply .zshrc
echo -e ${LIGHT_BLUE}Copying zsh dotfiles...${NC}
cp ./.zshrc ./.zprofile $HOME

# Fedora starts the SSH agent on login by default

# DIRECTORY CHANGE: Copy KDE Plasma autostart
echo Copying KDE Plasma autostart files...
cd $REPO_ROOT/linux/desktop/kde
cp ./kde-autostart.sh $HOME/kde-autostart.sh

# DIRECTORY CHANGE: Copy containers.conf
echo Copying containers config...
cd $REPO_ROOT/linux
mkdir $HOME/.config/containers
cp ./containers.conf $HOME/.config/containers/containers.conf

# DONE! Now let the user know of any postrequisite steps
printf "${LIGHT_BLUE}Almost done. Just some extra manual steps to do after you exit:${NC}\n"
printf "${LIGHT_BLUE}Make sure to create a new Konsole profile to use zsh.${NC}\n"
printf "${LIGHT_BLUE}You'll need to manually add a new login script for KDE Autostart.${NC}\n"

if [ -n $CHSH_FAILED ];then
    echo -e ${RED}You should run chsh to change the default shell: $CHANGE_SHELL_CMD${NC}
fi

restore_and_exit_with_code 0
