function custom_gvdiffsplit()
    local num_commits = vim.fn.input("Enter the number of commits to diff (default is 1): ", "1")
    vim.cmd("Gvdiffsplit HEAD~" .. num_commits)
end

return {
    {
        'will133/vim-dirdiff',
    },
    {
        "NeogitOrg/neogit",
        version = "v0.0.1",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
        },
        keys = {
            { '<leader>gs', "<cmd>Neogit<CR>", desc = "Neogit" },
        },
        config = function()
            local neogit = require("neogit")
            --neogit.setup {
            neogit.setup {
                mappings = {
                    status = {
                        ["<enter>"] = "Toggle",
                        ["o"] = "GoToFile",
                        ["y"] = "YankSelected", --Copy the commit sha
                    },
                },
                --},
            }
        end
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        keys = {
            --{ "<leader>gs", "<cmd>Git status<CR>",  mode = "n" },
            { "<leader>gdc", "<cmd>Gvdiffsplit<CR>",              mode = "n" },
            { "<leader>gdl", "<cmd>Gvdiffsplit HEAD~1<CR>",       mode = "n" },
            { "<leader>gdn", "<cmd>lua custom_gvdiffsplit()<CR>", mode = "n" },
            { "<leader>gc",  "<cmd>Git commit<CR>",               mode = "n" },
            --{ "<leader>gl",  "<cmd>Gclog<CR>",                    mode = "n" },
            { "<leader>gb",  "<cmd>Git blame<CR>",                mode = "n" },
        },
    },
    {
        'iberianpig/tig-explorer.vim',
        dependencies = {
            'rbgrouleff/bclose.vim',
        },
        init = function()
            vim.g.tig_explorer_enable_mappings = 0
            vim.g.tig_explorer_keymap_edit = 'o'
        end,
        keys = {
            { "<leader>tT", "<cmd>TigOpenCurrentFile<CR>",    mode = "n" },
            { "<leader>tt", "<cmd>TigOpenProjectRootDir<CR>", mode = "n" },
            { "<leader>tb", "<cmd>TigBlame<CR>",              mode = "n" },
        },
    },

}
