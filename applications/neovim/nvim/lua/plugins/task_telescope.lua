local history_file = vim.fn.stdpath("data") .. "/task_history.json"
local command_history = {}
local history_index = 0

local function load_history()
    local file = io.open(history_file, "r")
    if file then
        local content = file:read("*all")
        file:close()
        local success, data = pcall(vim.json.decode, content)
        if success and type(data) == "table" then
            command_history = data
        end
    else
        -- Try to migrate from old format
        local old_file = vim.fn.stdpath("data") .. "/task_history.txt"
        local old_f = io.open(old_file, "r")
        if old_f then
            local old_cmd = old_f:read("*line")
            old_f:close()
            if old_cmd then
                command_history = { old_cmd }
                save_history()
            end
        end
    end
end

local function save_history()
    local file = io.open(history_file, "w")
    if file then
        file:write(vim.json.encode(command_history))
        file:close()
    end
end

local function add_to_history(command)
    -- Remove command if it already exists
    for i, cmd in ipairs(command_history) do
        if cmd == command then
            table.remove(command_history, i)
            break
        end
    end

    -- Add to front of history
    table.insert(command_history, 1, command)

    -- Keep only last 50 commands
    if #command_history > 50 then
        command_history[51] = nil
    end

    save_history()
    history_index = 0
end

local function get_last_command()
    return command_history[1]
end

local function get_history_command(direction)
    if direction == "prev" then
        history_index = math.min(history_index + 1, #command_history)
    elseif direction == "next" then
        history_index = math.max(history_index - 1, 1)
    end

    return command_history[history_index]
end

local function extract_tasks_from_taskfile(yaml_content)
    local tasks = {}
    local current_indent = 0
    local in_tasks_section = false

    for line in yaml_content:gmatch("[^\n]+") do
        local indent = #(line:match("^%s*") or "")
        local trimmed = line:match("^%s*(.-)%s*$")

        if trimmed:match("^tasks:%s*$") then
            in_tasks_section = true
            current_indent = indent
        elseif in_tasks_section then
            if indent <= current_indent and not trimmed:match("^tasks:%s*$") then
                break
            elseif indent == current_indent + 2 and trimmed:match("^[%w%-_:]+:%s*$") then
                local task_name = trimmed:match("^([%w%-_:]+):")
                if task_name then
                    table.insert(tasks, task_name)
                end
            end
        end
    end

    return tasks
end

local function extract_tasks_from_tusk(yaml_content)
    local tasks = {}
    local in_tasks_section = false

    for line in yaml_content:gmatch("[^\n]+") do
        if not in_tasks_section then
            if line:match("^%s*tasks:%s*$") then
                in_tasks_section = true
            end
        else
            local indent, key = line:match("(%s*)(%S+)%s*:%s*(.*)")
            if indent and #indent == 2 and key and not key:find("^#") then
                table.insert(tasks, key)
            end
        end
    end

    return tasks
end

local function get_poetry_tasks()
    local file = io.open('pyproject.toml', 'r')
    if not file then
        return {}
    end

    local content = file:read('*all')
    file:close()

    local tasks = {}
    local in_scripts = false

    for line in content:gmatch("[^\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed:match("^%[tool%.poetry%.scripts%]") then
            in_scripts = true
        elseif trimmed:match("^%[") and in_scripts then
            break
        elseif in_scripts and trimmed:match("^[%w%-_]+%s*=") then
            local script_name = trimmed:match("^([%w%-_]+)%s*=")
            if script_name then
                table.insert(tasks, script_name)
            end
        end
    end

    return tasks
end

local function get_task_list()
    -- Use task --list to get all available tasks including from includes
    local handle = io.popen('task --list 2>/dev/null')
    if not handle then
        return {}
    end

    local result = handle:read('*all')
    handle:close()

    local tasks = {}
    for line in result:gmatch("[^\n]+") do
        -- Match lines like "* task_name:                   description"
        local task_name, description = line:match("^%* ([^%s]+):%s+(.*)$")
        if task_name then
            table.insert(tasks, {
                name = task_name,
                description = description or ""
            })
        end
    end

    return tasks
end

local function has_taskfile()
    local taskfile_files = {
        "Taskfile.yml",
        "taskfile.yml",
        "Taskfile.yaml",
        "taskfile.yaml",
        "Taskfile.dist.yml",
        "taskfile.dist.yml",
        "Taskfile.dist.yaml",
        "taskfile.dist.yaml"
    }
    for _, filename in ipairs(taskfile_files) do
        local file = io.open(filename, 'r')
        if file then
            file:close()
            return true
        end
    end
    return false
end

local function get_tasks()
    local all_tasks = {}
    local task_sources = {}

    -- Check for Taskfile and get all tasks via task --list
    if has_taskfile() then
        local tasks = get_task_list()
        for _, task in ipairs(tasks) do
            table.insert(all_tasks, task)
            task_sources[task.name] = "task"
        end
    end

    -- Check for tusk.yml
    local tusk_file = io.open('tusk.yml', 'r')
    if tusk_file then
        local yaml_content = tusk_file:read('*all')
        tusk_file:close()
        local tasks = extract_tasks_from_tusk(yaml_content)
        for _, task in ipairs(tasks) do
            table.insert(all_tasks, { name = task, description = "" })
            task_sources[task] = "tusk"
        end
    end

    -- Check for poetry
    local poetry_tasks = get_poetry_tasks()
    for _, task in ipairs(poetry_tasks) do
        local task_name = "poetry:" .. task
        table.insert(all_tasks, { name = task_name, description = "" })
        task_sources[task_name] = "poetry"
    end

    if #all_tasks == 0 then
        vim.notify("No task files found (Taskfile.yml, tusk.yml, or pyproject.toml)", vim.log.levels.WARN)
    end

    return all_tasks, task_sources
end

local function sort_tasks_by_history(tasks)
    -- Sort tasks: history items first, then alphabetically
    local history_tasks = {}
    local other_tasks = {}

    -- Separate history items from others
    for _, task in ipairs(tasks) do
        local is_in_history = false
        for _, hist_cmd in ipairs(command_history) do
            if task.name == hist_cmd then
                table.insert(history_tasks, { task = task, hist_index = _ })
                is_in_history = true
                break
            end
        end
        if not is_in_history then
            table.insert(other_tasks, task)
        end
    end

    -- Sort history tasks by history order
    table.sort(history_tasks, function(a, b) return a.hist_index < b.hist_index end)

    -- Sort other tasks alphabetically
    table.sort(other_tasks, function(a, b) return a.name < b.name end)

    -- Combine: history first, then others
    local sorted_tasks = {}
    for _, item in ipairs(history_tasks) do
        table.insert(sorted_tasks, item.task)
    end
    for _, task in ipairs(other_tasks) do
        table.insert(sorted_tasks, task)
    end

    return sorted_tasks
end

local function task_telescope()
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")

    load_history()
    vim.cmd("wall")

    local tasks, task_sources = get_tasks()
    if #tasks == 0 then
        return
    end

    -- Sort tasks to put history items at the top
    tasks = sort_tasks_by_history(tasks)

    local default_selection = 1 -- Always select first item (most recent history)
    history_index = 1           -- Start at first history item
    local current_history_cmd = nil

    pickers.new({
        layout_config = {
            height = 0.8,
            width = 0.9,
            preview_cutoff = 120,
        },
        layout_strategy = "horizontal",
    }, {
        prompt_title = "Task Commands (Alt+P/N for history)",
        finder = finders.new_table({
            results = tasks,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name .. " - " .. entry.description,
                    ordinal = entry.name .. " " .. entry.description,
                }
            end
        }),
        sorter = conf.generic_sorter({}),
        default_selection_index = default_selection,
        attach_mappings = function(prompt_bufnr, map)
            -- Alt+P for previous history
            map("i", "<M-p>", function()
                current_history_cmd = get_history_command("prev")
                if current_history_cmd then
                    print("History prev: " .. current_history_cmd) -- Debug
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    picker:set_prompt(current_history_cmd)
                end
            end)

            -- Alt+N for next history
            map("i", "<M-n>", function()
                current_history_cmd = get_history_command("next")
                if current_history_cmd then
                    print("History next: " .. current_history_cmd) -- Debug
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    picker:set_prompt(current_history_cmd)
                end
            end)

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local task = selection.value
                local command = task.name
                add_to_history(command)

                local source = task_sources[command]
                local terminal_command

                if source == "task" then
                    terminal_command = "task " .. command
                elseif source == "tusk" then
                    terminal_command = "tusk " .. command
                elseif source == "poetry" then
                    local script = command:match("poetry:(.+)")
                    terminal_command = "poetry run " .. script
                else
                    terminal_command = command
                end

                vim.cmd("tabnew term://" .. terminal_command)
                vim.defer_fn(function()
                    vim.cmd("startinsert")
                end, 100)
            end)
            return true
        end,
    }):find()
end

local function debug_get_tasks()
    local all_tasks = {}
    local task_sources = {}
    local debug_info = {}

    -- Check for Taskfile (in order of priority)
    local taskfile_files = {
        "Taskfile.yml",
        "taskfile.yml",
        "Taskfile.yaml",
        "taskfile.yaml",
        "Taskfile.dist.yml",
        "taskfile.dist.yml",
        "Taskfile.dist.yaml",
        "taskfile.dist.yaml"
    }

    for _, filename in ipairs(taskfile_files) do
        local file = io.open(filename, 'r')
        debug_info[filename] = file and "found" or "not found"
        if file then
            local yaml_content = file:read('*all')
            file:close()
            debug_info[filename .. "_content"] = yaml_content
            local tasks = extract_tasks_from_taskfile(yaml_content)
            debug_info[filename .. "_tasks"] = tasks
            for _, task in ipairs(tasks) do
                table.insert(all_tasks, task)
                task_sources[task] = "task"
            end
            break
        end
    end

    return { tasks = all_tasks, sources = task_sources, debug = debug_info }
end

vim.api.nvim_create_user_command('TaskTelescope', task_telescope, { desc = "Open task telescope" })
vim.api.nvim_create_user_command('TaskDebug', function()
    local result = debug_get_tasks()
    print(vim.inspect(result))
end, { desc = "Debug task detection" })

vim.api.nvim_create_user_command('TaskHistory', function()
    load_history()
    print("History file: " .. history_file)
    print("Command history:")
    for i, cmd in ipairs(command_history) do
        print(i .. ": " .. cmd)
        if i >= 10 then -- Show only first 10
            print("... and " .. (#command_history - 10) .. " more")
            break
        end
    end
end, { desc = "Show task history" })
vim.keymap.set("n", "<C-t>", task_telescope, { desc = "Open task telescope" })

return {}

