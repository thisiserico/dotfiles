set nocompatible " be iMproved, required skdvk
filetype off " required

" Add stuff to the runtime path
set rtp+=~/.vim/bundle/Vundle.vim " Include and initialize vundle
set runtimepath^=~/.vim/bundle/ctrlp.vim " Include ctrlp

set encoding=utf-8

call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " let bundle manage vundle

" Navigation helpers
Plugin 'https://github.com/scrooloose/nerdtree.git' " file navigation menu
Plugin 'jistr/vim-nerdtree-tabs'                    " improved nerd tree
Plugin 'Xuyuanp/nerdtree-git-plugin'                " git stuff for nerd tree
Plugin 'majutsushi/tagbar'                          " displays tags in a window
Plugin 'jakedouglas/exuberant-ctags'                " adds ctags - install ctags.sourcefoge.net
Plugin 'mileszs/ack.vim'                            " Ack within wim
Plugin 'dyng/ctrlsf.vim'                            " find stuff within project

" Look and feel
Plugin 'vim-airline/vim-airline'                          " cool status bar
Plugin 'vim-airline/vim-airline-themes'                   " themes for the status bar
Plugin 'morhetz/gruvbox'                                  " gruvbox theme
Plugin 'https://github.com/joeytwiddle/sexy_scroller.vim' " scrolls smoothly

" Git support
Plugin 'fugitive.vim'           " git on esteroids
Plugin 'airblade/vim-gitgutter' " git gutter

" Code helpers
Plugin 'Raimondi/delimitMate'                 " quotes highlighter
Plugin 'tpope/vim-surround'                   " performance for surrounding pairs like quotes or tags
Plugin 'ntpeters/vim-better-whitespace'       " whitespace renderer
Plugin 'ekalinin/Dockerfile.vim'              " dockerfile highlighter
Plugin 'https://github.com/ervandew/supertab' " Autocomplete with tab
Plugin 'garbas/vim-snipmate' 				  " snippets with <tab>
Plugin 'honza/vim-snippets'                   " lots of snippets
Plugin 'scrooloose/nerdcommenter'             " Comment and uncomment code easily
Plugin 'easymotion/vim-easymotion' 			  " Move faster through the code
Plugin 'MarcWeber/vim-addon-mw-utils'         " dependency for easy motion
Plugin 'tomtom/tlib_vim'                      " dependency for easy motion
Plugin 'https://github.com/elzr/vim-json'     " Json support
Plugin 'terryma/vim-multiple-cursors'  		  " Multiple cursor support

" Markdown specific
Plugin 'tpope/vim-markdown'             " markdown support
Plugin 'jtratner/vim-flavored-markdown' " github highlightning

" Go specific
Plugin 'fatih/vim-go'                " adds lots of go utilities
Plugin 'nsf/gocode', {'rtp': 'vim/'} " enable go code completions
Plugin 'SirVer/ultisnips'            " allow to use go snippets
Plugin 'AndrewRadev/splitjoin.vim'   " splits and joins structs

" PHP specific
Plugin 'StanAngeloff/php.vim', { 'for': 'php' }        " adds lots of php utilities
Plugin 'arnaud-lb/vim-php-namespace', { 'for': 'php' } " adds use statements
Plugin 'shawncplus/phpcomplete.vim', { 'for': 'php' }  " improved omnicompletion
Plugin 'wdalmut/vim-phpunit', { 'for': 'php' }         " phpunit features
call vundle#end() " required

filetype plugin indent on " required, do not remove

" improved navigation
set mouse=a        " enable mouse scrolling
set relativenumber " use relative numbers
set number         " set the line number
set expandtab      " uses spaces instead of tabs
set tabstop=4      " tab set to 4 spaces
set nowrap         " do not wrap lines
set cursorline     " highlight line of cursor


" proper ctrl + v
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
set nopaste

" improved finding
set ignorecase
set smartcase
set noswapfile
set nobackup
set splitright
set splitbelow
set autoread

" key mapping
nnoremap <silent> <C-l> :nohl<CR><C-l> " removes search highlightning with ctrl + l
map <C-x> :CtrlPBuffer " goes back to the previous opened file
nmap <F8> :TagbarToggle<CR>
nmap <S-F>f <Plug>CtrlSFPrompt

" get rid of the arrow keys and : \o/
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap ; :

" configure look and feel
syntax enable
syntax on
set visualbell " avoid beeping sound
set background=dark
colorscheme gruvbox
set laststatus=2 " show airline even when only 1 file is open
let g:airline_theme='distinguished'

" 2 below add little red mark on lines over 80 chars
highlight ColorColumn ctermbg=red ctermfg=black
call matchadd('ColorColumn', '\%81v', 100)

" configure the ctrlp plugin
let g:ctrlp_max_files = 0

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

" NERDTree settings
let NERDTreeShowHidden=1
map <C-k> :NERDTreeToggle<CR> " toggle the tree on ctrl + k
map <S-C-c> :NERDTreeTabsFind<CR> " position on the current file on ctrl + shift + c

" go-vim options
nmap gb :GoBuild<CR>
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_fmt_fail_silently = 0

" NERDCommenter settings
let g:NERDSpaceDelims = 1

" Ack settings
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Markdown Syntax Support
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" define space for particular file types
au BufNewFile,BufRead *.vim setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.md setlocal spell noet ts=4 sw=4
au BufNewFile,BufRead *.yml,*.yaml setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.feature setlocal expandtab ts=4 sw=4
au BufNewFile,BufRead *.json setlocal expandtab ts=4 sw=4

