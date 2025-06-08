function git_diff_last_change()
    local file = vim.fn.expand("%")
    local cmd = "git log -n 2 --pretty=format:%H -- " .. file .. " | sed -n 2p"
    local handle = io.popen(cmd)

    if handle == nil then
        vim.notify("Failed to get Git commit for file: " .. file, vim.log.levels.ERROR)
        return
    end

    local commit = handle:read("*a")
    handle:close()

    if commit and commit ~= "" then
        vim.notify("Gvdiffsplit " .. commit)
        vim.cmd("Gvdiffsplit " .. commit)
    else
        vim.notify("No previous commit found for file: " .. file, vim.log.levels.WARN)
    end
end

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
            { "<leader>gdc", "<cmd>Gvdiffsplit<CR>",                mode = "n" },
            { "<leader>gdl", "<cmd>lua git_diff_last_change()<CR>", mode = "n" },
            { "<leader>gdn", "<cmd>lua custom_gvdiffsplit()<CR>",   mode = "n" },
            { "<leader>gc",  "<cmd>Git commit<CR>",                 mode = "n" },
            --{ "<leader>gl",  "<cmd>Gclog<CR>",                    mode = "n" },
            { "<leader>gb",  "<cmd>Git blame<CR>",                  mode = "n" },
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
