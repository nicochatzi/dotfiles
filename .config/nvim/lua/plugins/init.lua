return {
  -- detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',

  {
     'troydm/zoomwintab.vim',
     event = 'VeryLazy',
  },

  {
    -- 'gcc' => line,  gc' visual, 'gc' + motion
    'numToStr/Comment.nvim',
    event = 'BufReadPre',
    opts = {}
  },

  {
    -- fancier `vim.ui`
    'stevearc/dressing.nvim',
    event = 'VeryLazy'
  },

  -- auto-closing braces
  -- { 'echasnovski/mini.pairs', event = 'BufReadPre', opts = {} },

  {
    -- global search and replace utils
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
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
    -- quickfix previewer
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        winblend = 0,
      }
    }
  },

  {
    'p00f/godbolt.nvim',
    cmd = 'Godbolt',
    opts = {
      languages = {
        cpp = { compiler = "g122", options = {} },
        c = { compiler = "cg122", options = {} },
        rust = { compiler = "r1650", options = {} },
        -- any_additional_filetype = { compiler = ..., options = ... },
      },
      quickfix = {
        enable = false,           -- whether to populate the quickfix list in case of errors
        auto_open = false         -- whether to open the quickfix list in case of errors
      },
      url = "https://godbolt.org" -- can be changed to a different godbolt instance
    }
  },

  {
    -- show all symbols in a source file
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    opts = {},
  },

  {
    'CraneStation/cranelift.vim',
    ft = 'clif',
  },

  {
    "brymer-meneses/grammar-guard.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = { 'markdown', 'latex', 'tex' },
    config = function()
      require("lspconfig").grammar_guard.setup({
        settings = {
          ltex = {
            enabled = { "latex", "tex", "bib", "markdown" },
            language = "en-GB",
            diagnosticSeverity = "information",
            setenceCacheSize = 2000,
            additionalRules = {
              enablePickyRules = true,
              motherTongue = "en-GB",
            },
            trace = { server = "verbose" },
            dictionary = {},
            disabledRules = {},
            hiddenFalsePositives = {},
          },
        },
      })
      require("grammar-guard").init()
    end
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end
    }
  },

  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    event = 'VeryLazy',
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = false,
      tabpages = false,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },

  {
    'vuki656/package-info.nvim',
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require('package-info').setup()
    end
  },

  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  {
    'fei6409/log-highlight.nvim',
    ft = 'log',
    config = function()
      require('log-highlight').setup()
    end,
  }
}
