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

--local function my_on_attach(bufnr)
-- local api = require "nvim-tree.api"

-- default mappings
--api.config.mappings.default_on_attach(bufnr)

-- custom mappings
-- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
-- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
--end

function custom_gvdiffsplit()
    local num_commits = vim.fn.input("Enter the number of commits to diff (default is 1): ", "1")
    vim.cmd("Gvdiffsplit HEAD~" .. num_commits)
end

local colors = {
    black        = '#000000',
    white        = '#FFFFFF',
    brightyellow = '#FFFF00',
    mediumcyan   = '#70C0F0',
    darkestblue  = '#002070',
    brightred    = '#F00000',
    darkred      = '#600000',
    brightorange = '#FF9000',
    darkorange   = '#301000',
    gray1        = '#101010',
    gray4        = '#404040',
    gray8        = '#808080',
}

local theme = {
    normal = {
        a = { fg = colors.black, bg = colors.brightyellow, gui = 'bold' },
        b = { fg = colors.white, bg = colors.gray4 },
        c = { fg = colors.white, bg = colors.gray1 },
    },
    insert = {
        a = { fg = colors.black, bg = colors.white, gui = 'bold' },
        b = { fg = colors.black, bg = colors.mediumcyan },
        c = { fg = colors.white, bg = colors.darkestblue },
    },
    visual = {
        a = { fg = colors.black, bg = colors.brightorange, gui = 'bold' },
        c = { fg = colors.white, bg = colors.darkorange },
    },
    replace = {
        a = { fg = colors.white, bg = colors.brightred, gui = 'bold' },
        c = { fg = colors.white, bg = colors.darkred },
    },
    inactive = {
        a = { fg = colors.gray1, bg = colors.gray8, gui = 'bold' },
        b = { fg = colors.gray1, bg = colors.gray4 },
        c = { fg = colors.gray8, bg = colors.gray1 },
    },
}

theme.terminal = theme.insert

local sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 3 }, '%S' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
}

--return {
--}




local colorsOneDark = {
    black       = '#000000',
    fg          = '#F0F0F0',
    purple      = '#D070F0',
    green       = "#20E040",
    yellow      = '#F0D020',
    yellow_soft = '#C0E080',
    cyan        = '#50E0F9',
    cyan2       = '#a8f1e6', --  # --  #
    grey        = '#708090',
    light_grey  = '#A0C0C0',
    dark_cyan   = '#008090',
    dark_orange = '#B09000',
    diff_add    = '#003010',
    diff_delete = '#700000',
    diff_change = '#000060',
    diff_text   = '#500060',
}


require("lazy").setup({
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = { theme = theme },
            sections = sections,
            inactive_sections = sections,
        }
    },
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        opts = {
            style = 'deep',
            transparent = true,
            term_colors = false,
            colors = colorsOneDark,
            highlights = {
                DiffDelete = { fg = colorsOneDark.gray, bg = colorsOneDark.diff_delete },
                IncSearch = { fg = colorsOneDark.black, bg = colorsOneDark.cyan, bold = true },
                CurSearch = { fg = colorsOneDark.black, bg = colorsOneDark.cyan, bold = true },
                Search = { fg = colorsOneDark.black, bg = colorsOneDark.yellow, bold = false },
                LineNr = { fg = colorsOneDark.dark_cyan },
                MatchParen = { fg = colorsOneDark.black, bg = colorsOneDark.purple },
                String = { fg = colorsOneDark.yellow_soft, fmt = 'bold' },
                ['@string'] = { fg = colorsOneDark.yellow_soft, fmt = 'bold' },
                --TSString = { fg = colorsOneDark.cyan2, fmt = 'bold' },
            },
            diagnostics = {
                darker = false,
                undercurl = false,
                background = true,
            },
        },
        init = function()
            vim.cmd [[colorscheme onedark]]
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
    {
        'nvim-pack/nvim-spectre',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }

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
        lazy = false,
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
    },
    {
        'will133/vim-dirdiff',
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        --@type Flash.Config
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
            vim.cmd [[ syntax on ]]
            vim.g.vimwiki_auto_chdir = 1 -- Change directory to root Vimwiki folder on opening page
        end,
        --keys = {
        --    --{ "<leader>wgt", "<cmd>VimwikiGenerateTagLink<CR>", desc = "Update vimwiki tags" },
        --    --{ "<leader>aa", "<cmd>VimwikiSearchTags<CR>", desc = "Search vimwiki tags" },
        --},
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
            local lspconfig = require('lspconfig')
            lspconfig.pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = { 'E501,W503,W504' },
                                maxLineLength = 100
                            }
                        }
                    }
                }
            })

            lsp.preset('recommended')

            lsp.configure('grammarly', {
                filetypes = { 'asciidoctor' },
                cmd = { "grammarly-languageserver", "--stdio" },
                init_options = { clientId = 'client_BaDkMgx4X19X9UxxYRCXZo', },
            })

            lsp.configure('golangci_lint_ls', {
                root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
            })

            lsp.configure('ltex', {
                filetypes = { 'asciidoctor', 'vimwiki', 'markdown' },
            })

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
        "ojroques/nvim-osc52",
        config = function()
            require("osc52").setup {
                max_length = 0, -- Maximum length of selection (0 for no limit)
                silent = false, -- Disable message on successful copy
                trim = false,   -- Trim surrounding whitespaces before copy
            }
            local function copy()
                if ((vim.v.event.operator == "y" or vim.v.event.operator == "d")
                        and vim.v.event.regname == "") then
                    require("osc52").copy_register("")
                end
            end

            vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufEnter",
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup()
            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[<F4>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
            on_close = function()
                vim.cmd("startinsert!")
            end,

        }

    }
}
)

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'JK', [[<Cmd>q<CR>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    --vim.cmd.startinsert
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local function extract_tasks(yaml_content)
    local tasks = {}
    local in_tasks_section = false

    for line in yaml_content:gmatch("[^\n]+") do
        if not in_tasks_section then
            -- Check if the line contains "tasks:"
            if line:match("^%s*tasks:%s*$") then
                in_tasks_section = true
            end
        else
            local indent, key = line:match("(%s*)(%S+)%s*:%s*(.*)")
            vim.notify("Indent: " .. vim.inspect(indent) .. " Key: " .. vim.inspect(key))

            if indent == nil then
                -- Not a key-value pair, ignore
                vim.notify("Ignoring line: " .. line)
            elseif #indent == 2 then
                -- Top-level key-value pair after "tasks:"
                if key ~= nil and not key:find("^#") then
                    table.insert(tasks, key)
                    vim.notify("Adding task: " .. key)
                end
                vim.notify("Ignoring line2: " .. line)
                --else
                --    -- End of "tasks" section
                --    break
            end
        end
    end

    return tasks
end

local conf         = require("telescope.config").values
local actions      = require "telescope.actions"
local action_state = require "telescope.actions.state"
local function tusk_telescope()
    --local commands_list = tasks
    local file = io.open('tusk.yml', 'r')
    if file == nil then
        vim.notify("No tusk.yml file found")
        return
    end
    local yaml_content = file:read('*all')
    file:close()

    vim.cmd("wall")

    local tasks = extract_tasks(yaml_content)
    table.insert(tasks, "test --type lint")

    require("telescope.pickers").new({}, {
        prompt_title = "Tusk",
        finder = require("telescope.finders").new_table({
            results = tasks
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd("tabnew term://tusk " .. selection[1] .. " | startinsert")
            end)
            return true
        end,
    }):find()
end

vim.keymap.set("n", "<C-t>", function() tusk_telescope() end,
    { desc = "Open tusk window" })
-- basic telescope configuration
--
