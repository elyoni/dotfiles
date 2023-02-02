local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -----------------------------

    -- LSP-ZERO - notworking
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use {
        "ms-jpq/chadtree",
        branch = "chad",
        run = 'python3 -m chadtree deps',
        config = {
            vim.api.nvim_set_keymap("n", "<C-n>", ":CHADopen<CR>", {})
        }
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        'habamax/vim-asciidoctor'
    }

    -- use {
    --     "folke/noice.nvim",
    --     event = "VimEnter",
    --     config = function()
    --         require("noice").setup()
    --     end,
    --     requires = {
    --         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     }
    -- }


    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'kdheepak/lazygit.nvim',
        config = { vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", {}) }
    }

    use {
        'tpope/vim-fugitive',
        config = {
            vim.api.nvim_set_keymap("n", "<leader>gs", ":Git status<CR>", {}),
            vim.api.nvim_set_keymap("n", "<leader>gd", ":Git difftool<CR>", {}),
            vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", {}),
            vim.api.nvim_set_keymap("n", "<leader>gl", ":Git log<CR>", {}),
            vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", {}),
        },
        requires = {
            {
                'shumphrey/fugitive-gitlab.vim',
                setup = function ()
                    vim.g.fugitive_gitlab_domains = 'https://gitlab.solaredge.com'
                    vim.g.gitlab_api_keys = "{'gitlab.solaredge.com': 'mPjW9aXaqUBueDQ6HAPy'}"
                end
            }
        }
        -- requires = {
        --     {
        --         'shumphrey/fugitive-gitlab.vim',
        --         setup = function () vim.g.fugitive_gitlab_domains = ['https://gitlab.solaredge.com']  end
        --     }
        -- }
    }
    
    use {
        'iberianpig/tig-explorer.vim',

        config = {
            -- open tig with current file
            vim.api.nvim_set_keymap("n", "<leader>tT", ":TigOpenCurrentFile<CR>", {}),
            -- open tig with Project root path
            vim.api.nvim_set_keymap("n", "<leader>tt", ":TigOpenProjectRootDir<CR>", {}),
        }
    }

    use {
        'vimwiki/vimwiki',
        setup = function () -- load stuff before the plugin is loaded
            vim.g.vimwiki_auto_chdir = 1
        end

    }

    -- use {
    --     'skanehira/preview-uml.vim',
    --     setup = function () -- load stuff before the plugin is loaded
    --         vim.g.preview_uml_url = 'http://localhost:8888'
    --     end
    -- }

    use {
        'weirongxu/plantuml-previewer.vim',
        requires = {
            {'tyru/open-browser.vim'},
            {'aklt/plantuml-syntax'}
        }
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end

end)

