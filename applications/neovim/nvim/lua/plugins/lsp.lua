return  {
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

            lsp.configure('clangd', {
                init_options = { fallbackFlags = "-I .. -std=c++17 " },
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
}
