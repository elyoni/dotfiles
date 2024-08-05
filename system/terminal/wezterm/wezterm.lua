local wezterm = require('wezterm')
local act = wezterm.action
-- timeout_milliseconds defaults to 1000 and can be omitted
--config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
--config.keys = {
--    {
--        key = '|',
--        mods = 'LEADER|SHIFT',
--        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
--    },
--    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
--    {
--        key = 'a',
--        mods = 'LEADER|CTRL',
--        action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
--    },
--}

return {
    --font = wezterm.font_with_fallback({ 'Hack Nerd Font', 'Liberation Sans', 'Noto Color Emoji' }),
    font_size = 11,
    --leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
    front_end = 'WebGpu',
    colors = {
        foreground = 'white',
        background = 'black',
        cursor_bg = 'white',
        ansi = {
            '#000000',
            '#e10000',
            '#00ee00',
            '#cdcd00',
            '#0080ff',
            '#cd00cd',
            '#00cdcd',
            '#e5e5e5',
        },
        brights = {
            '#7f7f7f',
            '#ff0000',
            '#00ff00',
            '#ffff00',
            '#00b0ff',
            '#ff00ff',
            '#00ffff',
            '#ffffff',
        },
    },
    check_for_updates = false,
    hide_tab_bar_if_only_one_tab = true,
    enable_scroll_bar = true,
    window_padding = {
        left = 0,
        right = 2,
        top = 0,
        bottom = 0,
    },
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'NONE',
            action = act.Nop,
        },
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
        },
    },
    quick_select_patterns = {
        -- 1. IP Address
        "%b()\b(?:%d{1,3}%.){3}%d{1,3}\b",

        -- 2. URL
        "https?://(?:[a-zA-Z]|%d|[%-$-_@.&+!*\\(\\),]|(?:%%[0-9a-fA-F][0-9a-fA-F]))+",

        -- 4. File Path (Unix-like)
        "/(?:[^/\\0]+/)*[^/\\0]+",

        -- 5. Numeric Values (Integers or Floats)
        "%b()\b%d+(%.%d+)?%b()\b",

        -- 6. Date (YYYY-MM-DD)
        "%b()\b%d%d%d%d-%d%d-%d%d%b()\b",

        -- 7. Hexadecimal Color Code
        "#%x+",

        -- 8. MAC Address
        "([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})",
    },

    keys = {
        { key = 'v',        mods = 'SUPER',      action = act.Nop },
        { key = 'Y',        mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
        { key = 'P',        mods = 'SHIFT|CTRL', action = act.Nop },
        { key = 'V',        mods = 'SHIFT|CTRL', action = act.Nop },
        { key = 'P',        mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
        { key = "Copy",     mods = "NONE",       action = act.CopyTo("Clipboard") },
        { key = "Paste",    mods = "NONE",       action = act.PasteFrom("Clipboard") },
        { key = 'PageUp',   mods = 'NONE',       action = act.ScrollByPage(-0.5) },
        { key = 'PageDown', mods = 'NONE',       action = act.ScrollByPage(0.5) },
    },

}
