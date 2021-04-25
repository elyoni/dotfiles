local saga = require 'lspsaga'
saga.init_lsp_saga()

vim.api.nvim_set_keymap('n', '<space>ds', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>dp', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>dn', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- nnoremap('<space>e', 'vim.lsp.diagnostic.show_line_diagnostics()')
-- nnoremap('[d', 'vim.lsp.diagnostic.goto_prev()')
-- nnoremap(']d', 'vim.lsp.diagnostic.goto_next()')

-- require'lspconfig'.pyright.setup{}
require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.bashls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.cmake.setup{on_attach=require'completion'.on_attach}

require 'lspconfig'.diagnosticls.setup{
  on_attach = on_attach,
  filetypes = {"sh"},
  init_options = {
    filetypes = {
      sh = "shellcheck",
    },
    formatFiletypes = {
      sh = "shfmt"
    },
    linters = {
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = { "--format", "json", "-" },
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint"
        },
      },
    },
    formatters = {
      shfmt = {
        command = "shfmt",
        args = {"-i", "2", "-bn", "-ci", "-sr"},
      }
    }
  }
}
local lsp_status = require('lsp-status')
-- completion_customize_lsp_label as used in completion-nvim
-- Optional: customize the kind labels used in identifying the current function.
-- g:completion_customize_lsp_label is a dict mapping from LSP symbol kind 
-- to the string you want to display as a label
-- lsp_status.config { kind_labels = vim.g.completion_customize_lsp_label }

-- Register the progress handler
lsp_status.register_progress()

let g:completion_chain_complete_list = {
      \ 'default': [
      \    {'complete_items': ['lsp']},
      \    {'complete_items': ['tags']},
      \  ]}
