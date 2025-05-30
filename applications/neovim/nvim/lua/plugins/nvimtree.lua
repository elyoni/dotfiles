return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
        init = function()
            require("nvim-tree").setup({
                git = {
                    enable = false
                },
                filesystem_watchers = {
                    enable = false
                },
                auto_reload_on_write = true,
                update_focused_file = {
                    enable = true,
                    update_root = {
                        enable = false,
                        ignore_list = {},
                    },
                },
                view = {
                    number = true,
                    relativenumber = true,
                },
                filters = {
                    git_ignored = false,
                    dotfiles = false,
                    git_clean = false,
                    no_buffer = false,
                    custom = {},
                    exclude = {},
                },
            })
        end,
        keys = {
            {
                "<leader>nn",
                mode = "n",
                function()
                    require("nvim-tree.api").tree.toggle({ focus = true })
                end
            },
            {
                "<C-n>",
                mode = "n",
                function()
                    -- Place this in your init.lua or nvim-tree config
                    local nvimtree_view = require("nvim-tree.view")
                    if nvimtree_view.is_visible() then
                        if vim.fn.win_getid() == nvimtree_view.get_winnr() then
                            vim.cmd("wincmd p") -- go to previous window
                        else
                            require("nvim-tree.api").tree.focus()
                        end
                    else
                        require("nvim-tree.api").tree.open()
                        require("nvim-tree.api").tree.focus()
                    end
                end
            },
        },
    },
}
