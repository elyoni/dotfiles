return {

    {
        "epwalsh/pomo.nvim",
        version = "*", -- Recommended, use latest release instead of latest commit
        lazy = true,
        cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
        dependencies = {
            -- Optional, but highly recommended if you want to use the "Default" timer
            "rcarriga/nvim-notify",
        },
        opts = {
            -- See below for full list of options 👇
        },
        init = function()
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
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
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        --Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        event = {
            -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
            -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
            -- refer to `:h file-pattern` for more examples
            "BufReadPre " .. vim.fn.expand "~" .. "/.obsidian/private/*.md",
            "BufNewFile " .. vim.fn.expand "~" .. "/.obsidian/private/*.md",
            "BufReadPre " .. vim.fn.expand "~" .. "/.obsidian/work/*.md",
            "BufNewFile " .. vim.fn.expand "~" .. "/.obsidian/work/*.md",
        },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        keys = {
            {
                "<leader>oow",
                function()
                    local obsidian = require("obsidian")
                    local client = obsidian.get_client()
                    if client then
                        client:switch_workspace("work") -- Replace "work" with your workspace name
                        print("Switched to workspace: work")
                    else
                        print("Error: Obsidian client not initialized.")
                    end
                end,
                desc = "Switch to Work Workspace"
            },
            {
                "<leader>oop",
                function()
                    local obsidian = require("obsidian")
                    local client = obsidian.get_client()
                    if client then
                        client:switch_workspace("private")
                        print("Switched to workspace: private")
                    else
                        print("Error: Obsidian client not initialized.")
                    end
                end,
                desc = "Switch to Work Workspace"
            },
            --{ "<leader>oow", "<cmd>lua require('obsidian').set_workspace('work')<CR>", desc = "Switch to Work Workspace" },
            { "<leader>on", "<cmd>ObsidianNew<CR>",   desc = "New Note" },
            { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Todays Note" },
            { "<leader>ow", "<cmd>ObsidianToday<CR>", desc = "Todays Note" },
            { "<leader>ot", "<cmd>ObsidianTags<CR>",  desc = "Open obsidian tags" },
        },
        opts = {
            workspaces = {
                {
                    name = "private",
                    path = "~/.obsidian/private",
                    strict = true,
                },
                {
                    name = "work",
                    path = "~/.obsidian/work",
                    strict = true,
                },
            },
            callbacks = {
                post_set_workspace = function(client, workspace)
                    -- Change the working directory to the current workspace's path
                    local new_cwd = workspace.path and workspace.path.filename or nil
                    if new_cwd then
                        -- Change the working directory to the new workspace path
                        vim.cmd("cd " .. new_cwd)
                        print("Changed working directory to: " .. new_cwd)
                    else
                        print("Error: Workspace path is invalid or nil.")
                    end
                end,
            },
            -- see below for full list of options 👇
        },
    },

    --{
    --    "epwalsh/obsidian.nvim",
    --    version = "*", -- recommended, use latest release instead of latest commit
    --    --lazy = true,
    --    ft = "markdown",
    --    dependencies = {
    --        -- Required.
    --        "nvim-lua/plenary.nvim",
    --        -- see below for full list of optional dependencies 👇
    --    },
    --    config = function()
    --        require("obsidian").setup({
    --            dir = "/home/yoni/.obsidian/notes/", -- Expand '~' to the full path
    --        })
    --    end,
    --    mappings = {
    --        -- overrides the 'gf' mapping to work on markdown/wiki links within your vault
    --        ["gf"] = {
    --            action = function()
    --                return require("obsidian").util.gf_passthrough()
    --            end,
    --            opts = { noremap = false, expr = true, buffer = true },
    --        },
    --        --toggle check-boxes
    --        ["<leader>ch"] = {
    --            action = function()
    --                return require("obsidian").util.toggle_checkbox()
    --            end,
    --            opts = { buffer = true },
    --        },
    --    },
    --    keys = {
    --        { "<leader>oo", "<cmd>cd $HOME/.obsidian/notes | e main.md<CR>", desc = "New Note" },
    --        { "<leader>on", "<cmd>ObsidianNew<CR>",                          desc = "New Note" },
    --        { "<leader>od", "<cmd>ObsidianToday<CR>",                        desc = "Todays Note" },
    --    },
    --    opts = {
    --        workspaces = {
    --            {
    --                name = "main",
    --                path = "$HOME/.obsidian/notes/main",
    --            },
    --            {
    --                name = "work",
    --                path = "$HOME/.obsidian/notes/work",
    --            },
    --        },
    --        picker = { name = "telescope.nvim" },
    --    },
    --},
}
