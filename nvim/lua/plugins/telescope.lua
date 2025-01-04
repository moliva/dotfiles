local function grep_string_input()
  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end

---live grep using extension filter
---@param opts {cwd: string | nil} | nil
local function live_multi_grep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local conf = require("telescope.config").values

  local finder = finders.new_async_job({

    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      -- two spaces for file extension
      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }

      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,

    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

return {
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    lazy = true,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      -- { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  {
    "gbrlsnchs/telescope-lsp-handlers.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    event = "VeryLazy",
    keys = {
      {
        "<leader>p",
        nil,
        desc = "Telescope",
      },
      {
        "<C-p>",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Look in git files",
      },
      {
        "<leader>pn",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = true,
            filename_first = false,
            cwd = "/Users/moliva/.config/nvim",
          })
        end,
        desc = "Telescope nvim config",
      },
      {
        "<leader>pb",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = true,
            filename_first = false,
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
          })
        end,
        desc = "Telescope builtins",
      },
      {
        -- global search
        "<leader>pF",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = false,
            filename_first = false,
          })
        end,
        desc = "Telescope smart_open (global)",
      },
      {
        "<leader>pf",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = true,
            filename_first = false,
          })
        end,
        desc = "Telescope smart_open",
      },
      {
        -- leaving old telescope find files for backup
        "<leader><leader>pf",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Telescope find files",
      },
      {
        "<leader>ps",
        grep_string_input,
        desc = "Telescope grep string with input",
      },
      {
        "<leader>pd",
        function()
          -- require("telescope.builtin").live_grep()
          live_multi_grep()
        end,
        desc = "Telescope live grep",
      },
      {
        "<leader>po",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Telescope document symbols",
      },
      {
        "<leader>pi",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Telescope dynamic workspace symbols",
      },
      {
        "<leader>pa",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Telescope grep string",
      },
      {
        "<leader>ph",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Telescope help tags",
      },
      {
        "<leader>pp",
        "<cmd>Telescope<cr>",
        desc = "Telescope introspection",
      },
      {
        "<leader>pr",
        "<cmd>Telescope harpoon marks<cr>",
        desc = "Telescope harpoon marks",
      },
      {
        "<c-f>",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Telescope buffers",
      },
      {
        "<leader><tab>",
        function()
          require("telescope.builtin").commands()
        end,
        desc = "Telescope commands",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          fzf = {},
          smart_open = {
            show_scores = false,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            match_algorithm = "fzf",
            disable_devicons = false,
          },
          lsp_handlers = {
            disable = {
              ["callHierarchy/incomingCalls"] = true,
              ["callHierarchy/outgoingCalls"] = true,
            },
            location = {
              telescope = {},
              no_results_message = "No references found",
            },
            symbol = {
              telescope = {},
              no_results_message = "No symbols found",
            },
            call_hierarchy = {
              telescope = {},
              no_results_message = "No calls found",
            },
            code_action = {
              telescope = require("telescope.themes").get_dropdown({}),
              no_results_message = "No code actions available",
              prefix = "",
            },
          },
        },
      })

      telescope.load_extension("smart_open")
      telescope.load_extension("git_worktree")

      telescope.load_extension("lsp_handlers")

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      telescope.load_extension("fzf")

      telescope.load_extension("neoclip")
      telescope.load_extension("noice")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
}
