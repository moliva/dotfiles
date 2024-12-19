return {
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gi", "<cmd>Git init<cr>", desc = "Git Init" },
      { "<leader>gs", vim.cmd.Git, desc = "Git Status" },
      { "<leader>gp", "<cmd>Git push origin HEAD<cr>", desc = "Git Push" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
    },
  },

  {
    "f-person/git-blame.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>g", nil, desc = "Git" },
      { "<leader>go", "<cmd>GitBlameOpenFileURL<CR>", desc = "Open Git URL" },
      { "<leader>gc", "<cmd>GitBlameCopyFileURL<CR>", desc = "Copy Git URL" },
    },
  },
}
