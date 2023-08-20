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
- Import the **FM_Oh-My-Zsh** profile:
  - Save [terminal/FM_Oh-My-Zsh.terminal](./terminal/FM_Oh-My-Zsh.terminal)
  - Open the newly saved terminal file
    - This will automatically import the profile
- Default to the **FM_Oh-My-Zsh** profile (open Terminal settings):
  - General
    - On startup, open: New window with profile: FM_Oh-My-Zsh
    - New windows open with: Same Profile, Default Working Directory
    - New tabs open with: Same Profile, Same Working Directory
  - Profiles
    - Select the FM_Oh-My-Zsh profile and then click the "Default" button

## Enable 1440p HiDPI/Retina
- Configure resolution, scale, HiDPI, refresh rate, HDR, etc. via **BetterDisplay**
- Set BetterDisplay to automatically launch on login:
  - Open BetterDisplay settings (gear icon in BetterDisplay modal)
  - General -> Enable "Automatically launch on login"
- On an Apple Silicon (e.g. M1 Pro) device, if you encounter any flickering, double-toggle HiDPI on BetterDisplay to mitigate the issue

## Configure AltTab
Start AltTab and open its preferences, then perform the below:
- General
  - Check "Start at login"
  - Change the Menubar icon to the colorful AltTab logo
- Controls -> Shortcut 1
  - Show windows from: All apps, All spaces, All screens
  - Minimized windows: Show
  - Hidden windows: Show
  - Fullscreen windows: Show
  - Window order: Recently Focused
  - Hold CMD and press: TAB Select next window
  - Then release: Focus selected window

## Configure Maccy
Start Maccy and open its preferences, then perform the below:
- General
  - Hotkey: CMD+SHIFT+V
  - Enable "Launch at login"
  - Search: Fuzzy
  - Enable "Paste automatically"
- Storage
  - Save: Files, Images, Text
  - Size: 50
- Appearance
  - Popup at: Cursor
  - Enable "Show menu icon"
  - Select the clipboard icon
- Advanced
  - Enable "Clear history on quit"
  - Enable "Clear the system clipboard too"

## Configure LinearMouse
Start LinearMouse and open its settings, then perform the below:
- General
  - Enable "Show in menu bar"
  - Enable "Start at login" 
  - Click on "Reveal Config in Finder..." and open `linearmouse.json`
  - Copy and paste the contents of [linearmouse/linearmouse.json](./linearmouse/linearmouse.json) into the LinearMouse JSON config file
  - Save changes and click "Reload Config"  

## (OPTIONAL) Configure Barrier
If you installed Barrier and want to use your Mac as a host, start and show Barrier, then perform the below:
- Click on "Configure Server..."
- For each separate device:
  - Drag a new screen to the grid in the desired location
  - Double click on the newly-added screen
  - Change the Screen name to the hostname of the other device
  - Change the Modifier keys as needed

