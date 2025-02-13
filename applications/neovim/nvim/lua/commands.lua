vim.cmd("command W w")
vim.cmd("command Wqa wqa")
vim.cmd("command Vsp vsp")
vim.cmd("command Wq wq")
vim.cmd("command Q q")
vim.cmd("command Qa qa")
vim.cmd("command DelFile call delete(expand('%')) | bdelete!")

-- Tab commands
vim.cmd("command Tn tabnew")
vim.cmd("command TN tabnew")


-- Command to enable Format Auto-Save
vim.api.nvim_create_user_command(
    "FormatAutoSaveOn",
    function()
        vim.g.editorconfig = true
        if is_plugin_loaded("format-on-save.nvim") then
            vim.cmd("FormatOn")
        end
        vim.b.autoformat = true
        print("Format Auto-Save enabled")
    end,
    { desc = "Enable Format Auto-Save" }
)
-- Command to disable Format Auto-Save
vim.api.nvim_create_user_command(
    "FormatAutoSaveOff",
    function()
        if is_plugin_loaded("format-on-save.nvim") then
            vim.cmd("FormatOff")
        end
        vim.g.editorconfig = false
        vim.b.autoformat = false
        print("Format Auto-Save disabled")
    end,
    { desc = "Disable Format Auto-Save" }
)

-- Command to toggle Format Auto-Save
vim.api.nvim_create_user_command(
    "FormatAutoSaveToggle",
    function()
        vim.g.editorconfig = not vim.g.editorconfig
        vim.b.autoformat = not vim.b.autoformat
        if vim.g.editorconfig then
            print("Format Auto-Save enabled")
        else
            print("Format Auto-Save disabled")
        end
    end,
    { desc = "Toggle Format Auto-Save" }
)
