vim.api.nvim_command('source $HOME/.config/nvim/general/utils_init.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/plugins.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/settings.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/commands.vim')
vim.api.nvim_command('source $HOME/.config/nvim/keys/mappings.vim')


require("nvim-surround").setup()
require('telescope')
--.load_extension('vimwiki')
require('lsp/lsp-zero')
require('lsp/lsp-cmp')
require('plugins')
-- require('treesitter')
-- vim.api.nvim_command('source $HOME/.config/nvim/general/wiki_settings.vim')

vim.g.wiki_root = "~/wiki"
-- vim.g.wiki_link_creation = { "adoc" = { "link_type" = "adoc_xref_bracket", "url_extension" = "" } }
vim.g.wiki_link_creation = {
    adoc = {
        link_type = "adoc_xref_bracket",
        url_extension = ""
    }
}


-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', '<C-t>',     api.tree.toggle_help,                  opts('Help'))
end

vim.keymap.set('n', '<C-n>',   ":NvimTreeToggle<CR>", {})

-- OR setup with some options
require("nvim-tree").setup({
  on_attach = my_on_attach,
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
