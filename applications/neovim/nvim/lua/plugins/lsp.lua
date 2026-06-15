return
{
    {
        'williamboman/mason.nvim',
        lazy = false,
        opts = {},
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        opts = { autoformat = false },
        init = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            -- Get default capabilities from cmp_nvim_lsp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Configure lua_ls
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }, -- Recognize 'vim' as a global variable
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
                        },
                        telemetry = {
                            enable = false, -- Disable telemetry for privacy
                        },
                    },
                },
            })

            -- Configure harper-ls (lightweight Rust-based grammar checker)
            vim.lsp.config('harper_ls', {
                capabilities = capabilities,
                filetypes = { "markdown", "tex", "bib" },
                settings = {
                    ["harper-ls"] = {
                        linters = {
                            spell_check = true,
                            sentence_capitalization = false,
                        },
                    },
                },
            })

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            --
            --lspconfig.pylsp.setup({
            --settings = {
            --pylsp = {
            --plugins = {
            --pycodestyle = {
            --ignore = { 'E501,W503,W504' },
            --maxLineLength = 100
            --}
            --}
            --}
            --}
            --})


            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                    vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end,
            })

            -- Configure pyright
            vim.lsp.config('pyright', {
                capabilities = capabilities,
                settings = {
                    pyright = {
                        -- Optional: configure pyright settings here
                    },
                    python = {
                        analysis = {
                            -- Optional: configure analysis settings
                            typeCheckingMode = "basic", -- "off", "basic", "strict"
                        },
                    },
                },
            })

            require('mason-lspconfig').setup({
                ensure_installed = { "lua_ls", "harper_ls", "pyright" }, -- Add more servers as needed
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        vim.lsp.config(server_name, {
                            capabilities = require('cmp_nvim_lsp').default_capabilities()
                        })
                    end,
                }
            })
        end
    },
}
