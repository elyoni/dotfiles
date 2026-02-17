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

return {
    {
        "monkoose/neocodeium",
        cond = FuncPrivatePC,
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup()
            vim.keymap.set("i", "<C-l>", neocodeium.accept)
            vim.keymap.set("i", "<M-l>", neocodeium.accept_word)
            vim.keymap.set("i", "<C-j>", function()
                neocodeium.cycle_or_complete()
            end)
            vim.keymap.set("i", "<C-k>", function()
                neocodeium.cycle_or_complete(-1)
            end)
        end,
        keys = {
            { "<leader>hm", "<cmd>lua require('neocodeium.commands').chat()<CR>", mode = { "i", "n" } },
            { "<leader>ho", "<cmd>lua require('neocodeium.commands')<CR>",        mode = { "n" } },
        },
    },
    {
        {
            'codota/tabnine-nvim',
            build = "./dl_binaries.sh",
            cond = FuncWorkPC,
            config = function()
                require('tabnine').setup({
                    disable_auto_comment = true,
                    accept_keymap = "<Tab>",
                    dismiss_keymap = "<C-]>",
                    debounce_ms = 800,
                    suggestion_color = { gui = "#808080", cterm = 244 },
                    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
                    log_file_path = nil, -- absolute path to Tabnine log file
                    ignore_certificate_errors = false,
                    -- workspace_folders = {
                    --   paths = { "/your/project" },
                    --   get_paths = function()
                    --       return { "/your/project" }
                    --   end,
                    -- },
                })
            end
        },
    },
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for git operations
        },
        config = function()
            require("claude-code").setup()
        end,
        keys = {
            { "<leader>hm", "<cmd>ClaudeCode<CR>", mode = { "n" }, desc = "Open Claude Code" },
        },
    },
    {
        "Sarctiann/cursor-agent.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },
        opts = {},
        config = function(_, opts)
            require("cursor-agent").setup(opts or {})

            local terminal = require("cursor-agent.terminal")

            local function build_line_ref(ctx, work_dir)
                if not ctx or not ctx.path or ctx.path == "" then
                    return nil
                end
                local rel = (work_dir and work_dir ~= "")
                    and (vim.fs.relpath(ctx.path, work_dir) or vim.fn.fnamemodify(ctx.path, ":."))
                    or vim.fn.fnamemodify(ctx.path, ":.")
                if ctx.line1 and ctx.line2 and ctx.line1 ~= ctx.line2 then
                    return ("@%s:%s-%s "):format(rel, ctx.line1, ctx.line2)
                end
                return ("@%s:%s "):format(rel, ctx.line or ctx.line1 or 1)
            end

            local function insert_line_ref_when_ready(tries)
                tries = tries or 0
                if tries > 40 then
                    _G._cursor_agent_auto_insert_line_ref = nil
                    return
                end
                vim.defer_fn(function()
                    if not _G._cursor_agent_auto_insert_line_ref or not terminal.term_buf or not vim.api.nvim_buf_is_valid(terminal.term_buf) then
                        return
                    end
                    local lines = vim.api.nvim_buf_get_lines(terminal.term_buf, 0, 5, false)
                    if lines[2] and lines[2]:match(" Cursor Agent") then
                        local ctx = _G._cursor_agent_line_context
                        local work_dir = terminal.working_dir or vim.fn.getcwd()
                        local ref = build_line_ref(ctx, work_dir)
                        if ref then
                            terminal.insert_text(ref)
                        end
                        _G._cursor_agent_auto_insert_line_ref = nil
                        return
                    end
                    insert_line_ref_when_ready(tries + 1)
                end, 200)
            end

            -- Visual mode: Ctrl-l opens Cursor Agent and pastes file ref + selected lines
            vim.keymap.set("v", "<C-l>", function()
                local path = vim.fn.expand("%:p")
                if path == "" then
                    return
                end
                local mark_lt = vim.api.nvim_buf_get_mark(0, "<")
                local mark_gt = vim.api.nvim_buf_get_mark(0, ">")
                local line1 = mark_lt[1] or 1
                local line2 = mark_gt[1] or 1
                if line1 > line2 then
                    line1, line2 = line2, line1
                end
                _G._cursor_agent_line_context = {
                    path = path,
                    line = line1,
                    line1 = line1,
                    line2 = line2,
                }
                _G._cursor_agent_auto_insert_line_ref = true
                require("cursor-agent.commands").open_git_root()
            end, { desc = "Open Cursor Agent with selection as file:lines" })

            -- Store last file path and line(s) when leaving a file buffer (for line refs in Cursor Agent)
            vim.api.nvim_create_autocmd("BufLeave", {
                callback = function()
                    local path = vim.fn.expand("%:p")
                    if path == "" or vim.bo.buftype ~= "" then
                        return
                    end
                    local line = vim.api.nvim_win_get_cursor(0)[1]
                    local mark_lt = vim.api.nvim_buf_get_mark(0, "<")
                    local mark_gt = vim.api.nvim_buf_get_mark(0, ">")
                    local line1 = (mark_lt[1] and mark_lt[1] > 0) and mark_lt[1] or line
                    local line2 = (mark_gt[1] and mark_gt[1] > 0) and mark_gt[1] or line
                    if line1 > line2 then
                        line1, line2 = line2, line1
                    end
                    _G._cursor_agent_line_context = {
                        path = path,
                        line = line,
                        line1 = line1,
                        line2 = line2,
                    }
                end,
            })

            -- In Cursor Agent terminal: keymap to insert file with line reference; auto-insert if opened from visual Ctrl-l
            vim.api.nvim_create_autocmd("BufEnter", {
                callback = function()
                    local bufname = vim.fn.bufname()
                    if not bufname or not bufname:match("cursor%-agent") then
                        return
                    end
                    if vim.bo.buftype ~= "terminal" then
                        return
                    end
                    vim.keymap.set("t", "<M-l>", function()
                        local ctx = _G._cursor_agent_line_context
                        if not ctx or not ctx.path or ctx.path == "" then
                            if terminal.current_file then
                                terminal.insert_text("@" .. terminal.current_file .. " ")
                            end
                            return
                        end
                        local work_dir = terminal.working_dir or vim.fn.getcwd()
                        local ref = build_line_ref(ctx, work_dir)
                        if ref then
                            terminal.insert_text(ref)
                        end
                    end, { buffer = 0, silent = true, desc = "Insert file:line ref" })
                    if _G._cursor_agent_auto_insert_line_ref then
                        insert_line_ref_when_ready(0)
                    end
                end,
            })

            -- <leader>hm: on Work open Cursor Agent, on Private open neocodeium chat, else Claude Code
            vim.schedule(function()
                vim.keymap.set("n", "<leader>hm", function()
                    if FuncWorkPC() then
                        require("cursor-agent.commands").open_git_root()
                    elseif FuncPrivatePC() then
                        pcall(function()
                            require("neocodeium.commands").chat()
                        end)
                    else
                        vim.cmd("ClaudeCode")
                    end
                end, { desc = "Open AI chat (Cursor Agent / neocodeium / Claude)" })
                vim.keymap.set("i", "<leader>hm", function()
                    if FuncWorkPC() then
                        require("cursor-agent.commands").open_git_root()
                    elseif FuncPrivatePC() then
                        pcall(function()
                            require("neocodeium.commands").chat()
                        end)
                    else
                        vim.cmd("ClaudeCode")
                    end
                end, { desc = "Open AI chat (Cursor Agent / neocodeium / Claude)" })
            end)
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
