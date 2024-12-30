vim.g.mapleader = " "

local u = require("kmobic33.utils")

-- move things around highlighted in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move line up or down
vim.keymap.set({ "n", "i", "v" }, "<a-k>", "<cmd>m .-2<cr>")
vim.keymap.set({ "n", "i", "v" }, "<a-j>", "<cmd>m .+1<cr>")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<A-w>", "<cmd>%bd|e#<cr>", { desc = "Close all buffers but this one" })
-- vim.keymap.set("n", "<A-Q>", "<cmd>bufdo bwipeout<cr>", { desc = "Close all buffers"})
vim.keymap.set("n", "<A-Q>", "<cmd>1,$bd!<cr>", { desc = "Close all buffers" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over without replacing the buffer" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete into an anonymous buffer" })
vim.keymap.set({ "n", "v" }, "<leader><leader>d", '"+d', { desc = "Delete to system clipboard" })

vim.keymap.set("n", "<leader>D", '"_D', { desc = "Delete into an anonymous buffer" })
vim.keymap.set("n", "<leader><leader>D", '"+D', { desc = "Delete to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>c", '"_c', { desc = "Change into an anonymous buffer" })
vim.keymap.set({ "n", "v" }, "<leader><leader>c", '"+c', { desc = "Change to system clipboard" })

vim.keymap.set("n", "<leader><leader>y", function()
  vim.fn.setreg("+", vim.fn.getreg(""))
end, { desc = "Copy unnamed register to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y')

-- select nvim pane with <leader>1-9
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, i .. "<C-W>w", { desc = "Move to window " .. i })
end

-- alternate window
vim.keymap.set("n", "<leader><leader>a", "<C-w><C-p>", { desc = "Alternate window" })

-- TODO - delete/select/yank until _ - moliva - 2024/03/05
-- TODO - delete/select/yank until next capitalized letter - moliva - 2024/03/05

-- TODO - go to the function declaration (when inside that function) - moliva - 2024/03/05
-- TODO - delete between parenthesis or , and parenthesis (function call) - moliva - 2024/03/08
-- TODO - cmd+shift+s => save all buffers - moliva - 2024/03/09

-- Close all buffers except visible ones
vim.keymap.set("n", "<leader>bo", function()
  local visible_buffers = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not visible_buffers[buf] then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
  vim.notify("Closed all non-visible buffers")
end, { desc = "Close all non-visible buffers" })

-- window movement
-- vim.keymap.set("n", "<c-j>", "<c-w>j")
-- vim.keymap.set("n", "<c-k>", "<c-w>k")
-- vim.keymap.set("n", "<c-h>", "<c-w>h")
-- vim.keymap.set("n", "<c-l>", "<c-w>l")

-- control c acts as escape in visual edit mode
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

-- changes to another tmux session
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- quickfix + location list movement
vim.keymap.set("n", "<leader>q", u.toggle_quickfix, { desc = "Quickfix toggle" })
-- NOTE(miguel): need to defer this, to avoid c-j command to be called on startup and showing errors - 2024/12/14
vim.defer_fn(function()
  vim.keymap.set("n", "<c-j>", "<cmd>cnext<CR>zz", { desc = "Quickfix next" })
end, 0)
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Quickfix previous" })
-- :cdo {cmd}

-- TODO(miguel): not sure this works as i intend it - 2024/12/14
vim.keymap.set("n", "<leader>l", u.toggle_locationlist, { desc = "Location list toggle" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Location list next" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Location list previous" })

-- substitute the current visual selection in the entire buffer
vim.keymap.set(
  "n",
  "<leader><leader>s",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Substitute current word for another in the entire buffer" }
)
vim.keymap.set(
  "v",
  "<leader><leader>s",
  'y:%s/<C-r>"/<C-r>"/g<Left><Left>',
  { desc = "Substitute current selection for another in the entire buffer" }
)

-- substitute the current visual selection in the line
vim.keymap.set(
  "n",
  "<leader>s",
  ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Substitute current word for another in the line" }
)
vim.keymap.set(
  "v",
  "<leader>s",
  'y:s/<C-r>"/<C-r>"/g<Left><Left>',
  { desc = "Substitute current selection for another in the line" }
)

-- set execution permissions to the current file
vim.keymap.set(
  "n",
  "<leader><leader>x",
  "<cmd>!chmod +x %<CR>",
  { desc = "Make current file executable", silent = true }
)

-- save on control s, control q for quitting and control x for quit/saving
local modes = { "n", "i", "v" }
vim.keymap.set(modes, "<a-S>", "<cmd>w<CR>")
-- vim.keymap.set(modes, "<C-x>", "<cmd>x<CR>")
vim.keymap.set(modes, "<C-q>", "<cmd>q<CR>")

-- alternate buffer!
vim.keymap.set(modes, "<a-a>", "<cmd>e #<cr>")

-- vim.keymap.set(modes, "<C-q>q", "<cmd>qa!<CR>")
-- vim.keymap.set(modes, "<C-x>x", "<cmd>xa!<CR>")

-- remap splits to the ones used in tmux
vim.keymap.set("n", "<C-w>\\", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-w>-", "<cmd>split<CR>")

-- split current tab into two
-- not used anymore with barbar
-- vim.keymap.set("n", "<C-w>t", "<cmd>tab split<CR>")

-- clear highlighted search
vim.keymap.set("n", "<leader>,", "<cmd>set hlsearch! hlsearch?<CR>", { desc = "Toggle search highlight" })

-- go to
vim.keymap.set("n", "gR", function()
  local cwd = vim.fn.getcwd()
  local file
  if u.file_exists(cwd .. "/README.md") then
    file = cwd .. "/README.md"
  end

  if file then
    vim.cmd("e " .. file)
  end
end, { desc = "Go to README" })

-- find the project description file (e.g. package.json, Cargo.toml) from the current path upwards
vim.keymap.set(
  "n",
  "gp",
  u.edit_project_description_file_from_current_file,
  { desc = "Looks up for the project description file (e.g. package.json, Cargo.toml) from the current path upwards" }
)

-- find the project description file (e.g. package.json, Cargo.toml) at the root of the cwd
vim.keymap.set(
  "n",
  "gP",
  u.edit_project_description_file_in_cwd,
  { desc = "Open project description file at cwd (e.g. package.json, Cargo.toml)" }
)

-- local wk = require("which-key")

-- source code + lsp restart
--
-- wk.add({
--   { "<leader><leader>r", group = "Source code" },
-- })
vim.keymap.set("n", "<leader><leader>rf", "<cmd>source %<cr><cmd>lua vim.notify('Sourced '.. vim.fn.expand('%'))<cr>")
vim.keymap.set("n", "<leader><leader>rs", ":.lua<cr><cmd>lua vim.notify('Sourced lines')<cr>")
vim.keymap.set("v", "<leader><leader>rs", ":lua<cr><cmd>lua vim.notify('Sourced lines')<cr>")
vim.keymap.set(
  "n",
  "<leader><leader>rl",
  "<cmd>LspRestart<cr><cmd>lua vim.print('LSPs restarted')<cr>",
  { desc = "Restart LSPs" }
)

-- escape terminal mode
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

-- Buffer navigation
-- vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move to window using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
-- vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
-- vim.keymap.set("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down" })
-- vim.keymap.set("n", "<A-Up>", ":m .-2<cr>==", { desc = "Move line up" })
-- vim.keymap.set("i", "<A-Down>", "<esc>:m .+1<cr>==gi", { desc = "Move line down" })
-- vim.keymap.set("i", "<A-Up>", "<esc>:m .-2<cr>==gi", { desc = "Move line up" })
-- vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
-- vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Clear search with <esc>
-- vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file
-- vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Duplicate lines
vim.keymap.set("n", "<A-S-j>", "yyp", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-S-k>", "yyP", { desc = "Duplicate line up" })

-- Center screen after various movements
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")
