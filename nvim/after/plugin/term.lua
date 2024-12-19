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
}

local function toggle_terminal()
  -- if job_id ~= 0 then
  --   vim.fn.chanclose(job_id)
  -- end

  -- vim.cmd.vnew()
  -- vim.cmd.term()
  -- vim.cmd.wincmd("J")
  -- vim.api.nvim_win_set_height(0, 10)
  --

  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()

      state.floating.chan = vim.bo.channel
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Open terminal" })
vim.keymap.set("n", "<leader>tj", function()
  if state.floating.chan ~= -1 then
    -- vim.fn.chansend(state.floating.chan, "yarn test:watch\r")
    vim.api.nvim_chan_send(state.floating.chan, "yarn test:watch\r")
  end
end, { desc = "Send job to terminal" })
