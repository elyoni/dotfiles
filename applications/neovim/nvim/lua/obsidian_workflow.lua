-- Obsidian vault workflow: active tasks, Jira tickets linked to daily notes

local M = {}

M._last_jira_ticket_scope = "active"

local VAULT_ROOT = "/home/yonie@liveu.tv/private/obsidian/work"
local DAILY_DIR = VAULT_ROOT .. "/00-Inbox/daily-notes"
local TICKETS_DIR = VAULT_ROOT .. "/01-Areas/work/tickets"
local ARCHIVE_DIR = TICKETS_DIR .. "/archive"
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
  local archive_path = ARCHIVE_DIR .. "/" .. basename .. ".md"

  if vim.fn.filereadable(file_path) == 1 or vim.fn.filereadable(archive_path) == 1 then
    if vim.fn.filereadable(file_path) == 1 then
      return file_path, basename, true
    end
    return archive_path, basename, true
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

function M.list_ticket_paths(scope)
  scope = scope or "active"
  local entries = {}

  if scope == "active" or scope == "all" then
    for _, path in ipairs(vim.fn.glob(TICKETS_DIR .. "/FP-*.md", false, true)) do
      table.insert(entries, { path = path, archived = false })
    end
  end

  if scope == "archive" or scope == "all" then
    ensure_dir(ARCHIVE_DIR)
    for _, path in ipairs(vim.fn.glob(ARCHIVE_DIR .. "/FP-*.md", false, true)) do
      table.insert(entries, { path = path, archived = true })
    end
  end

  table.sort(entries, function(a, b)
    return vim.fn.getftime(a.path) > vim.fn.getftime(b.path)
  end)

  return entries
end

function M.list_ticket_files()
  local files = {}
  for _, entry in ipairs(M.list_ticket_paths("active")) do
    table.insert(files, entry.path)
  end
  return files
end

local function move_ticket_file(path, dest_dir)
  ensure_dir(dest_dir)
  local basename = vim.fn.fnamemodify(path, ":t")
  local dest = dest_dir .. "/" .. basename

  if vim.fn.filereadable(dest) == 1 then
    return nil, "File already exists: " .. dest
  end

  if vim.fn.rename(path, dest) ~= 0 then
    return nil, "Failed to move ticket file"
  end

  local bufnr = vim.fn.bufnr(path)
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
    vim.cmd("edit " .. vim.fn.fnameescape(dest))
  end

  return dest
end

function M.archive_ticket(path)
  if path:find(ARCHIVE_DIR, 1, true) then
    return nil, "Ticket is already archived"
  end
  return move_ticket_file(path, ARCHIVE_DIR)
end

function M.unarchive_ticket(path)
  if not path:find(ARCHIVE_DIR, 1, true) then
    return nil, "Ticket is not archived"
  end
  return move_ticket_file(path, TICKETS_DIR)
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

local function ticket_entry(entry)
  local path = entry.path
  local basename = vim.fn.fnamemodify(path, ":t:r")
  local ticket_id = basename:match("^(FP%-%d+)") or basename
  local slug = basename:gsub("^FP%-%d+-", ""):gsub("-", " ")
  local prefix = entry.archived and "[archived] " or ""
  local display = prefix .. ticket_id .. " — " .. slug
  return {
    value = path,
    display = display,
    path = path,
    basename = basename,
    ticket_id = ticket_id,
    archived = entry.archived,
    ordinal = display .. " " .. basename,
  }
end

local function jira_ticket_telescope(config)
  local ok_telescope = pcall(require, "telescope")
  if not ok_telescope then
    vim.notify("telescope.nvim is required for Jira ticket picker", vim.log.levels.ERROR)
    return
  end

  local scope = config.scope or "active"
  M._last_jira_ticket_scope = scope
  local entries = M.list_ticket_paths(scope)
  if #entries == 0 then
    local location = scope == "archive" and ARCHIVE_DIR
      or scope == "all" and (TICKETS_DIR .. " or " .. ARCHIVE_DIR)
      or TICKETS_DIR
    vim.notify("No ticket files in " .. location, vim.log.levels.WARN)
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
    prompt_title = config.prompt_title,
    default_text = last_filter,
    initial_mode = "insert",
  }, {
    finder = finders.new_table({
      results = entries,
      entry_maker = ticket_entry,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      local function persist_and_close()
        persist_filter(prompt_bufnr)
        actions.close(prompt_bufnr)
      end

      map("i", "<Esc>", persist_and_close)
      map("i", "<C-c>", persist_and_close)
      map("n", "q", persist_and_close)
      map("n", "<Esc>", persist_and_close)

      if config.toggle_scope then
        local function toggle_scope_view()
          persist_filter(prompt_bufnr)
          actions.close(prompt_bufnr)
          local next_scope = scope == "active" and "archive" or "active"
          vim.schedule(function()
            M.open_jira_ticket_telescope(next_scope)
          end)
        end

        map("n", "a", toggle_scope_view)
        map("n", "<leader>oja", toggle_scope_view)
      end

      if config.move_action then
        map("n", config.move_action.key, function()
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          if config.move_action.when and not config.move_action.when(selection) then
            return
          end
          persist_filter(prompt_bufnr)
          actions.close(prompt_bufnr)
          local dest, err = config.move_action.fn(selection.value)
          if not dest then
            vim.notify(err or "Failed to move ticket", vim.log.levels.ERROR)
            return
          end
          vim.notify(
            config.move_action.success .. ticket_entry({ path = dest, archived = config.move_action.archived }).display,
            vim.log.levels.INFO
          )
          vim.schedule(function()
            config.move_action.reopen(scope)
          end)
        end)
      end

      actions.select_default:replace(function()
        persist_filter(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          config.on_select(selection)
        end
      end)

      return true
    end,
  }):find()
end

function M.open_jira_ticket_telescope(scope)
  scope = scope or "active"

  local move_action = scope == "active" and {
    key = "A",
    fn = M.archive_ticket,
    success = "Archived: ",
    archived = true,
    when = function(selection)
      return not selection.archived
    end,
  } or {
    key = "R",
    fn = M.unarchive_ticket,
    success = "Restored: ",
    archived = false,
    when = function(selection)
      return selection.archived
    end,
  }

  local scope_label = scope == "archive" and "Archived" or "Active"
  jira_ticket_telescope({
    scope = scope,
    prompt_title = scope_label .. " Jira tickets (a/toggle, "
      .. (scope == "active" and "A=archive" or "R=restore")
      .. ", filter remembered)",
    toggle_scope = true,
    on_select = function(selection)
      vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
    end,
    move_action = vim.tbl_extend("force", move_action, {
      reopen = M.open_jira_ticket_telescope,
    }),
  })
end

function M.open_archived_jira_ticket_telescope()
  M.open_jira_ticket_telescope("archive")
end

function M.toggle_jira_ticket_telescope()
  local next_scope = M._last_jira_ticket_scope == "archive" and "active" or "archive"
  M.open_jira_ticket_telescope(next_scope)
end

function M.link_existing_ticket_to_daily()
  jira_ticket_telescope({
    scope = "all",
    prompt_title = "Link Jira ticket to daily (active + archived)",
    on_select = function(selection)
      M.link_ticket_to_daily(selection.basename, selection.ticket_id, nil)
    end,
  })
end

return M
