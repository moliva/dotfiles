return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { { "echasnovski/mini.nvim", version = false } },
    config = function()
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 100

      local wk = require("which-key")

      wk.setup()

      wk.add({
        { "<leader>p", group = "Telescope" },
        { "<leader>g", group = "Git" },
      })
    end,
  },
}
