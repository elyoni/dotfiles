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
