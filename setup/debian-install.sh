# Upgrade packages
sudo apt update && sudo apt upgrade


# Install oh-my-zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Install build essentials
sudo apt install -y build-essential


# Prepare dotfiles and generic environment
git clone https://github.com/thisiserico/dotfiles.git
echo "" > .profile

## git
ln -s dotfiles/gitconfig .gitconfig
ln -s dotfiles/gitignore_global .gitignore_global

## tmuxinator
sudo apt install -y rubygems
sudo gem install tmuxinator
mkdir .bin && touch .bin/tmuxinator.zsh
wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh && mv tmuxinator.zsh .bin/tmuxinator.zsh

## zsh
rm .zshrc && ln -s dotfiles/zshrc .zshrc && source .zshrc

## tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -s dotfiles/tmux.conf .tmux.conf
# tmux -> ctrl-a I to install plugins...

## vim
git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
git clone https://github.com/ctrlpvim/ctrlp.vim.git .vim/bundle/ctrlp.vim
ln -s dotfiles/NERDTreeBookmarks .NERDTreeBookmarks
ln -s dotfiles/vimrc .vimrc
vim +PluginInstall +qall
sudo apt install -y silversearcher-ag


# Install  docker
# Follow this guide https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
# Follow this guide https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04
docker login quay.io


# Install languages
## Golang 1.9
wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.9.linux-amd64.tar.gz
rm go1.9.linux-amd64.tar.gz

## PHP 7.1
sudo apt install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -y
sudo apt-get install -y php7.1 php7.1-cli php7.1-common php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-mysql php7.1-mcrypt php7.1-zip

## Node latest
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
# Move nvm mess to .profile...
source .zshrc
nvm install node


# Install dependency managers
nvm install node npm
mkdir bin
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=bin --filename=composer
php -r "unlink('composer-setup.php');"

# Reboot
sudo reboot now

