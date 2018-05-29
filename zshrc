export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="lostavit"

plugins=(git docker-compose)

source $ZSH/oh-my-zsh.sh

bindkey "[C" forward-word
bindkey "[D" backward-word

export TERM=screen-256color

# Set up tmux related things
source ~/.bin/tmuxinator.zsh
alias tls="tmux list-sessions"

# Golang
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# gcloud
export PATH=$PATH:$HOME/bin/google-cloud-sdk/bin

# PHP
export PATH=/usr/local/php5/bin:/usr/local/php7/bin:$PATH:$HOME/bin

if [ -e ~/.profile ]; then
	source $HOME/.profile
fi

# Making lifes easier
alias path='echo $PATH | tr -s ":" "\n"'

# Methods
## prints port status using lsof
% busyport () {
    lsof -n -i:$1 | grep LISTEN
}

## helps ídentity misterious IPs
% whosip () {
    openssl s_client -showcerts -connect $1:$2 | grep CN
}

## golang's dep dependency graph (brew install graphviz)
% depgraph () {
    dep status -dot | dot -T png | open -f -a /Applications/Preview.app
}

