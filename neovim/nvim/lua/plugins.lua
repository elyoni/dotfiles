local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options

local function my_on_attach(bufnr)
    -- local api = require "nvim-tree.api"

    -- default mappings
    --api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    -- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
    -- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

require("lazy").setup({
    {
        "folke/tokyonight.nvim",
        dependencies = {
            'nvim-lualine/lualine.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.cmd [[colorscheme tokyonight-night]]
            require('lualine').setup()
        end,
    }, {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional
    },
    cmd = "NvimTreeToggle",
    config = true,
    keys = {
        { "<C-n>",      "<cmd>NvimTreeToggle<CR>",   mode = "n" },
        { "<leader>nf", "<cmd>NvimTreeFindFile<CR>", mode = "n" },
    },
},
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    virtual = "s",
                },
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        cmd = 'TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/playground',
        },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "yaml", "rust", "c", "lua", "python", "bash" },
                highlight = { enable = false },
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
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.2',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<leader>fg', "<cmd>Telescope live_grep<CR>",    desc = "Live grep" },
            { '<leader>ff', "<cmd>Telescope find_files<CR>",   desc = "Find file" },
            { '<leader>ff', "<cmd>Telescope buffers<CR>",      desc = "Buffers list" },
            { '<leader>fe', "<cmd>Telescope file_browser<CR>", desc = "Files Explorer" },
            { '<leader>fh', "<cmd>Telescope help_tags<CR>",    desc = "Help Tags" },
        },
    },
    {
        'lervag/wiki.vim',
        init = function()
            vim.g.wiki_root = '~/wiki'
        end,

    },
    {
        'will133/vim-dirdiff',
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        },
        init = function()
            require("mason").setup()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')

            lsp.configure('pyright', {
                flags = {
                    debounce_text_changes = 150,
                }
            })

            lsp.configure('grammarly', {
                filetypes = { 'asciidoctor' },
                cmd = { "grammarly-languageserver", "--stdio" },
                init_options = { clientId = 'client_BaDkMgx4X19X9UxxYRCXZo', },
            })

            lsp.configure('ltex', {
                filetypes = { 'asciidoctor', 'vimwiki', 'markdown' },
            })

            --lsp.configure('black', { filetypes = { 'python' }, })

            lsp.configure('shfmt', {
                cmd = { "shfmt" },
                filetypes = { 'sh' },
            })

            lsp.set_preferences({
                suggest_lsp_servers = true,
                setup_servers_on_start = true,
                set_lsp_keymaps = true,
                configure_diagnostics = true,
                cmp_capabilities = true,
                manage_nvim_cmp = true,
                call_servers = 'local',
                sign_icons = {
                    error = '✘',
                    warn = '▲',
                    hint = '⚑',
                    info = ''
                }
            })

            lsp.on_attach(function(client, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                local opts = { buffer = bufnr, remap = false }
                lsp.default_keymaps({ buffer = bufnr })

                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                vim.keymap.set({ 'n', 'i' }, '<F7>',
                    '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts
                )

                vim.keymap.set({ 'n', 'x' }, '<F8>', function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000,
                    })
                end)

                -- vim.keymap.set({'n','x'}, '<K>',
                --   '<cmd>lua vim.lsp.buf.hover()<cr>', opts
                --   )
            end)
            lsp.format_mapping('gq', {
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['lua_ls'] = { 'lua' },
                    ['rust_analyzer'] = { 'rust' },
                    ['shfmt'] = { 'sh' },
                }
            })

            lsp.format_on_save({
                servers = {
                    ['lua_ls'] = { 'lua' },
                    ['rust_analyzer'] = { 'rust' },
                    ['black'] = { 'python' },
                }
            })

            lsp.setup()
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
              mapping = {
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({select = false}),

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Navigate between snippet placeholder
                ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                ['<C-b>'] = cmp_action.luasnip_jump_backward(),
              }
            })
        end,
    },
    {
        'fei6409/log-highlight.nvim',
        config = true,
    },

    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gs", "<cmd>Git status<CR>",   mode = "n" },
            { "<leader>gd", "<cmd>Git difftool<CR>", mode = "n" },
            { "<leader>gc", "<cmd>Git commit<CR>",   mode = "n" },
            { "<leader>gl", "<cmd>Git log<CR>",      mode = "n" },
            { "<leader>gb", "<cmd>Git blame<CR>",    mode = "n" },
        },
    },
    {
        'iberianpig/tig-explorer.vim',
        keys = {
            { "<leader>tT", "<cmd>TigOpenCurrentFile<CR>",    mode = "n" },
            { "<leader>tt", "<cmd>TigOpenProjectRootDir<CR>", mode = "n" },
        },
    },
    {
        'skanehira/preview-uml.vim',
        init = function()
            vim.g.preview_uml_url = 'http://localhost:8888'
        end

    },
    {
        'weirongxu/plantuml-previewer.vim',
        dependencies = {
            'tyru/open-browser.vim',
            'aklt/plantuml-syntax',
        }


    },
    {
        "Cassin01/wf.nvim",
        version = "*",
        config = function()
            require("wf").setup()
        end
    },
    { 'preservim/nerdcommenter' },
    {
        'habamax/vim-asciidoctor',
        keys = {
            { "<leader>oo", "<cmd>AsciidoctorOpenRAW<CR>",    mode = "n" },
            { "<leader>op", "<cmd>AsciidoctorOpenPDF<CR>",    mode = "n" },
            { "<leader>oh", "<cmd>AsciidoctorOpenHTML<CR>",   mode = "n" },
            { "<leader>ox", "<cmd>AsciidoctorOpenDOCX<CR>",   mode = "n" },
            { "<leader>ch", "<cmd>Asciidoctor2HTML<CR>",      mode = "n" },
            { "<leader>cp", "<cmd>Asciidoctor2PDF<CR>",       mode = "n" },
            { "<leader>cx", "<cmd>Asciidoctor2PDF<CR>",       mode = "n" },
            { "<leader>p",  "<cmd>asciidoctorpasteimage<CR>", mode = "n" },
        },
    },
}
)
