" auto-install vim-plug
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   "autocmd VimEnter * PlugInstall
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" function! auto_plugin_update()
"     " Automatically install missing plugins on startup
"     autocmd VimEnter *
"       \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"       \|   PlugInstall --sync | q
"       \| endif
" endfunction



" To install the Plug just write in normal mode :PlugInstall"
call plug#begin()
" Must have
" " I am using this plugin on every day
Plug 'vimwiki/vimwiki'                  "Wiki for vim

" Auto complete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'


" Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code plugin
Plug 'ozelentok/vim-closer'             "Auto close brackets
Plug 'ryanoasis/vim-devicons'           "Add icons

" fzf alternative
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" A File Explorer For Neovim Written In Lua
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Adding color with colorizer & rainbow
Plug 'norcalli/nvim-colorizer.lua'

"Add comments to file, Toggles the comment state: <leader>c<space>
Plug 'scrooloose/nerdcommenter'

Plug 'liuchengxu/vim-which-key'

" Distraction-free writing in Vim.
Plug 'junegunn/goyo.vim'

call plug#end()
