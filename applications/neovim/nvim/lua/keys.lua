--vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", {})

local opts = { noremap = true, silent = true }

local function with_desc(desc)
    return vim.tbl_extend('force', opts, { desc = desc })
end

-- Better nav for omnicomplete
--inoremap <expr> <c-j> ("\<C-n>")
--inoremap <expr> <c-k> ("\<C-p>")
-- Function to toggle wrap mode

vim.keymap.set('n', '<leader>gs', GitSite, with_desc("Open GitHub link for current line or selection"))
vim.keymap.set('v', '<leader>gs', GitSite, with_desc("Open GitHub link for current line or selection"))
-- Key binding to toggle wrap mode
--" View
--" " Use alt + hjkl to resize windows
vim.keymap.set("n", "<A-j>", "<cmd>resize -2<CR>", with_desc("Resize window down"))
vim.keymap.set("n", "<A-k>", "<cmd>resize +2<CR>", with_desc("Resize window up"))
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<CR>", with_desc("Resize window left"))
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<CR>", with_desc("Resize window right"))
--" " window options

-- Window splits and resize
vim.keymap.set("n", "<leader>vf", "<C-w><bar>", with_desc("Split window vertically (maximize current)"))
vim.keymap.set("n", "<leader>ve", "<C-w>=", with_desc("Equalize all windows"))
vim.keymap.set("n", "<leader>vsh", "<C-w>s", with_desc("Split window horizontally"))
vim.keymap.set("n", "<leader>vsv", "<C-w>v", with_desc("Split window vertically"))
vim.keymap.set("n", "<leader>vn", ":set relativenumber!<CR>", with_desc("Toggle relative line numbers"))

-- Toggle wrap mode (assuming ToggleWrap function defined)
vim.keymap.set('n', '<leader>vw', ToggleWrap, with_desc("Toggle wrap mode"))


-- Folding
vim.keymap.set("n", "zC", "zM", with_desc("Close all folds"))
vim.keymap.set("n", "zO", "zR", with_desc("Open all folds"))
vim.keymap.set("n", "<leader>zf", "<cmd>foldclose<CR>", with_desc("Close current fold"))
vim.keymap.set("n", "<leader>zF", "zM", with_desc("Close all folds deeply"))
vim.keymap.set("n", "<leader>zt", "za", with_desc("Toggle fold"))
vim.keymap.set("n", "<leader>zO", "zR", with_desc("Open all folds deeply"))
vim.cmd("set foldmethod=marker")

-- Tabs
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", with_desc("New tab"))
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", with_desc("Close tab"))
vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>", with_desc("Next tab"))
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>", with_desc("Previous tab"))
vim.keymap.set("n", "<leader>tm", "<cmd>tabmove ", with_desc("Move tab"))

-- Navigation between windows
vim.keymap.set("n", "<C-l>", "<C-W><Right>", with_desc("Navigate to right window"))
vim.keymap.set("n", "<C-h>", "<C-W><Left>", with_desc("Navigate to left window"))
vim.keymap.set("n", "<C-k>", "<C-W><Up>", with_desc("Navigate to upper window"))
vim.keymap.set("n", "<C-j>", "<C-W><Down>", with_desc("Navigate to lower window"))

vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-W><Right>", with_desc("Navigate to right window from terminal"))
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-W><Left>", with_desc("Navigate to left window from terminal"))
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-W><Up>", with_desc("Navigate to upper window from terminal"))
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-W><Down>", with_desc("Navigate to lower window from terminal"))

-- Insert and terminal mode escape alternatives

vim.keymap.set("i", "kj", "<Esc>", with_desc("Exit insert mode"))
vim.keymap.set("t", "<C-k><C-j>", "<C-\\><C-n>", with_desc("Exit terminal mode"))
-- In your init.lua or relevant config file
vim.keymap.set('t', '<C-\\><C-n>', '<C-\\><C-n>', with_desc('Exit terminal mode'))
-- Or use a different key combo like Ctrl+Q
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', with_desc('Exit terminal mode'))
--vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)

-- Navigation improvements (gj/gk for wrapped lines)
vim.keymap.set("n", "j", "v:count ? 'j' : 'gj'",
    vim.tbl_extend('force', opts, { expr = true, desc = "Move down (respecting wrap)" }))
vim.keymap.set("n", "k", "v:count ? 'k' : 'gk'",
    vim.tbl_extend('force', opts, { expr = true, desc = "Move up (respecting wrap)" }))

-- Add a space in normal mode
vim.keymap.set("n", "ss", "i<Space><Esc>", with_desc("Insert space"))
vim.keymap.set("n", "sn", "i<Space>\\<Enter><Esc>==", with_desc("Insert space and newline"))

-- Buffer navigation
vim.keymap.set("n", "<TAB>", "<cmd>bnext<CR>", with_desc("Next buffer"))
vim.keymap.set("n", "<S-TAB>", "<cmd>bprevious<CR>", with_desc("Previous buffer"))
vim.keymap.set("n", "<C-DEL>", "<cmd>tabnew<CR>", with_desc("New tab"))

-- Easy save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", with_desc("Save file"))

-- Visual mode indenting stays in visual mode
vim.keymap.set("v", "<", "<gv", with_desc("Indent left and keep selection"))
vim.keymap.set("v", ">", ">gv", with_desc("Indent right and keep selection"))

-- Disable annoying copy-paste overwrite of default register
vim.keymap.set("v", "p", "\"_dP", with_desc("Paste without overwriting register"))
vim.keymap.set("v", "P", "\"_dp", with_desc("Paste before without overwriting register"))
vim.keymap.set("s", "P", "\"_dP", with_desc("Paste before without overwriting register"))
vim.keymap.set("s", "p", "\"_dp", with_desc("Paste without overwriting register"))

-- Spelling
vim.keymap.set("n", "zt", "<cmd>set spell!<CR>", with_desc("Toggle spell check"))
vim.keymap.set("n", "zl", "]s", with_desc("Next spelling error"))
vim.keymap.set("n", "zh", "[s", with_desc("Previous spelling error"))

-- Diff
vim.keymap.set("n", "<leader>dt", "<cmd>diffthis<CR>", with_desc("Enable diff for current buffer"))
vim.keymap.set("n", "<leader>do", "<cmd>diffoff<CR>", with_desc("Disable diff"))
vim.keymap.set("n", "<leader>ds", "<cmd>diffoff<CR>", with_desc("Disable diff"))

-- Diff navigation
vim.keymap.set("n", "dj", "]c", with_desc("Next diff change"))
vim.keymap.set("n", "dk", "[c", with_desc("Previous diff change"))


vim.keymap.set("n", "<F5>", "<cmd>r! date<CR>", with_desc("Insert current date (normal mode)"))
vim.keymap.set("i", "<F5>", "<cmd>r! date<CR>", with_desc("Insert current date (insert mode)"))

-- Python autocmd
vim.cmd [[
  autocmd FileType python map <buffer> <leader>rr :w<CR>:exec '!python3' shellescape(@%, 2)<CR>
  autocmd FileType python map <buffer> <leader>rb :w<CR>:exec '!poetry run python' shellescape(@%, 1)<CR>
]]

-- Rust autocmd
vim.cmd [[
  autocmd FileType rust map <buffer> <leader>rr :w<CR>:split term://cargo run<CR>
  autocmd FileType rust map <buffer> <leader>rbx :w<CR>:split term://cargo build<CR>
  autocmd FileType rust map <buffer> <leader>rba :w<CR>:split term://cargo build --target aarch64-unknown-linux-gnu<CR>
  autocmd FileType rust map <buffer> <leader>rc :w<CR>:exec '!cargo check'<CR>
  autocmd FileType rust map <buffer> <leader>rt :w<CR>:exec '!cargo test -- --nocapture'<CR>
]]

vim.cmd [[
  autocmd FileType cpp map <buffer> <leader>rr :w<CR>:split term://g++ -O2 -std=c++17 -Wall -fsanitize=address -pedantic % -o a && ./a && sleep 0.1 && rm a<CR>
]]

vim.cmd [[
  autocmd FileType sh map <buffer> <leader>rr :w<CR>:split term://./%<CR>
]]

-- Go autocmd
--autocmd FileType go nnoremap <buffer> <leader>rr :w<CR>:call RunGo()<CR>
vim.cmd [[
  autocmd FileType go map <buffer> <leader>rb :w<CR>:exec '!go mod tidy'<CR>
]]

-- Define a Lua function to run the appropriate Go command
function run_go_command()
    -- Get the current file name
    local filename = vim.fn.expand('%:t')
    -- Get the full path to the current file
    local filepath = vim.fn.expand('%:p')

    vim.cmd.normal("wa")
    -- Check if the file name ends with _test.go
    if filename:match('_test%.go$') then
        -- Run go test for test files
        -- TermExec cmd="echo
        vim.cmd('TermExec cmd="go test -v ' .. filepath .. '"')
    else
        -- Run go run for other Go files
        vim.cmd('TermExec cmd="go run ' .. filepath .. '"')
    end
end

-- Create an autocmd for Go file types
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
        -- Map <leader>rr to run the Go command
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rr', ':lua run_go_command()<CR>', { noremap = true, silent = true })
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'plantuml',
    callback = function()
        -- Map <leader>rr to run the Go command
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>po', '<cmd>:PlantumlOpen<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pt', '<cmd>:PlantumlToggle<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ps', '<cmd>:PlantumlStart<CR>', { noremap = true, silent = true })
    end
})

--vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    --vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'JK', [[<Cmd>q<CR>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    --vim.cmd.startinsert
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

--vim.api.nvim_set_keymap("n", "<leader>oo",
--    ":cd $HOME/.obsidian/work | :e main.md<cr>",
--    { silent = true, expr = true })

--vim.keymap.set("n", "<leader>oo", ":cd $HOME/.obsidian/work | :e main.md<cr>")
vim.keymap.set("n", "<leader>aa", ":VimwikiSearchTags ", with_desc("Search wiki tags"))
-- Map <Leader>r to run a command in a new terminal split
vim.keymap.set('n', '<Leader>t', ':split<CR>:terminal ',
    vim.tbl_extend('force', opts, { silent = false, desc = "Open terminal in split" }))
