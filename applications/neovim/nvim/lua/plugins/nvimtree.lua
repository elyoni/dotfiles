return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
        init = function()
            require("nvim-tree").setup({
                auto_reload_on_write = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                    ignore_list = {},
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
                    require("nvim-tree.api").tree.toggle({ focus = false })
                end
            },
            {
                "<leader>nn",
                mode = "n",
                function()
                    require("nvim-tree.api").tree.toggle({ focus = true })
                end
            },
        },
    },
}
