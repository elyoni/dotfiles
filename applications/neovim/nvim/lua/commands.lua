vim.api.nvim_create_user_command("GitSite", GitSite, { range = true })

vim.api.nvim_create_user_command("W", "w", { desc = "Save file" })
vim.api.nvim_create_user_command("Wqa", "wqa", { desc = "Save all and quit" })
vim.api.nvim_create_user_command("Vsp", "vsp", { desc = "Vertical split" })
vim.api.nvim_create_user_command("Wq", "wq", { desc = "Save and quit" })
vim.api.nvim_create_user_command("Q", "q", { desc = "Quit" })
vim.api.nvim_create_user_command("Qa", "qa", { desc = "Quit all" })
vim.api.nvim_create_user_command("DelFile", DeleteCurrentFile, { desc = "Delete current file and buffer" })


-- Tab commands
vim.api.nvim_create_user_command("Tn", "tabnew", { desc = "Open new tab" })
vim.api.nvim_create_user_command("TN", "tabnew", { desc = "Open new tab (caps)" })

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
