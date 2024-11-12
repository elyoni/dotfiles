local colorsOneDark = {
    black       = '#000000',
    fg          = '#F0F0F0',
    purple      = '#D070F0',
    green       = "#20E040",
    yellow      = '#F0D020',
    yellow_soft = '#C0E080',
    cyan        = '#50E0F9',
    cyan2       = '#a8f1e6', --  # --  #
    grey        = '#708090',
    light_grey  = '#A0C0C0',
    dark_cyan   = '#008090',
    dark_orange = '#B09000',
    diff_add    = '#003010',
    diff_delete = '#700000',
    diff_change = '#000060',
    diff_text   = '#500060',
}
return {
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {
        style = 'deep',
        transparent = true,
        term_colors = false,
        colors = colorsOneDark,
        highlights = {
            DiffDelete = { fg = colorsOneDark.gray, bg = colorsOneDark.diff_delete },
            IncSearch = { fg = colorsOneDark.black, bg = colorsOneDark.cyan, bold = true },
            CurSearch = { fg = colorsOneDark.black, bg = colorsOneDark.cyan, bold = true },
            Search = { fg = colorsOneDark.black, bg = colorsOneDark.yellow, bold = false },
            LineNr = { fg = colorsOneDark.dark_cyan },
            MatchParen = { fg = colorsOneDark.black, bg = colorsOneDark.purple },
            String = { fg = colorsOneDark.yellow_soft, fmt = 'bold' },
            ['@string'] = { fg = colorsOneDark.yellow_soft, fmt = 'bold' },
            --TSString = { fg = colorsOneDark.cyan2, fmt = 'bold' },
        },
        diagnostics = {
            darker = false,
            undercurl = false,
            background = true,
        },
    },
    init = function()
        vim.cmd [[colorscheme onedark]]
    end,
}
