local term = vim.api.nvim_create_augroup("custom-term-open", { clear = true })

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = term,
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
    -- Make the buffer hidden from buffer lists and other UI elements
    vim.bo[buf].buflisted = false
    vim.bo[buf].bufhidden = 'hide'
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local state = {
  floating = {
    win = -1,
    buf = -1,
    chan = -1,
  },
  docked = {
    win = -1,
  },
}

local function toggle_terminal()
  if vim.api.nvim_win_is_valid(state.docked.win) then
    -- If terminal is docked, convert it to floating
    local buf = state.floating.buf
    vim.api.nvim_win_close(state.docked.win, false)
    state.docked.win = -1

    state.floating = create_floating_window({ buf = buf })
  elseif not vim.api.nvim_win_is_valid(state.floating.win) then
    -- If no terminal window exists, create floating
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      state.floating.chan = vim.bo.channel
    end
  else
    -- Hide floating window
    vim.api.nvim_win_hide(state.floating.win)
  end
end

local function dock_terminal_right()
  if vim.api.nvim_win_is_valid(state.floating.win) then
    -- If floating window exists, convert it to a normal window
    local buf = state.floating.buf
    vim.api.nvim_win_close(state.floating.win, false)

    -- Create new vertical split and move it right
    vim.cmd("vsplit")
    vim.cmd("wincmd L")

    -- Set the buffer in the new window
    vim.api.nvim_win_set_buf(0, buf)

    -- Update state
    state.floating.win = -1
    state.docked.win = vim.api.nvim_get_current_win()
  else
    -- Create a new vertical split
    vim.cmd("vsplit")
    vim.cmd("wincmd L")

    -- If we already have a terminal buffer, use it
    if vim.api.nvim_buf_is_valid(state.floating.buf) and vim.bo[state.floating.buf].buftype == "terminal" then
      vim.api.nvim_win_set_buf(0, state.floating.buf)
    else
      vim.cmd.terminal()
      state.floating.buf = vim.api.nvim_get_current_buf()
      state.floating.chan = vim.bo.channel
    end

    -- Update state
    state.docked.win = vim.api.nvim_get_current_win()
  end

  -- Set the width to 1/3 of the screen
  local width = math.floor(vim.o.columns * 0.3)
  vim.api.nvim_win_set_width(0, width)
end

vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>tr", dock_terminal_right, { desc = "Dock terminal right" })
vim.keymap.set("n", "<leader>tj", function()
  if state.floating.chan ~= -1 then
    -- vim.fn.chansend(state.floating.chan, "yarn test:watch\r")
    vim.api.nvim_chan_send(state.floating.chan, "yarn test:watch\r")
  end
end, { desc = "Send job to terminal" })
