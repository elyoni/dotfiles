
function! TelescopeSettings()
    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <C-p> <cmd>Telescope git_files<cr>
    " nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fe <cmd>Telescope file_browser<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>

    nnoremap <leader>gc <cmd>Telescope git_commits<cr>
    nnoremap <leader>gb <cmd>Telescope git_branches<cr>
    nnoremap <leader>gs <cmd>Telescope git_status<cr>
    nnoremap <C-f> <cmd>Telescope grep_string<cr>
    vnoremap <C-f> <cmd>Telescope grep_string<cr>

endfunction

function! TelescopeWhichKeyFile()
    return {
                \ 'name': '+telescope_file',
                \}
endfunction

function! TelescopeWhichKeyGit()
    return {
                \ 'name': '+telescope_git',
                \}
endfunction

" if PlugLoaded("telescope.nvim")
call TelescopeSettings()
" endif



" Using lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
