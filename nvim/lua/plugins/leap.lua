local function leap_forward()
  local leap = require('leap')
  local current_window = vim.fn.win_getid()
  leap.leap { target_windows = { current_window } }
end

local function leap_global()
  local leap = require('leap')
  local focusable_windows_on_tabpage = vim.tbl_filter(
    function(win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  leap.leap { target_windows = focusable_windows_on_tabpage }
end

return {
  'ggandor/leap.nvim',
  keys = {
    { '<leader><leader>c',  leap_forward, desc = "Leap forward" },
    { '<leader><leader>gc', leap_global,  desc = "Leap global" }
  },
  config = function()
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
  end
}
