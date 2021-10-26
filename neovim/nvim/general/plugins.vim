if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif



" To install the Plug just write in normal mode :PlugInstall"
call plug#begin()
Plug 'liuchengxu/vim-which-key'

" Must have
" " I am using this plugin on every day
Plug 'vimwiki/vimwiki'                  "Wiki for vim

" Auto complete
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
" Plug 'kristijanhusak/completion-tags'  " Help with the tags
" Plug 'kristijanhusak/vim-packager'     " Needed for the completion-tags
" " Snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


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
" Plug 'kyazdani42/nvim-tree.lua'
Plug 'kevinhwang91/rnvimr'

" Adding color with colorizes & rainbow
Plug 'norcalli/nvim-colorizer.lua'

"Add comments to file, Toggles the comment state: <leader>c<space>
Plug 'scrooloose/nerdcommenter'


" Distraction-free writing in Vim.
Plug 'junegunn/goyo.vim'

" Grammar check 
Plug 'rhysd/vim-grammarous'

" Syntax
Plug 'mtdl9/vim-log-highlighting'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Git
Plug 'tpope/vim-fugitive'
Plug 'lambdalisue/gina.vim'

" 
Plug 'tpope/vim-surround'

" Plantuml
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'  " plantuml-preview dependency
Plug 'aklt/plantuml-syntax'  " plantuml-preview dependency

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
