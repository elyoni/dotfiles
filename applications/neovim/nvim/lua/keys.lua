--vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", {})


-- Better nav for omnicomplete
--inoremap <expr> <c-j> ("\<C-n>")
--inoremap <expr> <c-k> ("\<C-p>")
-- Function to toggle wrap mode
function toggle_wrap()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print("Wrap mode off")
    else
        vim.wo.wrap = true
        print("Wrap mode on")
    end
end

-- Key binding to toggle wrap mode
--" View
--" " Use alt + hjkl to resize windows
vim.api.nvim_set_keymap("n", "<A-j>", "<cmd>resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-k>", "<cmd>resize +2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-h>", "<cmd>vertical resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-l>", "<cmd>vertical resize +2<CR>", {})
--" " window options
--
vim.api.nvim_set_keymap("n", "<leader>vf", "<C-w><bar>", {})                                            -- Split window vertically
vim.api.nvim_set_keymap("n", "<leader>ve", "<C-w>=", {})                                                -- Equalize all windows
vim.api.nvim_set_keymap('n', '<leader>vw', ':lua toggle_wrap()<CR>', { noremap = true, silent = true }) -- Toggle wrap mode
vim.api.nvim_set_keymap("n", "<leader>vsh", "<C-w>s", {})                                               -- Split window horizontally
vim.api.nvim_set_keymap("n", "<leader>vsv", "<C-w>v", {})                                               -- Split window vertically
vim.api.nvim_set_keymap("n", "<leader>vn", ":set relativenumber!<CR>", {})                              -- Toggle relative line numbers


-- " Folding
vim.api.nvim_set_keymap("n", "zC", "zM", {})
vim.api.nvim_set_keymap("n", "zO", "zR", {})

-- tabs
vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>tabnew<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>tabclose<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>tl", "<cmd>tabnext<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>th", "<cmd>tabprevious<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>tm", "<cmd>tabmove ", {})


--" I hate escape more than anything else
vim.api.nvim_set_keymap("i", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("t", "<C-k><C-j>", "<C-\\><C-n>", {})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})

--" Add a space in normal mode
vim.api.nvim_set_keymap("n", "ss", "i<Space><Esc>", {})

--" TAB in general mode will move to text buffer
vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>bnext<CR>", {})
vim.api.nvim_set_keymap("n", "<S-TAB>", "<cmd>bprevious<CR>", {})
--vim.api.nvim_set_keymap("n", "bd", "<cmd>bdelete<CR>", {})
--
vim.api.nvim_set_keymap("n", "<C-DEL>", "<cmd>tabnew<CR>", {})


--" Easy save
vim.api.nvim_set_keymap("n", "<C-s>", "<cmd>w<CR>", {})

--" <TAB>: completion.
--inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

--" Better tabbing
vim.api.nvim_set_keymap("v", "<", "<gv", {})
vim.api.nvim_set_keymap("v", ">", ">gv", {})

--" Better window navigation
vim.api.nvim_set_keymap("n", "<C-l>", "<C-W><Right>", {})
vim.api.nvim_set_keymap("n", "<C-h>", "<C-W><Left>", {})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-W><Up>", {})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-W><Down>", {})

vim.api.nvim_set_keymap("n", "<C-k>", "<C-W><Up>", {})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-W><Down>", {})

vim.api.nvim_set_keymap("n", "j", "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "k", "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

--vim.api.nvim_set_keymap("i", "<C-l>", "<Esc><C-W><Right>", {})
--vim.api.nvim_set_keymap("i", "<C-h>", "<Esc><C-W><Left>", {})
--vim.api.nvim_set_keymap("i", "<C-k>", "<Esc><C-W><Up>", {})
--vim.api.nvim_set_keymap("i", "<C-j>", "<Esc><C-W><Down>", {})

vim.api.nvim_set_keymap("t", "<C-l>", "<C-\\><C-n><C-W><Right>", {})
vim.api.nvim_set_keymap("t", "<C-h>", "<C-\\><C-n><C-W><Left>", {})
vim.api.nvim_set_keymap("t", "<C-k>", "<C-\\><C-n><C-W><Up>", {})
vim.api.nvim_set_keymap("t", "<C-j>", "<C-\\><C-n><C-W><Down>", {})


--" Disable mark CAPS
--"vmap u <nop>
--"vmap U <nop>
--
-- Folding
vim.api.nvim_set_keymap("n", "<leader>zf", "<cmd>foldclose<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>zF", "zM", {})
vim.api.nvim_set_keymap("n", "<leader>zt", "za", {})
vim.cmd("set foldmethod=marker")

--" Spelling
vim.api.nvim_set_keymap("n", "zt", "<cmd>set spell!<CR>", {})
vim.api.nvim_set_keymap("n", "zl", "]s", {})
vim.api.nvim_set_keymap("n", "zh", "[s", {})

--" Easy Diff
--" " Set diff this
vim.api.nvim_set_keymap("n", "<leader>dt", "<Cmd>diffthis<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>do", "<Cmd>diffoff<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>ds", "<Cmd>diffoff<CR>", {})
--nnoremap dt :diffthis<CR>

--" " Diff jump
vim.api.nvim_set_keymap("n", "dj", "]c", {})
vim.api.nvim_set_keymap("n", "dk", "[c", {})

--" Cancel the insasaly annoying copy paste
vim.api.nvim_set_keymap("v", "p", "\"_dP", {})
vim.api.nvim_set_keymap("v", "P", "\"_dp", {})
vim.api.nvim_set_keymap("s", "P", "\"_dP", {})
vim.api.nvim_set_keymap("s", "p", "\"_dp", {})
--vnore p "_dP
--vnore P "_dp
--xnoremap p "_dP
--xnoremap P "_dp

vim.api.nvim_set_keymap("n", "<F5>", "<cmd>r! date<CR>", {})
vim.api.nvim_set_keymap("i", "<F5>", "<cmd>r! date<CR>", {})


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

vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
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
vim.keymap.set("n", "<leader>aa", ":VimwikiSearchTags ")
-- Map <Leader>r to run a command in a new terminal split
vim.api.nvim_set_keymap('n', '<Leader>t', ':split<CR>:terminal ', { noremap = true, silent = false })
