" set leader key
" let g:mapleader = "\<Space>"
let g:mapleader = ","

colors colosus

" syntax disable                        " Disable syntax highlighing, moved to
" treesitter
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			        " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object/
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=4                           " Insert 4 spaces for a tab
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
"set laststatus=0                        " Always display the status line

" Number bar
" set number norelativenumber             " Line numbers
set number relativenumber               " Line numbers relative with current line


set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
" set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set backup                              " This is recommended by coc
if empty(glob($HOME."/.nvim_backup/"))
    call mkdir($HOME."/.nvim_backup/")
endif
set backupdir=~/.nvim_backup/                              " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
" set clipboard=unnamed,unnamedplus      " Copy/Paste directly to System/X11 clipboard
" set autochdir                           " Your working directory will always be the same as your working directory

" Search
set hlsearch                            " Highlight the word when search
set incsearch                            " Start search in realtime

"Copy settings
set ignorecase      "Cancel the case sensative
set smartcase

au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

hi Normal ctermbg=none guibg=none
set encoding=utf8

" You can't stop me
cmap w!! w !sudo tee %

" When using vimdiff will open the find in read write
set noro

" folding
" set foldenable
"set foldmethod=syntax
" set foldmethod=marker
" set foldlevel=0
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable                     " Disable folding at startup.

" When searching I will see split screen with all the option
set inccommand=split 

" Go to file support for bash environment variable with {}
set isfname+={,}

" Auto insert when entering into a terminal window
autocmd TermOpen * startinsert
