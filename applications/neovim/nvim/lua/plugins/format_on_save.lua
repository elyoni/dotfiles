return {
    "elentok/format-on-save.nvim",
    config = function()
        local format_on_save = require("format-on-save")
        local formatters = require("format-on-save.formatters")

        --local message_buffer = require("format-on-save.error-notifiers.message-buffer")


        format_on_save.setup({
            experiments = {
                partial_update = 'diff', -- or 'line-by-line'
            },

            --error_notifier = message_buffer,
            formatter_by_ft = {
                css = formatters.lsp,
                html = formatters.lsp,
                java = formatters.lsp,
                javascript = formatters.lsp,
                go = formatters.lsp,
                json = formatters.lsp,
                lua = formatters.lsp,
                nix = formatters.nixfmt,
                markdown = formatters.prettierd,
                openscad = formatters.lsp,
                python = formatters.black,
            },
            python = {
                formatters.remove_trailing_whitespace,
                formatters.black,
            },
            fallback_formatter = {
                formatters.remove_trailing_whitespace,
                formatters.remove_trailing_newlines,
            },

        })
    end,
}
