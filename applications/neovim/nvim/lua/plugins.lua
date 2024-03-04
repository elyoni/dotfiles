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
                dim_inactive = {
                    enabled = true,    -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
            })
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                }
            }
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            plugins = {
                -- disable some global vim options (vim.o...)
                -- comment the lines to not apply the options
                options = {
                    enabled = true,
                    ruler = false,             -- disables the ruler text in the cmd line area
                    showcmd = false,           -- disables the command in the last line of the screen
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                gitsigns = { enabled = true }, -- enable git signs
                tmux = { enabled = false },    -- disables the tmux statusline
                -- this will change the font size on kitty when in zen mode
                -- to make this work, you need to set the following kitty options:
                -- - allow_remote_control socket-only
                -- - listen_on unix:/tmp/kitty
                kitty = {
                    enabled = true,
                    font = "+20", -- font size increment
                },
            },
        },
        keys = {
            { "<leader>vz", "<cmd>ZenMode<CR>", mode = "n" },
        },
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
    --{
    --'tools-life/taskwiki',
    --dependencies = {
    --'powerman/vim-plugin-AnsiEsc',
    --'majutsushi/tagbar',
    --'farseer90718/vim-taskwarrior',
    --},
    --},
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
        "elentok/format-on-save.nvim",
        config = function()
            local format_on_save = require("format-on-save")
            local formatters = require("format-on-save.formatters")

            --local message_buffer = require("format-on-save.error-notifiers.message-buffer")


            format_on_save.setup({
                experiments = {
                    partial_update = 'diff', -- or 'line-by-line'
                },

                --error_notifier = message_buffer,
                formatter_by_ft = {
                    css = formatters.lsp,
                    html = formatters.lsp,
                    java = formatters.lsp,
                    javascript = formatters.lsp,
                    json = formatters.lsp,
                    lua = formatters.lsp,
                    markdown = formatters.prettierd,
                    openscad = formatters.lsp,
                    python = formatters.black,
                },
                python = {
                    formatters.remove_trailing_whitespace,
                    formatters.black,
                },
                fallback_formatter = {
                    formatters.remove_trailing_whitespace,
                    formatters.remove_trailing_newlines,
                },

            })
        end,
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
                mappings = {
                    n = {
                        ['<x>'] = require('telescope/actions').delete_buffer
                    }, -- n
                    i = {
                        ['<c-e>'] = require('telescope/actions').delete_buffer
                    } -- i
                },
                pickers = {
                    live_grep = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        additional_args = function(_)
                            return { "--hidden" }
                        end
                    },
                    find_files = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        hidden = true
                    },
                },
            }
        end
    },
    --{
    --'lervag/wiki.vim',
    --init = function()
    --vim.g.wiki_root = '~/wiki'
    --end,
    ----keys = {
    ----{ '<leader>wt', "<cmd>WikiTagList<CR>",    desc = "Open Tags List" },
    ----},

    --},
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
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    { "averms/black-nvim" },
    {
        "vimwiki/vimwiki",
        init = function()
            vim.cmd [[set nocompatible ]]
            --vim.cmd [[filetype plugin on ]]
            vim.cmd [[ syntax on]]
        end,
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

            --lsp.configure('pyright', {
            --flags = {
            --debounce_text_changes = 150,
            --}
            --})

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
                vim.keymap.set({ 'i' }, '<C-h>',
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
                    ['autopep8'] = { 'python' },
                    ['black'] = { 'python' },
                }
            })

            lsp.format_on_save({
                servers = {
                    ['lua_ls'] = { 'lua' },
                    ['rust_analyzer'] = { 'rust' },
                    ['autopep8'] = { 'python' },
                    ['gopls'] = { 'go' },
                    ['black'] = { 'python' },
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
        "NeogitOrg/neogit",
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
        config = true
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
        keys = {
            --{ "<leader>gs", "<cmd>Git status<CR>",  mode = "n" },
            { "<leader>gd", "<cmd>Gvdiffsplit<CR>", mode = "n" },
            { "<leader>gc", "<cmd>Git commit<CR>",  mode = "n" },
            { "<leader>gl", "<cmd>Gclog<CR>",       mode = "n" },
            { "<leader>gb", "<cmd>Git blame<CR>",   mode = "n" },
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
    {
        'preservim/nerdcommenter',
    },
    {
        'tigion/nvim-asciidoc-preview',
        ft = { 'asciidoc' },
        keys = {
            { "<leader>ap", "<cmd>AsciiDocPreview<CR>",       mode = "n" },
            { "<leader>as", "<cmd>AsciiDocPreviewStop<CR>",   mode = "n" },
            { "<leader>ao", "<cmd>AsciiDocPreviewOpen<CR>",   mode = "n" },
            { "<leader>an", "<cmd>AsciiDocPreviewNotify<CR>", mode = "n" },
        },
        -- opts = {},
    },
    --{
    --'github/copilot.vim',
    ----keys = {
    ----{ "<C-l>", "<cmd>copilot#Accept()<CR>", mode = "i" },
    ----},
    --init = function()
    --vim.g.copilot_assume_mapped = true
    --vim.g.copilot_no_tab_map = true
    --end
    --},
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },
    { "lepture/vim-jinja" },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 5,
                    keymap = {
                        accept = "<C-l>",
                        accept_word = "<M-l>",
                        accept_line = false,
                        next = "<C-j>",
                        prev = "<C-k>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = true,
                },
            })
        end,

    },
    {
        "jellydn/CopilotChat.nvim",
        opts = {
            show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
            debug = false,     -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
        keys = {
            { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
            { "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
            {
                "<leader>ccv",
                ":CopilotChatVisual",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>ccx",
                ":CopilotChatInPlace<cr>",
                mode = "x",
                desc = "CopilotChat - Run in-place code",
            },
        },
    },



}
)

--local builtin = require('telescope.builtin')
--builtin.git_commits
