return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-treesitter/playground',
    },
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = { "yaml", "rust", "c", "lua", "python", "bash", "go", "markdown" },
            highlight = { enable = true },
            autopairs = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
            -- disable python and typescript indentation until fixed:
            --   https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issue-853914044
            indent = {
                enable = true,
                disable = { "python", "typescript", "javascript" },
            },
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = { ["<leader>a"] = "@parameter.inner" },
                    swap_previous = { ["<leader>A"] = "@parameter.inner" },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = { ["]]"] = "@function.outer" },
                    goto_previous_start = { ["[["] = "@function.outer" },
                },
            }
        }
    end,
}
