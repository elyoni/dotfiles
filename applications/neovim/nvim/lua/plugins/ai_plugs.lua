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
