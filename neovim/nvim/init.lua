vim.api.nvim_command('source $HOME/.config/nvim/general/utils_init.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/plugins.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/settings.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/commands.vim')
vim.api.nvim_command('source $HOME/.config/nvim/keys/mappings.vim')
vim.api.nvim_set_keymap("n", "<C-n>", ":CHADopen<CR>", {})


require('keymaps')
require('lsp/lsp-zero')
-- require('lsp/lsp-cmp')
require('plugins')
require('treesitter')
