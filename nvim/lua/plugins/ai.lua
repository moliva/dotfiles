return {
  -- llms and ai code support
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          javascript = true,
          typescript = true,
          javascriptreact = true,
          typescriptreact = true,
          python = true,
          rust = true,
          go = true,
          lua = true,
          markdown = true,
          gitcommit = true,
          ["*"] = false, -- disable for all other filetypes
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "main",
  --   cmd = "CopilotChat",
  --   opts = function()
  --     local user = vim.env.USER or "User"
  --     user = user:sub(1, 1):upper() .. user:sub(2)
  --     return {
  --       auto_insert_mode = true,
  --       question_header = "  " .. user .. " ",
  --       answer_header = "  Copilot ",
  --       window = {
  --         width = 0.4,
  --       },
  --     }
  --   end,
  --   keys = {
  --     { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
  --     { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
  --     {
  --       "<leader>aA",
  --       -- "<leader>aa",
  --       function()
  --         return require("CopilotChat").toggle()
  --       end,
  --       desc = "Toggle (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ax",
  --       function()
  --         return require("CopilotChat").reset()
  --       end,
  --       desc = "Clear (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input)
  --         end
  --       end,
  --       desc = "Quick Chat (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     -- Show prompts actions with telescope
  --     {
  --       "<leader>ap",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         return actions.pick(actions.prompt_actions({
  --           selection = require("CopilotChat.select").visual,
  --         }))
  --       end,
  --       desc = "Prompt Actions (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     -- Quick actions
  --     {
  --       "<leader>ae",
  --       function()
  --         require("CopilotChat").ask(
  --           "Explain how this code works",
  --           { selection = require("CopilotChat.select").visual }
  --         )
  --       end,
  --       desc = "Explain Code",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ar",
  --       function()
  --         require("CopilotChat").ask(
  --           "Review this code and suggest improvements",
  --           { selection = require("CopilotChat.select").visual }
  --         )
  --       end,
  --       desc = "Review Code",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>at",
  --       function()
  --         require("CopilotChat").ask(
  --           "Generate unit tests for this code",
  --           { selection = require("CopilotChat.select").visual }
  --         )
  --       end,
  --       desc = "Generate Tests",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ad",
  --       function()
  --         require("CopilotChat").ask(
  --           "Generate documentation for this code",
  --           { selection = require("CopilotChat.select").visual }
  --         )
  --       end,
  --       desc = "Generate Docs",
  --       mode = { "n", "v" },
  --     },
  --   },
  --   config = function(_, opts)
  --     -- local chat = require("copilot.chat")
  --     local chat = require("CopilotChat")
  --
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-chat",
  --       callback = function()
  --         vim.opt_local.relativenumber = false
  --         vim.opt_local.number = false
  --       end,
  --     })
  --
  --     chat.setup(opts)
  --   end,
  -- },

  {
    "yetone/avante.nvim",
    keys = {
      {
        "<leader>aa",
        "<cmd>AvanteAsk<cr>",
        desc = "Avante ask",
        mode = { "n", "v" },
      },
    },
    -- event = "VeryLazy",
    -- lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        -- event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
      },
    },
  },
}
