if PlugLoaded("vimwiki")

    if PlugLoaded("vim-which-key")
        let g:which_key_map = get(g:, 'which_key_sep', {})
        let g:which_key_map['w'] = { 'name' : 'Vimwiki' }
    endif
    let g:vimwiki_auto_chdir = 1
endif
