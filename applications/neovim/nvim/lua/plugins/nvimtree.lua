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
                    -- Modern nvim-tree API (compatible with latest versions)
                    local api = require("nvim-tree.api")
                    
                    -- Check if nvim-tree is open by looking for the buffer
                    local nvim_tree_buf = nil
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_get_option(buf, 'filetype') == 'NvimTree' then
                            nvim_tree_buf = buf
                            break
                        end
                    end
                    
                    if nvim_tree_buf and vim.fn.bufwinnr(nvim_tree_buf) ~= -1 then
                        -- NvimTree is visible
                        if vim.api.nvim_get_current_buf() == nvim_tree_buf then
                            vim.cmd("wincmd p") -- go to previous window
                        else
                            api.tree.focus()
                        end
                    else
                        -- NvimTree is not visible
                        api.tree.open()
                        api.tree.focus()
                    end
                end
            },
        },
    },
}
