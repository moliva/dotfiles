return {
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  -- call tree to be used by lsp zero
  {
    "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      panel = {
        orientation = "bottom",
        panel_size = 10,
      },
    },
    config = function(_, opts)
      require("litee.lib").setup(opts)
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      on_open = "panel",
      map_resize_keys = false,
    },
    config = function(_, opts)
      require("litee.calltree").setup(opts)
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" }, -- Snippets
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      { "rafamadriz/friendly-snippets" },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require("lsp-zero.cmp").extend()

      local lsp = require("lsp-zero")

      -- -- And you can configure cmp even more, if you want to.
      -- local cmp = require('cmp')
      -- local cmp_action = require('lsp-zero.cmp').action()
      --
      -- cmp.setup({
      --   mapping = {
      --     ['<C-Space>'] = cmp.mapping.complete(),
      --     ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      --     ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      --   }
      -- })

      vim.lsp.inlay_hint.enable()

      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Cr>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      -- / cmdline setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- : cmdline setup
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      local sources = lsp.defaults.cmp_sources()
      table.insert(sources, { name = "copilot", group_index = 2 })

      local utils = require("kmobic33.utils")
      local text_sources = utils.copy_table(sources)

      local index = utils.find_index(function(_, v)
        return v["name"] == "buffer"
      end, sources)

      if index ~= nil then
        sources[index] = { name = "buffer", keyword_length = 5 }
        table.remove(text_sources, index)
      end

      local lspkind = require("lspkind")

      -- lsp.setup_nvim_cmp({
      --   mapping = cmp_mappings,
      --   experimental = {
      --     ghost_text = true,
      --   },
      --   sources = sources,
      --   formatting = {
      --     format = lspkind.cmp_format(),
      --   },
      -- })
      cmp.setup({
        mapping = cmp_mappings,
        experimental = {
          ghost_text = true,
        },
        sources = sources,
        formatting = {
          format = lspkind.cmp_format(),
        },
      })

      require("cmp").setup.filetype("text", {
        sources = cmp.config.sources(text_sources),
      })
    end,
  },

  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    cmd = { "LspInfo", "Mason" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        },
        enabled = function(_)
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
      },
      { "neovim/nvim-lspconfig" },
      {
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
    },
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      -- require("neodev").setup({
      --   -- add any options here, or leave empty to use the default settings
      -- })
      -- require("java").setup()

      -- XXX - lsp-zero + lspconfig living together to avoid cycle dependencies - moliva - 2023/05/15
      local lsp = require("lsp-zero").preset("recommended")
      local klsp = require("kmobic33.lsp")

      -- This is where all the LSP shenanigans will live

      vim.diagnostic.config({
        -- shows errors in line
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      lsp.ensure_installed({
        -- lsps
        "cssmodules_ls",
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "eslint",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "taplo",
        "ts_ls",
        "yamlls",
      })

      klsp.ensure_installed({
        -- formatters + linters
        "prettier",
        "prettierd",
        "shellcheck",
        "shfmt",
        "stylua",
      })

      local on_attach = require("kmobic33.lsp.on_attach")

      local global_on_attach = function(c, b)
        -- require('lsp_mappings').on_attach(c, b)
        on_attach.on_attach(c, b)
      end

      lsp.on_attach(global_on_attach)

      klsp.setup_lsps()

      -- TODO - doesn't seem to work outside of nightly - moliva - 2024/04/04
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        -- border = "single",
        -- add the title in hover float window
        -- title = "hover"
        silent = true,
      })

      lsp.skip_server_setup({ "rust_analyzer" })

      lsp.setup()

      require("ufo")

      -- LUasnip config

      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.config.set_config({
        -- remembers last snippet to jump back into it if you moved out accidentally
        history = true,
        -- dynamic snippets updates
        updateevents = "TextChanged,TextChangedI",
        -- check if auto snippets are good
        enable_autosnippets = true,
        -- more
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<- Current Choice", "Error" } },
            },
          },
        },
      })

      -- c-k expansion key
      -- this will expand the current item or jump to the next item within the snippet
      --vim.keymap.set({ "i", "s" }, "<c-k>", function()
      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- TODO - these 2 are conflicting right!

      -- c-j jumps backwards
      -- moves to the previous item within the snippet
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- c-l changes choice in current snippet insert node
      -- useful for choice nodes
      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end)

      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/kmobic33/snippets" })
    end,
  },
}
