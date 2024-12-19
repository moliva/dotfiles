local HOME = os.getenv("HOME")
local breakpoints_path = HOME .. '/.cache/dap/breakpoints.json'

local breakpoints = require('dap.breakpoints')

local M = {}

--- @param clear boolean
--- @return nil
function M.store(clear)
  local f, err = io.open(breakpoints_path, 'r')
  if err ~= nil then
    -- TODO - make sure the directory and file is created and initialized accordinly - moliva - 2023/06/02
    print(err)
    return
  end
  local load_bps_raw = f:read("*a")

  local bps = vim.fn.json_decode(load_bps_raw)
  local breakpoints_by_buf = breakpoints.get()

  if (clear) then
    for _, bufrn in ipairs(vim.api.nvim_list_bufs()) do
      local file_path = vim.api.nvim_buf_get_name(bufrn)
      if (bps[file_path] ~= nil) then
        bps[file_path] = {}
      end
    end
  else
    for buf, buf_bps in pairs(breakpoints_by_buf) do
      bps[vim.api.nvim_buf_get_name(buf)] = buf_bps
    end
  end

  local fp = io.open(breakpoints_path, 'w')
  if fp == nil then
    return
  end
  local final = vim.fn.json_encode(bps)

  fp:write(final)
  fp:close()
end

--- @return nil
function M.load()
  local fp = io.open(breakpoints_path, 'r')
  if fp == nil then
    return
  end

  local content = fp:read('*a')
  local bps = vim.fn.json_decode(content)
  local loaded_buffers = {}
  local found = false

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local file_name = vim.api.nvim_buf_get_name(buf)
    if (bps[file_name] ~= nil and bps[file_name] ~= {}) then
      found = true
    end
    loaded_buffers[file_name] = buf
  end

  if (found == false) then
    return
  end

  for path, buf_bps in pairs(bps) do
    for _, bp in pairs(buf_bps) do
      local line = bp.line
      local opts = {
        condition = bp.condition,
        log_message = bp.logMessage,
        hit_condition = bp.hitCondition
      }
      breakpoints.set(opts, tonumber(loaded_buffers[path]), line)
    end
  end
end

return M
