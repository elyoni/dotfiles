"Default actions
    "move around like in any vim buffer
    "<CR> or o on .. will cd in the above directory
    "<C-]> will cd in the directory under the cursor
    "<BS> will close current opened directory or parent
    "type a to add a file. Adding a directory requires leaving a leading / at the end of the path.

        "you can add multiple directories by doing foo/bar/baz/f and it will add foo bar and baz directories and f as a file

    "type r to rename a file
    "type <C-r> to rename a file and omit the filename on input
    "type x to add/remove file/directory to cut clipboard
    "type c to add/remove file/directory to copy clipboard
    "type p to paste from clipboard. Cut clipboard has precedence over copy (will prompt for confirmation)
    "type d to delete a file (will prompt for confirmation)
    "type ]c to go to next git item
    "type [c to go to prev git item
    "type '-' to naviate up to the parent directory of the current file/directory
    "if the file is a directory, <CR> will open the directory otherwise it will open the file in the buffer near the tree
    "if the file is a symlink, <CR> will follow the symlink (if the target is a file)
    "<C-v> will open the file in a vertical split
    "<C-x> will open the file in a horizontal split
    "<C-t> will open the file in a new tab
    "<Tab> will open the file as a preview (keeps the cursor in the tree)
    "I will toggle visibility of folders hidden via |g:nvim_tree_ignore|
    "H will toggle visibility of dotfiles (files/folders starting with a .)
    "R will refresh the tree
    "Double left click acts like <CR>
    "Double right click acts like <C-]>
    "
if PlugLoaded("nvim-tree.lua")
    let g:nvim_tree_side = 'left' "right
    let g:nvim_tree_width = 40 "30 by default
    let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
    " let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
    " let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
    " let g:nvim_tree_auto_ignore_ft = {'startify', 'dashboard'} "empty by default, don't auto open tree on specific filetypes.
    let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
    " let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
    let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
    let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
    let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
    let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
    " let g:nvim_tree_tab_open = 0 "0 by default, will open the tree when entering a new tab and the tree was previously open
    let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
    " let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
    " let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
    let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
    let g:nvim_tree_show_icons = {
        \ 'git': 1,
        \ 'folders': 1,
        \ 'files': 1,
        \ }
    "If 0, do not show the icons for one of 'git' 'folder' and 'files'
    "1 by default, notice that if 'files' is 1, it will only display
    "if nvim-web-devicons is installed and on your runtimepath

    " default will show icon by default if no icon is provided
    " default shows no icon by default
    let g:nvim_tree_icons = {
        \ 'default': '',
        \ 'symlink': '',
        \ 'git': {
        \   'unstaged': "✗",
        \   'staged': "✓",
        \   'unmerged': "",
        \   'renamed': "➜",
        \   'untracked': "★"
        \   },
        \ 'folder': {
        \   'default': "",
        \   'open': "",
        \   'empty': "",
        \   'empty_open': "",
        \   'symlink': "",
        \   }
        \ }

    nnoremap <C-n> :NvimTreeToggle<CR>
    nnoremap <leader>r :NvimTreeRefresh<CR>
    nnoremap <leader>n :NvimTreeFindFile<CR>
    " NvimTreeOpen and NvimTreeClose are also available if you need them

    set termguicolors " this variable must be enabled for colors to be applied properly

    " a list of groups can be found at `:help nvim_tree_highlight`
    highlight NvimTreeFolderIcon guibg=blue
endif
