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
    --{
    --"folke/tokyonight.nvim",
    --dependencies = {
    --'nvim-lualine/lualine.nvim',
    --'nvim-tree/nvim-web-devicons',
    --},
    --init = function()
    --vim.cmd [[colorscheme tokyonight-night]]
    --require('lualine').setup()
    --end,
    --},
    --
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        dependencies = {
            'nvim-lualine/lualine.nvim',
        },
        init = function()
            vim.cmd.colorscheme "catppuccin"
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                transparent_background = false,
            })
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                }
            }
        end,
    },
    {
        "toppair/peek.nvim",
        event = { "BufRead", "BufNewFile" },
        build = "/home/yehonatan/.deno/bin/deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
        cmd = "NvimTreeToggle",
        init = function()
            require("nvim-tree").setup({
                auto_reload_on_write = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                    ignore_list = {},
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
            { "<C-n>",      "<cmd>NvimTreeToggle<CR>",   mode = "n" },
            { "<leader>nf", "<cmd>NvimTreeFindFile<CR>", mode = "n" },
        },
    },
    {
        'chentoast/marks.nvim',
        init = function()
            require("marks").setup {
                -- whether to map keybinds or not. default true
                default_mappings = true,
                -- which builtin marks to show. default {}
                builtin_marks = { ".", "<", ">", "^" },
                -- whether movements cycle back to the beginning/end of buffer. default true
                cyclic = true,
                -- whether the shada file is updated after modifying uppercase marks. default false
                force_write_shada = false,
                -- how often (in ms) to redraw signs/recompute mark positions.
                -- higher values will have better performance but may cause visual lag,
                -- while lower values may cause performance penalties. default 150.
                refresh_interval = 250,
                -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
                -- marks, and bookmarks.
                -- can be either a table with all/none of the keys, or a single number, in which case
                -- the priority applies to all marks.
                -- default 10.
                sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
                -- disables mark tracking for specific filetypes. default {}
                excluded_filetypes = {},
                -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
                -- sign/virttext. Bookmarks can be used to group together positions and quickly move
                -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
                -- default virt_text is "".
                bookmark_0 = {
                    sign = "⚑",
                    virt_text = "hello world",
                    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
                    -- defaults to false.
                    annotate = false,
                },
                mappings = {}
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    visual = "m",
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
                ensure_installed = { "yaml", "rust", "c", "lua", "python", "bash", "go" },
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
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        --builtin.grep_string
        keys = {
            { '<leader>fg', "<cmd>Telescope live_grep<CR>",    desc = "Live grep" },
            { '<leader>ff', "<cmd>Telescope find_files<CR>",   desc = "Find file" },
            { '<leader>fF', "<cmd>Telescope git_files<CR>",    desc = "Find file git" },
            { '<C-p>',      "<cmd>Telescope find_files<CR>",   desc = "Find file" },
            { '<C-f>',      "<cmd>Telescope grep_string<CR>",  desc = "Find Word",     mode = { "v", "n" } },
            { '<leader>fb', "<cmd>Telescope buffers<CR>",      desc = "Buffers list" },
            { '<leader>fe', "<cmd>Telescope file_browser<CR>", desc = "Files Explorer" },
            { '<leader>fh', "<cmd>Telescope help_tags<CR>",    desc = "Help Tags" },
        },
    },
    {
        'lervag/wiki.vim',
        init = function()
            vim.g.wiki_root = '~/wiki'
        end,
        --keys = {
        --{ '<leader>wt', "<cmd>WikiTagList<CR>",    desc = "Open Tags List" },
        --},

    },
    {
        'will133/vim-dirdiff',
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            search = {
                multi_window = false,
            },
            modes = {
                search = {
                    enabled = false,
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            --{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            --{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            --{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
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

            --lsp.configure('shfmt', {
            --cmd = { "shfmt" },
            --filetypes = { 'sh' },
            --})

            local lua_runtime_path = vim.split(package.path, ";")
            lsp.configure("lua_ls", {
                settings = {
                    Lua = {
                        telemetry = { enable = false },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { "vim" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = {
                                vim.fn.expand("$VIMRUNTIME/lua"),
                                vim.fn.stdpath("config") .. "/lua",
                            },
                        },
                    },
                },
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
                    ['gopls'] = { 'go' },
                }
            })

            lsp.setup()
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                mapping = {
                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

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
