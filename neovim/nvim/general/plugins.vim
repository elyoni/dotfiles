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
" Plug 'vimwiki/vimwiki'                  "Wiki for vim
" Plug 'habamax/vim-asciidoctor'


" Status Bar
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Code plugin
" Plug 'ozelentok/vim-closer'             "Auto close brackets
" Plug 'ryanoasis/vim-devicons'           "Add icons
" Plug 'editorconfig/editorconfig-vim'

" fzf alternative
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'

" Adding color with colorizes & rainbow
" Plug 'norcalli/nvim-colorizer.lua'

"Add comments to file, Toggles the comment state: <leader>c<space>
Plug 'scrooloose/nerdcommenter'


" Distraction-free writing in Vim.
" Plug 'junegunn/goyo.vim'

" Syntax
" Plug 'mtdl9/vim-log-highlighting'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
" Plug 'sirtaj/vim-openscad'
" Plug 'kergoth/vim-bitbake'

" Git
" Plug 'tpope/vim-fugitive'
" Plug 'lambdalisue/gina.vim'

" 
" Plug 'tpope/vim-surround'

" Plantuml
" Plug 'weirongxu/plantuml-previewer.vim'
" Plug 'tyru/open-browser.vim'  " plantuml-preview dependency
" Plug 'aklt/plantuml-syntax'  " plantuml-preview dependency

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
