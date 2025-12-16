-- prevent unnecessary screen redraws during macro execution and other operations.
vim.opt.lazyredraw = true

vim.opt.list = true
-- vim.opt.listchars.trail = '.'
-- vim.opt.listchars = {
--   eol = ' ',      -- Space for end of line
--   space = ' ',    -- Space for spaces
--   tab = '  ',     -- spaces for tabs
--   trail = '.',    -- Visible dot for trailing spaces
--   extends = ' ',  -- Space for extends
--   precedes = ' ', -- Space for precedes
-- }
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.wo.number = true
vim.o.mouse = 'a'
-- https://neovim.io/doc/user/options.html#'equalalways'
vim.o.equalalways = false
-- Enable break indent
vim.o.breakindent = true
vim.o.undofile = true
vim.o.wrap = false
vim.go.laststatus = 3
vim.go.ruler = false
vim.go.showmode = false
vim.go.showcmd = false
vim.opt.fillchars = { eob = ' ', stl = '─' }
vim.go.shortmess = 'a'
vim.go.shortmess = vim.go.shortmess .. 'F'
vim.o.splitright = true
vim.o.splitbelow = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.timeout = true
vim.o.timeoutlen = 100
-- ms of doing nothing, swap file will be written to disk
vim.o.updatetime = 50

-- Set completeopt to have a better completion experience
-- this
vim.o.completeopt = 'menuone,noselect'
vim.o.wildmenu = true

-- https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.o.foldenable = 0

-- from https://github.com/kevinhwang91/nvim-ufo
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.markdown_folding = 1 -- enable markdown folding

vim.o.spell = true
vim.o.spelllang = 'en_us'
vim.o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "spectre_panel" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitgraph",
  callback = function()
    vim.opt_local.spell = false
  end
})

vim.cmd [[
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
]]

vim.filetype.add({
  extension = {
    mdx = "markdown",
    mir = "rust",
    ll = "llvm",
    mojo = "python",
    tf = "terraform",
    -- alloy = "terraform",
    service = "systemd",
    service_ts = "typescript",
  },
  filename = {
    ["flake.lock"] = "json",
  },
})
