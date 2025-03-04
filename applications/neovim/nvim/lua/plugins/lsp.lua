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
            local lspconfig = require('lspconfig')
            local lsp_defaults = lspconfig.util.default_config
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            lspconfig.lua_ls.setup {
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
            }


            lspconfig.ltex.setup({
                cmd = { "ltex-ls" },
                on_attach = function(client, bufnr)
                    -- your other on_attach code
                    -- for example, set keymaps here, like
                    -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    -- (see below code block for more details)
                    require("ltex-utils").on_attach(bufnr)
                end,
                settings = {
                    ltex = {
                        language = "en-US",
                        disabledRules = {
                            ["en-US"] = {
                                "WHITESPACE_RULE", -- Ensure that the whitespace rule is disabled for en-US
                            }
                        },
                        additionalRuleFiles = {}, -- If you have any custom rules, specify them here
                    },
                },
            })

            --lspconfig.ltex.setup {
            --    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/ltex-ls") },
            --    settings = {
            --        ltex = {
            --            language = "en",
            --            disabledRules = { ["en-US"] = { "WHITESPACE_RULE" } },
            --        },
            --    },
            --}

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

            require('mason-lspconfig').setup({
                ensure_installed = { "lua_ls", "ltex" }, -- Add more servers as needed
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })
        end
    },
    {
        "jhofscheier/ltex-utils.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            -- "nvim-telescope/telescope-fzf-native.nvim", -- optional
        },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
}
