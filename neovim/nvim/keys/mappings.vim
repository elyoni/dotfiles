" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" View
" " Use alt + hjkl to resize windows
nnoremap <A-j> :resize -2<CR>
nnoremap <A-k> :resize +2<CR>
nnoremap <A-h> :vertical resize -2<CR>
nnoremap <A-l> :vertical resize +2<CR>
" " window options
nnoremap <leader>vf <C-w><bar>
nnoremap <leader>ve <C-w>=


" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>
tnoremap <C-k><C-j> <C-\><C-n>

" Add a space in normal mode
nnoremap ss i<space><esc>

" Add a quotes around word in visual mode
" vnoremap "" c""<Esc>"*


" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>
nnoremap bd :bd<CR>

" Easy save
map <C-s> :w<CR>

" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Better window navigation
nnoremap <C-l> <C-W><Right>
nnoremap <C-h> <C-W><Left>
nnoremap <C-k> <C-W><Up>
nnoremap <C-j> <C-W><Down>

imap <C-l> <Esc><C-W><Right>
imap <C-h> <Esc><C-W><Left>
imap <C-k> <Esc><C-W><Up>
imap <C-j> <Esc><C-W><Down>

tmap <C-l> <C-\><C-n><C-W><Right>
tmap <C-h> <C-\><C-n><C-W><Left>
tmap <C-k> <C-\><C-n><C-W><Up>
tmap <C-j> <C-\><C-n><C-W><Down>

" Prevent from entering visual mode
map Q <Nop>

" Disable mark CAPS
"vmap u <nop>
"vmap U <nop>


" Spelling
nnoremap zt :set spell!<CR>
nnoremap zl ]s
nnoremap zh [s

" Easy Diff
" " Set diff this
nnoremap dt :diffthis<CR>

" " Diff jump
nnoremap dj ]c 
nnoremap dk [c 

" Cancel the insasaly annoying copy paste
vnore p "_dP
vnore P "_dp
xnoremap p "_dP
xnoremap P "_dp

" To print the file type execute `:set filetype?`
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType rust map <buffer> <leader>r :w<CR>:exec '!cargo run'<CR>
autocmd FileType rust map <buffer> <leader>ir :w<CR>:terminal cargo run<CR>
autocmd FileType rust map <buffer> <leader>cr :w<CR>:exec '!cargo check'<CR>
:tnoremap <Esc> <C-\><C-n>
