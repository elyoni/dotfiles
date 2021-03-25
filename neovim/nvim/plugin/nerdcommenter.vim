if PlugLoaded("nerdcommenter")
    " Create default mappings
    let g:NERDCreateDefaultMappings = 1

    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1
    " Use compact syntax for prettified multi-line comments
    let g:NERDCompactSexyComs = 1
    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'
    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_java = 1
    " Add your own custom formats or override the defaults
    let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
    " Allow commenting and inverting empty lines (useful when commenting a region)
    let g:NERDCommentEmptyLines = 1
    " Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1
    " Enable NERDCommenterToggle to check all selected lines is commented or not 
    let g:NERDToggleCheckAllLines = 1

    if PlugLoaded("vim-which-key")
       let g:which_key_map = get(g:, 'which_key_sep', {})
       let g:which_key_map.c = {
                   \ 'c': ['<leader>cc', 'Comment'],
                   \ 'n': ['<leader>cn', 'Nested Comment'],
                   \ '<space>': ['<leader>c<space>', 'Toggle Comment'],
                   \ 'y': ['<leader>cy', 'Comment and Yank'],
                   \}
    endif
endif
