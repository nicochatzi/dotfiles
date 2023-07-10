return {
  -- 'tpope/vim-rhubarb',
  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Git related plugins
  { 'tpope/vim-fugitive',     event = 'VimEnter' },

  -- 'gcc' => line,  gc' visual, 'gc' + motion
  { 'numToStr/Comment.nvim',  event = 'BufReadPre', opts = {} },

  -- (ys) delete, change and insert surroundings
  { 'tpope/vim-surround',     event = 'BufReadPre' },
  { 'stevearc/dressing.nvim', event = "VimEnter" },

  -- auto-closing braces
  { 'echasnovski/mini.pairs', event = 'BufReadPre', opts = {} },

  'mhinz/vim-startify',

  { 'nvim-pack/nvim-spectre', event = 'VeryLazy', },
  { 'aca/marp.nvim',          ft = 'markdown', },
  { 'NoahTheDuke/vim-just',   ft = 'just', },
  { 'sindrets/diffview.nvim', event = 'VeryLazy', },

  {
    'mg979/vim-visual-multi',
    event = 'BufReadPre',
    config = function()
      vim.cmd [[
         let g:VM_maps = {}
         let g:VM_maps["Add Cursor Down"]    = '<M-j>'
         let g:VM_maps["Add Cursor Up"]      = '<M-k>'
      ]]
    end
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
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
      require('lsp')
    end
  },

  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    ft = { 'rust', 'rs' },
  },

  {
    'Saecki/crates.nvim',
    event = { "BufReadPre Cargo.toml" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    version = 'v0.3.x',
    opts = {},
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
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

  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VimEnter',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    config = function()
      vim.opt.list = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]
      require('indent_blankline').setup {
        char = '',
        space_char_blankline = ' ',
        show_trailing_blankline_indent = true,
        show_current_context = true,
        show_current_context_start = false,
      }
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
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

  -- debugging
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    config = function()
      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      local dap = require('dap')
      dap.adapters.codelldb = {
        -- type = 'server',
        -- host = '127.0.0.1',
        -- port = 13000, -- 💀 Use the port printed out or specified with `--port`
        type = 'server',
        port = '${port}',
        executable = {
          -- CHANGE THIS to your path!
          command = '~/.codelldb/extension/adapter/codelldb',
          args = { '--port', '${port}' },
          -- On windows you may have to uncomment this:
          -- detached = false,
        }
      }
      dap.configurations.rust = {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fin.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
      }
      require('dapui').setup({})
    end
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    event = 'VeryLazy',
    config = function()
      require('dapui').setup({
        layouts = { {
          elements = { {
            id = 'scopes',
            size = 0.40
          }, {
            id = 'stacks',
            size = 0.40
          }, {
            id = 'breakpoints',
            size = 0.10
          }, {
            id = 'watches',
            size = 0.10
          } },
          position = 'right',
          size = 100
        }, {
          elements = { {
            id = 'repl',
            size = 0.5
          }, {
            id = 'console',
            size = 0.5
          } },
          position = 'bottom',
          size = 15
        } },
      })
      local dap, dapui = require('dap'), require('dapui')
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },

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
      cmake_compile_commands_from_lsp = false,                                           -- automatically set compile commands location using lsp
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
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle' },
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
  },

  {
    'alopatindev/cargo-limit',
    ft = 'rust',
    build = 'cargo install cargo-limit nvim-send',
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
}
