vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.wo.number = true
vim.o.mouse = 'a'
-- Enable break indent
vim.o.breakindent = true
vim.o.undofile = true
vim.o.wrap = false
vim.go.laststatus = 3
vim.go.ruler = false
vim.go.showmode = false
vim.go.showcmd = false
vim.opt.fillchars = { eob = " ", stl = "—" }
vim.go.shortmess = 'a'

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 200
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
-- this
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = 0

vim.o.spell = true
vim.o.spelllang = "en"

-- thanks primagean!
-- move a block in visual mode with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- dont move cursor when using J
vim.keymap.set("n", "J", "mzJ`z")
