vim.api.nvim_command('source $HOME/.config/nvim/general/utils_init.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/plugins.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/settings.vim')
vim.api.nvim_command('source $HOME/.config/nvim/general/commands.vim')
vim.api.nvim_command('source $HOME/.config/nvim/keys/mappings.vim')

require('lsp.server_config')
