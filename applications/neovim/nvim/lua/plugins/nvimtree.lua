return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
        init = function()
            local function on_attach(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- Apply default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- Custom keybind: Duplicate file
                vim.keymap.set("n", "D", function()
                    local node = api.tree.get_node_under_cursor()
                    if node and node.type == "file" then
                        local source = node.absolute_path
                        vim.ui.input({ prompt = "Duplicate to: ", default = source }, function(dest)
                            if dest and dest ~= "" and dest ~= source then
                                vim.fn.system({ "cp", source, dest })
                                api.tree.reload()
                                vim.notify("Duplicated to: " .. dest)
                            end
                        end)
                    else
                        vim.notify("Please select a file to duplicate", vim.log.levels.WARN)
                    end
                end, opts("Duplicate file"))
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
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
                    local api = require("nvim-tree.api")
                    if api.tree.is_visible() then
                        local nvim_tree_winid = api.tree.winid()
                        if vim.fn.win_getid() == nvim_tree_winid then
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
