local M = {}

---Helper function to find the context node given a start node and different language contexts
---Returns the context node found, the language and the kind of node found (TS query)
---@param node TSNode
---@return TSNode | nil, string | nil, string | nil
local function find_node(node, langs)
  local file_type = vim.treesitter.get_parser():lang()
  local lang = langs[file_type]
  if not lang then
    vim.notify("Not supported language '" .. file_type .. "'")
    return nil, nil, nil
  end

  local kind = nil
  while node ~= nil do
    kind = lang.nodes[node:type()]
    if kind ~= nil then
      break
    end

    node = node:parent()
  end

  if not node then
    vim.notify("Not inside a known context")

    return nil, nil, nil
  end

  return node, file_type, kind
end

---Helper function to find the context node given a start node for different languages
---Returns the context node found, the language and the kind of node found (TS query)
---@param node TSNode
---@return TSNode | nil, string | nil, string | nil
local function find_context_node(node)
  local langs = require("kmobic33.lsp.contexts")

  return find_node(node, langs)
end

---Visually select a range from start row and column to end row and column
---Conditionally delete the range if delete is true
---@param start_row number
---@param start_column number
---@param end_row number
---@param end_column number
---@param delete boolean|nil
local function visually_select_range(start_row, start_column, end_row, end_column, delete)
  -- set cursor at the start
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_column })

  local column_cmd
  if end_column == 0 or end_column == 1 then
    column_cmd = "0"
  else
    column_cmd = "0" .. end_column - 1 .. "l"
  end

  local delete_cmd = delete and "d" or ""

  -- select the range
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(
      "<esc>v" .. end_row + 1 .. "gg" .. column_cmd .. "o" .. delete_cmd,
      true,
      false,
      true
    ),
    "x",
    true
  )
end

---Delete the surrounding function call to a list of arguments leaving the arguments alone
function M.delete_surrounding_call()
  local start = vim.treesitter.get_node()
  local langs = require("kmobic33.lsp.calls")
  local node, lang, kind = find_node(start, langs)

  if not node then
    return
  end

  local query = vim.treesitter.query.parse(lang, kind)
  local iter = query:iter_captures(node, 0)
  local _, each, _ = iter()

  local row, column, _ = each:end_()
  local row2, column2, _ = node:end_()

  -- TODO(miguel): check that this works for other langs other than lua function call - 2024/12/15
  -- might need to +1 the column
  visually_select_range(row, column - 1, row2, column2, true)

  row, column, _ = node:start()
  row2, column2, _ = each:start()

  -- TODO(miguel): check that this works for other langs other than lua function call - 2024/12/15
  -- might need to -1 the column
  visually_select_range(row, column, row2, column2 + 1, true)
end

---Delete the current function call with all its arguments
function M.delete_call()
  local start = vim.treesitter.get_node()
  local langs = require("kmobic33.lsp.calls")
  local node = find_node(start, langs)

  if not node then
    return
  end

  local row, column, _ = node:start()
  local row2, column2, _ = node:end_()

  visually_select_range(row, column, row2, column2, true)
end

---Select the current code context visually
function M.visual_select_context()
  local start = vim.treesitter.get_node()
  local node = find_context_node(start)
  if not node then
    return
  end

  local row, column, _ = node:start()
  local end_row, end_column, _ = node:end_()

  visually_select_range(row, column, end_row, end_column)
end

---Go to the current code body declaration
function M.go_to_current_declaration()
  local start = vim.treesitter.get_node():parent()
  local node, lang, kind = find_context_node(start)
  if not node then
    return
  end

  local query = vim.treesitter.query.parse(lang, kind)
  local iter = query:iter_captures(node, 0)
  local _, each, _ = iter()
  local row, column, _ = each:start()

  vim.api.nvim_win_set_cursor(0, { row + 1, column })
end

return M
