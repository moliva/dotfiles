function ColorMyPencils(color)
  -- color = color or "rose-pine"
  -- TODO(miguel): review how to make floats transparent - 2024/12/05
  -- color = color or "base16-harmonic-dark"
  -- color = color or "base16-tomorrow-night"
  -- vim.cmd.colorscheme(color)

  -- vim.cmd("colorscheme rose-pine")
  -- vim.cmd("colorscheme rose-pine-main")
  vim.cmd("colorscheme rose-pine-moon")
  -- vim.cmd("colorscheme rose-pine-dawn")

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
