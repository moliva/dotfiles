-- fat cursor
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
-- case insensitive searching
vim.opt.ignorecase = true
-- case-sensitive if expresson contains a capital letter
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- color column at number (or none)
vim.opt.colorcolumn = ""

vim.g.mapleader = " "

-- don't redraw while executing macros
-- vim.opt.nolazyredraw = true

-- show matching braces
vim.opt.showmatch = true -- ((( )))
-- vim.opt.setmagic = true
-- vim.opt.mat = 2

vim.opt.laststatus = 2

vim.opt.cursorline = false

-- swtich keys - forward and backward
vim.keymap.set("n", "sk", "xph", { desc = "Swap char with next one" })
vim.keymap.set("n", "Sk", "xhPl", { desc = "Swap char with next one" })

-- on split, do it to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
-- vim.opt.listchars:append({ space = '⋅', trail = '⋅', eol = '¬' })
vim.opt.listchars:append({ space = '⋅', trail = '⋅' })

-- ufo and folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- set as keyword, to be used for word wrapping
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append("_")

