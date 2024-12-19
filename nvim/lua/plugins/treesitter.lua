return {
  {
    "windwp/nvim-ts-autotag",
    -- should be triggered by the treesitter autotag config below
    lazy = true,
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- ast and highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      -- force nvim-ts-autotag to be loaded here
      require("nvim-ts-autotag")

      require("nvim-treesitter.configs").setup({
        -- autotag = {
        --   enable = true,
        -- },
        -- A list of parser names, or "all"
        -- TODO - remoing help as it is not found as a language - moliva - 2023/05/14
        -- ensure_installed = { "help", "javascript", "typescript", "c", "lua", "rust", "vim", "toml", "http", "json" },
        ensure_installed = {
          "javascript",
          "typescript",
          "c",
          "lua",
          "rust",
          "vim",
          "toml",
          "http",
          "json",
          "gitcommit",
          "markdown",
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },

        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      })
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 10, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
      })
    end,
  },
}
