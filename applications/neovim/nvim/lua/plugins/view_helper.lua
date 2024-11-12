return {
    {
        "folke/zen-mode.nvim",
        opts = {
            plugins = {
                -- disable some global vim options (vim.o...)
                -- comment the lines to not apply the options
                options = {
                    enabled = true,
                    ruler = false,             -- disables the ruler text in the cmd line area
                    showcmd = false,           -- disables the command in the last line of the screen
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                gitsigns = { enabled = true }, -- enable git signs
                tmux = { enabled = false },    -- disables the tmux statusline
                -- this will change the font size on kitty when in zen mode
                -- to make this work, you need to set the following kitty options:
                -- - allow_remote_control socket-only
                -- - listen_on unix:/tmp/kitty
                kitty = {
                    enabled = true,
                    font = "+20", -- font size increment
                },
            },
        },
        keys = {
            { "<leader>vz", "<cmd>ZenMode<CR>", mode = "n" },
        }
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },
    {
        'fei6409/log-highlight.nvim',
        config = true,
    },

    -- Which key like
    -- { 
    --     "Cassin01/wf.nvim",
    --     version = "*",
    --     config = function()
    --         require("wf").setup()
    --     end
    -- },

}
