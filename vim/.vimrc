set guicursor=
set termguicolors
"set spell
colors colosus
hi Normal ctermbg=none guibg=none
set encoding=utf8


" To install the Plug just write in normal mode ":PlugInstall"
call plug#begin()

Plug 'neomake/neomake'              " Give errors to the code
Plug 'scrooloose/nerdtree'
Plug 'roxma/vim-tmux-clipboard'
"Plug 'vim-airline/vim-airline'          " Bar
"Plug 'vim-airline/vim-airline-themes'   
Plug 'ozelentok/vim-closer'
Plug 'tweekmonster/deoplete-clang2'        " Oz - deoplete-clang 2 is the new plugin - just install the 'clang' package
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
map <C-k>  <PageUp> 
map <C-j>  <PageDown> 
map . :call DoNothing()<CR>

map <C-A-S-R> :call SearchAndReplace()<CR>
map <F2> :call RunScript()<CR>
map <F3> :call RunPython()<CR>
map <F4> :call CompileTheCore()<CR>
map <F5> :call UploadToPortia()<CR>
map <F6> :call CpToPorita()<CR>
map <F9> :call SearchEveryWhere()<CR>
map <F12> :call RestartPmanager()<CR>
map <F7> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>
map <F8> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --upload % <CR>
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
let g:python_host_prog = "/usr/bin/python2"
"let g:python3_host_prog = "/usr/bin/python3.5"


" deoplete.vim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'


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


if filereadable($HOME.'/.ipPortia.txt')
    let portiaIP = readfile($HOME.'/.ipPortia.txt')
endif
"let portiaIP = "10.90.1.225"




function CpToPorita()
    write
    echo g:portiaIP
    echom "Where do you want to copy the file"
    echom "Copy the file to"
    echom "1./root"
    echom "2./usr/lib/python/python3.4/site-package/"
    echom "3(spff)          /usr/lib/python/python3.4/site-package/spff/"
    echom "4(usb_upgrade)   /usr/lib/python3.4/site-packages/usb_upgrade/"
    echom "5(management)    /usr/lib/python3.4/site-packages/management/"
    echom "6(webserver)     /usr/lib/python3.4/site-packages/webserver/"
    echom "7(restapi)       /usr/lib/python3.4/site-packages/restapi/"
    echom "8(test)          /usr/lib/python3.4/site-packages/test/"
    echom "61./usr/lib/python3.4/site-packages/webserver/templates"
    echom "9.Change Portia IP"
    echom "99.Print Portia IP"
    let readVal = input("Choose>")
    if readVal == 1
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=2 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/root'
    elseif readVal == 2
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=2 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=2 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-package'
    elseif readVal == 3
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=2 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/spff/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=2 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/spff/'
    elseif readVal == 4
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=2 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/usb_upgrade/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=2 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/usb_upgrade/'
    elseif readVal == 5
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=5 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/management/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/management/'
    elseif readVal == 6
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        "execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=30 ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/webserver/'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=5 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/webserver/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/webserver/'
    elseif readVal == 7
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        "execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=30 ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/webserver/'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/restapi/'
    elseif readVal == 8
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/tests/'
    elseif readVal == 61
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/webserver/templates/'
    elseif readVal == 9
        write
        let g:portiaIP = input("IP>")
        execute '!echo ' . g:portiaIP . ' > ~/.ipPortia.txt'
    elseif readVal == 99
        write
        g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        echo g:portiaIP
    endif
endfunctio

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


function RunScript()
    write
    execute "!bash " . "%"
endfunctio

function UploadToPortia()
    write
    execute "!bash " .  $HOME . "/.dotfiles/work_script/sync_file_to_protia.sh " . "%:p"
endfunctio


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
    execute "!python3.5 " . "%"
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
let g:neomake_python_enabled_makers = ['flake8']

let g:neomake_python_enabled_makers = ['pep8']
", 'pylint']

