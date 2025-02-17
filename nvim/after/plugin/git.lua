-- local wk = require("which-key")
--
-- wk.add({
--   { "<leader>g", group = "Git" },
-- })

vim.keymap.set("n", "<leader>gu", function()
  vim.notify("Pulling last changes...")
  local r = vim.fn.system("git spull")
  vim.notify(r)
end, { desc = "Git pull" })

vim.keymap.set("n", "<leader>gk", function()
  local branch = vim.fn.input("Branch > ")
  local result = vim.cmd.Git("checkout " .. branch)

  vim.notify(result)
end, { desc = "Git checkout" })

vim.keymap.set("n", "<leader>gK", function()
  local branch = vim.fn.input("New Branch > ")
  local result = vim.cmd.Git("checkout -b" .. branch)

  vim.notify(result)
end, { desc = "Git checkout new branch" })

local function query_code_owners()
  local currentFile = vim.fn.expand("%p")

  local result = vim.system({ "query-codeowners", currentFile }):wait()

  if result.code == 0 then
    vim.notify(result.stdout)
  else
    vim.notify("Error: " .. result.stderr, vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>gw", query_code_owners, { desc = "Git checkout new branch" })
