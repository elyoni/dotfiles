set guicursor=
"set spell
colors colosus
hi Normal ctermbg=none guibg=none
set encoding=utf8
set shell=/usr/bin/zsh


"general settings
set number "Add number line
set tabstop=4		" tab will insert 4 space
set shiftwidth=4	" when indeting the '>', use 4 space
set expandtab		" on pressing tab, insert 4 spaces

set hlsearch        " Highlight the word when search
set incsearch       " Start search in realtime
set clipboard=unnamed,unnamedplus " Copy/Paste directly to System/X11 clipboard


" To install the Plug just write in normal mode ":PlugInstall"
call plug#begin()

Plug 'vimwiki/vimwiki'                  "Wiki for vim

"Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ozelentok/vim-closer'             "Auto close brackets
Plug 'ryanoasis/vim-devicons'           "Add icons

"Files navigate helper
Plug '/usr/local/opt/fzf'               "Smart complelete
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'kien/ctrlp.vim'                   " Easy Jump between files
Plug 'skywind3000/asyncrun.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'scrooloose/nerdtree'

"Edit UML Graphs
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'

"git
Plug 'tpope/vim-fugitive'               " For git
Plug 'airblade/vim-gitgutter'           " Show symbols on change/remove/add line


"Code plugins
Plug 'scrooloose/nerdcommenter'     "Add comments to file, Toggles the comment state: <leader>c<space>
Plug 'neomake/neomake'              " Give errors to the code

"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}


"Plug 'neoclide/coc.nvim', {'branch': 'release'}  " auto complete
"Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-jedi', {'do': 'yarn install'}
"Plug 'neoclide/coc-python'

Plug 'sheerun/vim-polyglot'         " A plugin that adds syntax highlighting for almost any language you can think of
"Plug 'vim-syntastic/syntastic'
Plug 'huawenyu/neogdb.vim'          " Debug for GDBSERVER
"Plug 'kiteco/vim-plugin'

"Mist
Plug 'fedorenchik/VimCalc3'         "To run the calc type :Calc
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'leiserfg/qalc.vim', {'do': ':UpdateRemotePlugins' }



"Plug 'tweekmonster/deoplete-clang2'    " Oz - deoplete-clang 2 is the new plugin - just install the 'clang' package
"Plug 'zchee/deoplete-jedi'
"
"Plug 'davidhalter/jedi-vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'vifm/vifm.vim'
Plug 'wincent/ferret'               "Multifile search and replace
Plug 'francoiscabrol/ranger.vim'
"Plug 'vim-scripts/Conque-GDB'
"Plug 'sakhnik/nvim-gdb', { 'do': './install.sh' }
"Plug 'lifepillar/vim-mucomplete'
Plug 'majutsushi/tagbar'
"Plug 'ncm2/ncm2'
"Plug 'roxma/nvim-yarp'

"Plug 'ncm2/ncm2-bufword'
"Plug 'ncm2/ncm2-path'

call plug#end()

" enable ncm2 for all buffers
"autocmd BufEnter * call ncm2#enable_for_buffer()

"" IMPORTANT: :help Ncm2PopupOpen for more information
"set completeopt=noinsert,menuone,noselect


" keys

""noremap <Up> <NOP>
""noremap <Down> <NOP>
""noremap <Left> <NOP>
""noremap <Right> <NOP>

":ia td #YE TODO 
:map Q <Nop>

map <C-n> :NERDTreeToggle<CR>
map <S-B> ^<CR>
map <C-s> :w<CR>
"map <C-k>  <PageUp> 
"map <C-j>  <PageDown> 
"map . :call DoNothing()<CR>
vmap u <nop>
vmap U <nop>
map ' <nop>
"map <C-A-S-R> :call SearchAndReplace()<CR>
"map <F3> :call RunScript()<CR>
map <F4> :call RunBashScript()<CR>
map <F3> :call RunPython()<CR>

"This map is the same as <S-F3>
map <F15> :call CheckPython()<CR>
map <Leader><F3> :call RunPythonWithArgs()<CR>
"map <F4> :call CompileTheCore()<CR>
map <F5> :call SmartF5()<CR>
map <F17> :call SmartShiftF5()<CR>
"map <F17> :call UploadPythonToPorita()<CR>
map <F6> :call UpdatePoritaIP()<CR>
"map <F6> :call CpToPorita()<CR>
map <F9> :call SearchEveryWhere()<CR>
map <F12> :call CurtineIncSw()<CR>
"map <F7> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --verify % <CR>
"map <F8> :w <bar> :!~/Downloads/arduino-1.6.13/arduino --upload % <CR>
nmap <F8> :TagbarToggle<CR>

nmap <C-g>s :Gstatus<CR>
nmap <C-g>d :Gdiff<CR>
nmap <C-g>c :Gcommit<CR>
nmap <C-g>b :Gblame<CR>
nmap <C-S-f> :Rg<CR>
"vmap <C-S-f> :y:@" y:@"<CR>

imap <C-l> <Esc><C-W><Right>
imap <C-h> <Esc><C-W><Left>
imap <C-k> <Esc><C-W><Up>
imap <C-j> <Esc><C-W><Down>

tmap <C-l> <Esc><C-W><Right>
tmap <C-h> <Esc><C-W><Left>
tmap <C-k> <Esc><C-W><Up>
tmap <C-j> <Esc><C-W><Down>

" resize horzontal split window
nmap <C-S-Up>  <C-W>-<C-W>-
nmap <C-S-Down>   <C-W>+<C-W>+
"nmap <C-S-k>  <C-W>-<C-W>-
"nmap <C-S-J>   <C-W>+<C-W>+
" resize vertical split window
nmap <C-S-Right> <C-W>><C-W>>
nmap <C-S-Left> <C-W><<C-W><
"nmap <C-S-h> <C-W>><C-W>>
"nmap <C-S-l> <C-W><<C-W><

nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>

nnoremap z] ]s
nnoremap z[ [s

nnoremap zt :set spell!<CR>


" Open the tag in split window
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

":tnoremap <Esc> <C-\><C-n>

nmap <C-l> <C-W><Right>
nmap <C-h> <C-W><Left>
nmap <C-k> <C-W><Up>
nmap <C-j> <C-W><Down>


command W w
command Wqa wqa
command Wq wq
command Q q
command Qa qa
command SearchAll call SearchEveryWhere()
command Lab call LabSplit()
command Ter call Ter()
command DelFile call delete(expand('%')) | bdelete!
command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis


"Copy settings
set ignorecase      "Cancel the case sensative
set smartcase


vnore p "_dP     " Cancel the insasaly annoying copy paste
vnore P "_dp     " Cancel the insasaly annoying copy paste
xnoremap p "_dP
xnoremap P "_dp

set nowrap        " Disable wrap line
" Tags

function CreateTags()
    set tags=tags
    "call Gctag()
    let workdir = getcwd()
    if (workdir =~ "lab")
        set tags=~/projects/lab/tags,~/projects/tools/lib/tags
    elseif (workdir =~ "tools")
        set tags=~/projects/tools/lib/tags
    elseif (workdir =~ "pmanager")
        set tags=~/projects/sources/apps/pmanager/tags
    elseif (workdir =~ "core")
        set tags=~/projects/sources/apps/core/tags,~/projects/sources/libs/mqttc/tags
    endif
endfunctio

autocmd VimEnter * call CreateTags()

"map <C-[> :tselect<CR>

autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
" <F10> :split verifyOutput <bar> :read !~/Downloads/arduino-1.6.13/arduino --verify % <CR>

nnore <c-b> <nop>

"Python
let g:python_host_prog = "/usr/bin/python2.7"
"let g:python3_host_prog = "/usr/bin/python3.4"
let g:python3_host_prog = "/usr/bin/python3.8"

set completeopt-=preview
set completeopt+=longest,menuone,noselect
let g:jedi#popup_on_dot = 0  " It may be 1 as well
let g:mucomplete#enable_auto_at_startup = 0

" disable autocompletion, cause we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"


" deoplete.vim
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#enable_ignore_case = 1
"let g:deoplete#auto_completion_start_length = 0
"let g:min_pattern_length = 0

set completeopt+=menuone

"autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>
autocmd CompleteDone * pclose " To close preview window of deoplete automagically
autocmd FileType vimwiki setlocal spell wrap

let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'

"airline
let g:airline#extensions#tabline#formatter = 'unique_tail'
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create(['%3p%%', 'linenr', 'maxlinenr', '%3v'])
let g:airline_section_x = ''
let g:airline_section_y = ''
"let g:airline_detect_whitespace=0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string=''

let g:airline_mode_map = {
    \ '__' : '-',
    \ 'n'  : 'Norm',
    \ 'i'  : 'Index',
    \ 'R'  : 'Repl',
    \ 'c'  : 'C',
    \ 'v'  : 'Vis',
    \ 'V'  : 'Vis',
    \ '' : 'V',
    \ 's'  : 'S',
    \ }


set grepprg=Rg\ --nogroup\ --nocolor
" " ripgrep
" if executable('rg')
"   " Use rg over grep
"   set grepprg=rg\ --nogroup\ --nocolor
" 
"   " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
"   let g:ctrlp_user_command = 'rg %s -l --nocolor -g ""'
" 
"   " rg is fast enough that CtrlP doesn't need to cache
"   let g:ctrlp_use_caching = 0
" endif

"command! -bang -nargs=* Rg
"  \ call fzf#vim#grep(
"  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
"  \   <bang>0 ? fzf#vim#with_preview('up:60%')
"  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"  \   <bang>0)

" Likewise, Files command with preview window
"
"command! -bang -nargs=? -complete=dir Files
  "\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

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
:syntax keyword ColorColumn porita



"highlight question cterm=bold,undercurl ctermbg=9 gui=undercurl guibg=DarkRed
highlight question ctermfg=196 guifg=#E85848 guibg=#461E1A 
call matchadd('question',"^\?.*")
highlight ans ctermfg=117 gui=bold guifg=fg 
call matchadd('ans',"^\!.*")

" === syntastic ===
"let g:syntastic_python_python_exec='/usr/bin/python3'
"let g:syntastic_python_checkers=['pylint']
"let g:syntastic_python_pylint_exec='/usr/bin/pylint3'
"let g:syntastic_python_checker_args = '--ignore=E1004'
"let g:syntastic_python_pylint_post_args="--max-line-length=120"
"; import sys; sys.path.append('/home/yoni/projects/tools/lib')"

" ==== NeoMake ====
" When writing a buffer.
call neomake#configure#automake('w')
" When writing a buffer, and on normal mode changes (after 750ms).
"call neomake#configure#automake('nw', 1)
" When reading a buffer (after 1s), and when writing.
"call neomake#configure#automake('rw', 5)
"let g:neomake_open_list = 2
let g:neomake_open_list = 0
let g:neomake_python_enable_makers = ['pylint3']
let g:neomake_python_pylint_exe = 'pylint3'
let g:neomake_python_pylint3_maker = {
    \ 'args': ['--ignore=D103', '--max-line-length=120']
    \}
let g:neomake_python_pycodestyle_maker = { 'args': ['--ignore=E402', '--max-line-length=120'] }

"highlight onit ctermfg=0 ctermbg=214 guifg=#000000 guibg=#C0A25F
"call matchadd('onit',".*onit.*")
"
"highlight ygye cterm=bold ctermfg=16 ctermbg=186 gui=bold,underline guifg=#cae682 guibg=#363946 
"call matchadd('ygye',".*yg-ye.*")
"call matchadd('ygye',".*ygye.*")

" === ctrlp plug in ===
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"let g:ctrlp_custom_ignore = {
  "\ 'dir':  '\v[\/]\.(git|hg|svn)$',
  "\ 'file': '\v\.(exe|so|dll)$',
  "\ 'link': 'some_bad_symbolic_links',
  "\ }
" =====================

function UploadPythonToPorita()
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    echo "Portia IP Json: " .ip
    execute '!bash ~/projects/sources/apps/pmanager/sync-python.sh ~/projects/proto '. ip
endfunction

function SearchAndReplace()
    let search = input("What To Replace>")
    let replace = input("Replace With   >")
    execute ":%s/" . search . "/" . replace . "/gc"
endfunctio

function Se()
    let search = input("Search:@func,any: ")
    execute ":vimgrep /" . search . "/ **"
    copen
endfunctio

function SearchRG(word)
    execute Rg a:word
endfunction

function RunBashScript()
    write
    execute "!bash " . "%"
endfunctio

function UploadToPortia()
    write
    let ip=system("echo $PORTIA_IP")
    echo "Portia IP: " .ip
    execute "!bash " .  $HOME . "/.dotfiles/work_script/sync_file_to_protia.sh " . "%:p"
endfunction

function UpdatePoritaIP()
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    echo "Portia IP Json: " .ip
    let ip=input("IP>")
    if ip != ""
        execute '!python3.4 ~/projects/tools/configure.py -i ' . ip . ' -p 80'
        "execute '!echo ' . ip . ' > ~/.ipPortia.txt'
        let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
        echo "Portia IP Json: " .ip
    endif
endfunction

function DoNothing()
endfunctio

function SmartF5()
    let workdir = getcwd()
    let ip=system("echo $PORTIA_IP")
    if (getcwd() =~ "core")
        let workdir = split(getcwd(), 'core')[0]
        let run=workdir . "core/sync-core.sh -l ~/projects/sources/libsuite -i " . ip
        set splitbelow
        new
        call termopen(run)
        startinsert
    elseif (getcwd() =~ "pmanager")
        call UploadToPortia()
    endif
endfunctio

function SmartShiftF5()
    let workdir = getcwd()
    let ip=system("jq -r '.ip' < ~/projects/tools/configurations.json")
    if (getcwd() =~ "core")
        let workdir = split(getcwd(), 'core')[0]
        let run=workdir . "core/sync-core.sh -p ~/projects/proto -i " . ip
        set splitbelow
        new
        call termopen(run)
        startinsert
    elseif (getcwd() =~ "pmanager")
        let workdir = split(getcwd(), 'pmanager')[0]
        let run=workdir . "pmanager/sync-python.sh -p ~/projects/proto -i " . ip . "-r"
    endif
endfunction

function Gctag()
    if (getcwd() =~ "core")
        let workdir = split(getcwd(), 'core')[0] . "core/"
        let cmd="!ctags -R -f " . workdir . "tags ". $LIBSUITE_PATH ."/include " . $CORE_DIR
        execute cmd
    elseif (getcwd() =~ "pmanager")
        let workdir = split(getcwd(), 'pmanager')[0] . "pmanager/"
        let cmd="!ctags -R -f " . workdir . "tags"
        AsyncRun cmd
    elseif (getcwd() =~ "lab")
        let workdir = split(getcwd(), 'lab')[0] . "lab/"
        let cmd="!ctags -R " . $LAB_DIR . " ". $TOOLS_DIR ."/lib " 
        echo cmd
    endif
endfunction

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

function Ter()
    set splitbelow
    1sp terminal
endfunction

function RestartPmanager()
    execute "!bash " . $HOME . "/.dotfiles/bash_scripts/restart_pmanager.sh"
endfunc

function RunPython()
    write
    "execute "!python3.4 " . "%"
    execute "!./" . "%"
endfunc

function CheckPython()
    write
    echo "\n~~~~~~Check Python code with pyflakes~~~~~~"
    echo "\n"
    execute "!pyflakes " . "%"
endfunction


function RunPythonWithArgs()
    write
    let args = input("Enter Your Args>")
    echo "\n"
    execute "!python3.4 " . "% " . args
endfunction

    
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
function RunScript()


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

command! -nargs=+ MyCommand :call MyFunction(<f-args>)
let s:dictionary = {}

function! Srg(...)
    let myString = ""
    for arg in a:000
      myString = myString . arg
   endfor
   echo myString
endfunction


command! -nargs=* DN :call DisplayName(<f-args>)
function DisplayName(...)
    let rgSearch = ""
    for i in a:000
        let rgSearch = rgSearch . " " . i
    endfor
    let rgSearch = substitute(rgSearch, '(', '\\(', 'g')
    let rgSearch = substitute(rgSearch, ')', '\\)', 'g')
    execute Rg rgSearch
endfunction

" =============== fzf ===============
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
let g:fzf_history_dir = '~/.local/share/fzf-history'
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
"let g:neomake_python_enabled_makers = ['pylint3']
"let g:neomake_python_pylint_exe = 'pylint3'
"let g:neomake_python_pylint_maker = {
"    \ 'args': ['--ignore=W213,W23']
"    \}
"
nmap <C-p> :GFiles<CR>
nmap <S-p> :Files<CR>


" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

"" Use <TAB> to select the popup menu:
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
            \ 'name' : 'css',
            \ 'priority': 9,
            \ 'subscope_enable': 1,
            \ 'scope': ['css','scss'],
            \ 'mark': 'css',
            \ 'word_pattern': '[\w\-]+',
            \ 'complete_pattern': ':\s*',
            \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
            \ })
