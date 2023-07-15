return {
  -- detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- 'gcc' => line,  gc' visual, 'gc' + motion
  { 'numToStr/Comment.nvim',  event = 'BufReadPre', opts = {} },

  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  -- auto-closing braces
  -- { 'echasnovski/mini.pairs', event = 'BufReadPre', opts = {} },

  { 'nvim-pack/nvim-spectre', cmd = 'Spectre', },

  { 'NoahTheDuke/vim-just',   ft = 'just', },

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
    'simrat39/symbols-outline.nvim',
    cmd = 'SymbolsOutline',
    opts = {},
  },
}
