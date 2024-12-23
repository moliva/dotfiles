return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      -- local ih = require("inlay-hints")

      local rt = require("rust-tools")

      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      -- local extension_path = codelldb:get_install_path() .. "/extension/"
      local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.0/"

      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

      local capabilities = require("kmobic33.lsp").get_capabilities()
      local server = require("kmobic33.rust_analyzer").config(capabilities)
      server.on_attach = function(client, bufnr)
        require("kmobic33.lsp.on_attach").on_attach(client, bufnr)

        -- Hover actions
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Hover actions" })
        -- Code action groups
        vim.keymap.set(
          "n",
          "<Leader>a",
          rt.code_action_group.code_action_group,
          { buffer = bufnr, desc = "Code action" }
        )
      end

      local opts = {
        tools = {
          -- rust-tools options

          -- how to execute terminal commands
          -- options right now: termopen / quickfix
          -- executor = require("rust-tools.executors").termopen,

          -- callback to execute once rust-analyzer is done initializing the workspace
          -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
          on_initialized = function()
            -- ih.set_all()
          end,
          -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
          reload_workspace_from_cargo_toml = true,
          -- These apply to the default RustSetInlayHints command
          inlay_hints = {
            -- automatically set inlay hints (type hints)
            -- default: true
            -- moliva: setting to false in favor of inlay-hints plugin
            auto = false,
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,
            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
          },
          -- options same as lsp hover / vim.lsp.util.open_floating_preview()
          hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
            -- Maximal width of the hover window. Nil means no max.
            max_width = nil,
            -- Maximal height of the hover window. Nil means no max.
            max_height = nil,
            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = true,
          },
          -- settings for showing the crate graph based on graphviz and the dot
          -- command
          crate_graph = {
            -- Backend used for displaying the graph
            -- see: https://graphviz.org/docs/outputs/
            -- default: x11
            backend = "x11",
            -- where to store the output, nil for no output stored (relative
            -- path from pwd)
            -- default: nil
            output = nil,
            -- true for all crates.io and external crates, false only the local
            -- crates
            -- default: true
            full = true,
          },
        },
        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        -- server = {
        --   -- standalone file support
        --   -- setting it to false may improve startup time
        --   standalone = true,
        -- },
        server = server,
        -- rust-analyzer options
        -- debugging stuff
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }

      rt.setup(opts)
    end,
  },
}
