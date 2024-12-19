vim.keymap.set(
  "n",
  "<leader>vcd",
  "<cmd>%s/\\<dbg\\!(\\(.*\\))/\\1/g<cr>",
  { desc = "Remove all dbg!() statements in the file" }
)

vim.keymap.set("n", "<leader>vcl", "<cmd>!just lint<cr>", { desc = "Run just lint" })
