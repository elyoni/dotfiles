-- Obsidian New File Creation Module
-- Creates new files in the Obsidian vault with proper templates and folder structure

local M = {}

-- Vault root path
local VAULT_ROOT = "/home/yonie@liveu.tv/private/obsidian/work"

-- Helper function to slugify a string (lowercase, replace spaces with hyphens)
local function slugify(str)
  if not str then return "" end
  return str:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
end

-- Helper function to get current date in YYYY-MM-DD format
local function get_date()
  return os.date("%Y-%m-%d")
end

-- Helper function to read template file and replace variables
local function process_template(template_path, vars)
  local template_file = VAULT_ROOT .. "/" .. template_path
  local file = io.open(template_file, "r")
  if not file then
    return nil, "Template file not found: " .. template_path
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Replace template variables
  -- First replace variables with format specifiers (e.g., {{date:YYYY-MM-DD}})
  for key, value in pairs(vars) do
    local escaped_key = key:gsub("%-", "%%-")
    -- Replace {{key:format}} patterns
    content = content:gsub("{{" .. escaped_key .. ":([^}]+)}}", value)
    -- Replace {{key}} patterns
    content = content:gsub("{{" .. escaped_key .. "}}", value)
  end
  
  return content
end

-- Helper function to ensure directory exists
local function ensure_dir(path)
  os.execute("mkdir -p " .. vim.fn.shellescape(path))
end

-- Helper function to create file with content
local function create_file(file_path, content)
  ensure_dir(vim.fn.fnamemodify(file_path, ":h"))
  local file = io.open(file_path, "w")
  if not file then
    return false, "Failed to create file: " .. file_path
  end
  file:write(content)
  file:close()
  return true, nil
end

-- File type handlers
local handlers = {
  daily_note = function()
    local date = get_date()
    local file_path = VAULT_ROOT .. "/00-Inbox/daily-notes/" .. date .. ".md"
      local content, err = process_template("04-Meta/templates/daily-note.md", {
        ["date:YYYY-MM-DD"] = date,
        date = date,
        ["date"] = date
      })
    if not content then
      vim.notify("Error: " .. err, vim.log.levels.ERROR)
      return
    end
    local success, err = create_file(file_path, content)
    if success then
      vim.cmd("edit " .. file_path)
      vim.notify("Created daily note: " .. date, vim.log.levels.INFO)
    else
      vim.notify("Error: " .. err, vim.log.levels.ERROR)
    end
  end,
  
  project_work = function()
    vim.ui.input({ prompt = "Project name: " }, function(project_name)
      if not project_name or project_name == "" then return end
      local slug = slugify(project_name)
      local date = get_date()
      local folder = VAULT_ROOT .. "/01-Areas/work/projects/" .. slug
      local file_path = folder .. "/" .. slug .. "-overview.md"
      
      local content, err = process_template("04-Meta/templates/project-note.md", {
        ["project-name"] = slug,
        ["date:YYYY-MM-DD"] = date,
        date = date,
        ["date"] = date
      })
      if not content then
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
        return
      end
      
      ensure_dir(folder)
      ensure_dir(folder .. "/design")
      local success, err = create_file(file_path, content)
      if success then
        vim.cmd("edit " .. file_path)
        vim.notify("Created project: " .. project_name, vim.log.levels.INFO)
      else
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
      end
    end)
  end,
  
  project_personal = function()
    vim.ui.input({ prompt = "Project name: " }, function(project_name)
      if not project_name or project_name == "" then return end
      local slug = slugify(project_name)
      local date = get_date()
      local folder = VAULT_ROOT .. "/01-Areas/personal/projects/" .. slug
      local file_path = folder .. "/" .. slug .. "-overview.md"
      
      local content, err = process_template("04-Meta/templates/project-note.md", {
        ["project-name"] = slug,
        ["date:YYYY-MM-DD"] = date,
        date = date,
        ["date"] = date
      })
      if not content then
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
        return
      end
      
      ensure_dir(folder)
      local success, err = create_file(file_path, content)
      if success then
        vim.cmd("edit " .. file_path)
        vim.notify("Created personal project: " .. project_name, vim.log.levels.INFO)
      else
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
      end
    end)
  end,
  
  ticket = function()
    vim.ui.input({ prompt = "Ticket ID (e.g., FP-60613): " }, function(ticket_id)
      if not ticket_id or ticket_id == "" then return end
      vim.ui.input({ prompt = "Ticket title: " }, function(ticket_title)
        if not ticket_title or ticket_title == "" then return end
        local slug = slugify(ticket_title)
        local date = get_date()
        local file_path = VAULT_ROOT .. "/01-Areas/work/tickets/" .. ticket_id .. "-" .. slug .. ".md"
        
      local content, err = process_template("04-Meta/templates/ticket-note.md", {
        ["ticket-id"] = ticket_id,
        ["ticket-title"] = ticket_title,
        ["date:YYYY-MM-DD"] = date,
        date = date,
        ["date"] = date
      })
        if not content then
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
          return
        end
        
        local success, err = create_file(file_path, content)
        if success then
          vim.cmd("edit " .. file_path)
          vim.notify("Created ticket: " .. ticket_id, vim.log.levels.INFO)
        else
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
        end
      end)
    end)
  end,
  
  quick_capture = function()
    vim.ui.input({ prompt = "Note name (optional, press Enter for timestamp): " }, function(note_name)
      local date = get_date()
      local timestamp = os.date("%Y-%m-%d-%H%M")
      local name = note_name and note_name ~= "" and slugify(note_name) or timestamp
      local file_path = VAULT_ROOT .. "/00-Inbox/quick-captures/" .. name .. ".md"
      
      local content, err = process_template("04-Meta/templates/quick-capture.md", {
        title = name,
        ["title"] = name,
        ["date:YYYY-MM-DD"] = date,
        date = date,
        ["date"] = date
      })
      if not content then
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
        return
      end
      
      local success, err = create_file(file_path, content)
      if success then
        vim.cmd("edit " .. file_path)
        vim.notify("Created quick capture: " .. name, vim.log.levels.INFO)
      else
        vim.notify("Error: " .. err, vim.log.levels.ERROR)
      end
    end)
  end,
  
  resource = function()
    local categories = { "cloud", "infrastructure", "development", "build-systems", "tools" }
    vim.ui.select(categories, { prompt = "Select category: " }, function(category)
      if not category then return end
      vim.ui.input({ prompt = "Resource name: " }, function(resource_name)
        if not resource_name or resource_name == "" then return end
        local slug = slugify(resource_name)
        local date = get_date()
        local file_path = VAULT_ROOT .. "/02-Resources/" .. category .. "/" .. slug .. ".md"
        
        local content, err = process_template("04-Meta/templates/resource-note.md", {
          title = slug,
          ["title"] = slug,
          category = category,
          ["category"] = category,
          ["date:YYYY-MM-DD"] = date,
          date = date,
          ["date"] = date
        })
        if not content then
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
          return
        end
        
        ensure_dir(VAULT_ROOT .. "/02-Resources/" .. category)
        local success, err = create_file(file_path, content)
        if success then
          vim.cmd("edit " .. file_path)
          vim.notify("Created resource: " .. resource_name, vim.log.levels.INFO)
        else
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
        end
      end)
    end)
  end,
  
  design = function()
    vim.ui.input({ prompt = "Project name: " }, function(project_name)
      if not project_name or project_name == "" then return end
      local project_slug = slugify(project_name)
      vim.ui.input({ prompt = "Feature name (optional, press Enter for 'overview'): " }, function(feature_name)
        local feature_slug = feature_name and feature_name ~= "" and slugify(feature_name) or "overview"
        local date = get_date()
        local folder = VAULT_ROOT .. "/01-Areas/work/projects/" .. project_slug .. "/design"
        local file_path = folder .. "/design-" .. feature_slug .. ".md"
        
        local content, err = process_template("04-Meta/templates/design-note.md", {
          feature = feature_slug,
          ["feature"] = feature_slug,
          ["project-name"] = project_slug,
          ["date:YYYY-MM-DD"] = date,
          date = date,
          ["date"] = date
        })
        if not content then
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
          return
        end
        
        ensure_dir(folder)
        local success, err = create_file(file_path, content)
        if success then
          vim.cmd("edit " .. file_path)
          vim.notify("Created design document: " .. project_name .. "/" .. feature_slug, vim.log.levels.INFO)
        else
          vim.notify("Error: " .. err, vim.log.levels.ERROR)
        end
      end)
    end)
  end
}

-- Main function to show menu and create file
function M.new_file()
  local file_types = {
    { label = "Daily Note", value = "daily_note" },
    { label = "Project (Work)", value = "project_work" },
    { label = "Project (Personal)", value = "project_personal" },
    { label = "Ticket", value = "ticket" },
    { label = "Quick Capture", value = "quick_capture" },
    { label = "Resource Note", value = "resource" },
    { label = "Design Document", value = "design" }
  }
  
  vim.ui.select(file_types, {
    prompt = "Select file type:",
    format_item = function(item)
      return item.label
    end
  }, function(choice)
    if not choice then return end
    local handler = handlers[choice.value]
    if handler then
      handler()
    else
      vim.notify("Unknown file type: " .. choice.value, vim.log.levels.ERROR)
    end
  end)
end

return M
