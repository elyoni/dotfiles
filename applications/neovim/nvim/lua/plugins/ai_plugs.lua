-- Define the enum
PluginEnvEnum = { Work = "Work", Private = "Private", Other = "Other" }

vim.api.nvim_create_user_command("SetEnv", function(opts)
    set_plugin_env(opts.args)
end, {
    nargs = 1,
    complete = function()
        return { "Work", "Private", "Other" }
    end,
})

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

PluginEnv = determine_plugin_env()

local function func_work_pc()
    return PluginEnv == PluginEnvEnum.Work
end

local function func_private_pc()
    return PluginEnv == PluginEnvEnum.Private
end


return {
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        enable = func_private_pc,
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
            { "<leader>hm", "<cmd>lua require('neocodeium.commands').chat()<CR>", mode = { "i", "s" } },
        },
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        enabled = func_work_pc,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 5,
                    keymap = {
                        accept = "<C-l>",
                        accept_word = "<M-l>",
                        accept_line = false,
                        next = "<C-j>",
                        prev = "<C-k>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = true,
                },
            })
        end,

    },
}
