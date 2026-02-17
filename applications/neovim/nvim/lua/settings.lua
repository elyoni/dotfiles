vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.editorconfig = true

-- Add Node.js to PATH for markdown preview and other plugins
local nvm_dir = os.getenv("HOME") .. "/.config/nvm"
if vim.fn.isdirectory(nvm_dir) == 1 then
    local versions_dir = nvm_dir .. "/versions/node"
    local node_path = nil
    if vim.fn.isdirectory(versions_dir) == 1 then
        -- Find the latest version (use last one alphabetically, usually latest)
        local versions = vim.fn.readdir(versions_dir)
        table.sort(versions)
        if #versions > 0 then
            node_path = versions_dir .. "/" .. versions[#versions] .. "/bin"
        end
    end
    if node_path and vim.fn.isdirectory(node_path) == 1 then
        vim.env.PATH = node_path .. ":" .. vim.env.PATH
    end
end


vim.opt.hidden = true          -- Required to keep multiple buffers open multiple buffers
vim.opt.wrap = false           -- Display long lines as just one line
vim.opt.linebreak = true       -- Don't split the word and wrap is set
vim.opt.encoding = "utf-8"     -- The encoding displayed
vim.opt.pumheight = 10         -- Makes popup menu smaller
vim.opt.fileencoding = "utf-8" -- The encoding written to file
vim.opt.ruler = true           -- Show the cursor position all the time
vim.opt.cmdheight = 2          -- More space for displaying messages
vim.opt.showcmd = true         -- Show partial command in the last line of the screen
vim.opt.laststatus = 2         -- Always display the status line
vim.opt.iskeyword:append("-")  -- treat dash separated words as a word text object/
vim.opt.mouse = "a"            -- Enable your mouse
vim.opt.splitbelow = true      -- Horizontal splits will automatically be below
vim.opt.splitright = true      -- Vertical splits will automatically be to the right
vim.opt.conceallevel = 1       -- To hide `` in markdown files
vim.opt.tabstop = 4            -- Insert 4 spaces for a tab
vim.opt.shiftwidth = 4         -- Change the number of space characters inserted for indentation
vim.opt.smarttab = true        -- Makes tabbing smarter will realize you have 2 vs 4
vim.opt.expandtab = true       -- Converts tabs to spaces
vim.opt.smartindent = true     -- Makes indenting smart
vim.opt.autoindent = true      -- Good auto indent
-- laststatus is set above to 2 (always display the status line)
vim.opt.scrolloff = 10         -- Good auto indent

--" Number bar
--" set number norelativenumber             " Line numbers
vim.opt.number = true         -- Line numbers relative with current line
vim.opt.relativenumber = true -- Line numbers relative with current line
vim.opt.cursorline = true     -- Enable highlighting of the current line
vim.opt.background = "dark"   -- tell vim what the background color looks like
vim.opt.showtabline = 2       -- Always show tabs

-- Set nvim backup folder
local nvim_backup_dir = os.getenv("HOME") .. "/.nvim_backup"
if vim.fn.isdirectory(nvim_backup_dir) then
    os.execute("mkdir -p " .. nvim_backup_dir)
end
vim.opt.backupdir = nvim_backup_dir

-- Set nvim swap file directory
local nvim_swap_dir = os.getenv("HOME") .. "/.local/state/nvim/swap"
if not vim.fn.isdirectory(nvim_swap_dir) then
    os.execute("mkdir -p " .. nvim_swap_dir)
end
vim.opt.directory = nvim_swap_dir

vim.opt.updatetime = 300                       -- Faster completion
vim.opt.timeoutlen = 1000                      -- Timeout for key sequences (increased to see showcmd)
vim.opt.ttimeoutlen = 100                      -- Timeout for key codes
vim.opt.formatoptions:remove { "c", "r", "o" } -- Stop newline continution of comments

--vim.opt.clipboard="unnamedplus"               -- Copy paste between vim and everything else
vim.opt.clipboard = { "unnamed", "unnamedplus" }
if os.getenv('SSH_TTY') then
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = function() return 0 end,
            ['*'] = function() return 0 end,
        },
    }
end

vim.opt.hlsearch = true   -- Highlight the word when search
vim.opt.incsearch = true  -- Start search in realtime

vim.opt.ignorecase = true -- Cancel the case sensitive
vim.opt.smartcase = true

--hi Normal ctermbg=none guibg=none

-- You can't stop me
--cmap w!! w !sudo tee %

-- When using vimdiff will open the find in read write
vim.opt.ro = false

--vim.opt.foldmethod = marker
--vim.opt.foldexpr=nvim_treesitter#foldexpr()
vim.opt.foldenable = true -- Disable folding at startup.

-- When searching I will see split screen with all the option
vim.opt.inccommand = split

-- Go to file support for bash environment variable with {}
--vim.opt.isfname:append({,})
--vim.cmd.colorscheme "catppuccin"

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = vim.fn.expand("~/.ssh/config.d/*"),
    command = "setfiletype sshconfig",
})

-- Folding for markdown files in Obsidian vault (code blocks only)
_G.markdown_fold_cache = {}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufWritePost", "FileType" }, {
    pattern = vim.fn.expand("~/private/obsidian/work") .. "/**/*.md",
    callback = function(args)
        local bufnr = args.buf
        
        -- Show checkboxes and list markers literally (no conceal)
        vim.opt_local.conceallevel = 0
        vim.opt_local.concealcursor = ""
        
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.markdown_codeblock_fold()"
        vim.opt_local.foldlevel = 0  -- Start with all folds closed
        vim.opt_local.foldenable = true
        
        -- Build cache of code block positions
        vim.schedule(function()
            _G.build_markdown_fold_cache(bufnr)
        end)
        
        -- Set up todo keybindings for this buffer
        local todo = require('obsidian_todo')
        vim.keymap.set('n', '<leader>tc', todo.toggle_checkbox, { buffer = bufnr, desc = "Toggle checkbox" })
        vim.keymap.set('n', '<leader>ta', todo.new_todo_above, { buffer = bufnr, desc = "New todo above" })
        vim.keymap.set('n', '<leader>tb', todo.new_todo_below, { buffer = bufnr, desc = "New todo below" })
        vim.keymap.set('v', '<leader>tc', todo.toggle_selection, { buffer = bufnr, desc = "Toggle todos in selection" })
        vim.keymap.set('v', '<leader>tx', todo.check_selection, { buffer = bufnr, desc = "Check todos in selection" })
        vim.keymap.set('v', '<leader>tu', todo.uncheck_selection, { buffer = bufnr, desc = "Uncheck todos in selection" })
        
        -- Set up visual highlighting for todos
        vim.schedule(function()
            vim.api.nvim_buf_set_var(bufnr, 'obsidian_todo_highlighted', true)
        end)
    end,
})

-- Visual highlighting for todo states (simple highlighting, no syntax overrides)
--vim.api.nvim_create_autocmd({ "Syntax", "BufReadPost", "BufNewFile", "FileType" }, {
    --pattern = vim.fn.expand("~/private/obsidian/work") .. "/**/*.md",
    --callback = function()
        ---- Simple highlighting for todos without overriding markdown syntax
        --vim.cmd([[
            --syntax match ObsidianTodoChecked /- \[x\].*/
            --highlight ObsidianTodoChecked cterm=strikethrough gui=strikethrough ctermfg=gray guifg=gray
            
            --syntax match ObsidianTodoUnchecked /- \[ \].*/
            --highlight ObsidianTodoUnchecked ctermfg=cyan guifg=cyan
            
            --syntax match ObsidianTodoCancelled /- \[-\].*/
            --highlight ObsidianTodoCancelled cterm=strikethrough gui=strikethrough ctermfg=red guifg=red
        --]])
    --end,
--})

-- Build cache of code block start/end lines
function _G.build_markdown_fold_cache(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cache = {}
    local in_block = false
    local block_start = nil
    
    for i, line in ipairs(lines) do
        if line:match("^%s*```") then
            if not in_block then
                block_start = i
                in_block = true
            else
                -- Found closing fence
                if block_start then
                    cache[block_start] = "start"
                    cache[i] = "end"
                end
                in_block = false
                block_start = nil
            end
        end
    end
    
    _G.markdown_fold_cache[bufnr] = cache
end

-- Fold expression using the cache
function _G.markdown_codeblock_fold()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.v.lnum
    local cache = _G.markdown_fold_cache[bufnr]
    
    if not cache then
        return "="
    end
    
    if cache[lnum] == "start" then
        return "a1"  -- Start fold after this line
    elseif cache[lnum] == "end" then
        return "s1"  -- End fold on this line
    end
    
    return "="
end

-- Clean up cache when buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(args)
        _G.markdown_fold_cache[args.buf] = nil
    end,
})

-- Automatically handle stale swap files
vim.api.nvim_create_autocmd("SwapExists", {
    callback = function(args)
        local original_file = args.file
        if not original_file then return end
        
        -- Get swap directory
        local swap_dir = vim.opt.directory:get()[1] or (vim.fn.stdpath("state") .. "/swap")
        
        -- Construct swap file path: neovim encodes paths by replacing / with %
        local full_path = vim.fn.fnamemodify(original_file, ":p")
        local encoded_path = full_path:gsub("/", "%%")
        local swap_file = swap_dir .. "/" .. encoded_path .. ".swp"
        
        -- CRITICAL SAFETY CHECKS:
        -- 1. Swap file must end with .swp
        -- 2. Swap file must be different from original file
        -- 3. Original file must NOT end with .swp (never delete the actual file!)
        -- 4. Swap file must exist
        if swap_file:match("%.swp$") 
           and not original_file:match("%.swp$")
           and swap_file ~= original_file
           and vim.fn.filereadable(swap_file) == 1 then
            -- Check if swap file is stale (can be opened for reading)
            local handle = io.open(swap_file, "r")
            if handle then
                handle:close()
                -- Remove ONLY the swap file, never the original file
                local result = os.remove(swap_file)
                if result then
                    vim.v.swapchoice = "e"  -- Edit anyway
                    vim.notify("Removed stale swap file", vim.log.levels.INFO)
                end
            end
        end
    end,
})
