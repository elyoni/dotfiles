return {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup()
        vim.keymap.set("x", "m", "<Plug>(nvim-surround-visual)")
        vim.keymap.set("n", "ms", "<Plug>(nvim-surround-normal)")
    end
}
