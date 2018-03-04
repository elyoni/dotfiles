set guicursor=
"set termguicolors
"set spell
colors colosus
hi Normal ctermbg=none guibg=none
set encoding=utf8


" To install the Plug just write in normal mode ":PlugInstall"
call plug#begin()

Plug 'neomake/neomake'              " Give errors to the code
Plug 'scrooloose/nerdtree'
Plug 'roxma/vim-tmux-clipboard'
Plug 'vim-airline/vim-airline'          " Bar
Plug 'vim-airline/vim-airline-themes'   
Plug 'ozelentok/vim-closer'
"Plug 'tweekmonster/deoplete-clang2'        " Oz - deoplete-clang 2 is the new plugin - just install the 'clang' package
Plug 'roxma/nvim-yarp'
Plug 'zchee/deoplete-jedi'
 
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'           "Add icons
Plug 'junegunn/fzf'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-fugitive'               " For git
"Plug 'w0rp/ale'

call plug#end()

" keys
map <C-n> :NERDTreeToggle<CR>
map <S-B> ^<CR>
map <C-s> :w<CR>
map <C-k>  <PageUp> 
map <C-j>  <PageDown> 
map . :call DoNothing()<CR>

map <C-A-S-R> :call SearchAndReplace()<CR>
map <F2> :call RunBashScript()<CR>
map <F3> :call RunPython()<CR>
map <F4> :call CompileTheCore()<CR>
map <F5> :call UploadToPortia()<CR>
map <F17> :call UploadPythonToPorita<CR>
map <F6> :call UpdatePoritaIP()<CR>
"map <F6> :call CpToPorita()<CR>
map <F9> :call SearchEveryWhere()<CR>
map <F12> :call RestartPmanager()<CR>
map <F7> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>
map <F8> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --upload % <CR>

nmap <C-g>s :Gstatus<CR>
nmap <C-g>d :Gdiff<CR>
nmap <C-g>c :Gcommit<CR>

nmap <A-Right> <C-W><Right>
nmap <A-Left> <C-W><Left>
nmap <A-Up> <C-W><Up>
nmap <A-Down> <C-W><Down>

imap <A-Right> <Esc><C-W><Right>
imap <A-Left> <Esc><C-W><Left>
imap <A-Up> <Esc><C-W><Up>
imap <A-Down> <Esc><C-W><Down>

tmap <A-Right> <Esc><C-W><Right>
tmap <A-Left> <Esc><C-W><Left>
tmap <A-Up> <Esc><C-W><Up>
tmap <A-Down> <Esc><C-W><Down>


" resize horzontal split window
nmap <C-Up>  <C-W>-<C-W>-
nmap <C-Down>   <C-W>+<C-W>+
" resize vertical split window
nmap <C-Right> <C-W>><C-W>>
nmap <C-Left> <C-W><<C-W><

nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>

:tnoremap <Esc> <C-\><C-n>

command W w
command Wqa wqa
command Wq wq
command Q q
command Qa qa
command SearchAll call SearchEveryWhere()
command Lab call LabSplit()

"general settings
set number "Add number line
set tabstop=4		" tab will insert 4 space
set shiftwidth=4	" when indeting the '>', use 4 space
set expandtab		" on pressing tab, insert 4 spaces

set hlsearch        " Highlight the word when search
set incsearch       " Start search in realtime
set clipboard=unnamed,unnamedplus " Copy/Paste directly to System/X11 clipboard

"Copy settings
set ignorecase      "Cancel the case sensative
set smartcase


vnore p "_dP     " Cancel the insasaly annoying copy paste
vnore P "_dp     " Cancel the insasaly annoying copy paste

set nowrap        " Disable wrap line

autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
" <F10> :split verifyOutput <bar> :read !~/Downloads/arduino-1.6.13/arduino --verify % <CR>

nnore <c-b> <nop>

"Python
let g:python_host_prog = "/usr/bin/python2.7"
let g:python3_host_prog = "/usr/bin/python3.4"


" deoplete.vim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'

"airline
let g:airline#extensions#tabline#formatter = 'unique_tail'
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create(['%3p%%', 'linenr', 'maxlinenr', '%3v'])
"let g:airline_detect_whitespace=0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string=''

"let g:airline_mode_map = {
"    \ '__' : '-',
"    \ 'n'  : 'Norm',
"    \ 'i'  : 'Index',
"    \ 'R'  : 'Repl',
"    \ 'c'  : 'C',
"    \ 'v'  : 'Vis',
"    \ 'V'  : 'Vis',
"    \ '' : 'V',
"    \ 's'  : 'S',:set invlist
"    \ }
" mouse support
set mouse=a

set foldenable
"set foldmethod=syntax
set foldmethod=marker
set foldlevel=0
" zm = fold all
" zr = un-fold all
" za = toggle folding current section 
"======= open files ============
" gf on text file complete pathnam open it in current tab
" gx on Any file pathname open it with default application 
"
set inccommand=split "When searching I will see split screen with all the option
set tags=tags
"
syn keyword ColorColumn ygye
syn keyword Search Debug
syn keyword SpellBad debug



"highlight question cterm=bold,undercurl ctermbg=9 gui=undercurl guibg=DarkRed
highlight question ctermfg=196 guifg=#E85848 guibg=#461E1A 
call matchadd('question',"^\?.*")
highlight ans ctermfg=117 gui=bold guifg=fg 
call matchadd('ans',"^\!.*")

" ==== NeoMake ====
" When writing a buffer.
call neomake#configure#automake('w')
" When writing a buffer, and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 100)
" When reading a buffer (after 1s), and when writing.
call neomake#configure#automake('rw', 500)
let g:neomake_open_list = 0

highlight onit ctermfg=0 ctermbg=214 guifg=#000000 guibg=#C0A25F
call matchadd('onit',".*onit.*")

highlight ygye cterm=bold ctermfg=16 ctermbg=186 gui=bold,underline guifg=#cae682 guibg=#363946 
call matchadd('ygye',".*yg-ye.*")
call matchadd('ygye',".*ygye.*")


function UploadPythonToPorita()
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    echo "Portia IP Json: " .ip
    execute '!bash ~/projects/sources/apps/pmanager/sync-python.sh ~/projects/proto '. ip
endfunction

function SearchAndReplace()
    let search = input("What To Replace>")
    let replace = input("Replace With   >")
    execute ":%s/" . search . "/" . replace . "/g"
endfunctio

function SearchEveryWhere()
    let search = input("File Content To Search: ")
    execute ":vimgrep /" . search . "/ **"
    copen
endfunctio


function RunBashScript()
    write
    execute "!bash " . "%"
endfunctio

function UploadToPortia()
    write
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    echo "Portia IP: " .ip
    execute "!bash " .  $HOME . "/.dotfiles/work_script/sync_file_to_protia.sh " . "%:p"
endfunction

function UpdatePoritaIP()
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    echo "Portia IP Json: " .ip
    let ip=input("IP>")
    if ip != ""
        execute '!py ~/projects/tools/configure.py -i ' . ip . ' -p 80'
        "execute '!echo ' . ip . ' > ~/.ipPortia.txt'
        let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
        echo "Portia IP Json: " .ip
    endif
endfunction

function DoNothing()
endfunctio

function LabSplit()
    set splitright
    set splitbelow
         
    lcd $HOME/project/lab
    vsp | terminal
    set nospell
    4sp $HOME/projects/tools/configurations.json

    set nosplitright
    set nosplitbelow
endfunction


function RestartPmanager()
    execute "!bash " . $HOME . "/.dotfiles/bash_scripts/restart_pmanager.sh"
endfunc

function RunPython()
    write
    execute "!python3.4 " . "%"
endfunc

function CompileTheCore()
    write
    execute "!make -C ~/projects/yehonatan/board/sama5d2_portia/sources/core PLATFORM=sama5d2"
endfunc

function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
"let g:fzf_history_dir = '~/.local/share/fzf-history'
"
let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=E221,E241,E272,E251,W702,E203,E201,E202',  '--format=default'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#',
    \ }
"let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_enabled_makers = ['pep8', 'pylint']
let g:neomake_python_pylint_exe = 'pylint3'
let g:neomake_python_pylint_maker = {
    \ 'args': ['--ignore=W213,W23']
    \}

