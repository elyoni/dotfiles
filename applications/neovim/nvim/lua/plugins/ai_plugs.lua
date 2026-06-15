-- Define the enum
PluginEnvEnum = { Work = "Work", Private = "Private", Other = "Other" }


local function set_plugin_env(env)
    local plugin_choice_file = vim.fn.expand("~/.nvim_plugin_choice")
    local valid_envs = { "Work", "Private", "Other" }

    -- Check if the provided env is valid
    if not vim.tbl_contains(valid_envs, env) then
        print("Invalid environment. Choose from: Work, Private, Other")
        return
    end

    -- Write the environment to the file
    local file = io.open(plugin_choice_file, "w")
    file:write(env)
    file:close()

    print("Environment set to " .. env)
end

local function read_env_file()
    local env_file = vim.fn.expand("~/.nvim_plugin_choice")
    local env_content = vim.fn.readfile(env_file)
    if #env_content > 0 then
        return vim.trim(env_content[1]) -- Read the first line and trim whitespace
    else
        return nil
    end
end


local function determine_plugin_env()
    local plugin_choice_file = vim.fn.expand("~/.nvim_plugin_choice")
    local file = io.open(plugin_choice_file, "r")
    if file then
        local content = file:read("*all"):gsub("%s+", "") -- Trim whitespace
        file:close()
        if content == "Work" then
            return PluginEnvEnum.Work
        elseif content == "Private" then
            return PluginEnvEnum.Private
        end
    end
    return PluginEnvEnum.Other -- Default if file not found or unexpected content
end

vim.api.nvim_create_user_command("GetEnv", function(opts)
    print(determine_plugin_env())
end, {})

vim.api.nvim_create_user_command("SetEnv", function(opts)
    set_plugin_env(opts.args)
end, {
    nargs = 1,
    complete = function()
        return { "Work", "Private", "Other" }
    end,
})


PluginEnv = determine_plugin_env()

function FuncWorkPC()
    return PluginEnv == PluginEnvEnum.Work
end

function FuncPrivatePC()
    return PluginEnv == PluginEnvEnum.Private
end

-- Yank file:line reference for AI (normal mode: file:line, visual: file:start:end)
vim.keymap.set('n', '<leader>hy', function()
    local file = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
    -- In diff mode, cursor can land on a virtual filler line which returns 0
    local line = math.max(1, vim.fn.line('.'))
    local ref = file .. ':' .. line
    vim.fn.setreg('+', ref)
    vim.notify('Yanked: ' .. ref)
end, { noremap = true, silent = true, desc = "Yank file:line reference for AI" })

vim.keymap.set('v', '<leader>hy', function()
    local file = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
    -- Use 'v' (visual start) and '.' (cursor) which are valid *during* visual
    -- mode; the '< and '> marks only update after leaving visual mode and would
    -- otherwise return the previous selection. In diff mode filler lines return
    -- 0, so clamp to 1.
    local l1 = math.max(1, vim.fn.line('v'))
    local l2 = math.max(1, vim.fn.line('.'))
    local start_line = math.min(l1, l2)
    local end_line = math.max(l1, l2)
    local ref
    if start_line == end_line then
        ref = file .. ':' .. start_line
    else
        ref = file .. ':' .. start_line .. ':' .. end_line
    end
    vim.fn.setreg('+', ref)
    vim.notify('Yanked: ' .. ref)
end, { noremap = true, silent = true, desc = "Yank file:line range reference for AI" })

--vim.keymap.set('i', '<C-l>', function()
--local suggestion = require('tabnine.status').status().message
--if suggestion then
--local word = suggestion:match("^(%S+)")
--if word then
--vim.api.nvim_put({ word }, 'c', true, true)
--end
--end
--end, { desc = "Tabnine: Accept single word" })

--vim.keymap.set('i', '<C-S-l>', function()
--local suggestion = require('tabnine.status').status().message
--if suggestion then
--vim.api.nvim_put({ suggestion }, 'c', true, true)
--end
--end, { desc = "Tabnine: Accept full line" })


-- ============================================================
-- Per-project AI choice
-- ============================================================

local function get_project_root()
    local result = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")
    if vim.v.shell_error == 0 and #result > 0 and result[1] ~= "" then
        return result[1]
    end
    return vim.fn.getcwd()
end

local function get_ai_choice_path()
    local root = get_project_root()
    local git_dir = root .. "/.git"
    if vim.fn.isdirectory(git_dir) == 1 then
        return git_dir .. "/nvim_ai_choice"
    end
    -- No git repo: store by sanitized path name
    local dir = vim.fn.expand("~/.local/share/nvim/ai_choices")
    vim.fn.mkdir(dir, "p")
    local safe = root:gsub("[^%w%-_.]", "_"):sub(-60)
    return dir .. "/" .. safe
end

local function read_project_ai()
    local path = get_ai_choice_path()
    local f = io.open(path, "r")
    if not f then return nil end
    local v = f:read("*all"):gsub("%s+", "")
    f:close()
    return (v == "cursor" or v == "claude") and v or nil
end

local function save_project_ai(choice)
    local path = get_ai_choice_path()
    local f = io.open(path, "w")
    if not f then return end
    f:write(choice)
    f:close()
    vim.notify("AI set to [" .. choice .. "] for this project", vim.log.levels.INFO)
end

local function log_ai_session(ai_type)
    local dir = vim.fn.expand("~/.local/share/nvim/ai_sessions")
    vim.fn.mkdir(dir, "p")
    local root = get_project_root()
    local name = vim.fn.fnamemodify(root, ":t")
    local ts = os.date("%Y-%m-%dT%H:%M:%S")
    local line = ts .. "\t" .. ai_type .. "\t" .. root .. "\t" .. name .. "\n"
    local f = io.open(dir .. "/sessions.log", "a")
    if not f then return end
    f:write(line)
    f:close()
end

-- ============================================================
-- Window tracking for <leader>hm bottom split toggle
-- ============================================================

local _ai_win = nil

local function is_ai_win_open()
    return _ai_win ~= nil and vim.api.nvim_win_is_valid(_ai_win)
end

-- Capture whichever new window appeared after the plugin opened its split
local function capture_new_win(wins_before)
    for _, w in ipairs(vim.api.nvim_list_wins()) do
        local is_old = false
        for _, old in ipairs(wins_before) do
            if w == old then
                is_old = true
                break
            end
        end
        if not is_old and vim.api.nvim_win_is_valid(w) then
            _ai_win = w
            return
        end
    end
end

local function launch_ai(ai_type, layout)
    log_ai_session(ai_type)
    local wins_before = vim.api.nvim_list_wins()
    if ai_type == "cursor" then
        vim.cmd("CursorCliOpenWithLayout " .. layout)
    else
        vim.cmd("ClaudeCode")
    end
    -- Give the plugin time to create its window before we capture it
    vim.defer_fn(function()
        capture_new_win(wins_before)
    end, 120)
end

-- ============================================================
-- Keybind actions
-- ============================================================

local function with_ai_choice(callback)
    local choice = read_project_ai()
    if choice then
        callback(choice)
        return
    end
    vim.ui.select({ "cursor", "claude" }, {
        prompt = "Choose AI for this project (saved for next time):",
        format_item = function(item)
            return item == "cursor" and "Cursor Agent" or "Claude Code"
        end,
    }, function(selected)
        if not selected then return end
        save_project_ai(selected)
        callback(selected)
    end)
end

-- <leader>hm: toggle bottom split
local function toggle_ai_bottom()
    if is_ai_win_open() then
        vim.api.nvim_win_close(_ai_win, true)
        _ai_win = nil
        return
    end
    _ai_win = nil
    with_ai_choice(function(ai_type)
        launch_ai(ai_type, "hsplit")
    end)
end

-- <leader>hf: open in float (always opens, does not toggle)
local function open_ai_float()
    with_ai_choice(function(ai_type)
        launch_ai(ai_type, "float")
    end)
end

-- <leader>hh: show session history for this project
-- Read all Claude Code sessions from ~/.claude/projects/ (terminal + nvim).
-- Returns a list of {ts, ai, path, name, summary} sorted newest-first.
local function read_claude_sessions()
    local projects_dir = vim.fn.expand("~/.claude/projects")
    if vim.fn.isdirectory(projects_dir) == 0 then return {} end

    local sessions = {}
    for _, jsonl_file in ipairs(vim.fn.glob(projects_dir .. "/*/*.jsonl", false, true)) do
        local session_id = vim.fn.fnamemodify(jsonl_file, ":t:r")
        if #session_id == 36 then -- UUID only, skip non-session files
            local mtime = vim.fn.getftime(jsonl_file)
            local cwd, ts, summary
            for _, line in ipairs(vim.fn.readfile(jsonl_file, "", 20)) do
                local ok, obj = pcall(vim.fn.json_decode, line)
                if ok and type(obj) == "table" and obj.type == "user" and obj.cwd then
                    cwd = obj.cwd
                    ts  = obj.timestamp and obj.timestamp:sub(1, 19) or nil
                    local content = obj.message and obj.message.content
                    if type(content) == "string" then
                        summary = content:sub(1, 80):gsub("\n", " ")
                    elseif type(content) == "table" then
                        for _, c in ipairs(content) do
                            if type(c) == "table" and c.type == "text" then
                                summary = c.text:sub(1, 80):gsub("\n", " ")
                                break
                            end
                        end
                    end
                    break
                end
            end
            if cwd then
                table.insert(sessions, {
                    ts         = ts or os.date("!%Y-%m-%dT%H:%M:%S", mtime),
                    ai         = "claude",
                    path       = cwd,
                    name       = vim.fn.fnamemodify(cwd, ":t"),
                    summary    = summary or "",
                    mtime      = mtime,
                    session_id = session_id,
                })
            end
        end
    end
    table.sort(sessions, function(a, b) return a.mtime > b.mtime end)
    return sessions
end

local function show_ai_history(project_only)
    local root = get_project_root()
    local sessions = read_claude_sessions()

    -- Add cursor sessions from the neovim log (claude sessions come from ~/.claude/projects/)
    local log_file = vim.fn.expand("~/.local/share/nvim/ai_sessions/sessions.log")
    if vim.fn.filereadable(log_file) == 1 then
        for _, line in ipairs(vim.fn.readfile(log_file)) do
            if line ~= "" then
                local parts = vim.split(line, "\t")
                if parts[2] == "cursor" then
                    table.insert(sessions, {
                        ts      = parts[1] or "",
                        ai      = "cursor",
                        path    = parts[3] or "",
                        name    = parts[4] or "",
                        summary = "",
                        mtime   = 0,
                    })
                end
            end
        end
    end

    if project_only then
        local filtered = {}
        for _, s in ipairs(sessions) do
            if s.path == root then
                table.insert(filtered, s)
            end
        end
        sessions = filtered
    end

    if #sessions == 0 then
        local msg = project_only and ("No AI sessions for " .. vim.fn.fnamemodify(root, ":t")) or "No AI session history yet"
        vim.notify(msg, vim.log.levels.WARN)
        return
    end

    -- Sort all newest-first by ISO timestamp string
    table.sort(sessions, function(a, b) return a.ts > b.ts end)

    local title = project_only
        and ("AI Sessions — " .. vim.fn.fnamemodify(root, ":t") .. " (Enter to resume)")
        or  "AI Sessions — all projects (Enter to resume)"

    require("telescope.pickers").new({}, {
        prompt_title = title,
        finder = require("telescope.finders").new_table({
            results = sessions,
            entry_maker = function(s)
                local ts_disp = s.ts:sub(1, 19):gsub("T", " ")
                local summary = s.summary ~= "" and ("  " .. s.summary) or ""
                return {
                    value   = s,
                    display = string.format("%-19s  %-6s  %-18s%s", ts_disp, s.ai, s.name, summary),
                    ordinal = s.ts .. " " .. s.ai .. " " .. s.name .. " " .. s.path .. " " .. s.summary,
                }
            end,
        }),
        sorter  = require("telescope.config").values.generic_sorter({}),
        previewer = false,
        attach_mappings = function(prompt_bufnr, _)
            local actions      = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local s = action_state.get_selected_entry().value
                vim.cmd("cd " .. vim.fn.fnameescape(s.path))
                vim.notify("Resuming " .. s.ai .. " in " .. s.name, vim.log.levels.INFO)
                if s.ai == "claude" and s.session_id then
                    vim.cmd("botright split")
                    vim.cmd("terminal claude --resume " .. s.session_id)
                    vim.cmd("startinsert")
                else
                    launch_ai(s.ai, "hsplit")
                end
            end)
            return true
        end,
    }):find()
end

-- ============================================================
-- Commands to manage per-project AI choice
-- ============================================================

vim.api.nvim_create_user_command("SetAI", function(opts)
    save_project_ai(opts.args)
end, {
    nargs = 1,
    complete = function() return { "cursor", "claude" } end,
    desc = "Set AI tool for this project (cursor|claude)",
})

vim.api.nvim_create_user_command("GetAI", function()
    local choice = read_project_ai()
    print(choice or "not set — will ask on next <leader>hm")
end, { desc = "Show current project AI choice" })

-- ============================================================
-- Keybinds (set at startup, trigger lazy-load via cmd)
-- ============================================================

vim.keymap.set("n", "<leader>hm", toggle_ai_bottom,
    { noremap = true, silent = true, desc = "Toggle AI bottom split" })

vim.keymap.set("n", "<leader>hf", open_ai_float,
    { noremap = true, silent = true, desc = "Open AI float" })

vim.keymap.set("n", "<leader>hh", function() show_ai_history(true) end,
    { noremap = true, silent = true, desc = "Show AI session history (this project)" })

vim.keymap.set("n", "<leader>hH", function() show_ai_history(false) end,
    { noremap = true, silent = true, desc = "Show AI session history (all projects)" })


return {
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = { "ClaudeCode", "ClaudeCodeOpen", "ClaudeCodeToggle" },
        config = function()
            require("claude-code").setup()
        end,
    },
    {
        "suiramdev/cursorcli.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },
        cmd = { "CursorCliOpenWithLayout", "CursorCliOpen" },
        opts = {
            command = { "cursor-agent" },
            position = "float",
            auto_insert = true,
            path = { relative_to_cwd = true },
            float = { width = 0.9, height = 0.8, border = "rounded" },
        },
        config = function(_, opts)
            require("cursorcli").setup(opts or {})

            -- Visual selection: open Cursor CLI float and attach selection
            vim.keymap.set("v", "<C-l>", function()
                vim.cmd("CursorCliOpenWithLayout float")
                require("cursorcli").add_visual_selection()
            end, { desc = "Open Cursor CLI and add selection as file:lines" })

            -- Layout shortcuts
            vim.keymap.set("n", "<leader>af", "<Cmd>CursorCliOpenWithLayout float<CR>",   { desc = "Cursor CLI (float)" })
            vim.keymap.set("n", "<leader>av", "<Cmd>CursorCliOpenWithLayout vsplit<CR>",  { desc = "Cursor CLI (vsplit)" })
            vim.keymap.set("n", "<leader>ah", "<Cmd>CursorCliOpenWithLayout hsplit<CR>",  { desc = "Cursor CLI (hsplit)" })
            vim.keymap.set("n", "<leader>ac", function() require("cursorcli").close() end, { desc = "Close Cursor CLI" })
            vim.keymap.set("x", "<leader>aa", function() require("cursorcli").add_visual_selection() end, { desc = "Add selection to Cursor CLI" })
        end,
    },

    --{
    --"zbirenbaum/copilot.lua",
    --cmd = "Copilot",
    --event = "InsertEnter",
    --cond = FuncWorkPC,
    --config = function()
    --require("copilot").setup({
    --suggestion = {
    --enabled = true,
    --auto_trigger = true,
    --debounce = 5,
    --keymap = {
    --accept = "<C-l>",
    --accept_word = "<M-l>",
    --accept_line = false,
    --next = "<C-j>",
    --prev = "<C-k>",
    --dismiss = "<C-]>",
    --},
    --},
    --filetypes = {
    --yaml = true,
    --},
    --})
    --end,

    --},
    --{
    --"CopilotC-Nvim/CopilotChat.nvim",
    --branch = "canary",
    --enabled = FuncWorkPC,
    --dependencies = {
    --{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    --},
    --build = "make tiktoken",         -- Only on MacOS or Linux
    --opts = {
    --debug = true,                -- Enable debugging
    --model = 'claude-3.7-sonnet',
    ---- See Configuration section for rest
    --},
    --keys = {
    --{
    --"<leader>hm",
    --function()
    --local input = vim.fn.input("Quick Chat: ")
    --if input ~= "" then
    --require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
    --end
    --end,
    --mode = "n", -- Normal mode
    --desc = "CopilotChat - Quick chat",
    --},
    ---- Visual mode keybind
    --{
    --"<leader>hm",
    --function()
    --local input = vim.fn.input("Quick Chat: ")
    --if input ~= "" then
    --require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
    --end
    --end,
    --mode = "v", -- Visual mode
    --desc = "CopilotChat - Quick chat (visual)",
    --}, },
    --},
}
