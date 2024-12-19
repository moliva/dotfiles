local wk = require("which-key")

wk.add({
  { "<leader>g", group = "Git" },
})

vim.keymap.set("n", "<leader>gu", "<cmd>!gpull<cr>", { desc = "Git pull" })

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
