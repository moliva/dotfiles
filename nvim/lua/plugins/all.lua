return {
  -- tree dir
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- secure notes (1password)
  { "mrjones2014/op.nvim", cmd = { "OpOpen", "OpSignin", "OpNote", "OpView", "OpEdit" }, build = "make install" },

  -- markdown
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },

  -- edit
  {
    "tpope/vim-surround",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- visual multi cursor edit
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      { "<c-n>", nil, desc = "Vim visual multi (next occurrence)" },
    },
  },

  -- code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    keys = {
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
      {
        "zK",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Peek fold",
      },
    },
    config = function()
      require("lsp-zero")
      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "lsp", "indent" }
        end,
      })
    end,
  },

  -- TODO - check this one - moliva - 2024/12/15
  -- use('tpope/vim-repeat')

  -- git utils
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle },
    },
  },

  -- linters
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        -- lua = { "luacheck" }, -- lua check not working with mason
        -- lua = { "selene" }, -- not adding lots of value currently
        json = { "jsonlint" },
      }
    end,
  },

  -- formatting
  {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
      local conform = require("conform")
      conform.setup({
        -- format_on_save = {
        --   -- I recommend these options. See :help conform.format for details.
        --   lsp_fallback = true,
        --   timeout_ms = 500,
        -- },
        formatters_by_ft = {
          lua = { "stylua" },
          -- Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          typescript = function(bufnr)
            -- if conform.get_formatter_info("biome", bufnr).available then
            --   return { "biome" }
            -- else
            return { "prettier" }
            -- end
          end,
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          -- typescript = { { "prettierd", "prettier" } },
          -- typescriptreact = { { "prettierd", "prettier" } },
          -- javascript = { { "prettierd", "prettier" } },
          -- javascriptreact = { { "prettierd", "prettier" } },
          -- json = { { "prettierd", "prettier" } },
          -- html = { { "prettierd", "prettier" } },
          -- css = { { "prettierd", "prettier" } },
          go = { "goimports", "gofmt" },
          toml = { "taplo" },
          sql = { "pg_format", "sqlfluff" },
          rust = { "rustfmt" },
          zig = { "zigfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          sh = { "shfmt" },
          xml = { "xmlformat" },
          java = { "clang-format" },
        },
      })

      require("conform").formatters.shfmt = {
        prepend_args = function(self, ctx)
          return { "-i", "2" }
        end,
      }
    end,
  },

  -- maximize windows
  {
    "declancm/maximize.nvim",
    keys = {
      {
        "<leader>z",
        function()
          require("maximize").toggle()
        end,
        desc = "Maximize buffer",
      },
    },
    config = function()
      require("maximize").setup()
    end,
  },

  -- markdown
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- typescript
  -- use 'jose-elias-alvarez/typescript.nvim'
}
