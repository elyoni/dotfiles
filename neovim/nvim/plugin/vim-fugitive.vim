if PlugLoaded("vim-fugitive")
    nmap <C-g>s :Git status<CR>
    nmap <C-g>d :Git difftool<CR>
    nmap <C-g>c :Git commit<CR>
    nmap <C-g>b :Git blame<CR>
endif
