#! /bin/bash

set -eou pipefail

nocolor='\033[0m'
red='\033[0;31m'
yellow='\033[0;33m'

whodis=$(whoami)

cin() {
    local -r question=$1
    local -r dest=$2

    read -rp "⚡️ $question: " "$dest"
}

cout() {
    local -r msg=$1
    echo -e "${yellow}$msg${nocolor}"
}

cerr() {
    cout "${red}$1${nocolor}"
}

binary_exists() {
    which $1 > /dev/null 2>&1
}

folder_exists() {
    [ -d $1 ]
}

file_exists() {
    [ -f $1 ]
}

setup_ssh_keys() {
    if file_exists ~/.ssh/id_ed25519; then
        cout "ssh keys already exist, skipping"
        return
    fi

    cout "setting up ssh keys..."
    mkdir -m 700 -p ~/.ssh
    cin "email address for the ssh key" "email"
    ssh-keygen -t ed25519 -C $email -f ~/.ssh/id_ed25519

    cat ~/.ssh/id_ed25519.pub
    cin "add the public key above to github and come back (press enter when done)" "x"
}

install_brew() {
    if binary_exists brew; then
        cout "brew already installed, skipping"
        return
    fi

    cout "installing brew..."
    bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    source <(curl -s https://raw.githubusercontent.com/thisiserico/dotfiles/main/zsh/zshenv)
}

install_git() {
    if binary_exists git; then
        cout "git already installed, skipping"
        return
    fi

    cout "installing git..."
    brew install git
}

clone_dotfiles_repo() {
    if folder_exists ~/dotfiles; then
        cout "dotfiles repo already exists, skipping"
        return
    fi

    cout "cloning dotfiles repo..."
    git clone --recurse-submodules git@github.com:thisiserico/dotfiles.git ~/dotfiles
}

install_brew_applications() {
    cin "make sure to sign into the apple store (press enter when done)" "x"

    cout "installing applications listed in the Brewfile..."
    brew bundle install --file="~/dotfiles/os/mac/brew/Brewfile" --no-lock --force --no-upgrade || true
}

use_zsh_by_default() {
    cout "making zsh the default terminal..."
    local -r shell_is_recognized=$(cat /etc/shells | grep /bin/zsh)
    if [[ $shell_is_recognized != 0 ]]; then
        echo "/bin/zsh" | sudo tee -a /etc/shells > /dev/null
    fi

    chsh -s /bin/zsh
}

set_macos_defaults() {
    # inspired by mathiasbynens/dotfiles
    cout "setting up os defaults..."

    osascript -e 'tell application "System Preferences" to quit' # close preference windows

    cin "do you wanna change the computer name (y/n)" "yn"
    if [ $yn == "y" ]; then
        cin "computer name" "host" # set computer name
        sudo scutil --set ComputerName $host
        sudo scutil --set HostName $host
        sudo scutil --set LocalHostName $host
        sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $host
    fi

    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' # dark mode
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/'$whodis'/dotfiles/os/wallpaper.jpg"' # set wallpaper
    sudo dscl . delete /Users/$whodis JPEGPhoto # set profile picture
    sudo dscl . delete /Users/$whodis Picture
    sudo dscl . create /Users/$whodis Picture "/Users/$whodis/dotfiles/os/profile.jpg"
    sudo nvram SystemAudioVolume=" " # disable sound on boot
    defaults write NSGlobalDomain _HIHideMenuBar -bool false # do not hide menu bar
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 # small finder sidebar icons
    defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling" # scrollbars when needed only
    defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false # no focus rings
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true # expand save panel
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true # expand print panel
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # save to disk
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true # don't quit inactive apps
    defaults write com.apple.CrashReporter DialogType -string "none" # no crash reporter
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null # no notification center
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false # no auto-capitalization
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false # no smart dashes
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # no automatic periods
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false # no smart quotes
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # no auto-correct
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true # tap on click
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -int 1 # drag with three fingers
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 # full keyboard access for all controls
    defaults write NSGlobalDomain KeyRepeat -int 2 # quick keyboard repeat rate
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain AppleLanguages -array "en-US" "es-ES" "pl" # configure languages and formats
    defaults write NSGlobalDomain AppleLocale -string "en_ES@currency=EUR"
    defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
    defaults write NSGlobalDomain AppleMetricUnits -bool true
    sudo systemsetup -settimezone "Europe/Madrid" > /dev/null 2>&1 # set timezone
    sudo pmset -a lidwake 1 # lid wakeup
    sudo pmset -a displaysleep 0 # do not sleep nor hibernate
    sudo pmset -c sleep 0
    sudo pmset -b sleep 0
    sudo systemsetup -setcomputersleep Off > /dev/null 2>&1
    sudo pmset -a hibernatemode 0
    defaults write com.apple.screensaver askForPassword -int 1 # ask for password right after locking
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    defaults write com.apple.screencapture location -string "${HOME}/Desktop" # save screenshots in the desktop
    defaults write com.apple.screencapture type -string "png" # save screenshots in png
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder DisableAllAnimations -bool true # no finder animations
    defaults write com.apple.finder NewWindowTarget -string "PfDe" # use $HOME as the default finder window
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false # hide certain icons from the desktop
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write com.apple.finder AppleShowAllFiles -bool false # hide hidden files
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true # show filename extensions
    defaults write com.apple.finder ShowStatusBar -bool false # hide finder status bar
    defaults write com.apple.finder ShowPathbar -bool true # show path bar
    defaults write com.apple.finder _FXSortFoldersFirst -bool true # show folders first
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # search current folder only
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # no warning when changing extension
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # no .DS_Store files in network or USBs
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist # snap to grid
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    defaults write com.apple.finder FXPreferredViewStyle -string "icnv" # icons view in finder
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true # airdrop over the net
    defaults write com.apple.dock tilesize -int 22 # dock icons size
    defaults write com.apple.dock minimize-to-application -bool true # minimize into application's icon
    defaults write com.apple.dock show-process-indicators -bool true # show open apps indicator
    defaults write com.apple.dock persistent-apps -array # remove all dock apps
    defaults write com.apple.dock launchanim -bool false # no application opening animations
    defaults write com.apple.dock autohide -bool true # hide dock
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock show-recents -bool false # no recent apps in dock
    defaults write com.apple.dashboard mcx-disabled -bool true # disable dock as dashboard
    defaults write com.apple.dock dashboard-in-overlay -bool true
    defaults write com.apple.dock orientation -string left # display dock to the left
    defaults write com.apple.spotlight orderedItems -array '{"enabled" = 1;"name" = "APPLICATIONS";}' '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' # only apps and preferences in spotlight
    open -a /Applications/iTerm.app "$HOME/dotfiles/iterm/profile.itermkeymap" # use a custom iTerm2 keymap setup
    open -a /Applications/iTerm.app "$HOME/dotfiles/iterm/themes/Ciapre.itermcolors" # use the iTerm2 ciapire theme
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false # quit iTerm2 without a prompt
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true # avoid time machine prompts
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true # main window when launching activity monitor
    defaults write com.apple.ActivityMonitor IconType -int 5 # CPU in the activity monitor dock icon
    defaults write com.apple.ActivityMonitor ShowCategory -int 0 # all processes in the activity monitor
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" # show activity monitor results per CPU usage
    defaults write com.apple.ActivityMonitor SortDirection -int 0
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true # app store update checker
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1 # background download of app updates
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true # do nothing when plugging new devices

    killall Dock
    killall Finder
}

install_go() {
    if binary_exists go; then
        cout "go already installed, skipping"
        return
    fi

    cout "installing go..."
    mkdir -p ~/go/{src,bin,pkg}
    curl -o golang.pkg https://dl.google.com/go/go1.20.2.darwin-amd64.pkg
    sudo open golang.pkg
    # go get golang.org/x/tools/cmd/guru
    # go get github.com/go-delve/delve/cmd/dlv
}

link_dotfiles() {
    cout "linking dotfiles..."
    ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
    ln -sf ~/dotfiles/git/gitignore_global ~/.gitignore_global
    ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
    ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
    ln -sf ~/dotfiles/zsh/hushlogin ~/.hushlogin
    ln -sf ~/dotfiles/zsh/zlogin ~/.zlogin
    ln -sf ~/dotfiles/zsh/zshenv ~/.zshenv
    ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
}

setup_tmux() {
    cout "setting up tmux..."
    if ! folder_exists ~/.tmux/plugins/tpm; then
        git clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm
    fi

    ~/.tmux/plugins/tpm/bin/install_plugins
}

setup_vim() {
    cout "setting up vim..."
    if ! folder_exists ~/.vim/bundle/Vundle.vim; then
	    git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    if ! folder_exists ~/.vim/bundle/ctrlp.vim; then
	    git clone git@github.com:ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
    fi

    vim -c PluginInstall -c qall
}

cout "✨ initiating installation..."
sudo -v
setup_ssh_keys
install_brew
install_git
clone_dotfiles_repo
install_brew_applications
use_zsh_by_default
set_macos_defaults
install_go
link_dotfiles
setup_tmux
setup_vim
cout "✨ installation completed!"
