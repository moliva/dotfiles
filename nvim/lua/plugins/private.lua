return {
  {
    "moliva/private.nvim",
    -- dir = "/Users/moliva/repos/private.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufWritePost" },
    keys = {
      { "<leader>i", nil, desc = "Private" },

      { "<leader>ie", nil, desc = "Encrypt" },
      {
        "<leader>iep",
        function()
          require("private.predef_actions").encrypt_path()
        end,
        desc = "encrypt action",
      },
      {
        "<leader>iec",
        function()
          require("private.predef_actions").encrypt_current_file()
        end,
        desc = "encrypt current file",
      },
      { "<leader>id", nil, desc = "Decrypt" },
      {
        "<leader>idp",
        function()
          require("private.predef_actions").decrypt_path()
        end,
        desc = "decrypt action",
      },
      {
        "<leader>idc",
        function()
          require("private.predef_actions").decrypt_current_file()
        end,
        desc = "decrypt current file",
      },

      --#region debugging utils
      { "<leader>ir", ":Lazy reload private.nvim<CR>", desc = "Reload plugin" },
      {
        "<leader>ic",
        function()
          print(vim.inspect(require("private").cache))
        end,
        desc = "inspect cache",
      },
      --#endregion
    },
    config = function()
      require("private").setup()
    end,
  },
}
