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
