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
                    enable = false,
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
                "<C-n>",
                mode = "n",
                function()
                    require("nvim-tree.api").tree.toggle({ focus = true })
                end
            },
            {
                "<leader>nn",
                mode = "n",
                function()
                    require("nvim-tree.api").tree.toggle({ focus = false })
                end
            },
        },
    },
}
