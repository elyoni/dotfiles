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
        init = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config

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

            -- This should be executed before you configure any language server
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

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
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })
        end
    }
}



--return {
--    {
--        init = function()
--            require("mason").setup()
--            local lsp = require('lsp-zero')
--            local lspconfig = require('lspconfig')
--            lspconfig.pylsp.setup({
--                settings = {
--                    pylsp = {
--                        plugins = {
--                            pycodestyle = {
--                                ignore = { 'E501,W503,W504' },
--                                maxLineLength = 100
--                            }
--                        }
--                    }
--                }
--            })

--            lsp.preset('recommended')

--            lsp.configure('grammarly', {
--                filetypes = { 'asciidoctor' },
--                cmd = { "grammarly-languageserver", "--stdio" },
--                init_options = { clientId = 'client_BaDkMgx4X19X9UxxYRCXZo', },
--            })

--            lsp.configure('golangci_lint_ls', {
--                root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
--            })

--            lsp.configure('clangd', {
--                init_options = { fallbackFlags = "-I .. -std=c++17 " },
--            })

--            lsp.configure('ltex', {
--                filetypes = { 'asciidoctor', 'vimwiki', 'markdown' },
--            })

--            lsp.configure("lua_ls", {
--                settings = {
--                    Lua = {
--                        telemetry = { enable = false },
--                        diagnostics = {
--                            -- Get the language server to recognize the `vim` global
--                            globals = { "vim" },
--                        },
--                        workspace = {
--                            -- Make the server aware of Neovim runtime files
--                            library = {
--                                vim.fn.expand("$VIMRUNTIME/lua"),
--                                vim.fn.stdpath("config") .. "/lua",
--                            },
--                        },
--                    },
--                },
--            })

--            lsp.set_preferences({
--                suggest_lsp_servers = true,
--                setup_servers_on_start = true,
--                set_lsp_keymaps = true,
--                configure_diagnostics = true,
--                cmp_capabilities = true,
--                manage_nvim_cmp = true,
--                call_servers = 'local',
--                sign_icons = {
--                    error = '✘',
--                    warn = '▲',
--                    hint = '⚑',
--                    info = ''
--                }
--            })

--            lsp.on_attach(function(client, bufnr)
--                local nmap = function(keys, func, desc)
--                    if desc then
--                        desc = 'LSP: ' .. desc
--                    end

--                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--                end

--                local opts = { buffer = bufnr, remap = false }
--                lsp.default_keymaps({ buffer = bufnr })

--                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--                vim.keymap.set({ 'n', 'i' }, '<F7>',
--                    '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts
--                )
--                vim.keymap.set({ 'i' }, '<C-h>',
--                    '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts
--                )

--                vim.keymap.set({ 'n', 'x' }, '<F8>', function()
--                    vim.lsp.buf.format({ async = false, timeout_ms = 10000,
--                    })
--                end)

--                -- vim.keymap.set({'n','x'}, '<K>',
--                --   '<cmd>lua vim.lsp.buf.hover()<cr>', opts
--                --   )
--            end)
--            lsp.format_mapping('gq', {
--                format_opts = {
--                    async = false,
--                    timeout_ms = 10000,
--                },
--                servers = {
--                    ['lua_ls'] = { 'lua' },
--                    ['rust_analyzer'] = { 'rust' },
--                    ['shfmt'] = { 'sh' },
--                    ['autopep8'] = { 'python' },
--                    ['black'] = { 'python' },
--                }
--            })

--            lsp.format_on_save({
--                servers = {
--                    ['lua_ls'] = { 'lua' },
--                    ['rust_analyzer'] = { 'rust' },
--                    ['autopep8'] = { 'python' },
--                    ['gopls'] = { 'go' },
--                    ['black'] = { 'python' },
--                }
--            })

--            lsp.setup()
--            local cmp = require('cmp')
--            local cmp_action = require('lsp-zero').cmp_action()

--            cmp.setup({
--                mapping = {
--                    -- `Enter` key to confirm completion
--                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

--                    -- Ctrl+Space to trigger completion menu
--                    ['<C-Space>'] = cmp.mapping.complete(),

--                    -- Navigate between snippet placeholder
--                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
--                }
--            })
--        end,
--    },
--}
