"Color
colors colosus
hi Normal ctermbg=none

" To install the Plug just write in normal mode ":PlugInstall"
call plug#begin()

Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'Shougo/neocomplete.vim'
"Plug 'Valloric/YouCompleteMe'

call plug#end()

" Neocomplete plugin
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#enable_smart_case = 1

" keymaps
map <C-n> :NERDTreeToggle<CR>

"general settings
set number "Add number line
set tabstop=4		" tab will insert 4 space
set shiftwidth=4	" when indeting the '>', use 4 space
set expandtab		" on pressing tab, insert 4 spaces

