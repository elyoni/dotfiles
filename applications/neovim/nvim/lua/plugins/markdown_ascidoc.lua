return {
    {
        "toppair/peek.nvim",
        event = { "BufRead", "BufNewFile" },
        build = "/home/yehonatan/.deno/bin/deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreview<CR>", mode = "n" },
        },
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function()
            vim.g.mkdp_browser = '/usr/bin/microsoft-edge'
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
        end,
    },
    {
        "davidgranstrom/nvim-markdown-preview",
        ft = "markdown",
        build = "cd app && npm install",
    },
    {
        "barrett-ruth/live-server.nvim",
        config = function()
            require("live-server").setup({
                port = 9090,
                browser = "firefox", -- or your preferred browser
            })
        end,
    },
    {
        'tigion/nvim-asciidoc-preview',
        ft = { 'asciidoc' },
        keys = {
            { "<leader>ap", "<cmd>AsciiDocPreview<CR>",       mode = "n" },
            { "<leader>as", "<cmd>AsciiDocPreviewStop<CR>",   mode = "n" },
            { "<leader>ao", "<cmd>AsciiDocPreviewOpen<CR>",   mode = "n" },
            { "<leader>an", "<cmd>AsciiDocPreviewNotify<CR>", mode = "n" },
        },
        -- opts = {},
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
}
