local M = {}

local wezterm = require("wezterm")
local act = wezterm.action

M.key = act.SendKey

---Input the tmux prefix
function M.tmux_prefix()
  return M.key({ mods = "CTRL", key = "a" })
end

---Input multiple keys ending in a newline
---@param keys string
---@return action
function M.multiple_actions(keys)
  local actions = {}

  for k in keys:gmatch(".") do
    table.insert(actions, M.key({ key = k }))
  end
  table.insert(actions, M.key({ key = "\n" }))

  return act.Multiple(actions)
end

---Helper function to create a key table
---@param mods string
---@param key string
---@param action action
---@return table
function M.key_table(mods, key, action)
  return {
    mods = mods,
    key = key,
    action = action,
  }
end

---Input a key with the CMD modifier
function M.cmd_key(k, action)
  return M.key_table("CMD", k, action)
end

---Input an action prefixed by the tmux prefix
function M.tmux_prefixed(action)
  return act.Multiple({
    M.tmux_prefix(),
    action,
  })
end

---Input key with tmux prefix
---@param key_t table
---@return action
function M.tmux_prefixed_key(key_t)
  return M.tmux_prefixed(M.key(key_t))
end

function M.cmd_to_tmux_prefix(k, tmux_key)
  return M.cmd_key(
    k,
    act.Multiple({
      M.tmux_prefix(),
      M.key({ key = tmux_key }),
    })
  )
end

return M
