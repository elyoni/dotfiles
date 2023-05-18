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
    filetypes = { 'asciidoctor', 'vimwiki' },
})

lsp.configure('black', {
    filetypes = { 'python' },
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



  local opts = {buffer = bufnr, remap = false}
  lsp.default_keymaps({buffer = bufnr})

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  vim.keymap.set({'n', 'i'}, '<F7>',
      '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts
      )

  vim.keymap.set({'n', 'x'}, '<F8>', function()
    vim.lsp.buf.format({async = false, timeout_ms = 10000})
  end)

  -- vim.keymap.set({'n','x'}, '<K>',
  --   '<cmd>lua vim.lsp.buf.hover()<cr>', opts
  --   )
end)

lsp.format_on_save({
  servers = {
    ['lua_ls'] = {'lua'},
    ['rust_analyzer'] = {'rust'},
    ['black'] = {'python'},
  }
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = true,
})

