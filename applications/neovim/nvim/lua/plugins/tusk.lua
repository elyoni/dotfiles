local function extract_tasks(yaml_content)
    local tasks = {}
    local in_tasks_section = false

    for line in yaml_content:gmatch("[^\n]+") do
        if not in_tasks_section then
            -- Check if the line contains "tasks:"
            if line:match("^%s*tasks:%s*$") then
                in_tasks_section = true
            end
        else
            local indent, key = line:match("(%s*)(%S+)%s*:%s*(.*)")
            vim.notify("Indent: " .. vim.inspect(indent) .. " Key: " .. vim.inspect(key))

            if indent == nil then
                -- Not a key-value pair, ignore
                vim.notify("Ignoring line: " .. line)
            elseif #indent == 2 then
                -- Top-level key-value pair after "tasks:"
                if key ~= nil and not key:find("^#") then
                    table.insert(tasks, key)
                    vim.notify("Adding task: " .. key)
                end
                vim.notify("Ignoring line2: " .. line)
                --else
                --    -- End of "tasks" section
                --    break
            end
        end
    end

    return tasks
end

local conf         = require("telescope.config").values
local actions      = require "telescope.actions"
local action_state = require "telescope.actions.state"
local function tusk_telescope()
    --local commands_list = tasks
    local file = io.open('tusk.yml', 'r')
    if file == nil then
        vim.notify("No tusk.yml file found")
        return
    end
    local yaml_content = file:read('*all')
    file:close()

    vim.cmd("wall")

    local tasks = extract_tasks(yaml_content)
    table.insert(tasks, "test --type lint")

    require("telescope.pickers").new({}, {
        prompt_title = "Tusk",
        finder = require("telescope.finders").new_table({
            results = tasks
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd("tabnew term://tusk " .. selection[1] .. " | startinsert")
            end)
            return true
        end,
    }):find()
end

-- vim.keymap.set("n", "<C-t>", function() tusk_telescope() end,
--     { desc = "Open tusk window" })
return {}
