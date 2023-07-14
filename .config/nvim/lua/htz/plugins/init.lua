return {
  -- 'tpope/vim-rhubarb',
  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Git related plugins
  { 'tpope/vim-fugitive',     event = 'VeryLazy' },

  -- 'gcc' => line,  gc' visual, 'gc' + motion
  { 'numToStr/Comment.nvim',  event = 'BufReadPre', opts = {} },

  -- (ys) delete, change and insert surroundings
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  -- auto-closing braces
  -- { 'echasnovski/mini.pairs', event = 'BufReadPre', opts = {} },

  { 'nvim-pack/nvim-spectre', cmd = 'Spectre', },
  { 'NoahTheDuke/vim-just',   ft = 'just', },
  { 'sindrets/diffview.nvim', event = 'VeryLazy', },

  -- {
  --   'mg979/vim-visual-multi',
  --   event = 'BufReadPre',
  --   config = function()
  --     vim.cmd [[
  --        let g:VM_maps = {}
  --        let g:VM_maps["Add Cursor Down"]    = '<M-j>'
  --        let g:VM_maps["Add Cursor Up"]      = '<M-k>'
  --     ]]
  --   end
  -- },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- event = 'VeryLazy',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'folke/neodev.nvim',       opts = {} },
      {
        'j-hui/fidget.nvim',
        branch = 'legacy',
        opts = {
          window = {
            blend = 0,
            border = 'none',
          }
        },
      },
    },
    config = function()
      require('htz.lsp')
    end
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPost", "BufNewFile" },
    -- cmd = { "TSUpdateSync" },
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', },
    },
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        indent = {
          enable = true
        }
      }
    end
  },

  { 'nvim-treesitter/nvim-treesitter-context', event = 'BufReadPre' },

  {
    'Civitasv/cmake-tools.nvim',
    ft = 'cpp',
    opts = {
      cmake_command = 'cmake',
      cmake_build_directory = '',
      cmake_build_directory_prefix = 'cmake_build_',                                     -- when cmake_build_directory is '', this option will be activated
      cmake_generate_options = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
      cmake_regenerate_on_save = true,                                                   -- Saves CMakeLists.txt file only if mofified.
      cmake_soft_link_compile_commands = true,                                           -- if softlink compile commands json file
      cmake_compile_commands_from_lsp = false,                                           -- automatically set compile commands location using lsp },
      cmake_build_options = {},
      cmake_console_size = 10,                                                           -- cmake output window height
      cmake_console_position = 'belowright',                                             -- 'belowright', 'aboveleft', ...
      cmake_show_console = 'always',                                                     -- 'always', 'only_on_error'
      cmake_kits_path = nil,                                                             -- global cmake kits path
      cmake_dap_configuration = { name = 'cpp', type = 'codelldb', request = 'launch' }, -- dap configuration, optional
      cmake_variants_message = {
        short = { show = true },
        long = { show = true, max_length = 40 }
      }
    }
  },

  {
    'aca/marp.nvim',
    ft = { 'markdown', 'md' },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle' },
    ft = { 'markdown', 'md' },
    build = function() vim.fn['mkdp#util#install']() end,
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      }
    }
  },

  {
    'someone-stole-my-name/yaml-companion.nvim',
    ft = 'yaml',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim' },
    },
    config = function()
      require('telescope').load_extension('yaml_schema')
      require('yaml-companion').setup({
        builtin_matchers = {
          kubernetes = { enabled = true },
          cloud_init = { enabled = true }
        },
        -- Additional schemas available in Telescope picker
        schemas = {
          --{
          --name = "Kubernetes 1.22.4",
          --uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json",
          --},
        },
        -- Pass any additional options that will be merged in the final LSP config
        lspconfig = {
          flags = {
            debounce_text_changes = 150,
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              validate = true,
              format = { enable = true },
              hover = true,
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemaDownload = { enable = true },
              schemas = {},
              trace = { server = "debug" },
            },
          },
        },
      })
      local function get_current_schema()
        local schema = require("yaml-companion").get_buf_schema(0)
        if schema.result[1].name == "none" then
          return ""
        end
        return schema.result[1].name
      end
      vim.api.nvim_create_user_command('YamlWhichSchema', function(_)
        print(get_current_schema())
      end, { desc = 'YAML: Show Schema for Current Buffer' })
    end,
  }
}
