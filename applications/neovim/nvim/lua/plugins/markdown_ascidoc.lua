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
        "nvim-treesitter/nvim-treesitter",
        dependencies = { "OXY2DEV/markview.nvim" },
        lazy = false,

        -- ... All other options.
    },
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("markview").setup({
                -- Enable Hebrew/RTL text support
                modes = { "n", "i", "no", "c" },
                hybrid_modes = { "i" },

                -- Fix Hebrew font rendering
                callbacks = {
                    on_enable = function()
                        vim.wo.conceallevel = 2
                        vim.wo.concealcursor = "nc"
                    end
                },

                -- Improve Hebrew text handling
                block_quotes = {
                    enable = true,
                    default = {
                        border = "▌",
                        hl = "MarkviewBlockQuoteDefault"
                    }
                },

                -- Better list rendering for RTL text
                list_items = {
                    enable = true,
                    shift_width = 2,
                    indent_size = 2
                },

                -- Improved heading rendering
                headings = {
                    enable = true,
                    shift_width = 0
                },

                -- Fix inline code rendering with Hebrew text
                inline_codes = {
                    enable = true,
                    corner_right = " ",
                    corner_left = " ",
                    hl = "MarkviewInlineCode"
                }
            })
        end
    },
}
