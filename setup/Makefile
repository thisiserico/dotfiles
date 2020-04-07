brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew-install:
	brew install wget git zsh zsh-completions wget tmux tmuxinator-completion tree mdv ag ack ccat exa

dev-tools: tmuxinator zsh vim go

tmuxinator:
	sudo gem install tmuxinator
	mkdir -p ~/.bin ~/bin
	wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O ~/.bin/tmuxinator.zsh

zsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	chsh -s $(which zsh)

vim:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim

go: go-install go-setup grpc

go-install:
	@echo "dowload and install go from https://golang.org/dl/"

go-setup:
	mkdir -p ~/go/{src,pkg,bin}
	go get golang.org/x/tools/cmd/guru

grpc:
	go get -u google.golang.org/grpc
	wget https://github.com/google/protobuf/releases/download/v3.8.0/protobuf-all-3.8.0.tar.gz
	tar -xzvf protobuf-all-3.8.0.tar.gz
	cd protobuf-3.8.0
	./configure
	make
	sudo make install
	cd ..
	rm -rf protobuf-3.8.0
	go get -u github.com/golang/protobuf/protoc-gen-go

php:
	curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1

dotfiles:
	ln -s ~/dotfiles/gitconfig ~/.gitconfig
	ln -s ~/dotfiles/gitignore_global ~/.gitignore_global
	ln -s ~/dotfiles/vimrc ~/.vimrc
	ln -sF ~/dotfiles/vim/colors ~/.vim/colors
	ln -s ~/dotfiles/fzf.zsh ~/.fzf.zsh
	ln -s ~/dotfiles/zshrc ~/.zshrc
	ln -s ~/dotfiles/oh-my-zsh/themes/lostavit.zsh-theme ~/.oh-my-zsh/themes/lostavit.zsh-theme
	ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
	ln -s ~/dotfiles/NERDTreeBookmarks ~/.NERDTreeBookmarks
	zsh ~/dotfiles/zshrc
	vim +PluginInstall +qall
	git clone https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git
	cd tmux-MacOSX-pasteboard && make reattach-to-user-namespace && cp reattach-to-user-namespace ~/bin && cd .. && rm -rf tmux-MacOSX-pasteboard
	tmux source ~/.tmux.conf

