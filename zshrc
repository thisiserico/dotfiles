export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="lostavit"

source $ZSH/oh-my-zsh.sh

export TERM=screen-256color

# Set up tmux related things
alias tls="tmux list-sessions"

# Golang
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Modify $PATH
export PATH=$PATH:$HOME/bin

if [ -e ~/.profile ]; then
	source $HOME/.profile
fi

# Making lifes easier and prettier
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'"
alias path='echo $PATH | tr -s ":" "\n"'
alias cat='bat'
alias ping='prettyping --nolegend'
alias preview="fzf --preview 'bat --color \"always\" {}'"
alias top="htop"
alias du="ncdu --color dark -rr --exclude .git --exclude node_modules"
alias nan='tldr'
alias ll='exa --long --header --git'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^e' edit-command-line

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

