set nocompatible " be iMproved, required skdvk
filetype off " required

" Add stuff to the runtime path
set rtp+=~/.vim/bundle/Vundle.vim " Include and initialize vundle
set runtimepath^=~/.vim/bundle/ctrlp.vim " Include ctrlp

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'                       " let bundle manage vundle
Plugin 'https://github.com/scrooloose/nerdtree.git' " file left menu
Plugin 'jistr/vim-nerdtree-tabs'                    " improved nerd tree
Plugin 'Xuyuanp/nerdtree-git-plugin'                " git stuff for nerd tree
Plugin 'vim-airline/vim-airline'                    " cool status bar
Plugin 'vim-airline/vim-airline-themes'             " themes for the status bar
Plugin 'morhetz/gruvbox'                            " gruvbox theme
Plugin 'fugitive.vim'                               " git on esteroids
Plugin 'airblade/vim-gitgutter'                     " git gutter
Plugin 'Raimondi/delimitMate'                       " quotes highlighter
Plugin 'ntpeters/vim-better-whitespace'             " whitespace renderer
Plugin 'tpope/vim-surround'                         " performance for surrounding pairs like quotes or tags
Plugin 'ekalinin/Dockerfile.vim'                    " dockerfile highlighter
Plugin 'mileszs/ack.vim'                            " Ack within wim
Plugin 'https://github.com/ervandew/supertab'       " Autocomplete with tab
Plugin 'scrooloose/nerdcommenter'                   " Comment and uncomment code easily
Plugin 'easymotion/vim-easymotion' 					" Move faster through the code
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate' 						" snippets with <tab>
Plugin 'honza/vim-snippets'
Plugin 'https://github.com/elzr/vim-json'           " Json support
Plugin 'terryma/vim-multiple-cursors'  				" Multiple cursor support
" Plugins to work with go
Plugin 'fatih/vim-go'
Plugin 'nsf/gocode', {'rtp': 'vim/'} " enable go code completions
Plugin 'SirVer/ultisnips' " allow to use go snippets
Plugin 'AndrewRadev/splitjoin.vim' " splits and joins structs
" Plugins to work with php
Plugin 'StanAngeloff/php.vim', { 'for': 'php' }
Plugin 'arnaud-lb/vim-php-namespace', { 'for': 'php' } " adds use statements
Plugin 'shawncplus/phpcomplete.vim', { 'for': 'php' } " improved omnicompletion
Plugin 'wdalmut/vim-phpunit', { 'for': 'php' } " phpunit features
call vundle#end() " required

filetype plugin indent on " required, do not remove

" improved navigation
set mouse=a " enable mouse scrolling
set relativenumber " use relative numbers
set number " set the line number
set tabstop=4 " tab set to 4 spaces
set nowrap " do not wrap lines
set cursorline " highlight line of cursor

" improved finding
set ignorecase
set smartcase

" key mapping
nnoremap <silent> <C-l> :nohl<CR><C-l> " removes search highlightning with ctrl + l
map <C-x> :CtrlPBuffer " goes back to the previous opened file

" get rid of the arrow keys and :! \o/
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap ; :

" configure themes and colors
syntax enable
syntax on
set visualbell " avoid beeping sound
set background=dark
colorscheme gruvbox
set laststatus=2 " show airline when only 1 file is open
let g:airline_theme='distinguished'
" 2 below add little red mark on lines over 80 chars
highlight ColorColumn ctermbg=red ctermfg=black
call matchadd('ColorColumn', '\%81v', 100)

" configure the raimondi/delimitMate plugin
let delimitMate_expand_cr = 0
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" get rid of the whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

" paste mode
set nopaste

" NERDTree settings
let NERDTreeShowHidden=1
map <C-k> :NERDTreeToggle<CR> " toggle the tree on ctrl + k
map <S-C-c> :NERDTreeTabsFind<CR> " position on the current file on ctrl + shift + c

" go-vim options
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1

" NERDCommenter settings
let g:NERDSpaceDelims = 1

" Ack settings
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

