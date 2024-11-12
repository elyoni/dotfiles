return {

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    {
        "vimwiki/vimwiki",
        init = function()
            vim.cmd [[set nocompatible ]]
            --vim.cmd [[filetype plugin on ]]
            vim.cmd [[ syntax on ]]
            vim.g.vimwiki_auto_chdir = 1 -- Change directory to root Vimwiki folder on opening page
        end,
        --keys = {
        --    --{ "<leader>wgt", "<cmd>VimwikiGenerateTagLink<CR>", desc = "Update vimwiki tags" },
        --    --{ "<leader>aa", "<cmd>VimwikiSearchTags<CR>", desc = "Search vimwiki tags" },
        --},
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        --lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",
            -- see below for full list of optional dependencies 👇
        },
        mappings = {
            -- overrides the 'gf' mapping to work on markdown/wiki links within your vault
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            -- toggle check-boxes
            -- ["<leader>ch"] = {
            --   action = function()
            --     return require("obsidian").util.toggle_checkbox()
            --   end,
            --   opts = { buffer = true },
            -- },
        },
        keys = {
            { "<leader>oo", "<cmd>cd $HOME/.obsidian/work | e main.md<CR>", desc = "New Note" },
            { "<leader>on", "<cmd>ObsidianNew<CR>",                         desc = "New Note" },
            { "<leader>od", "<cmd>ObsidianToday<CR>",                       desc = "Todays Note" },
        },
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/.obsidian/work",
                },
            },
        },
    },
}
