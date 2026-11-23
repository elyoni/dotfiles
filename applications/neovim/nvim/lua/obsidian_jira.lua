-- Jira autolink: turns a typed Jira ID (FP-66735) into a markdown link.
-- Triggers when you type a space or punctuation right after the ID.
-- Same rules as the Obsidian plugin (jira-autolink) in the work vault.

local M = {}

local BASE = "https://liveu.atlassian.net/browse/"
local KEYS = { FP = true, LUT = true, LTOLD = true, LUMIS = true, MISSUP = true, MNGN = true, AD = true }

local function link(id)
    return string.format("[%s](%s%s)", id, BASE, id)
end

-- True if the char is part of a word, or of a link/URL (so the ID is already linked).
local function is_word_or_link_char(c)
    return c ~= "" and c:match("[%w%[/%-]") ~= nil
end

-- If text ends with a known Jira ID, return its 1-based start column and the ID.
local function trailing_id(text)
    local s, _, key, num = text:find("([A-Z]+)%-(%d+)$")
    if not s or not KEYS[key] then return nil end
    if s > 1 and is_word_or_link_char(text:sub(s - 1, s - 1)) then return nil end
    return s, key .. "-" .. num
end

local function on_change()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row 1-based, col 0-based (byte)
    local line = vim.api.nvim_get_current_line()
    local before = line:sub(1, col)
    local last = before:sub(-1)
    if last == "" or not last:match("[%s|,.;:%)]") then return end

    local s, id = trailing_id(before:sub(1, -2))
    if not s then return end

    local r = row - 1
    local new_link = link(id)
    vim.api.nvim_buf_set_text(0, r, s - 1, r, s - 1 + #id, { new_link })
    -- Keep the cursor after the typed trigger character.
    vim.api.nvim_win_set_cursor(0, { row, col + #new_link - #id })
end

-- Convert every Jira ID in the buffer, skipping fenced code blocks.
function M.convert_all()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local in_code = false
    local count = 0

    for i, line in ipairs(lines) do
        if line:match("^%s*```") then
            in_code = not in_code
        elseif not in_code then
            local new = line:gsub("()([A-Z]+)%-(%d+)()", function(s, key, num, e)
                if not KEYS[key] then return nil end
                if s > 1 and is_word_or_link_char(line:sub(s - 1, s - 1)) then return nil end
                if line:sub(e, e):match("[%w%]]") then return nil end
                count = count + 1
                return link(key .. "-" .. num)
            end)
            lines[i] = new
        end
    end

    if count > 0 then
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.fn.winrestview(view)
    end
    vim.notify("Jira autolink: converted " .. count .. " IDs", vim.log.levels.INFO)
end

-- Hide the "[" and "](url)" parts of Jira links so only the ID shows.
-- The line under the cursor shows the raw link so you can still edit it.
local function hide_links()
    -- Set every time: the markdown FileType handler resets conceallevel to 0.
    vim.opt_local.conceallevel = 2
    if vim.w.jira_links_hidden then return end
    vim.w.jira_links_hidden = true
    local base = [[https://liveu\.atlassian\.net/browse/]]
    vim.fn.matchadd("Conceal", [[\[\ze[A-Z]\+-\d\+\](]] .. base, 20, -1, { conceal = "" })
    vim.fn.matchadd("Conceal", [[\](]] .. base .. [[[A-Z]\+-\d\+)]], 20, -1, { conceal = "" })
end

-- Call once per markdown buffer.
function M.attach(bufnr)
    hide_links()
    local group = vim.api.nvim_create_augroup("JiraAutolink" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = group,
        buffer = bufnr,
        callback = on_change,
    })
    vim.api.nvim_buf_create_user_command(bufnr, "JiraLinkAll", M.convert_all, {
        desc = "Convert Jira IDs in this buffer to links",
    })
end

return M
