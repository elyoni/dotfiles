if PlugLoaded("rnvimr")
    tnoremap <silent> <C-n> <C-\><C-n>:RnvimrResize<CR>
    nnoremap <silent> <C-n> :RnvimrToggle<CR>
    tnoremap <silent> <C-n> <C-\><C-n>:RnvimrToggle<CR>

    " Make Ranger replace Netrw and be the file explorer
    let g:rnvimr_enable_ex = 1

    " Make Ranger to be hidden after picking a file
    let g:rnvimr_enable_picker = 1

    " Make Neovim wipe the buffers corresponding to the files deleted by Ranger
    let g:rnvimr_enable_bw = 1
endif

