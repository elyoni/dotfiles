require'lspconfig'.ltex.setup{}

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
    filetypes = { 'asciidoctor' },
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

-- lsp.on_attach(function(client, bufnr)
--   local opts = {buffer = bufnr, remap = false}
--   local bind = vim.keymap.set
--
--   bind('n', '<Ctrl-k>', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
-- end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = true,
})

