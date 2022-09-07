"airline
if PlugLoaded("vim-airline")
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
endif
