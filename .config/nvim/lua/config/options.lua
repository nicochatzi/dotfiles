vim.opt.list = true
vim.opt.listchars = {
  eol = ' ',
  space = ' ',
  trail = '.',
  extends = ' ',
  precedes = ' ',
}

vim.o.cursorline = true
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
vim.go.shortmess = vim.go.shortmess .. 'F'
vim.o.splitright = true
vim.o.splitbelow = true

vim.go.tabstop = 4
vim.go.shiftwidth = 4

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.timeout = true
vim.o.updatetime = 100
vim.o.timeoutlen = 100

-- Set completeopt to have a better completion experience
-- this
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldenable = 0

-- from https://github.com/kevinhwang91/nvim-ufo
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.spell = true
vim.o.spelllang = "en_gb"

vim.cmd([[
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
]])

vim.cmd([[autocmd BufRead,BufNewFile *.mdx setfiletype markdown]])
vim.cmd([[autocmd BufRead,BufNewFile *.mir setfiletype mir]])
vim.cmd([[autocmd BufRead,BufNewFile *.ll setfiletype llvm]])
