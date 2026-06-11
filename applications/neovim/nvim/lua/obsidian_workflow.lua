-- Obsidian vault workflow: active tasks, Jira tickets linked to daily notes

local M = {}

local VAULT_ROOT = "/home/yonie@liveu.tv/private/obsidian/work"
local DAILY_DIR = VAULT_ROOT .. "/00-Inbox/daily-notes"
local TICKETS_DIR = VAULT_ROOT .. "/01-Areas/work/tickets"
local ACTIVE_TASKS = VAULT_ROOT .. "/01-Areas/work/active-tasks.md"
local FILTER_HISTORY_FILE = vim.fn.stdpath("data") .. "/jira_ticket_filter.json"

local function slugify(str)
  if not str then
    return ""
  end
  return str:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
end

local function get_date()
  return os.date("%Y-%m-%d")
end

local function process_template(template_path, vars)
  local template_file = VAULT_ROOT .. "/" .. template_path
  local file = io.open(template_file, "r")
  if not file then
    return nil, "Template file not found: " .. template_path
  end

  local content = file:read("*all")
  file:close()

  for key, value in pairs(vars) do
    local escaped_key = key:gsub("%-", "%%-")
    content = content:gsub("%{%{" .. escaped_key .. ":([^}]+)%}%}", value)
    content = content:gsub("%{%{" .. escaped_key .. "%}%}", value)
  end

  if vars.date then
    content = content:gsub("%{%{date:([^}]+)%}%}", vars.date)
    content = content:gsub("%{%{date%}%}", vars.date)
  end

  return content
end

local function ensure_dir(path)
  os.execute("mkdir -p " .. vim.fn.shellescape(path))
end

local function write_file(file_path, content)
  ensure_dir(vim.fn.fnamemodify(file_path, ":h"))
  local file = io.open(file_path, "w")
  if not file then
    return false, "Failed to write: " .. file_path
  end
  file:write(content)
  file:close()
  return true
end

local function read_lines(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local function write_lines(file_path, lines)
  local file = io.open(file_path, "w")
  if not file then
    return false
  end
  for i, line in ipairs(lines) do
    file:write(line)
    if i < #lines then
      file:write("\n")
    end
  end
  file:close()
  return true
end

function M.open_active_tasks()
  if vim.fn.filereadable(ACTIVE_TASKS) == 0 then
    vim.notify("active-tasks.md not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(ACTIVE_TASKS))
end

function M.ensure_daily_note()
  local date = get_date()
  local file_path = DAILY_DIR .. "/" .. date .. ".md"

  if vim.fn.filereadable(file_path) == 1 then
    return file_path
  end

  local content, err = process_template("04-Meta/templates/daily-note.md", { date = date })
  if not content then
    vim.notify("Error: " .. err, vim.log.levels.ERROR)
    return nil
  end

  if not write_file(file_path, content) then
    vim.notify("Failed to create daily note", vim.log.levels.ERROR)
    return nil
  end

  return file_path
end

--- Build wikilink line for a ticket file basename (no .md)
function M.ticket_link_line(basename, ticket_id, title)
  local label = ticket_id or basename:match("^(FP%-%d+)")
  local suffix = ""
  if title and title ~= "" then
    suffix = " — " .. title
  end
  return "- [ ] [[" .. basename .. "|" .. label .. "]]" .. suffix
end

function M.append_under_section(file_path, section_name, new_line)
  local lines = read_lines(file_path)
  if not lines then
    return false, "Cannot read " .. file_path
  end

  local wiki_target = new_line:match("%[%[([^|%]]+)")
  if wiki_target then
    for _, line in ipairs(lines) do
      if line:find("%[%[" .. wiki_target:gsub("%-", "%%-") .. "[%]|]", 1, true)
        or line:find("%[%[" .. wiki_target:gsub("%-", "%%-") .. "%]", 1, true) then
        return true, "already_linked"
      end
    end
  end

  local heading = "## " .. section_name
  local insert_at = nil
  local section_end = #lines + 1

  for i, line in ipairs(lines) do
    if line == heading then
      insert_at = i + 1
      for j = i + 1, #lines do
        if lines[j]:match("^## ") then
          section_end = j
          break
        end
      end
      break
    end
  end

  if not insert_at then
    if #lines > 0 and lines[#lines] ~= "" then
      table.insert(lines, "")
    end
    table.insert(lines, heading)
    table.insert(lines, "")
    table.insert(lines, new_line)
    write_lines(file_path, lines)
    return true
  end

  table.insert(lines, insert_at, new_line)
  write_lines(file_path, lines)
  return true
end

function M.create_ticket_file(ticket_id, ticket_title)
  local slug = slugify(ticket_title)
  local date = get_date()
  local basename = ticket_id .. "-" .. slug
  local file_path = TICKETS_DIR .. "/" .. basename .. ".md"

  if vim.fn.filereadable(file_path) == 1 then
    return file_path, basename, true
  end

  local content, err = process_template("04-Meta/templates/ticket-note.md", {
    ["ticket-id"] = ticket_id,
    ["ticket-title"] = ticket_title,
    date = date,
  })
  if not content then
    return nil, nil, false, err
  end

  if not write_file(file_path, content) then
    return nil, nil, false, "Failed to create ticket file"
  end

  return file_path, basename, false
end

function M.link_ticket_to_daily(basename, ticket_id, title)
  local daily_path = M.ensure_daily_note()
  if not daily_path then
    return false
  end

  local line = M.ticket_link_line(basename, ticket_id, title)
  local ok, status = M.append_under_section(daily_path, "Jira Tickets", line)
  if not ok then
    vim.notify("Failed to update daily note", vim.log.levels.ERROR)
    return false
  end
  if status == "already_linked" then
    vim.notify("Ticket already linked in today's daily note", vim.log.levels.INFO)
  else
    vim.notify("Linked in daily note: " .. vim.fn.fnamemodify(daily_path, ":t"), vim.log.levels.INFO)
  end
  return true
end

function M.new_jira_ticket_and_link()
  vim.ui.input({ prompt = "Ticket ID (e.g., FP-60613): " }, function(ticket_id)
    if not ticket_id or ticket_id == "" then
      return
    end
    ticket_id = ticket_id:upper()

    vim.ui.input({ prompt = "Ticket title: " }, function(ticket_title)
      if not ticket_title or ticket_title == "" then
        return
      end

      local file_path, basename, existed, err = M.create_ticket_file(ticket_id, ticket_title)
      if not file_path then
        vim.notify("Error: " .. (err or "unknown"), vim.log.levels.ERROR)
        return
      end

      if existed then
        vim.notify("Ticket file exists, linking to daily note", vim.log.levels.INFO)
      end

      M.link_ticket_to_daily(basename, ticket_id, ticket_title)
      vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    end)
  end)
end

function M.list_ticket_files()
  local pattern = TICKETS_DIR .. "/FP-*.md"
  local files = vim.fn.glob(pattern, false, true)
  table.sort(files, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)
  return files
end

local function load_jira_filter()
  local file = io.open(FILTER_HISTORY_FILE, "r")
  if not file then
    return ""
  end
  local content = file:read("*all")
  file:close()
  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" and type(data.last_filter) == "string" then
    return data.last_filter
  end
  return ""
end

local function save_jira_filter(filter)
  local file = io.open(FILTER_HISTORY_FILE, "w")
  if not file then
    return
  end
  file:write(vim.json.encode({ last_filter = filter or "" }))
  file:close()
end

local function ticket_display_name(path)
  local basename = vim.fn.fnamemodify(path, ":t:r")
  local ticket_id = basename:match("^(FP%-%d+)") or basename
  local slug = basename:gsub("^FP%-%d+-", ""):gsub("-", " ")
  return ticket_id .. " — " .. slug
end

function M.open_jira_ticket_telescope()
  local ok_telescope, telescope = pcall(require, "telescope")
  if not ok_telescope then
    vim.notify("telescope.nvim is required for ,ojo", vim.log.levels.ERROR)
    return
  end

  local files = M.list_ticket_files()
  if #files == 0 then
    vim.notify("No ticket files in " .. TICKETS_DIR, vim.log.levels.WARN)
    return
  end

  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local last_filter = load_jira_filter()

  local function persist_filter(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    if picker then
      save_jira_filter(picker:_get_prompt())
    end
  end

  pickers.new({
    prompt_title = "Jira tickets (filter remembered)",
    default_text = last_filter,
    initial_mode = "insert",
  }, {
    finder = finders.new_table({
      results = files,
      entry_maker = function(path)
        local display = ticket_display_name(path)
        return {
          value = path,
          display = display,
          path = path,
          ordinal = display .. " " .. vim.fn.fnamemodify(path, ":t:r"),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        persist_filter(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection and selection.value then
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
        end
      end)

      actions.close:replace(function()
        persist_filter(prompt_bufnr)
        actions.close(prompt_bufnr)
      end)

      return true
    end,
  }):find()
end

function M.link_existing_ticket_to_daily()
  local files = M.list_ticket_files()
  if #files == 0 then
    vim.notify("No ticket files in " .. TICKETS_DIR, vim.log.levels.WARN)
    return
  end

  local choices = {}
  for _, path in ipairs(files) do
    local basename = vim.fn.fnamemodify(path, ":t:r")
    local ticket_id = basename:match("^(FP%-%d+)") or basename
    table.insert(choices, {
      label = ticket_id .. " — " .. basename:gsub("^FP%-%d+-", ""),
      value = path,
      basename = basename,
      ticket_id = ticket_id,
    })
  end

  vim.ui.select(choices, {
    prompt = "Link ticket to today's daily note:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.link_ticket_to_daily(choice.basename, choice.ticket_id, nil)
  end)
end

return M
