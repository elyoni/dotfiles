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
        build = "cd app && npm install",
        config = function()
            local browsers = {
                '/usr/bin/google-chrome',
                '/usr/bin/google-chrome-stable',
                '/usr/local/bin/firefox',
                '/usr/bin/firefox',
            }
            vim.g.mkdp_browser = ''
            for _, browser in ipairs(browsers) do
                if vim.fn.executable(browser) == 1 then
                    vim.g.mkdp_browser = browser
                    break
                end
            end
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            -- Debug: echo preview URL so you see something when it works
            vim.g.mkdp_echo_preview_url = 1
            -- Optional: enable plugin debug log (set before opening a markdown buffer / running command)
            -- vim.env.NVIM_MKDP_LOG_FILE = vim.fn.expand("~") .. "/mkdp-log.log"
            -- vim.env.NVIM_MKDP_LOG_LEVEL = "debug"
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
            vim.g.live_server = {
                port = 9090,
                browser = "firefox", -- or your preferred browser
            }
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
        "nvim-treesitter/nvim-treesitter",
        lazy = false,

        -- ... All other options.
    },
    {
        "noisesfromspace/touchup.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },
}
