export ZSH=/Users/eric/.oh-my-zsh

ZSH_THEME="avit"

plugins=(git docker-compose)

source $ZSH/oh-my-zsh.sh

bindkey "[C" forward-word
bindkey "[D" backward-word

export TERM=screen-256color

# Prepare tmuxinator projects
source ~/.bin/tmuxinator.zsh

# Golang
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# PHP
export PATH=/usr/local/php5/bin:$PATH:$HOME/bin

if [ -e ~/.profile ]; then
	source $HOME/.profile
fi

