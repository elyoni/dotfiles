" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Use alt + hjkl to resize windows
nnoremap <A-j> :resize -2<CR>
nnoremap <A-k> :resize +2<CR>
nnoremap <A-h> :vertical resize -2<CR>
nnoremap <A-l> :vertical resize +2<CR>

" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>

" Add a space in normal mode
nnoremap ss i<space><esc>

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

tmap <C-l> <Esc><C-W><Right>
tmap <C-h> <Esc><C-W><Left>
tmap <C-k> <Esc><C-W><Up>
tmap <C-j> <Esc><C-W><Down>

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
noremap dl ]c 
noremap dh [c 

" Cancel the insasaly annoying copy paste
vnore p "_dP
vnore P "_dp
xnoremap p "_dP
xnoremap P "_dp
