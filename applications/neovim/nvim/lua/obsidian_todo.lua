-- Obsidian Todo List Enhancement Module
-- Provides improved todo/checkbox handling for Obsidian markdown files

local M = {}

-- Todo states in Obsidian
local TODO_STATES = {
    unchecked = "[ ]",
    checked = "[x]",
    cancelled = "[-]",
    migrated = "[>]",
    scheduled = "[<]",
}

-- Get current line content
local function get_current_line()
    return vim.api.nvim_get_current_line()
end

-- Set current line content
local function set_current_line(line)
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, { line })
end

-- Find checkbox pattern in line
local function find_checkbox(line)
    -- Match patterns like: - [ ], - [x], - [-], etc.
    local pattern = "^(%s*[-*+]%s+)(%[%s*[x>-<]?%s*%])"
    local prefix, checkbox = line:match(pattern)
    return prefix, checkbox
end

-- Toggle checkbox state
function M.toggle_checkbox()
    local line = get_current_line()
    local prefix, checkbox = find_checkbox(line)
    
    if not checkbox then
        -- No checkbox found, create one
        local indent = line:match("^(%s*)")
        local new_line = indent .. "- [ ] " .. line:gsub("^%s*", "")
        set_current_line(new_line)
        vim.notify("Created new todo item", vim.log.levels.INFO)
        return
    end
    
    -- Toggle between states
    local new_checkbox
    if checkbox == "[ ]" then
        new_checkbox = "[x]"
    elseif checkbox == "[x]" then
        new_checkbox = "[-]"
    elseif checkbox == "[-]" then
        new_checkbox = "[ ]"
    else
        -- For other states, toggle to checked
        new_checkbox = "[x]"
    end
    
    local new_line = line:gsub("%[%s*[x>-<]?%s*%]", new_checkbox)
    set_current_line(new_line)
    
    local state_name = new_checkbox == "[ ]" and "unchecked" or 
                      new_checkbox == "[x]" and "checked" or "cancelled"
    vim.notify("Todo: " .. state_name, vim.log.levels.INFO)
end

-- Create new todo item below current line
function M.new_todo_below()
    local line = get_current_line()
    local indent = line:match("^(%s*)")
    local row = vim.api.nvim_win_get_cursor(0)[1]
    
    -- Check if current line has a checkbox to match indentation
    local prefix, _ = find_checkbox(line)
    if prefix then
        indent = prefix:match("^(%s*)")
    end
    
    local new_line = indent .. "- [ ] "
    vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
    
    -- Move cursor to new line and position after checkbox
    vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
    vim.cmd("startinsert")
end

-- Create new todo item above current line
function M.new_todo_above()
    local line = get_current_line()
    local indent = line:match("^(%s*)")
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    
    -- Check if current line has a checkbox to match indentation
    local prefix, _ = find_checkbox(line)
    if prefix then
        indent = prefix:match("^(%s*)")
    end
    
    local new_line = indent .. "- [ ] "
    vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
    
    -- Move cursor to new line and position after checkbox
    vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
    vim.cmd("startinsert")
end

-- Toggle all checkboxes in visual selection
function M.toggle_selection()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local toggled = false
    
    for i, line in ipairs(lines) do
        local prefix, checkbox = find_checkbox(line)
        if checkbox then
            local new_checkbox
            if checkbox == "[ ]" then
                new_checkbox = "[x]"
            elseif checkbox == "[x]" then
                new_checkbox = "[-]"
            else
                new_checkbox = "[ ]"
            end
            
            lines[i] = line:gsub("%[%s*[x>-<]?%s*%]", new_checkbox)
            toggled = true
        end
    end
    
    if toggled then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
        vim.notify("Toggled todos in selection", vim.log.levels.INFO)
    else
        vim.notify("No checkboxes found in selection", vim.log.levels.WARN)
    end
end

-- Mark all todos in visual selection as checked
function M.check_selection()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local checked = false
    
    for i, line in ipairs(lines) do
        local prefix, checkbox = find_checkbox(line)
        if checkbox and checkbox ~= "[x]" then
            lines[i] = line:gsub("%[%s*[x>-<]?%s*%]", "[x]")
            checked = true
        end
    end
    
    if checked then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
        vim.notify("Checked todos in selection", vim.log.levels.INFO)
    else
        vim.notify("No unchecked todos found in selection", vim.log.levels.WARN)
    end
end

-- Uncheck all todos in visual selection
function M.uncheck_selection()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local unchecked = false
    
    for i, line in ipairs(lines) do
        local prefix, checkbox = find_checkbox(line)
        if checkbox and checkbox ~= "[ ]" then
            lines[i] = line:gsub("%[%s*[x>-<]?%s*%]", "[ ]")
            unchecked = true
        end
    end
    
    if unchecked then
        vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
        vim.notify("Unchecked todos in selection", vim.log.levels.INFO)
    else
        vim.notify("No checked todos found in selection", vim.log.levels.WARN)
    end
end

return M
