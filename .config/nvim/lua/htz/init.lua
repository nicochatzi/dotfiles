local M = {}

local setup_keymaps = function()
  -- move a block in visual mode with J/K
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
  -- dont move cursor when using J
  vim.keymap.set("n", "J", "mzJ`z")

  -- `:help vim.keymap.set()`
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
  vim.keymap.set('n', '<leader>E', ':Neotree toggle<CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>B', ':Neotree buffers toggle<CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>G', ':Neotree git_status toggle<CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>S', ':Neotree document_symbols toggle<CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>D', ':Neotree diagnostics toggle<CR>', { noremap = true })

  vim.keymap.set('n', '<leader>tx', ':split | terminal<CR>', { noremap = true })
  vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>th', ':resize +2 <CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>tk', ':vertical resize +2 <CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>tj', ':vertical resize -2 <CR>', { noremap = true })
  -- vim.keymap.set('n', '<leader>tk', ':resize +2 <CR>', { noremap = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- Buffers!
  vim.keymap.set('n', '<Tab>', ':bnext<CR>')
  vim.keymap.set('n', '<S-Tab>', ':bprev<CR>')
  vim.keymap.set('n', '<leader>bt', ':%bd|e#<CR>', { noremap = true })

  -- c/cpp/cmake remaps
  vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>')
  vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>')
  vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>')
  vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>')
  vim.keymap.set('n', '<leader>cp', ':CMakeSelectBuildPreset<CR>')
  vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildTarget<CR>')

  -- git remaps
  vim.api.nvim_set_keymap("n", "<leader>gd", ":Gvdiff<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>gL", ":Git ll<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>gl", ":Git l<CR>", { noremap = true })

  -- rust
  vim.keymap.set('n', '<leader>rv', ":lua require'crates'.show_versions_popup() <CR>", { silent = true })
  vim.keymap.set('n', '<leader>rf', ":lua require'crates'.show_features_popup() <CR>", { silent = true })
  vim.keymap.set('n', '<leader>rd', ":lua require'crates'.show_dependencies_popup() <CR>", { silent = true })
  vim.keymap.set('n', '<leader>rg', ":lua require'crates'.open_repository() <CR>", { silent = true })

  -- debugging remaps
  vim.keymap.set('n', '<leader>dc', ':DapContinue <CR>', { noremap = true })
  vim.keymap.set('n', '<leader>ds', ':DapStepOver <CR>', { noremap = true })
  vim.keymap.set('n', '<leader>di', ':DapStepInto <CR>', { noremap = true })
  vim.keymap.set('n', '<leader>do', ':DapStepOut <CR>', { noremap = true })
  vim.keymap.set('n', '<leader>dk', ':DapTerminate <CR>', { noremap = true })
  vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint <CR>', { noremap = true })

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

  -- Telescope remaps
  vim.keymap.set("n", "<leader>rr", ":Telescope registers<CR>", { noremap = true })
  vim.keymap.set("n", "<leader>m", ":Telescope marks<CR>", { noremap = true })

  -- this places the browser at the current directory
  vim.keymap.set("n", "<leader>F", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
  -- this starts the browser at `:pwd`
  vim.keymap.set("n", "<leader>f", ":Telescope file_browser path=:pwd select_buffer=true<CR>", { noremap = true })

  -- vim.keymap.set('n', '<leader>y', ':Telescope frecency<CR>', { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader>u', ":Telescope undo<CR>")
  vim.keymap.set('n', '<leader>p', ":lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>",
    { noremap = true, silent = true })
  -- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  --
  vim.keymap.set('n', '<leader><space>', ":lua require'telescope.builtin'.buffers() <CR>",
    { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', ":lua require'telescope.builtin'.current_buffer_fuzzy_find() <CR>",
    { desc = '[/] Fuzzily search in current buffer' })

  -- [S]earch
  vim.keymap.set('n', '<leader>sh', ":lua require'telescope.builtin'.help_tags() <CR>", { desc = '[S]earch [H]elp' })
  --
  -- Search [F]iles
  vim.keymap.set('n', '<leader>sfg', ":lua require'telescope.builtin'.git_files() <CR>",
    { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', '<leader>sff', ":lua require'telescope.builtin'.find_files() <CR>", { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sgs', ":lua require'telescope.builtin'.grep_string() <CR>",
    { desc = '[S]earch [G]rep [S]tring' })
  vim.keymap.set('n', '<leader>sgl', ":lua require'telescope.builtin'.live_grep() <CR>",
    { desc = '[S]earch by [G]rep [L]ive' })

  -- [S]earch Others
  vim.keymap.set('n', '<leader>sd', ":lua require'telescope.builtin'.diagnostics() <CR>",
    { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>so', ":lua require'telescope.builtin'.lsp_document_symbols() <CR>",
    { desc = '[S]earch [O]objets/Symbols' })
  vim.keymap.set('n', '<leader>sr', ":lua require'telescope.builtin'.lsp_references() <CR>",
    { desc = '[S]earch [R]eferences' })
  vim.keymap.set('n', '<leader>sw', ":lua require'telescope.builtin'.lsp_dynamic_workspace_symbols() <CR>",
    { desc = '[W]orkspace [S]ymbols' })

  vim.keymap.set('n', '<leader>sro', ':Spectre<CR>', { desc = '[S]pect[R]e [O]pen' })

  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })
end

local set_options = function()
  -- disable netrw
  -- vim.g.loaded_netrw = 1
  -- vim.g.loaded_netrwPlugin = 1

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

  vim.go.tabstop = 4
  vim.go.shiftwidth = 4

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

  -- vim.o.foldmethod = "expr"
  -- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  -- vim.o.foldenable = 0

  vim.o.spell = true
  vim.o.spelllang = "en"
end

function M.setup()
  set_options()
  setup_keymaps()
end

return M
