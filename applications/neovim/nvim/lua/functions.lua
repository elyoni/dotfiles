function GitSite()
    local file = vim.fn.expand('%:p')
    local mode = vim.fn.mode()
    local start_line, end_line
    if mode == 'v' or mode == 'V' or mode == '\22' then
        -- Visual mode: get selection range
        start_line = vim.fn.line("v")
        end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
    else
        -- Normal mode: single line
        start_line = vim.fn.line('.')
        end_line = start_line
    end

    local cmd
    if start_line == end_line then
        cmd = string.format('!git site --file %s:%d', file, start_line)
    else
        cmd = string.format('!git site --file %s:%d-%d', file, start_line, end_line)
    end

    vim.cmd(cmd)
end

function ToggleWrap()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print("Wrap mode off")
    else
        vim.wo.wrap = true
        print("Wrap mode on")
    end
end

function DeleteCurrentFile()
    local file = vim.fn.expand('%')
    local deleted = vim.fn.delete(file)
    if deleted == 0 then
        print("Deleted file: " .. file)
    else
        print("Failed to delete file: " .. file)
    end
    vim.cmd("bdelete!")
end

function ToggleWrap()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print("Wrap mode off")
    else
        vim.wo.wrap = true
        print("Wrap mode on")
    end
end

function TrimShellPrompt()
    -- Get the visual selection range
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    -- Pattern matches: username@hostname:path$ and replaces with just $
    -- The 'e' flag suppresses errors if no match is found
    vim.cmd(string.format('%d,%ds/^[^@]\\+@[^:]\\+:[^$]*\\$ /$ /e', start_line, end_line))

    print(string.format("Trimmed shell prompts on lines %d-%d", start_line, end_line))
end

-- Folding functions

-- Close folds until a specific level
function FoldCloseToLevel()
    vim.ui.input({ prompt = "Close folds to level (0-9): " }, function(input)
        if not input or input == "" then return end
        local level = tonumber(input)
        if level and level >= 0 and level <= 9 then
            vim.opt.foldlevel = level
            vim.notify("Closed folds to level " .. level, vim.log.levels.INFO)
        else
            vim.notify("Invalid level. Please enter a number between 0-9", vim.log.levels.ERROR)
        end
    end)
end

-- Open folds from a specific level
function FoldOpenFromLevel()
    vim.ui.input({ prompt = "Open folds from level (0-9): " }, function(input)
        if not input or input == "" then return end
        local level = tonumber(input)
        if level and level >= 0 and level <= 9 then
            vim.opt.foldlevel = level
            vim.notify("Opened folds from level " .. level, vim.log.levels.INFO)
        else
            vim.notify("Invalid level. Please enter a number between 0-9", vim.log.levels.ERROR)
        end
    end)
end

-- Fold by type (code blocks or headers)
function FoldByType()
    vim.ui.select({ "code", "headers" }, {
        prompt = "Select fold type:",
    }, function(choice)
        if not choice then return end
        
        if choice == "code" then
            -- For markdown files in Obsidian, trigger code block folding
            local bufnr = vim.api.nvim_get_current_buf()
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            
            if filepath:match("private/obsidian/work/.*%.md$") then
                -- Rebuild fold cache and apply
                _G.build_markdown_fold_cache(bufnr)
                vim.cmd("normal! zx")  -- Update folds
                vim.opt.foldlevel = 0  -- Close all folds
                vim.notify("Folded all code blocks", vim.log.levels.INFO)
            else
                vim.notify("Code block folding only works in Obsidian markdown files", vim.log.levels.WARN)
            end
        elseif choice == "headers" then
            -- Fold by markdown headers (requires treesitter or manual setup)
            vim.notify("Header folding not yet implemented", vim.log.levels.INFO)
        end
    end)
end
