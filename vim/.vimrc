set guicursor=
"Color
colors colosus
hi Normal ctermbg=none
set encoding=utf8


" To install the Plug just write in normal mode ":PlugInstall"
call plug#begin()

Plug 'neomake/neomake'              " Give errors to the code
Plug 'scrooloose/nerdtree'
Plug 'roxma/vim-tmux-clipboard'
Plug 'vim-airline/vim-airline'          " Bar
Plug 'vim-airline/vim-airline-themes'   
Plug 'ozelentok/vim-closer'
"Plug 'zchee/deoplete-clang'        " OZ WILL TELL ME NEW TIME
"Plug 'pangloss/vim-javascript'
"Plug 'Shougo/neocomplete.vim'
"Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'           "Add icons

call plug#end()

" Neocomplete plugin
"let g:neocomplete#enable_at_startup = 1
"let g:neocomplete#sources#syntax#min_keyword_length = 2
"let g:neocomplete#enable_smart_case = 1
"let g:airline_theme = 'powerlineish'


" keymaps
map <C-n> :NERDTreeToggle<CR>
command W w
"map <F5> :!sh /home/yehonatan.e/.dotfiles/vim/scripts/scpFastCopy.sh<CR>
map <F5> :w !sh /home/yehonatan.e/.dotfiles/vim/scripts/scpFastCopy.sh %<CR>
"map <F8> :!echo -e "Uploading This file to root\n" ; sudo scp % root@10.90.2.107:/root<CR>
"map <F5> :!echo -e "Uploading This file to site-packages\n"  ; sudo scp % root@10.90.2.107:/root<CR>

"general settings
set number "Add number line
set tabstop=4		" tab will insert 4 space
set shiftwidth=4	" when indeting the '>', use 4 space
set expandtab		" on pressing tab, insert 4 spaces

set hlsearch        " Highlight the word when search
set incsearch       " Start search in realtime
set clipboard=unnamed,unnamedplus " Copy/Paste directly to System/X11 clipboard
vnoremap p "_dP     " Cancel the insasaly annoying copy paste
vnoremap P "_dp     " Cancel the insasaly annoying copy paste
set nowrap          " Disable wrap line

autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
"map <F10> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>
"map <F10> :split verifyOutput <bar> :read !~/Downloads/arduino-1.6.13/arduino --verify % <CR>
"map <F8> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>

nnoremap <c-b> <nop>

"Python
let g:python3_host_prog = "/usr/bin/python3"


" deoplete.vim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

" mouse support
""set mouse=a

set foldenable
"set foldmethod=syntax
set foldmethod=marker
set foldlevel=0
" zm = fold all
" zr = un-fold all
" za = toggle folding current section 
" ======= open files ============
" gf on text file complete pathnam open it in current tab
" gx on Any file pathname open it with default application 
"
"
"

syn keyword Todo NOTE ASK contained


