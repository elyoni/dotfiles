return {

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufEnter",
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup()
            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            open_mapping = [[F7]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
            on_close = function()
                vim.cmd("startinsert!")
            end,

        }

    },
    { "lepture/vim-jinja" },
    { "preservim/nerdcommenter" }, -- Comment functions so powerful—no comment necessary.
    { "averms/black-nvim" },       -- black formatter, python
}
