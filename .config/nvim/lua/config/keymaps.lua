-- folds
vim.keymap.set('n', 'zR', ':lua require\'ufo\'.openAllFolds()<CR>')
vim.keymap.set('n', 'zM', ':lua require\'ufo\'.closeAllFolds<CR>')

-- `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<C-Z>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local function toggle_or_focus_neotree(source)
  local bufnr = vim.api.nvim_get_current_buf()
  local is_neo_tree = vim.bo[bufnr].filetype == "neo-tree"

  local function get_neo_tree_source()
    local neo_tree_source = vim.b[bufnr].neo_tree_source
    return neo_tree_source
  end

  -- Find the Neotree window if it exists
  local neo_tree_win
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[win_buf].filetype == "neo-tree" then
      neo_tree_win = win
      break
    end
  end

  if is_neo_tree then
    local current_source = get_neo_tree_source()
    if current_source == source then
      vim.cmd.Neotree("close")
    else
      vim.cmd.Neotree(source)
    end
  elseif neo_tree_win then
    vim.api.nvim_set_current_win(neo_tree_win)
    vim.cmd.Neotree(source)
  else
    vim.cmd.Neotree(source)
  end
end

local function pick_window_and_switch()
  local window_picker = require 'window-picker'
  local picked_window_id = window_picker.pick_window({ include_current_win = true })
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
  end
end

-- panels
vim.keymap.set('n', '<leader>E', ":Neotree filesystem toggle<CR>",
  { noremap = true, desc = "Toggle or focus filesystem tree" })
vim.keymap.set('n', '<leader>G', ":Neotree git_status toggle<CR>",
  { noremap = true, desc = "Toggle or focus git status" })
vim.keymap.set('n', '<leader>S', ":Neotree document_symbols toggle<CR>",
  { noremap = true, desc = "Toggle or focus document symbols" })
vim.keymap.set('n', '<leader>D', ":Neotree diagnostics toggle<CR>",
  { noremap = true, desc = "Toggle or focus diagnostics" })
vim.keymap.set('n', '<leader>P', ":Neotree dependencies toggle<CR>",
  { noremap = true, desc = "Toggle or focus dependencies" })
vim.keymap.set('n', '<leader>T', ':Neotest summary<CR>', { noremap = true })
vim.keymap.set('n', '<leader>W', pick_window_and_switch, { noremap = true })

-- Resizing panes with Alt-H/J/K/L
vim.api.nvim_set_keymap('n', '<M-h>', ':vertical resize -5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-l>', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-k>', ':resize -5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-j>', ':resize +5<CR>', { noremap = true, silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
vim.keymap.set('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })

-- test
vim.keymap.set('n', '<leader>tst', ':lua require("neotest").run.run()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tss', ':lua require("neotest").run.stop()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tsf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tsa', ':lua require("neotest").run.attach()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tsd', ':lua require("neotest").run.run({strategy = "dap"})<CR>', { noremap = true })

-- c/cpp/cmake remaps
vim.keymap.set('n', '<leader>ch', ':ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<leader>co', ':CMakeOpen<CR>')
vim.keymap.set('n', '<leader>cs', ':CMakeSettings<CR>')
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>')
vim.keymap.set('n', '<leader>cd', ':CMakeDebug<CR>')
vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>')
vim.keymap.set('n', '<leader>cc', ':CMakeSelectCwd<CR>')
vim.keymap.set('n', '<leader>cp', ':CMakeSelectBuildPreset<CR>')
vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildTarget<CR>')

-- git remaps
vim.api.nvim_set_keymap('n', '<leader>gd', ':DiffviewOpen<CR>', { noremap = true, desc = "git diff" })
vim.api.nvim_set_keymap('n', '<leader>gf', ':DiffviewFileHistory %<CR>', { noremap = true, desc = "git file history" })
vim.api.nvim_set_keymap('v', '<leader>gf', ":'<,'>DiffviewFileHistory<CR>", { noremap = true, desc = "git line history" })
vim.api.nvim_set_keymap('n', '<leader>gF', ":DiffviewFileHistory<CR>", { noremap = true, desc = "git project history" })
vim.api.nvim_set_keymap('n', '<leader>gb', ":Gitsigns blame<CR>", { noremap = true, desc = "git blame for file" })

-- package management
vim.keymap.set('n', '<leader>vv', ':lua require\'crates\'.show_versions_popup() <CR>', { silent = true })
vim.keymap.set('n', '<leader>vf', ':lua require\'crates\'.show_features_popup() <CR>', { silent = true })
vim.keymap.set('n', '<leader>vd', ':lua require\'crates\'.show_dependencies_popup() <CR>', { silent = true })
vim.keymap.set('n', '<leader>vg', ':lua require\'crates\'.open_repository() <CR>', { silent = true })
vim.keymap.set(
  'n',
  '<leader>vv',
  ':lua require\'package-info\'.change_version() <CR>',
  { silent = true, noremap = true }
)
-- vim.keymap.set('n', '<leader>vt', ":lua require'package-info'.toggle() <CR>", { silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>vu', ":lua require'package-info'.update() <CR>", { silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>vd', ":lua require'package-info'.delete() <CR>", { silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>vi', ":lua require'package-info'.install() <CR>", { silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>vc', ":lua require'package-info'.change_version() <CR>", { silent = true, noremap = true })

-- debugging remaps
vim.keymap.set('n', '<leader>dc', ':DapContinue <CR>', { noremap = true })
vim.keymap.set('n', '<leader>ds', ':DapStepOver <CR>', { noremap = true })
vim.keymap.set('n', '<leader>di', ':DapStepInto <CR>', { noremap = true })
vim.keymap.set('n', '<leader>do', ':DapStepOut <CR>', { noremap = true })
vim.keymap.set('n', '<leader>dk', ':DapTerminate <CR>', { noremap = true })
vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint <CR>', { noremap = true })

-- TODOs
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Telescope remaps
vim.keymap.set('n', '<leader>rr', ':Telescope registers<CR>', { noremap = true })
vim.keymap.set('n', '<leader>m', ':Telescope marks<CR>', { noremap = true })
vim.keymap.set('n', '<leader>se', ':Telescope symbols<CR>', { noremap = true })

-- this places the browser at the current directory
vim.keymap.set('n', '<leader>F', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { noremap = true })
-- this starts the browser at `:pwd`
vim.keymap.set('n', '<leader>f', ':Telescope file_browser select_buffer=true<CR>', { noremap = true })

-- vim.keymap.set('n', '<leader>y', ':Telescope frecency<CR>', { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>u', ':Telescope undo<CR>')
vim.keymap.set(
  'n',
  '<leader>p',
  ':lua require\'telescope\'.extensions.project.project{display_type = \'full\'}<CR>',
  { noremap = true, silent = true }
)
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
--
vim.keymap.set(
  'n',
  '<leader><space>',
  ':lua require\'telescope.builtin\'.buffers() <CR>',
  { desc = '[ ] Find existing buffers' }
)
vim.keymap.set(
  'n',
  '<leader>/',
  ':lua require\'telescope.builtin\'.current_buffer_fuzzy_find() <CR>',
  { desc = '[/] Fuzzily search in current buffer' }
)

vim.keymap.set('n', '<leader>ss', ':SearchSession<CR>', { desc = '[S]earch [S]ession' })

-- [S]earch
vim.keymap.set('n', '<leader>sh', ':lua require\'telescope.builtin\'.help_tags() <CR>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>st', ':TodoTelescope<CR>', { desc = '[S]earch [T]odos' })
--
-- Search [F]iles
vim.keymap.set('n', '<leader>sf', ':lua require\'telescope.builtin\'.find_files() <CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set(
  'n',
  '<leader>sg',
  ':lua require\'telescope.builtin\'.git_files() <CR>',
  { desc = '[S]earch [G]it Files' }
)
vim.keymap.set(
  'n',
  '<leader>sh',
  ':lua require\'telescope.builtin\'.grep_string() <CR>',
  { desc = '[S]earch Grep String' }
)
vim.keymap.set(
  'n',
  '<leader>sj',
  ':lua require\'telescope.builtin\'.live_grep() <CR>',
  { desc = '[S]earch by Grep Live' }
)

-- [S]earch Others
vim.keymap.set(
  'n',
  '<leader>sd',
  ':lua require\'telescope.builtin\'.diagnostics() <CR>',
  { desc = '[S]earch [D]iagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>so',
  ':lua require\'telescope.builtin\'.lsp_document_symbols() <CR>',
  { desc = '[S]earch [O]objets/Symbols' }
)
vim.keymap.set(
  'n',
  '<leader>sr',
  ':lua require\'telescope.builtin\'.lsp_references() <CR>',
  { desc = '[S]earch [R]eferences' }
)
vim.keymap.set(
  'n',
  '<leader>sw',
  ':lua require\'telescope.builtin\'.lsp_dynamic_workspace_symbols() <CR>',
  { desc = '[W]orkspace [S]ymbols' }
)

vim.keymap.set(
  'n',
  '<leader>saf',
  '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
  { desc = '[S]pectre in File' }
)
vim.keymap.set('n', '<leader>sao', ':Spectre<CR>', { desc = '[S]pect[R]e [O]pen' })
vim.keymap.set('n', '<leader>saw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = '[S]earch [A]ll current [W]ord',
})
vim.keymap.set('v', '<leader>saw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = '[S]earch [A]ll current [W]ord',
})

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

vim.keymap.set('n', '<leader>rw', function() vim.cmd [[ %s/\s\+$//e ]] end,
  { desc = 'Remove trailing whitespace' })

-- Buffers!
local function close_all_but_visible_buffers()
  local visible_buffers = {}
  local special_buftypes = { "terminal", "quickfix", "help" }

  -- Mark all buffers that are visible in any window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    visible_buffers[buf] = true
  end

  -- Close all buffers that are not visible
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if not visible_buffers[buffer] and vim.api.nvim_buf_is_valid(buffer) then
      local buftype = vim.bo[buffer].buftype
      local modified = vim.bo[buffer].modified

      -- Skip special buffer types and modified buffers
      if not vim.tbl_contains(special_buftypes, buftype) and not modified then
        local success, err = pcall(vim.api.nvim_buf_delete, buffer, { force = true })
        if not success then
          print("Failed to close buffer " .. buffer .. ": " .. err)
        end
      end
    end
  end
end

vim.keymap.set('n', '<leader>bt', close_all_but_visible_buffers, { noremap = true })

--
-- Of tabs and terms...
--
function _G.open_or_focus_terminal_tab()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      -- If terminal buffer exists, switch to it
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      vim.cmd('tabnew | b ' .. buf)
      return
    end
  end
  -- If no terminal buffer exists, create a new one
  vim.cmd('tabnew | terminal')
end
function _G.goto_tab_n(n)
  if n > 0 and n <= vim.fn.tabpagenr('$') then
    vim.cmd('tabnext ' .. n)
  end
end
local classic_term_exit ='<C-\\><C-n>'
vim.keymap.set('t', '<C-w>', classic_term_exit , { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tt', open_or_focus_terminal_tab, { noremap = true, silent = true })
for i = 1, 9 do
  vim.keymap.set('n', '<leader>t' .. i, function() goto_tab_n(i) end, { noremap = true, silent = true })
end
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { noremap = true })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true })
