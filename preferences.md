# System and App Preferences

## Configure Finder Settings
- Sidebar
  - Show home directory (check the box)
  - Show Applications directory (check the box)
- Advanced
  - Check "Show all file name extensions"
- Permanently show hidden files in Finder
  - Run the below commands in terminal (from https://apple.stackexchange.com/a/5871)
  ```bash
  defaults write com.apple.finder AppleShowAllFiles true
  killall Finder
  ```

## Configure Terminal Settings
- Default to the **Homebrew** profile:
  - General
    - On startup, open: New window with profile: Homebrew
    - New windows open with: Same Profile, Default Working Directory
    - New tabs open with: Same Profile, Same Working Directory

## Enable 1440p HiDPI/Retina
- Configure resolution, scale, HiDPI, refresh rate, HDR, etc. via **BetterDisplay**
- On an Apple Silicon (e.g. M1 Pro) device, if you encounter any flickering, double-toggle HiDPI on BetterDisplay to mitigate the issue
