local meeting_mode = false

local function toggle_meeting_mode()
  if meeting_mode then
    -- show all widgets in the screen (neovim and tmux)
    vim.cmd([[
" show status bar space
silent set laststatus=2
" show lualine status bar
silent lua require('lualine').hide({unhide=true})
" show tmux status bar
silent !tmux set -g status on
" show barbar tabline header
silent set showtabline=2
" show sign column
silent lua vim.wo.signcolumn = "yes"
" show line number and relative number
silent set number relativenumber
" show folding column
silent set foldcolumn=1
]])

    vim.notify("Meeting mode disabled")
  else
    -- hide all widgets in the screen (neovim and tmux)
    vim.cmd([[
" remove space for folding column
silent set foldcolumn=0
" remove numbering and relative numbering columns
silent set nonumber norelativenumber
" remove sign column
silent lua vim.wo.signcolumn = "no"
" remove barbar tabline header
silent set showtabline=0
" remove tmux status bar
silent !tmux set -g status off
" remove lualine status bar
silent lua require('lualine').hide()
" remove status bar space
silent set laststatus=0
]])

    vim.notify("Meeting mode enabled")
  end

  meeting_mode = not meeting_mode
end

vim.keymap.set("n", "<leader>mm", toggle_meeting_mode, { desc = "Toggle meeting mode" })
