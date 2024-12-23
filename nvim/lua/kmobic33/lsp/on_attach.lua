local M = {}

local cache = {}

---@diagnostic disable-next-line: unused-local
function M.on_attach(_client, bufnr)
  if cache[bufnr] then
    -- already attached!
    return
  end

  -- do not reexecute this function for this buffer in the future
  -- we almost always call on_attach multiple times (as copilot is enabled for every ft)
  cache[bufnr] = true

  local wk = require("which-key")
  local u = require("kmobic33.lsp.utils")

  local opts = { buffer = bufnr, remap = false }

  ---Extends a table table with the opts provided
  ---@param original table The original table (keymap for which-key or opts for keymap set)
  ---@return table table with merged values
  local function k(original)
    return vim.tbl_extend("force", original, opts)
  end

  -- symbols
  vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>", k({ desc = "Open symbols outline" }))

  vim.keymap.set("n", "K", vim.lsp.buf.hover, k({ desc = "Hover over symbol" }))
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, k({ desc = "Signature help" }))

  -- show next/prev error in file
  vim.keymap.set("n", "<a-.>", vim.diagnostic.goto_next, k({ desc = "Go to next diagnostic" }))
  vim.keymap.set("n", "<a-,>", vim.diagnostic.goto_prev, k({ desc = "Go to previous diagnostic" }))
  -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

  -- NOTE(miguel): not sure its worth it, since i'm usign Trouble - 2024/12/14
  -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set loclist with diagnostics", unpack(opts) })

  -- input a name/filter to look for a symbol in the workspaces

  -- lsp workspace folders management
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, k({ desc = "Add folder to workspace" }))
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, k({ desc = "Remove folder from workspace" }))
  vim.keymap.set("n", "<leader>wl", function()
    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, k({ desc = "List current workspace folders" }))

  wk.add({
    -- lsp workspace
    k({ "<leader>w", group = "LSP workspaces" }),

    -- visual selection
    k({ "vc", u.visual_select_context, desc = "Visually select the current context" }),

    -- delete function calls
    k({ "dc", u.delete_call, desc = "Delete function call" }),
    k({ "dsc", u.delete_surrounding_call, desc = "Delete surrounding function call" }),

    -- go to
    k({ "g", group = "Go to" }),
    k({ "gd", vim.lsp.buf.definition, desc = "Go to definition" }),
    k({ "gi", vim.lsp.buf.type_definition, desc = "Go to implementation" }),
    k({ "gy", vim.lsp.buf.implementation, desc = "Go to type definition" }),
    k({ "ga", u.go_to_current_declaration, desc = "Go to current function signature/definition" }),

    -- "vim" lsp actions
    k({ "<leader>v", group = "Vim" }),
    k({ "<leader>vc", group = "Code" }),
    k({ "<leader>vca", vim.lsp.buf.code_action, desc = "Actions from LSP" }),
    -- { "<leader>vd", vim.diagnostic.open_float, desc = "Diagnostics float", unpack(opts) },

    -- Telescope
    k({ "<leader>px", "<cmd>Telescope diagnostics<cr>", desc = "Telescope diagnostics" }),

    k({
      "<leader>vrn",
      function()
        vim.lsp.buf.rename()
        -- require("renamer").rename()
      end,
      desc = "Rename",
    }),
    k({ "<leader>vws", vim.lsp.buf.workspace_symbol, desc = "List symbols in the current workspace" }),
    -- NOTE(miguel): gr works the same way - 2024/12/15
    -- { "<leader>vrr", "<cmd>Telescope lsp_references<cr>", desc = "References to current symbol", unpack(opts) },

    k({
      "<leader>vi",
      function()
        vim.lsp.buf.incoming_calls()
        require("litee.calltree").open_to()
      end,
      desc = "Incoming calls",
    }),
    k({
      "<leader>vo",
      function()
        vim.lsp.buf.outgoing_calls()
        require("litee.calltree").open_to()
      end,
      desc = "Outgoing calls",
    }),
  })
end

return M
