return {
    'nvim-telescope/telescope.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    --builtin.grep_string
    keys = {
        { '<leader>fg', "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
        { '<leader>ff', "<cmd>Telescope find_files<CR>", desc = "Find file" },
        { '<C-p>',      "<cmd>Telescope git_files<CR>",  desc = "Find file git" },
        {
            '<C-f>',
            "<cmd>Telescope grep_string<CR>",
            desc = "Find Word",
            mode = {
                "v", "n" }
        },
        --{ '<leader>fb', "<cmd>Telescope buffers<CR>",      desc = "Buffers list" },
        { '<leader>fn', "<cmd>Telescope buffers<CR>",   desc = "Buffers list" },
        { '<leader>fh', "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    },
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
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    additional_args = { '--hidden' },
                },
                find_files = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    hidden = true
                },
                git_files = {
                    show_untracked = true,
                    --recurse_submodules = true,
                },

            },
        }
    end
}
