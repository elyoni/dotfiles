local function git_or_files()
    local is_git = vim.fn.system("git rev-parse --is-inside-work-tree"):match("^true")
    if is_git then
        require('telescope.builtin').git_files()
    else
        require('telescope.builtin').find_files()
    end
end


return {
    'nvim-telescope/telescope.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        "sopa0/telescope-makefile",
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            -- This will not install any breaking changes.
            -- For major updates, this must be adjusted manually.
            version = "^1.0.0",
        },
    },
    --builtin.grep_string
    keys = {
        { '<leader>fg', "<cmd>Telescope live_grep_args<CR>", desc = "Live grep" },
        { '<leader>ff', "<cmd>Telescope find_files<CR>",     desc = "Find file" },
        {
            '<C-p>',
            git_or_files,
            desc = "Find file (Git fallback to regular files)"
        },
        {
            '<C-f>',
            "<cmd>Telescope grep_string<CR>",
            desc = "Find Word",
            mode = {
                "v", "n" }
        },
        --{ '<leader>fb', "<cmd>Telescope buffers<CR>",      desc = "Buffers list" },
        { '<leader>fn', "<cmd>Telescope buffers<CR>",        desc = "Buffers list" },
        { '<leader>fh', "<cmd>Telescope search_history<CR>", desc = "Search History" },
        { '<leader>gs', "<cmd>Telescope git_status<CR>",     desc = "Git Status" },
        { '<leader>gl', "<cmd>Telescope git_commits<CR>",    desc = "Git Log" },
        { '<leader>gm', "<cmd>Telescope git_branches<CR>",   desc = "Git Branchs" },

    },
    config = function()
        local telescope = require("telescope")
        telescope.load_extension("live_grep_args")
    end,
    init = function()
        require('telescope').setup {
            defaults = {
                mappings = {
                    n = {
                        ['<C-d>'] = require('telescope/actions').delete_buffer + require('telescope/actions').move_to_top
                    },
                    i = {
                        ['<del>'] = require('telescope/actions').delete_buffer + require('telescope/actions').move_to_top
                    }
                },
            },
            pickers = {
                live_grep = {
                    file_ignore_patterns = { 'node_modules', '.git/', '.venv' },
                    additional_args = { '--hidden' },
                },
                grep_string = {
                    file_ignore_patterns = { 'node_modules', '.git/', '.venv' },
                    additional_args = { '--hidden' },
                },
                find_files = {
                    file_ignore_patterns = { 'node_modules', '.git/', '.venv' },
                    hidden = true
                },
                git_files = {
                    show_untracked = true,
                    --recurse_submodules = true,
                },

            },
        }
        require 'telescope'.load_extension('make')
    end
}
