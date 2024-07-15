return {
  -- detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',

  {
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
  },

  {
    -- zoom in/out of current buffer
    -- <C-w>o to zoom in/out
    'troydm/zoomwintab.vim',
    event = 'VeryLazy',
  },

  {
    -- 'gcc' => line,  gc' visual, 'gc' + motion
    'numToStr/Comment.nvim',
    event = 'BufReadPre',
    opts = {},
  },

  {
    -- fancier `vim.ui`
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },

  {
    'folke/neoconf.nvim',
    event = 'VimEnter',
    opts = {
      import = {
        vscode = true, -- local .vscode/settings.json
        coc = false,   -- global/local coc-settings.json
        nlsp = false,  -- global/local nlsp-settings.nvim json settings
      },
      live_reload = true,
      filetype_jsonc = true,
    }
  },

  {
    'nvim-neotest/neotest',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'rouge8/neotest-rust',
      'lawrence-laz/neotest-zig',
      'alfaix/neotest-gtest',
      'nvim-neotest/neotest-vim-test',
    },
    config = function()
      require('neotest').setup {
        -- floating = {
        --   border = "rounded",
        --   max_height = 0.85,
        --   max_width = 0.85,
        --   options = {}
        -- },
        log_level = vim.log.levels.DEBUG,
        adapters = {
          require('rustaceanvim.neotest'),
          require('neotest-python') {
            dap = { justMyCode = false },
          },
          require('neotest-rust') {
            args = { '--no-capture' },
            dap_adapter = 'codelldb',
          },
          require('neotest-zig'),
          require('neotest-gtest'),
          require('neotest-plenary'),
          require("neotest-vim-test") {
            ignore_file_types = {
              'python', 'vim', 'lua', 'cpp', 'zig', 'rust',
            },
          },
        },
      }
    end
  },

  {
    -- global search and replace utils
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    config = function()
      require('spectre').setup {
        mapping = {
          ['open_in_split'] = {
            map = '<c-s>',
            cmd = '<cmd>lua vim.cmd(\'split \' .. require(\'spectre.actions\').get_current_entry().filename)<CR>',
            desc = 'open in horizontal split',
          },
          ['open_in_vsplit'] = {
            map = '<c-v>',
            cmd = '<cmd>lua vim.cmd(\'vsplit \' .. require(\'spectre.actions\').get_current_entry().filename)<CR>',
            desc = 'open in vertical split',
          },
          ['open_in_tab'] = {
            map = '<c-t>',
            cmd = '<cmd>lua vim.cmd(\'tab split \' .. require(\'spectre.actions\').get_current_entry().filename)<CR>',
            desc = 'open in new tab',
          },
        },
      }
    end,
  },

  {
    'NoahTheDuke/vim-just',
    ft = 'just',
  },

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
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        TODO = { alt = { "todo", "unimplemented" } },
      },
      highlight = {
        pattern = {
          [[.*<(KEYWORDS)\s*:]],
          [[.*<(KEYWORDS)\s*!\(]],
        },
        comments_only = false,
      },
      search = {
        pattern = [[\b(KEYWORDS)(:|!\()]],
      },
    }
  },

  {
    -- quickfix previewer
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      },
    },
  },

  {
    'p00f/godbolt.nvim',
    cmd = 'Godbolt',
    opts = {
      languages = {
        cpp = { compiler = 'g122', options = {} },
        c = { compiler = 'cg122', options = {} },
        rust = { compiler = 'r1650', options = {} },
        -- any_additional_filetype = { compiler = ..., options = ... },
      },
      quickfix = {
        enable = false,            -- whether to populate the quickfix list in case of errors
        auto_open = false,         -- whether to open the quickfix list in case of errors
      },
      url = 'https://godbolt.org', -- can be changed to a different godbolt instance
    },
  },

  {
    'CraneStation/cranelift.vim',
    ft = 'clif',
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      provider_selector = function(_, _, _)
        return { 'treesitter', 'indent' }
      end,
    },
  },

  {
    'vuki656/package-info.nvim',
    ft = 'json',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      require('package-info').setup {}
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup {}
    end,
  },

  {
    'fei6409/log-highlight.nvim',
    ft = 'log',
    config = function()
      require('log-highlight').setup {}
    end,
  },

  {
    'kawre/leetcode.nvim',
    event = 'VeryLazy',
    build = ':TSUpdate html',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
      'MunifTanjim/nui.nvim',

      -- optional
      'nvim-treesitter/nvim-treesitter',
      -- 'rcarriga/nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      lang = 'rust',
    },
  },

  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup({
        autoselect_one = true,
        include_current = true,
        show_prompt = false,
        hint = 'floating-big-letter',
        selection_chars = 'ASDF;HJLK',
        filter_func = function(window_ids)
          -- Filter out floating windows
          return vim.tbl_filter(function(winid)
            local win_config = vim.api.nvim_win_get_config(winid)
            return win_config.relative == ''
          end, window_ids)
        end,
      })
    end,
  },
}
