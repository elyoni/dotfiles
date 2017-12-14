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
Plug 'roxma/nvim-yarp'
"Plug 'Shougo/neocomplete.vim'
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ryanoasis/vim-devicons'           "Add icons
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
"Plug 'Valloric/YouCompleteMe'

call plug#end()

" Neocomplete plugin
"let g:neocomplete#enable_at_startup = 1
"let g:neocomplete#sources#syntax#min_keyword_length = 2
"let g:neocomplete#enable_smart_case = 1
"let g:airline_theme = 'powerlineish'


" keys
map <C-n> :NERDTreeToggle<CR>
map <S-B> ^<CR>
map <C-k>  <PageUp> 
map <C-j>  <PageDown> 


map <C-S-R> :call SearchAndReplace()<CR>
map <F2> :call RunScript()<CR>
map <F3> :call RunPython()<CR>
map <F4> :call CompileTheCore()<CR>
"map <F5> :call CpToPorita()<CR>
map <F5> :call UploadToPortia()<CR>
map <F12> :call RestartPmanager()<CR>
map <F7> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>
map <F8> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --upload % <CR>

nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>


command W w

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

set nowrap          " Disable wrap line

autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
" <F10> :split verifyOutput <bar> :read !~/Downloads/arduino-1.6.13/arduino --verify % <CR>

nnore <c-b> <nop>

"Python
let g:python_host_prog = "/usr/bin/python2"
let g:python3_host_prog = "/usr/bin/python3"


" deoplete.vim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1

let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'


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

"
syn keyword ColorColumn ygye
syn keyword Search Debug
syn keyword SpellBad debug

let portiaIP = readfile($HOME.'/.ipPortia.txt')
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
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/root'
    elseif readVal == 2
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=5 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-package'
    elseif readVal == 3
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=5 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/spff/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/spff/'
    elseif readVal == 4
        write
        let g:portiaIP = readfile('/home/yehonatan.e/.ipPortia.txt')[0]
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo ssh -o ConnectTimeout=5 root@' . g:portiaIP . ' rm /usr/lib/python3.4/site-packages/usb_upgrade/'. % .'c'
        execute '!sshpass -f /home/yehonatan.e/.passPortia.txt sudo scp -o ConnectTimeout=5 -o StrictHostKeyChecking=no ' . "%" . ' root@' . g:portiaIP . ':/usr/lib/python3.4/site-packages/usb_upgrade/'
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

function RunScript()
    write
    execute "!bash " . "%"
endfunctio

function UploadToPortia()
    write
    execute "!bash " .  $HOME . "/.dotfiles/bash_scripts/sync_file_to_protia.sh " . "%:p"
endfunctio

function RestartPmanager()
    execute "!bash " . $HOME . "/.dotfiles/bash_scripts/restart_pmanager.sh"
endfunctio

function RunPython()
    write
    execute "!python3 " . "%"
endfunctio

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

