--vim.api.nvim_set_keymap("n", "<leader>gg", ":LazyGit<CR>", {})


-- Better nav for omnicomplete
--inoremap <expr> <c-j> ("\<C-n>")
--inoremap <expr> <c-k> ("\<C-p>")

--" View
--" " Use alt + hjkl to resize windows
vim.api.nvim_set_keymap("n", "<A-j>", "<cmd>resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-k>", "<cmd>resize +2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-h>", "<cmd>vertical resize -2<CR>", {})
vim.api.nvim_set_keymap("n", "<A-l>", "<cmd>vertical resize +2<CR>", {})
--" " window options
--
vim.api.nvim_set_keymap("n", "<leader>vf", "<C-w><bar>", {})
vim.api.nvim_set_keymap("n", "<leader>ve", "<C-w>=", {})


--" I hate escape more than anything else
vim.api.nvim_set_keymap("i", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("t", "<C-k><C-j>", "<C-\\><C-n>", {})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {})

--" Add a space in normal mode
vim.api.nvim_set_keymap("n", "ss", "i<Space><Esc>", {})

--" TAB in general mode will move to text buffer
vim.api.nvim_set_keymap("n", "<TAB>", "<cmd>bnext<CR>", {})
vim.api.nvim_set_keymap("n", "<S-TAB>", "<cmd>bprevious<CR>", {})
vim.api.nvim_set_keymap("n", "bd", "<cmd>bdelete<CR>", {})

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
vim.api.nvim_set_keymap("n", "dt", "<Cmd>diffthis<CR>", {})
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

-- Go autocmd
vim.cmd [[
  autocmd FileType go map <buffer> <leader>rr :w<CR>:exec '!go run %'<CR>
  autocmd FileType go map <buffer> <leader>rb :w<CR>:exec '!go mod tidy'<CR>
]]

vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
