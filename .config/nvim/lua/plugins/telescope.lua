return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  -- event = 'VimEnter',
  dependencies = {
    { 'nvim-lua/plenary.nvim', },
    {
      'debugloop/telescope-undo.nvim',
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
      -- branch = 'feat/tree',
    },
    {
      'nvim-telescope/telescope-project.nvim',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
      -- config = function()
      --   require('telescope').setup {
      --     defaults = {
      --       mappings = {
      --         i = {
      --           ['<C-u>'] = false,
      --           ['<C-d>'] = false,
      --         },
      --       },
      --     }
      --   }
      --   -- Enable telescope fzf native, if installed
      --   pcall(require('telescope').load_extension, 'fzf')
      -- end
    },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        border = true,
        sorting_strategy = 'ascending',
        layout_strategy = 'bottom_pane',
        layout_config = {
          height = 0.5,
          prompt_position = 'top',
        },
      },
      pickers = {
        find_files = {
          theme = 'ivy',
        }
      },
      extensions = {
        undo = {
          side_by_side = true,
          sorting_strategy = 'ascending',
          layout_strategy = 'bottom_pane',
          layout_config = {
            height = 0.5,
            prompt_position = 'top',
          },
        },
        project = {},
        file_browser = {
          grouped = true,
          hijack_netrw = true,
          auto_depth = true,
          initial_browser = 'tree',
          depth = 1,
          hidden = true,
        },
        ['ui-select'] = {
          require('telescope.themes').get_cursor {
            -- even more opts
            width = 0.8,
            previewer = false,
            prompt_title = false,
            borderchars = {
              { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
              prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
              results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
              preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            },
          }
        },
      }
    })

    telescope.load_extension('file_browser')
    telescope.load_extension('undo')
    telescope.load_extension('ui-select')
    telescope.load_extension('project')
    telescope.load_extension('fzf')
  end
}
