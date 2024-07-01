# `zsh` Setup
I decided to pivot to `zsh` as my primary shell mainly because it was the default shell in macOS and Oh My Zsh makes it nice and brings in a lot of powerful functionality. This is my shell of preference for macOS, Linux, and WSL (Windows Subsystem for Linux).

## Install `zsh`
While `zsh` is the default shell for macOS now, it is not the default shell for most (if not all) Linux distros. You will likely need to use a package manager to install `zsh` from your existing shell.

Debian and Ubuntu (via `apt`):
```sh
sudo apt update && sudo apt upgrade && sudo apt install zsh
```

Arch (via `pacman`):
```sh
sudo pacman -Syu && sudo pacman -Syu zsh 
```

## Change Default Shell to `zsh`
Use the below command to change your default terminaL shell to `zsh` (don't `sudo` this as it will change the shell for the executing user):
```sh
chsh -s $(which zsh) 
```

## Install Oh My Zsh
As with a lot of other `zsh` users, I use [Oh My Zsh](https://ohmyz.sh/) to extend functionality and make the `zsh`` terminal look nice.

To install Oh My Zsh (taken from their website linked above):
``` sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Copy `.zshrc` and other settings
Copy the contents of [.zshrc](./.zshrc) and paste it into the `.zshrc` created by Oh My Zsh in your home directory. This is the file that will configure Oh My Zsh and `zsh` on each shell startup.
I also personally like to set the below config in `git`:
```sh
git config --add oh-my-zsh.hide-dirty 1
```

## Install Powerline fonts for the "agnoster" Theme
My favorite Oh My Zsh theme is ["agnoster"](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster), which requires one of the Powerline fonts to render correctly. The installation instructions vary based on the OS you're installing them onto:

### Linux and macOS
I've made a quick script which will perform the steps taken from [the Powerline fonts repository](https://github.com/powerline/fonts) to install the Powerline fonts. If you cloned the repo or saved the file locally, you can run it with the below command (if you've changed your working directory to the one containing this file):
```sh
sh ./install-powerline-fonts.sh
```

Alternatively, you can run the below terminal commands yourself instead of using the script (directory-agnostic):
```sh
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts 
```

### Windows/WSL
The [Powerline fonts GitHub repository](https://github.com/powerline/fonts) includes a PowerShell install script to install the fonts on Windows. Follow the below steps to install the fonts:

- Clone the [Powerline fonts GitHub repository](https://github.com/powerline/fonts)
    ```sh
    git clone https://github.com/powerline/fonts.git
    ```
- Open a new `Powershell` window **as an Administrator** and run the below commands (substituting parameters as needed):
  ```powershell
  cd <PATH_TO_CLONED_FONTS_REPOSITORY>
  # Elevate privileges to allow script execution (SAY YES TO THE PROMPT)
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
  # Run Powerline fonts install script 
  #    Windows takes a long time to install fonts, so only install the fonts I want
  ./install.ps1 ubuntu*
  # If you want to install all fonts, just run without arguments: 
  # ./install.ps1
  ```
- Set the default Windows Terminal font
  - Open Windows Terminal Settings (in dropdown next to new tab button)
  - Change the font to `Ubuntu Mono derivative Powerline` for your desired profiles
- Restart Windows (does not need to be done immediately)

## Configure VSCode for Oh My Zsh
Visual Studio Code needs some additional setup to get the Oh My Zsh profile to correctly render. All you need to do is go to the VSCode settings and set the below settings in `settings.json` or in the Settings menu:

- `"terminal.integrated.fontFamily": "Ubuntu Mono derivative Powerline"`
- `"terminal.integrated.fontSize": 13`

You've now fully set up Oh My Zsh, but VSCode will not observe it as the default terminal shell profile just yet (unless you're on macOS, where it already is the default). To make it the new default (for WSL and Linux), set the below setting:

- `"terminal.integrated.defaultProfile.linux": "zsh"`

**And that's it! You've fully configured `zsh`! Restart your terminal and you should be launched into my `zsh` setup.**
