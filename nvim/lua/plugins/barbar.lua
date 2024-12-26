local opts = { noremap = true, silent = true }

return {
  "romgrk/barbar.nvim",
  -- event = "VeryLazy", -- bar is shown without transparency as intended
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- Move to previous/next
    { "<s-h>", "<Cmd>BufferPrevious<CR>", opts },
    { "<s-l>", "<Cmd>BufferNext<CR>", opts },
    -- { "<A-J>", "<Cmd>BufferPrevious<CR>", opts },
    -- { "<A-K>", "<Cmd>BufferNext<CR>", opts },
    -- Re-order to previous/next
    { "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts },
    { "<A->>", "<Cmd>BufferMoveNext<CR>", opts },
    -- Goto buffer in position...
    { "<A-1>", "<Cmd>BufferGoto 1<CR>", opts },
    { "<A-2>", "<Cmd>BufferGoto 2<CR>", opts },
    { "<A-3>", "<Cmd>BufferGoto 3<CR>", opts },
    { "<A-4>", "<Cmd>BufferGoto 4<CR>", opts },
    { "<A-5>", "<Cmd>BufferGoto 5<CR>", opts },
    { "<A-6>", "<Cmd>BufferGoto 6<CR>", opts },
    { "<A-7>", "<Cmd>BufferGoto 7<CR>", opts },
    { "<A-8>", "<Cmd>BufferGoto 8<CR>", opts },
    { "<A-9>", "<Cmd>BufferGoto 9<CR>", opts },
    { "<A-0>", "<Cmd>BufferLast<CR>", opts },
    -- Close buffer
    { "<A-q>", "<Cmd>BufferClose<CR>", opts },
    { "<A-e>", "<Cmd>BufferClose!<CR>", opts },
    -- Reorder tabs
    { "<leader>b", nil, desc = "Barbar" },
    { "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", desc = "Order by buffer number" },
    { "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", desc = "Order by directory" },
    { "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", desc = "Order by language" },
    { "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", desc = "Order by window number" },
    -- close all other tabs?
  },
  config1 = function()
    local map = vim.api.nvim_set_keymap

    -- Move to previous/next
    -- map("n", "<A-j>", "<Cmd>BufferPrevious<CR>", opts)
    -- map("n", "<A-k>", "<Cmd>BufferNext<CR>", opts)
    -- map('n', '∆', '<Cmd>BufferPrevious<CR>', opts)
    -- map('n', '˚', '<Cmd>BufferNext<CR>', opts)

    -- Re-order to previous/next
    map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
    -- map('n', '<A-,>', '<Cmd>BufferMovePrevious<CR>', opts)
    map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
    -- map('n', '<A-.>', '<Cmd>BufferMoveNext<CR>', opts)
    -- map('n', '≤', '<Cmd>BufferMovePrevious<CR>', opts)
    -- map('n', '≥', '<Cmd>BufferMoveNext<CR>', opts)
    -- map('n', '≤', '<Cmd>BufferMovePrevious<CR>', opts)
    -- map('n', '≥', '<Cmd>BufferMoveNext<CR>', opts)

    -- Goto buffer in position...
    map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
    map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
    map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
    map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
    map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
    map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
    map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
    map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
    map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
    map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
    -- map('n', '¡', '<Cmd>BufferGoto 1<CR>', opts)
    -- map('n', '™', '<Cmd>BufferGoto 2<CR>', opts)
    -- map('n', '£', '<Cmd>BufferGoto 3<CR>', opts)
    -- map('n', '¢', '<Cmd>BufferGoto 4<CR>', opts)
    -- map('n', '∞', '<Cmd>BufferGoto 5<CR>', opts)
    -- map('n', '§', '<Cmd>BufferGoto 6<CR>', opts)
    -- map('n', '¶', '<Cmd>BufferGoto 7<CR>', opts)
    -- map('n', '•', '<Cmd>BufferGoto 8<CR>', opts)
    -- map('n', 'ª', '<Cmd>BufferGoto 9<CR>', opts)
    -- map('n', 'ª', '<Cmd>BufferLast<CR>', opts)

    -- Pin/unpin buffer
    -- map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    -- map('n', 'π', '<Cmd>BufferPin<CR>', opts)

    -- Close buffer
    -- map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    map("n", "<A-q>", "<Cmd>BufferClose<CR>", opts)
    map("n", "<A-e>", "<Cmd>BufferClose!<CR>", opts)
    -- map('n', 'œ', '<Cmd>BufferClose<CR>', opts)

    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)

    -- Sort automatically by...
    local wk = require("which-key")
    wk.register({
      b = {
        name = "Barbar",
        b = { "<Cmd>BufferOrderByBufferNumber<CR>", "Order by buffer number" },
        d = { "<Cmd>BufferOrderByDirectory<CR>", "Order by directory" },
        l = { "<Cmd>BufferOrderByLanguage<CR>", "Order by language" },
        w = { "<Cmd>BufferOrderByWindowNumber<CR>", "Order by window number" },
      },
    }, { prefix = "<leader>" })

    -- Other:
    -- :BarbarEnable - enables barbar (enabled by default)
    -- :BarbarDisable - very bad command, should never be used
  end,
}
