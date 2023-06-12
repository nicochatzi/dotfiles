-- `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>E', ':Neotree toggle<CR>', { noremap = true })
vim.keymap.set('n', '<leader>B', ':Neotree buffers toggle<CR>', { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Cycle through buffers with tab
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>')

-- c/cpp/cmake remaps
vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>')
vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>')
vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>')
vim.keymap.set('n', '<leader>cp', ':CMakeSelectBuildPreset<CR>')
vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildTarget<CR>')

-- git remaps
vim.api.nvim_set_keymap("n", "<leader>gL", ":Git ll<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>gl", ":Git l<CR>", { noremap = true })

-- rust
vim.keymap.set('n', '<leader>rv', require('crates').show_versions_popup, { silent = true })
vim.keymap.set('n', '<leader>rf', require('crates').show_features_popup, { silent = true })
vim.keymap.set('n', '<leader>rd', require('crates').show_dependencies_popup, { silent = true })

-- debugging remaps
vim.keymap.set('n', '<leader>dc', require('dap').continue)
vim.keymap.set('n', '<leader>ds', require('dap').step_over)
vim.keymap.set('n', '<leader>di', require('dap').step_into)
vim.keymap.set('n', '<leader>do', require('dap').step_out)
vim.keymap.set('n', '<leader>dl', require('dap').run_last)
vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- telescope remaps
vim.keymap.set("n", "<leader>r", ":Telescope registers<CR>", { noremap = true })
vim.keymap.set("n", "<leader>m", ":Telescope marks<CR>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
vim.keymap.set('n', '<leader>y', ':Telescope frecency<CR>', { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>u', ":Telescope undo<CR>")
vim.keymap.set('n', '<leader>p', ":lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>",
  { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

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
