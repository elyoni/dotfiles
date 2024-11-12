vim.g.mapleader = "," -- Make sure to set `mapleader` before lazy so your mappings are correct


vim.opt.hidden = true          -- Required to keep multiple buffers open multiple buffers
vim.opt.wrap = false           -- Display long lines as just one line
vim.opt.linebreak = true       -- Don't split the word and wrap is set
vim.opt.encoding = "utf-8"     -- The encoding displayed
vim.opt.pumheight = 10         -- Makes popup menu smaller
vim.opt.fileencoding = "utf-8" -- The encoding written to file
vim.opt.ruler = true           -- Show the cursor position all the time
vim.opt.cmdheight = 2          -- More space for displaying messages
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
--set laststatus=0                       -- Always display the status line
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
vim.opt.timeoutlen = 500                       -- By default timeoutlen is 1000 ms
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
