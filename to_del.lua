-- our picker function: colors
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values


local colors = function(opts)
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = "colors",
        finder = finders.new_table {
            results = { "red", "green", "blue" }
        },
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                -- print(vim.inspect(selection))
                vim.api.nvim_put({ selection[1] }, "", false, true)
            end)
            return true
        end,
        sorter = conf.generic_sorter(opts),
    }):find()
end

-- to execute the function
colors(require("telescope.themes").get_dropdown {})
--colors()
