vim.keymap.set(
  "n",
  "<leader>vcd",
  "<cmd>%s/\\<dbg\\!(\\(.*\\))/\\1/g<cr>",
  { desc = "Remove all dbg!() statements in the file" }
)

vim.keymap.set("n", "<leader>vcl", "<cmd>!just lint<cr>", { desc = "Run just lint" })


-- Wrap in dbg! for Rust debugging using Treesitter
vim.keymap.set("n", "<leader>rd", function()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end

  -- Get the parent nodes to find a valid expression
  local current = node
  while
    current
    and not vim.tbl_contains({
      "expression_statement",
      "assignment_expression",
      "binary_expression",
      "unary_expression",
      "call_expression",
      "field_expression",
      "identifier",
    }, current:type())
  do
    current = current:parent()
  end

  if not current then
    vim.notify("No valid expression found", vim.log.levels.WARN)
    return
  end

  local start_row, start_col, end_row, end_col = current:range()
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

  -- Handle single-line and multi-line expressions
  local text
  if start_row == end_row then
    text = string.sub(lines[1], start_col + 1, end_col)
  else
    local result = { string.sub(lines[1], start_col + 1) }
    for i = 2, #lines - 1 do
      table.insert(result, lines[i])
    end
    table.insert(result, string.sub(lines[#lines], 1, end_col))
    text = table.concat(result, "\n")
  end

  -- Replace the text with dbg! wrapped version
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { string.format("dbg!(%s)", text) })
end, { desc = "Wrap expression in dbg!" })

vim.keymap.set("v", "<leader>rd", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
  local end_row, end_col = end_pos[2] - 1, end_pos[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  local text

  if start_row == end_row then
    text = string.sub(lines[1], start_col + 1, end_col)
  else
    local result = { string.sub(lines[1], start_col + 1) }
    for i = 2, #lines - 1 do
      table.insert(result, lines[i])
    end
    table.insert(result, string.sub(lines[#lines], 1, end_col))
    text = table.concat(result, "\n")
  end

  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { string.format("dbg!(%s)", text) })
end, { desc = "Wrap selection in dbg!" })
