-- set the transparency of the buffer on open (helpful when opening new windows, splits, tabs
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  command = "hi NormalNC ctermbg=NONE guibg=NONE",
})

-- format on save
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.rs" },
--   callback = vim.lsp.buf.format
-- })

-- highglight text on yank

vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
