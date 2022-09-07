function! VimGrammarousSettings()
endfunction

function! VimGrammarousWhichKey()
    return {
                \ 'g': ['<leader>zg', 'GrammarousCheck'],
                \}
endfunction

if PlugLoaded("vim-grammarous")
    call VimGrammarousSettings()
endif
